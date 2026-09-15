# AGENTS.md

TrønderLeikan: tournament management and scoring platform for the team.

## Stack

- Backend: .NET 10, Clean Architecture (`src/TronderLeikan.*`)
- Frontend: Next.js 16 in `src/frontend`
- Orchestration: .NET Aspire via `src/TronderLeikan.AppHost`
- Infrastructure: PostgreSQL, Valkey, Zitadel

## Running

- Full stack: `dotnet run --project src/TronderLeikan.AppHost`
- Tests: `dotnet test`

## Documentation

- Domain and scoring rules: `docs/TRONDER_LEIKAN.md`
- Backlog: `docs/backlog.md`
