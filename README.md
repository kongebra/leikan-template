# Trønder Leikan

> **Workshop-deltaker?** Start med [WORKSHOP.md](WORKSHOP.md).

Intern plattform for turneringsstyring og poengberegning. Brukes til å administrere konkurranser, registrere resultater og vise scoreboard — alt fra gaming-turneringer til simracing.

---

## Innhold

- [Hva er dette?](#hva-er-dette)
- [Teknologistack](#teknologistack)
- [Kom i gang](#kom-i-gang)
- [Prosjektstruktur](#prosjektstruktur)
- [Arkitektur](#arkitektur)
- [API-oversikt](#api-oversikt)
- [Domenemodell og poengregler](#domenemodell-og-poengregler)
- [Testing](#testing)

---

## Hva er dette?

Trønder Leikan lar administratorer:

- Opprette turneringer med egne poengregler
- Registrere spill (enkeltkonkurranser) innen en turnering
- Knytte deltakere, arrangører og tilskuere til hvert spill
- Fullføre spill med plasseringer (1., 2., 3. plass — støtter ties)
- Se live scoreboard per turnering

---

## Teknologistack

| Lag | Teknologi |
|---|---|
| Backend | .NET 10 (C#) |
| Frontend | Next.js 16, React 19, Tailwind CSS 4, TypeScript |
| Database | PostgreSQL |
| Identity | Zitadel v4 |
| Orkestrering | .NET Aspire |
| Pakkehåndtering (frontend) | npm (Node.js 22+) |

---

## Kom i gang

### Forutsetninger

- [.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (PostgreSQL og Zitadel kjører i containere)
- [Node.js 22 eller nyere](https://nodejs.org/en/download) med npm (frontend)
- [Git](https://git-scm.com/downloads)
- [GitHub CLI](https://cli.github.com/), innlogget med `gh auth login`

Aspire trenger ingen workload; AppHost bruker `Aspire.AppHost.Sdk` fra NuGet.
[Aspire CLI](https://aspire.dev/get-started/install-cli/) er valgfritt.

Sjekk at alt er på plass:

```bash
./bootstrap.sh                                    # macOS / Linux
pwsh -ExecutionPolicy Bypass -File .\bootstrap.ps1  # Windows (PowerShell 7)
```

Scriptet installerer ingenting utover `dotnet ef` fra `.config/dotnet-tools.json`, men sier tydelig hva som mangler og hvor du finner det.
Windows-scriptet krever [PowerShell 7](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows).
`-ExecutionPolicy Bypass` trengs fordi Windows som standard nekter å kjøre script lastet ned fra nettet.

På Windows: klon til en kort sti, for eksempel `C:\src\`, og bruk gjerne Windows Terminal.
Bruker du WSL, klon inne i WSL-filsystemet og ikke under `/mnt/c`.

### Kjør hele stacken

```bash
dotnet run --project src/TronderLeikan.AppHost   # med .NET SDK
aspire run                                       # med Aspire CLI
```

Aspire starter opp og orkestrerer:

1. **PostgreSQL** — database for TrønderLeikan og Zitadel
2. **Zitadel** — identitetsleverandør (api, login-UI og Traefik-proxy på port 8080)
3. **DbMigrator** — kjører EF Core-migrasjoner og legger inn demodata hvis databasen er tom
4. **API** — venter til migrasjoner er fullført
5. **Frontend** — Next.js via npm. Aspire velger en ledig port, adressen står på `frontend` i dashboardet

Første oppstart tar 2-5 minutter fordi containere lastes ned og Zitadel initialiseres.
Aspire Dashboard åpnes automatisk og viser logger, helse og traces for alle tjenester.

### Innlogging

Admin-panelet på `<frontend-adresse>/admin` krever innlogging via Zitadel.
Zitadel oppretter en admin-bruker ved første oppstart:

| | |
|---|---|
| Bruker | `zitadel-admin@zitadel.localhost` |
| Passord | `Password1!` |

Zitadel-konsollen finnes på <http://localhost:8080/ui/console> med samme bruker.

### Hemmeligheter

Postgres-passord, Zitadel-masterkey og better-auth-secret genereres første gang og lagres i user secrets for AppHost.
OIDC-klienten frontend bruker opprettes automatisk i Zitadel ved første oppstart og lagres i `src/TronderLeikan.AppHost/zitadel-bootstrap/` (gitignored).
Du trenger ikke gjøre noe manuelt.

Vil du overstyre en verdi:

```bash
dotnet user-secrets --project src/TronderLeikan.AppHost \
  set "Parameters:postgres-password" "<passord>"
```

### Porter

Frontend og API får ledige porter av Aspire, så de kolliderer ikke med noe annet som kjører på maskinen.
Zitadel må ha en fast port fordi login-URL-ene lagres i databasen ved første oppstart. Standard er 8080.
Er 8080 opptatt, sett en annen port før første oppstart:

```bash
dotnet user-secrets --project src/TronderLeikan.AppHost set "Zitadel:Port" 8081
```

Bytter du port etter at Zitadel er initialisert, kjør reset-scriptet under først.

### Nullstill lokalt miljø

Vil du starte helt på nytt: stopp AppHost og kjør reset-scriptet.
Det fjerner postgres-containeren, Aspire-nettverket, datavolumet `leikan-postgres-data` og `zitadel-bootstrap/`, og rører ikke andre prosjekter.

```bash
./reset-local.sh      # macOS / Linux
.\reset-local.ps1     # Windows
```

### Feilsøking

| Symptom | Årsak | Løsning |
|---|---|---|
| `zitadel-api` stopper med `lookup postgres.dev.internal ... no such host` | Postgres-containeren henger igjen fra en tidligere kjøring og er ikke på Aspire-nettverket | Stopp AppHost, kjør `reset-local`, start igjen |
| `postgres` stopper med melding om `pg_upgrade` eller «database files are incompatible» | Volumet har data fra en eldre Postgres-versjon enn Aspire nå bruker | Samme som over |
| AppHost feiler med `Zitadel er klar, men admin-PAT finnes ikke` | Zitadel-databasen er initialisert fra før, men `zitadel-bootstrap/` er slettet | Samme som over |
| Innlogging gir 400 fra Zitadel med `redirect_uri` | Frontend kjører på en annen adresse enn da OIDC-appen ble laget | Start AppHost på nytt, provisioneren oppdaterer redirect-URI |
| AppHost feiler med at port 8080 er i bruk | En annen app bruker porten Zitadel trenger | Sett `Zitadel:Port` som beskrevet under «Porter», kjør `reset-local`, start igjen |
| Innlogging havner på feil port eller gir 404 fra Zitadel | `Zitadel:Port` er endret etter at databasen ble initialisert | Kjør `reset-local` og start igjen |
| Forsiden viser «Ingen turneringer ennå» | Frontend får ikke svar fra API-et | Sjekk at `api` er grønn i dashboardet, se konsolloggen til `frontend` |
| `migrator` eller `api` stopper med `Could not load file or assembly` | Repoet ligger under `/tmp` på macOS, som er en symlink | Klon til en vanlig mappe |
| Frontend starter ikke, `frontend-npm-install` feiler | Node.js/npm mangler eller nettverket blokkerer registry | Kjør `npm install` manuelt i `src/frontend` og se feilen |
| Sesjonen forsvinner etter noen minutter | better-auth kjører uten database og lagrer sesjonen i cookie | Forventet. Cookien fornyes ved aktivitet og varer 7 dager |

### Kjør kun frontend (manuelt)

```bash
cd src/frontend
npm install
npm run dev
```

### Bytte pakkebehandler i frontend

Templaten bruker npm fordi det følger med Node.js og fungerer likt for alle.
Vil du heller bruke pnpm, yarn eller Bun, gjør tre ting:

1. Slett `src/frontend/package-lock.json` og kjør `pnpm install`, `yarn install` eller `bun install` for å få riktig lockfil.
2. I `src/TronderLeikan.AppHost/AppHost.cs`, legg til `.WithPnpm()`, `.WithYarn()` eller `.WithBun()` etter `AddJavaScriptApp(...)`.
3. I `.github/workflows/ci.yml`, bytt `setup-node` og `npm`-stegene i `frontend`-jobben til tilsvarende for verktøyet ditt.

### Kjør kun API (uten Aspire)

Sett environment-variabel `ConnectionStrings__tronderleikan` til en PostgreSQL-connection string og:

```bash
dotnet run --project src/TronderLeikan.API
```

---

## Prosjektstruktur

```
src/
├── TronderLeikan.AppHost/          # .NET Aspire — orkestrerer alle tjenester
├── TronderLeikan.ServiceDefaults/  # Delt Aspire-konfig (OpenTelemetry, helse, service discovery)
├── TronderLeikan.API/              # HTTP-lag: Controllers, Program.cs
├── TronderLeikan.Application/      # Use cases, queries, commands, Result-pattern
├── TronderLeikan.Domain/           # Entiteter, domenehendelser, forretningslogikk
├── TronderLeikan.Infrastructure/   # EF Core, PostgreSQL, migrasjoner, bildehåndtering
├── TronderLeikan.DbMigrator/       # Standalone-app som kjører migrasjoner ved oppstart
└── frontend/                       # Next.js-app med Tailwind CSS

docs/
├── TRONDER_LEIKAN.md               # Fullstendig domenedokumentasjon
└── backlog.md                      # User stories til workshopen
```

---

## Arkitektur

Prosjektet følger **Clean Architecture** med streng avhengighetsregel:

```
API → Application → Domain
Infrastructure implementerer interfaces fra Application
```

### Lag

**Domain** — kjerneentiteter uten eksterne avhengigheter. Ingen EF Core, ingen HTTP. Inneholder forretningslogikk og domenehendelser.

**Application** — use cases som handlers. Returnerer `Result<T>` med en sterk `Error`-type (kode + `ErrorType`-enum). Ingen domenelogikk her, kun koordinering.

**Infrastructure** — EF Core + PostgreSQL via Npgsql. Konfigurasjoner i `Persistence/Configurations/`. Domain events skrives til `EventStore` og `OutboxMessages` i samme transaksjon som forretningsdata. Ingenting leser outboxen ennå; det finnes ingen prosessor eller meldingskø.

**API** — Controllers arver `ApiControllerBase` som tilbyr `Problem(Error)` med RFC 9457 Problem Details. Versjonert via URL-segment (`/api/v1/`). Ingen autentisering i dag.

---

## API-oversikt

Alle endepunkter er under `/api/v1/`. Feil returneres som RFC 9457 Problem Details.

```
GET    /api/v1/departments

GET    /api/v1/persons
GET    /api/v1/persons/{id}
POST   /api/v1/persons
PUT    /api/v1/persons/{id}
DELETE /api/v1/persons/{id}
PUT    /api/v1/persons/{id}/image        # multipart/form-data
DELETE /api/v1/persons/{id}/image

GET    /api/v1/tournaments
GET    /api/v1/tournaments/{slug}
POST   /api/v1/tournaments
PUT    /api/v1/tournaments/{id}/point-rules
GET    /api/v1/tournaments/{id}/scoreboard
GET    /api/v1/tournaments/{id}/games

GET    /api/v1/games/{id}
POST   /api/v1/games
PUT    /api/v1/games/{id}
POST   /api/v1/games/{id}/participants
POST   /api/v1/games/{id}/organizers
POST   /api/v1/games/{id}/spectators
POST   /api/v1/games/{id}/complete
PUT    /api/v1/games/{id}/banner         # multipart/form-data
GET    /api/v1/games/{id}/simracing-results
POST   /api/v1/games/{id}/simracing-results
POST   /api/v1/games/{id}/simracing-results/complete
```

OpenAPI-dokumentet er tilgjengelig på `/openapi/v1.json` i development. Det finnes ingen Swagger UI.

---

## Domenemodell og poengregler

### Entiteter

**Tournament** — samling av spill med egne poengregler og en `slug` for URL-bruk.

**Game** — enkeltkonkurranse i en turnering. Har deltakere, arrangører og tilskuere. Støtter `GameType` (Standard, Simracing m.fl.). Kun spill med `IsDone = true` teller på scoreboard.

**Person** — person som kan delta i, arrangere eller tilskue spill.

**Department** — avdeling som personer kan tilhøre.

### Poengregler (standard)

| Handling | Poeng |
|---|---|
| Delta i spill | 3 |
| 1. plass | +3 |
| 2. plass | +2 |
| 3. plass | +1 |
| Arrangere (uten deltakelse) | 3 |
| Arrangere (med deltakelse) | +1 (i tillegg til deltaker-poeng) |
| Tilskuer | 1 |

Plasseringspoeng er **additive** — en vinner får deltakerpoeng + plasspoeng. Reglene er konfigurerbare per turnering. Ties støttes: flere kan dele samme plass.

Arrangørpoeng avhenger av om arrangørene også spiller (`isOrganizersParticipating` på spillet):

- Arrangør som **ikke** spiller får bare arrangørpoeng, med standardregler 3. Det er samme sum som en vanlig deltaker, så ingen taper på å arrangere.
- Arrangør som **også** spiller får deltakerpoeng + arrangørtillegg, med standardregler 3 + 1 = 4, og eventuelle plasspoeng oppå det.

Eksempel med standardregler: Kari arrangerer og spiller, vinner. Ola spiller, blir nummer to. Tor arrangerer uten å spille. Astrid ser på.

| Person | Utregning | Poeng |
|---|---|---|
| Kari | 3 deltaker + 1 arrangør + 3 førsteplass | 7 |
| Ola | 3 deltaker + 2 andreplass | 5 |
| Tor | 3 arrangør uten deltakelse | 3 |
| Astrid | 1 tilskuer | 1 |

Flere scenarier ligger i [docs/TRONDER_LEIKAN.md](docs/TRONDER_LEIKAN.md) under «Example Scenarios».

---

## Testing

### Kjør alle tester

```bash
dotnet test
```

### Kjør spesifikk testklasse

```bash
dotnet test --filter "FullyQualifiedName~PersonsApiTests"
```

### Akseptansetester (API)

Testprosjektet `TronderLeikan.Api.Tests` bruker `WebApplicationFactory` + `Testcontainers.PostgreSql` — ekte PostgreSQL-container, black-box mot HTTP-kontrakten. Ingen referanser til Application- eller Domain-typer i testene.
Assertions skrives med [AwesomeAssertions](https://awesomeassertions.org/) (Apache 2.0).

### Migrasjoner

`dotnet ef` ligger i `.config/dotnet-tools.json` og gjenopprettes av bootstrap-scriptet (eller `dotnet tool restore`).

```bash
dotnet ef migrations add <Navn> --project src/TronderLeikan.Infrastructure
```
