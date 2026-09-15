# AGENTS.md

TrønderLeikan: plattform for turneringsstyring og poengberegning for faggruppa.

## Stack

- Backend: .NET 10, Clean Architecture (`src/TronderLeikan.*`)
- Frontend: Next.js 16 i `src/frontend`
- Orkestrering: .NET Aspire via `src/TronderLeikan.AppHost`
- Infrastruktur: PostgreSQL, Valkey, Zitadel

## Kjøring

- Hele stacken: `dotnet run --project src/TronderLeikan.AppHost`
- Tester: `dotnet test`

## Dokumentasjon

- Domene og poengregler: `docs/TRONDER_LEIKAN.md`
- Oppgaver: `docs/backlog.md`
