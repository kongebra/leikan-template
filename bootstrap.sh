#!/usr/bin/env bash
# Sjekker at verktøyene TrønderLeikan trenger er på plass. Installerer ingenting.
# Grønn linje = ok, rød linje = mangler (med lenke), gul linje = anbefalt men ikke påkrevd.
# Exit-kode 1 hvis noe påkrevd mangler.

set -u

GREEN=$'\033[32m'; RED=$'\033[31m'; YELLOW=$'\033[33m'; BOLD=$'\033[1m'; RESET=$'\033[0m'
missing=0

ok()   { printf '%s✓%s %s\n' "$GREEN" "$RESET" "$1"; }
fail() { printf '%s✗%s %s\n   → %s\n' "$RED" "$RESET" "$1" "$2"; missing=1; }
warn() { printf '%s!%s %s\n   → %s\n' "$YELLOW" "$RESET" "$1" "$2"; }

printf '%sTrønderLeikan - sjekk av utviklingsmiljø%s\n\n' "$BOLD" "$RESET"

# .NET SDK 10
if command -v dotnet >/dev/null 2>&1 && dotnet --list-sdks 2>/dev/null | grep -q '^10\.'; then
  ok ".NET SDK 10 ($(dotnet --list-sdks | grep '^10\.' | tail -1 | cut -d' ' -f1))"
else
  fail ".NET SDK 10 mangler" "https://dotnet.microsoft.com/download/dotnet/10.0"
fi

# Docker daemon
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  ok "Docker kjører ($(docker version --format '{{.Server.Version}}' 2>/dev/null))"
  mem_bytes=$(docker info --format '{{.MemTotal}}' 2>/dev/null || echo 0)
  if [ "${mem_bytes:-0}" -gt 0 ] && [ "$mem_bytes" -lt 4000000000 ]; then
    warn "Docker har under 4 GB minne ($((mem_bytes / 1024 / 1024)) MB). Zitadel kan bli treg ved første oppstart" "Øk minne i Docker Desktop → Settings → Resources"
  fi
else
  fail "Docker daemon svarer ikke" "https://www.docker.com/products/docker-desktop/ (start Docker Desktop)"
fi

# Bun
if command -v bun >/dev/null 2>&1; then
  ok "Bun $(bun --version)"
else
  fail "Bun mangler" "https://bun.sh/docs/installation"
fi

# Git
if command -v git >/dev/null 2>&1; then
  ok "$(git --version)"
else
  fail "Git mangler" "https://git-scm.com/downloads"
fi

# Aspire CLI er valgfritt: AppHost bygger med Aspire.AppHost.Sdk fra NuGet, men CLI gir «aspire run» og MCP-server
if command -v aspire >/dev/null 2>&1; then
  ok "Aspire CLI $(aspire --version 2>/dev/null | head -1 | cut -d'+' -f1)"
else
  warn "Aspire CLI mangler (valgfritt)" "https://aspire.dev/get-started/install-cli/"
fi

# Agent-harness. Claude Code er default i workshopen, men andre er lov
if command -v claude >/dev/null 2>&1; then
  ok "Claude Code $(claude --version 2>/dev/null | head -1)"
else
  warn "Claude Code mangler. Bruker du en annen harness er det greit" "https://docs.anthropic.com/en/docs/claude-code/quickstart"
fi

# GitHub CLI brukes i workshopen til PR-er og issues
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then
    ok "GitHub CLI innlogget"
  else
    warn "GitHub CLI finnes men er ikke innlogget" "Kjør: gh auth login"
  fi
else
  warn "GitHub CLI mangler (brukes i workshopen)" "https://cli.github.com/"
fi

echo
if [ "$missing" -ne 0 ]; then
  printf '%sNoe mangler. Installer det som er rødt og kjør scriptet igjen.%s\n' "$RED" "$RESET"
  exit 1
fi

printf '%sAlt påkrevd er på plass.%s\n\n' "$GREEN" "$RESET"
cat <<'NEXT'
Neste steg:

  dotnet run --project src/TronderLeikan.AppHost

Passord og nøkler genereres automatisk første gang og lagres i user secrets.
Første oppstart laster ned containere og initialiserer Zitadel, regn med 2-5 minutter.
Aspire-dashboardet åpnes i nettleseren (URL med token står i terminalen).

  Frontend:  http://localhost:3000
  Admin:     http://localhost:3000/admin
  Bruker:    zitadel-admin@zitadel.localhost
  Passord:   Password1!
NEXT
