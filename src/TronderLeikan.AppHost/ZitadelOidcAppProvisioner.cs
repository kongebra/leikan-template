// Oppretter OIDC-appen frontend bruker mot Zitadel, slik at ingen må klikke seg gjennom Zitadel-konsollen.
// Kjøres første gang frontend startes, og er idempotent: eksisterende prosjekt og app gjenbrukes.

using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;

internal sealed class ZitadelOidcAppProvisioner(string zitadelBaseUrl, string bootstrapDirectory, string frontendBaseUrl)
{
    private const string ProjectName = "TronderLeikan";
    private const string AppName = "frontend";
    private static readonly TimeSpan ReadyTimeout = TimeSpan.FromMinutes(5);

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web)
    {
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
    };

    internal sealed record OidcClient(string ClientId, string ClientSecret);

    private string CredentialsPath => Path.Combine(bootstrapDirectory, "frontend-oidc.json");
    private string AdminPatPath => Path.Combine(bootstrapDirectory, "admin.pat");

    /// <summary>
    /// Returnerer client id og secret for frontend-appen. Leser fra fil hvis den finnes,
    /// ellers opprettes prosjekt og app i Zitadel og resultatet lagres i bootstrap-mappen.
    /// </summary>
    public async Task<OidcClient> EnsureAsync(CancellationToken ct)
    {
        if (File.Exists(CredentialsPath))
        {
            var cached = JsonSerializer.Deserialize<OidcClient>(await File.ReadAllTextAsync(CredentialsPath, ct), Json);
            if (cached is { ClientId.Length: > 0, ClientSecret.Length: > 0 })
                return cached;
        }

        using var http = new HttpClient { BaseAddress = new Uri(zitadelBaseUrl) };
        await WaitUntilReadyAsync(http, ct);

        var pat = (await File.ReadAllTextAsync(AdminPatPath, ct)).Trim();
        http.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", pat);

        var projectId = await FindProjectIdAsync(http, ct) ?? await CreateProjectAsync(http, ct);
        var client = await FindAppAsync(http, projectId, ct) is { } existing
            ? new OidcClient(existing.ClientId, await RegenerateSecretAsync(http, projectId, existing.AppId, ct))
            : await CreateAppAsync(http, projectId, ct);

        await File.WriteAllTextAsync(CredentialsPath, JsonSerializer.Serialize(client, Json), ct);
        return client;
    }

    // Venter til Zitadel svarer på ready-endepunktet og har skrevet admin-PAT ved første oppstart
    private async Task WaitUntilReadyAsync(HttpClient http, CancellationToken ct)
    {
        using var timeout = CancellationTokenSource.CreateLinkedTokenSource(ct);
        timeout.CancelAfter(ReadyTimeout);

        while (true)
        {
            try
            {
                using var response = await http.GetAsync("/debug/ready", timeout.Token);
                if (response.IsSuccessStatusCode && File.Exists(AdminPatPath))
                    return;
            }
            catch (HttpRequestException)
            {
                // Zitadel er ikke oppe enda, prøv igjen
            }
            catch (OperationCanceledException) when (timeout.IsCancellationRequested && !ct.IsCancellationRequested)
            {
                throw new TimeoutException(
                    $"Zitadel svarte ikke på {zitadelBaseUrl}/debug/ready innen {ReadyTimeout.TotalMinutes} minutter, " +
                    $"eller admin-PAT mangler i {AdminPatPath}. Slett postgres-volumet og start på nytt hvis Zitadel er initialisert uten PAT.");
            }

            await Task.Delay(TimeSpan.FromSeconds(2), timeout.Token);
        }
    }

    private static async Task<string?> FindProjectIdAsync(HttpClient http, CancellationToken ct)
    {
        var body = new { queries = new[] { new { nameQuery = new { name = ProjectName, method = "TEXT_QUERY_METHOD_EQUALS" } } } };
        var result = await PostAsync<SearchResult<ProjectResult>>(http, "/management/v1/projects/_search", body, ct);
        return result.Result?.FirstOrDefault()?.Id;
    }

    private static async Task<string> CreateProjectAsync(HttpClient http, CancellationToken ct)
    {
        var result = await PostAsync<ProjectResult>(http, "/management/v1/projects", new { name = ProjectName }, ct);
        return result.Id;
    }

    private static async Task<AppResult?> FindAppAsync(HttpClient http, string projectId, CancellationToken ct)
    {
        var body = new { queries = new[] { new { nameQuery = new { name = AppName, method = "TEXT_QUERY_METHOD_EQUALS" } } } };
        var result = await PostAsync<SearchResult<AppResult>>(http, $"/management/v1/projects/{projectId}/apps/_search", body, ct);
        return result.Result?.FirstOrDefault(a => a.OidcConfig is not null);
    }

    private async Task<OidcClient> CreateAppAsync(HttpClient http, string projectId, CancellationToken ct)
    {
        // devMode tillater http://-redirects, som trengs lokalt
        var body = new
        {
            name = AppName,
            redirectUris = new[] { $"{frontendBaseUrl}/api/auth/oauth2/callback/zitadel" },
            postLogoutRedirectUris = new[] { frontendBaseUrl },
            responseTypes = new[] { "OIDC_RESPONSE_TYPE_CODE" },
            grantTypes = new[] { "OIDC_GRANT_TYPE_AUTHORIZATION_CODE" },
            appType = "OIDC_APP_TYPE_WEB",
            authMethodType = "OIDC_AUTH_METHOD_TYPE_BASIC",
            accessTokenType = "OIDC_TOKEN_TYPE_JWT",
            devMode = true
        };
        var result = await PostAsync<CreateAppResult>(http, $"/management/v1/projects/{projectId}/apps/oidc", body, ct);
        return new OidcClient(result.ClientId, result.ClientSecret);
    }

    // Secret returneres bare ved opprettelse, så finnes appen uten lagret fil må den genereres på nytt
    private static async Task<string> RegenerateSecretAsync(HttpClient http, string projectId, string appId, CancellationToken ct)
    {
        var result = await PostAsync<SecretResult>(http, $"/management/v1/projects/{projectId}/apps/{appId}/oidc_config/_generate_client_secret", new { }, ct);
        return result.ClientSecret;
    }

    private static async Task<T> PostAsync<T>(HttpClient http, string path, object body, CancellationToken ct)
    {
        using var response = await http.PostAsJsonAsync(path, body, Json, ct);
        if (!response.IsSuccessStatusCode)
        {
            var error = await response.Content.ReadAsStringAsync(ct);
            throw new InvalidOperationException($"Zitadel {path} svarte {(int)response.StatusCode}: {error}");
        }

        return await response.Content.ReadFromJsonAsync<T>(Json, ct)
            ?? throw new InvalidOperationException($"Zitadel {path} returnerte tom respons.");
    }

    private sealed record SearchResult<T>(List<T>? Result);
    private sealed record ProjectResult(string Id);
    private sealed record OidcConfigResult(string ClientId);
    private sealed record AppResult(string Id, OidcConfigResult? OidcConfig)
    {
        public string AppId => Id;
        public string ClientId => OidcConfig!.ClientId;
    }
    private sealed record CreateAppResult(string AppId, string ClientId, string ClientSecret);
    private sealed record SecretResult(string ClientSecret);
}
