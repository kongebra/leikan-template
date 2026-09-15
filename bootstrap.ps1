# Sjekker at verktøyene TrønderLeikan trenger er på plass. Installerer ingenting.
# Grønn linje = ok, rød linje = mangler (med lenke), gul linje = anbefalt men ikke påkrevd.
# Exit-kode 1 hvis noe påkrevd mangler.

$ErrorActionPreference = "SilentlyContinue"
$script:missing = $false

function Ok($text)          { Write-Host "✓ " -ForegroundColor Green -NoNewline; Write-Host $text }
function Fail($text, $hint) { Write-Host "✗ " -ForegroundColor Red -NoNewline; Write-Host $text; Write-Host "   → $hint"; $script:missing = $true }
function Warn($text, $hint) { Write-Host "! " -ForegroundColor Yellow -NoNewline; Write-Host $text; Write-Host "   → $hint" }
function Has($cmd)          { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

Write-Host "TrønderLeikan - sjekk av utviklingsmiljø" -ForegroundColor White
Write-Host ""

# .NET SDK 10
$sdk10 = if (Has dotnet) { dotnet --list-sdks 2>$null | Where-Object { $_ -match '^10\.' } | Select-Object -Last 1 } else { $null }
if ($sdk10) { Ok ".NET SDK 10 ($(($sdk10 -split ' ')[0]))" }
else { Fail ".NET SDK 10 mangler" "https://dotnet.microsoft.com/download/dotnet/10.0" }

# Docker daemon
if ((Has docker) -and (docker info 2>$null)) {
    Ok "Docker kjører ($(docker version --format '{{.Server.Version}}' 2>$null))"
    $memBytes = [long](docker info --format '{{.MemTotal}}' 2>$null)
    if ($memBytes -gt 0 -and $memBytes -lt 4000000000) {
        Warn "Docker har under 4 GB minne ($([int]($memBytes / 1MB)) MB). Zitadel kan bli treg ved første oppstart" "Øk minne i Docker Desktop → Settings → Resources"
    }
}
else { Fail "Docker daemon svarer ikke" "https://www.docker.com/products/docker-desktop/ (start Docker Desktop)" }

# Bun
if (Has bun) { Ok "Bun $(bun --version)" }
else { Fail "Bun mangler" "https://bun.sh/docs/installation" }

# Git
if (Has git) { Ok "$(git --version)" }
else { Fail "Git mangler" "https://git-scm.com/downloads" }

# Aspire CLI er valgfritt: AppHost bygger med Aspire.AppHost.Sdk fra NuGet, men CLI gir «aspire run» og MCP-server
if (Has aspire) { Ok "Aspire CLI $((aspire --version 2>$null | Select-Object -First 1) -split '\+' | Select-Object -First 1)" }
else { Warn "Aspire CLI mangler (valgfritt)" "https://aspire.dev/get-started/install-cli/" }

# Agent-harness. Claude Code er default i workshopen, men andre er lov
if (Has claude) { Ok "Claude Code $(claude --version 2>$null | Select-Object -First 1)" }
else { Warn "Claude Code mangler. Bruker du en annen harness er det greit" "https://docs.anthropic.com/en/docs/claude-code/quickstart" }

# GitHub CLI brukes i workshopen til PR-er og issues
if (Has gh) {
    gh auth status 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) { Ok "GitHub CLI innlogget" }
    else { Warn "GitHub CLI finnes men er ikke innlogget" "Kjør: gh auth login" }
}
else { Warn "GitHub CLI mangler (brukes i workshopen)" "https://cli.github.com/" }

Write-Host ""
if ($script:missing) {
    Write-Host "Noe mangler. Installer det som er rødt og kjør scriptet igjen." -ForegroundColor Red
    exit 1
}

Write-Host "Alt påkrevd er på plass." -ForegroundColor Green
Write-Host ""
Write-Host @"
Neste steg:

  dotnet run --project src/TronderLeikan.AppHost

Passord og nøkler genereres automatisk første gang og lagres i user secrets.
Første oppstart laster ned containere og initialiserer Zitadel, regn med 2-5 minutter.
Aspire-dashboardet åpnes i nettleseren (URL med token står i terminalen).

  Frontend:  http://localhost:3000
  Admin:     http://localhost:3000/admin
  Bruker:    zitadel-admin@zitadel.localhost
  Passord:   Password1!
"@
exit 0
