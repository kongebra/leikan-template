# Workshop: Agentisk utvikling

Dette er styringsdokumentet for begge dagene.
Ha det oppe på egen maskin, så jobber du i eget tempo.
Fasilitator roper opp til teori og recap.
Klokkeslett får du på stedet.

Oppgavene bruker user stories fra [docs/backlog.md](docs/backlog.md).
Domenet er beskrevet i [docs/TRONDER_LEIKAN.md](docs/TRONDER_LEIKAN.md).
Teknisk oppsett står i [README.md](README.md).

## Forberedelser

Gjør dette hjemme, minst tre dager før workshopen.
Vi bruker ikke workshoptid på oppstartsfeil.

**Påkrevd**

1. Lag ditt eget repo fra templaten: åpne `github.com/kongebra/leikan-template` og klikk «Use this template».
2. Klon repoet ditt.
   Laget du repoet før materialet ble oppdatert? Hent de nye versjonene:

   ```
   git remote add template https://github.com/kongebra/leikan-template.git
   git fetch template
   git checkout template/main -- WORKSHOP.md docs/backlog.md
   git commit -m "Oppdater workshopmateriell fra templaten"
   ```

3. Kjør `./bootstrap.sh` (macOS/Linux) eller `pwsh -ExecutionPolicy Bypass -File .\bootstrap.ps1` (Windows, PowerShell 7). Alt påkrevd skal være grønt.
4. Kjør `dotnet run --project src/TronderLeikan.AppHost`. Første gang tar 2-5 minutter.
5. Åpne Aspire-dashboardet fra lenken i terminalen. Alle ressurser skal bli grønne.
6. Klikk på lenken til `frontend`. Du skal se to turneringer med scoreboard.
7. Legg til `/admin` på samme adresse, logg inn med `zitadel-admin@zitadel.localhost` og `Password1!`.
8. Harnessen din er installert og innlogget. Fasilitator kjører Claude Code, men alle harnesser kan brukes, se «Andre harnesser» bakerst. Bruker du Claude Code, skal `claude --version` vise 2.1.281 eller nyere. Start og avslutt én sesjon etter oppgraderingen, før workshopen.

**Anbefalt**

- GitHub CLI, innlogget med `gh auth login`. Brukes til issues og PR-er.
- Aspire MCP, så agenten kan lese logger og ressursstatus selv. Sjekk med `claude mcp list`.
- Playwright MCP med `npx playwright install chromium`, så agenten kan bevise ting i nettleseren.

**Ta med**

- Din personlige instruksfil slik den er i dag, hvis du har en. For Claude Code er det `~/.claude/CLAUDE.md`.

Hvis noe stopper: sjekk «Feilsøking» i [README.md](README.md#feilsøking) først, og skriv så i Slack-tråden med feilmeldingen.

## Modulene

Hver modul har navn etter det vi jobber med.
Navnet er ikke nødvendigvis en fil du skal lage.

| Modul | Hva vi jobber med |
|---|---|
| `AGENTS.md` | Instruksene agenten får hver gang |
| `PLAN.md` | Å planlegge og utføre en oppgave med en agent |
| `hooks.json` | Tester, bevis og regler agenten ikke kan bryte |
| `SUBAGENTS.md` | Å delegere og jobbe parallelt |
| `SKILL.md` | Å gjøre gjentakelser om til noe gjenbrukbart |
| `REVIEW.md` | Review og sikkerhet |

I `PLAN.md` velger du én story, og den tar du med deg videre.
Ingen feiler workshopen fordi storyen ikke ble ferdig.
Det som ikke gikk, er også læring.

## Hva du sitter igjen med

1. Hva som hører hjemme i `AGENTS.md`.
2. Når en `SKILL.md` lønner seg.
3. Hvordan hooks stopper det som aldri skal skje.
4. Erfaring med subagenter, både i naturlig språk og definert.
5. Kunnskap til å foreslå et oppsett hos kunden din.

## Slik leser du en modul

- **Mål:** hva du kan etterpå.
- **Start:** det første alle gjør.
- **Utforsk:** retninger og spørsmål, ikke oppskrifter.
- **Ferdig tidlig:** for deg som har tid til overs.
- **Ferdig når:** hva som skal være sant når modulen er slutt.
- **Recap:** spørsmålene vi tar i smågrupper og plenum.

Oppgavene er bevisst åpne.
Den som limer inn en story og trykker enter lærer ingenting.
Tolk, utforsk koden og gi agenten kontekst, gjerne sammen med andre.

## Dag 1

### `AGENTS.md`

**Mål:** en fersk agent vet hvordan repoet kjøres, testes og er bygd opp, uten at du må forklare det.

**Start**

Start en fersk sesjon uten `AGENTS.md`.
Spør hvordan appen kjøres og testes.
Noter alt agenten bommer på eller må lete lenge etter.

**Utforsk**

- Kjør `/init` og les resultatet kritisk. Hva er nyttig, og hva er støy? Slett `CLAUDE.md` som `/init` lagde før du går videre, ellers leser ikke Claude Code `AGENTS.md`-en din.
- Skriv din egen `AGENTS.md` for hånd, under omtrent 100 linjer. Det er vårt eget mål; Anthropic anbefaler under 200. Fjern det som ikke hjelper.
- For hver linje: gjør agenten feil uten den? Hvis ikke, kutt den.
- Mye som bare gjelder én del av repoet, kan ligge i en egen `AGENTS.md` i den mappa. Claude Code, opencode og Copilot CLI laster den når de leser filer der. Codex og pi laster den bare hvis du starter agenten i mappa.
- Pek til detaljer i stedet for å lime dem inn, for eksempel «Detaljer om migrasjoner: docs/migrations.md». En `@`-import lastes alltid, en vanlig sti leses bare ved behov.
- Flytt det som gjelder alle prosjektene dine til din personlige instruksfil. Har du en fra før, gjør den bedre.
- Kjør `/context` og `/memory` før og etter. Stemmer det med det du trodde?
- Ny fersk sesjon, samme spørsmål. Sammenlign med starten.

Claude Code leser `AGENTS.md` direkte fra versjon 2.1.281, så lenge det ikke finnes noen `CLAUDE.md` eller `CLAUDE.local.md` i prosjektet.
Eldre versjoner trenger en `CLAUDE.md` med én linje: `@AGENTS.md`.

Når konteksten er forgiftet, gjentar agenten feil du har rettet, følger noe du limte inn i stedet for kodebasen, eller glemmer krav fra tidlig i sesjonen.
Bruk `/clear` for en ny oppgave eller en forgiftet kontekst.
Bruk `/compact` når du fortsatt jobber med samme oppgave, men konteksten er full.

Noter prompter du skriver flere ganger underveis i workshopen. Du trenger dem i `SKILL.md`.

Ferdig tidlig:

- Legg regler for én del av repoet i `.claude/rules/` med `paths:`.
- Se hva auto memory har skrevet om deg.
- Sammenlign din `AGENTS.md` med naboens.
- Jobber du i store repoer hos kunde: les [Claude Code i store kodebaser](https://code.claude.com/docs/en/large-codebases).

**Ferdig når:** `AGENTS.md` er committet, og agenten klarer seg selv.

**Recap:**

1. Hva fjernet du fordi det ikke hjalp?
2. Hvordan skiller fila di seg fra `/init` og fra naboens?
3. Hva hører hjemme i din personlige fil?

### `PLAN.md`

**Mål:** du lar agenten utforske og planlegge før den bygger, og du vet hva grilling tilfører briefen din.

**Start**

Velg en story fra [docs/backlog.md](docs/backlog.md). Den tar du med deg resten av workshopen.
Skriv en brief på tre linjer: hva som skal være sant etterpå, hva som ikke skal røres (hvis du vet det, ellers finner du det ut underveis), og hvordan vi vet at det virker.
Start en fersk sesjon og gå i plan mode: skriv `/plan` foran briefen, eller trykk `Shift+Tab` til statuslinja viser plan mode.
På Pro, Max og Team starter Claude Code i auto, og da må du trykke `Shift+Tab` tre ganger.
Ikke godkjenn planen før du faktisk er enig i den.

Start så en ny fersk sesjon på samme story.
La agenten grille deg før den planlegger, med `grill-me` fra [mattpocock/skills](https://github.com/mattpocock/skills) eller `brainstorming` fra [obra/superpowers](https://github.com/obra/superpowers).
Legg de to planene side om side, velg den beste, og bygg videre på den.

**Utforsk**

- La agenten utforske koden før den planlegger. Hva fant den som du ikke visste?
- Kjør `/context` etter utforskningen. Hvor mye kostet det å lese seg opp?
- Hva måtte du forklare agenten som den burde visst om repoet? Legg det inn i `AGENTS.md`.

Ferdig tidlig:

- Kjør samme brief uten plan mode i en ny sesjon. Hva ble annerledes?
- Ta neste steg i manual-modus og i auto-modus. Hvor mange ganger måtte du svare?

**Ferdig når:** planene er sammenlignet, den beste er valgt, og første skive bygger.

**Recap:**

1. Hva gjorde agenten som du ikke forutså?
2. Hva måtte du forklare som agenten burde visst?
3. Hva fant grillingen som briefen din manglet?

### `hooks.json`

**Mål:** agenten beviser at arbeidet virker, og du har minst én regel den ikke kan bryte.

**Start**

Skriv en test for kjerneregelen i storyen din.
Den skal være rød før agenten implementerer.
Agenten skal ikke endre testen for å få den grønn.

**Utforsk**

- Bevis mot kjørende system, med Playwright eller kall mot API-et. Grønne tester er ikke nok.
- Lag en hook. Den kan være personlig og gjelde alle prosjektene dine, eller høre til dette repoet. Hva i jobben din burde vært en hook og ikke en instruks?
- Trigg hooken med vilje. En hook som aldri har fyrt, er bare en hypotese.

Hvor hører en feil agenten gjorde hjemme?

| Agenten gjorde feil | Løs det med |
|---|---|
| Den visste det ikke | regel i `AGENTS.md` |
| Det kan sjekkes | test |
| Det må aldri skje | hook |
| Det gjentar seg | skill |
| Det er mekanisk | script |

Ferdig tidlig:

- Lag en hook til, av en annen type enn den første.
- Del hooken din med en som jobber annerledes enn deg. Passer den for dem?

**Ferdig når:** minst én test var rød før den ble grønn, beviset er klart for PR-en, og hooken er trigget med vilje.

**Recap:**

1. Hva fant testen eller beviset som du ellers ville sendt videre?
2. Når prøvde agenten å jukse seg forbi?
3. Hva i jobben din burde vært en hook og ikke en instruks?

### Før du går

Ingen lekser. Hvil hodet.
I morgen starter vi med å se om `AGENTS.md`-en din holder.

## Dag 2

### Holder `AGENTS.md`-en din?

Start en fersk sesjon.
Ta neste steg i storyen din, uten hjelp.
Klarer agenten seg med det du skrev i går?

### `SUBAGENTS.md`

**Mål:** du delegerer til subagenter på to måter, og du jobber parallelt i en worktree.

**Start**

Be hovedagenten starte en subagent som reviewer storyen din i fersk kontekst.
Skriv hand-offen selv: målet, hvilke filer den skal se på, hva som allerede er bestemt, og nøyaktig hva du vil ha tilbake.
Subagenten vet ingenting om samtalen din.
Claude Code kan også velge en fork, som arver hele samtalen og hovedmodellen. Skriv «ikke fork, bruk en fersk subagent» i hand-offen.

**Utforsk**

- Kjør `/context` før og etter at du delegerer en utforskning. Hva ble igjen i hovedsesjonen?
- La subagenter kjøre på en mindre og raskere modell. Legg regelen i din personlige instruksfil.
- Lag en definert subagent i `.claude/agents/`. Start gjerne fra en samling, men les den før du bruker den: [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents), [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code), [github/awesome-copilot](https://github.com/github/awesome-copilot) eller [VoltAgent/awesome-codex-subagents](https://github.com/VoltAgent/awesome-codex-subagents).
- Følg opp ett funn fra reviewen i en worktree, i en egen sesjon, mens hovedsesjonen jobber videre med storyen. Merge tilbake når det er ferdig.

AppHost kjører bare fra hovedklonen, se [README.md](README.md#feilsøking).
Kjør bare tester i worktreen.

Ferdig tidlig:

- La en definert subagent med `isolation: worktree` gjøre oppfølgingen. Commit først og sett `"worktree": { "baseRef": "head" }` i `.claude/settings.local.json`, ellers starter den fra `main`.

**Ferdig når:** review-rapporten finnes, minst ett funn er fulgt opp, og minst én subagent kjørte på en billigere modell.

**Recap:**

1. Hva fant reviewen som du ikke så selv?
2. Hvordan så hand-offen din ut, og hva manglet?
3. Når ville du delegert hos kunden, og når ikke?

### `SKILL.md`

**Mål:** du har gjort noe du gjentar til en skill, og agenten finner den selv når du trenger den.

**Start**

Plukk én prompt du har skrevet flere ganger.
En skill er egentlig bare en prompt med et navn og en beskrivelse.

**Utforsk**

- Lag skillen i `.claude/skills/<navn>/SKILL.md`, eller personlig i `~/.claude/skills/`.
- Bruk den på storyen din i en fersk sesjon.
- Test begge veier: med `/navn`, og med naturlig språk uten å nevne skillen. Hentes den ikke, er beskrivelsen feil.
- Forbedre den etter første kjøring.
- Skal andre harnesser bruke den: legg den også i `.agents/skills`. Claude Code leser ikke noe under `.agents/`.

Inspirasjon: [mattpocock/skills](https://github.com/mattpocock/skills), [obra/superpowers](https://github.com/obra/superpowers), [anthropics/skills](https://github.com/anthropics/skills) og [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code).
Sjekk lisensen før du kopierer: awesome-claude-code er CC BY-NC-ND, så les den for ideer.

Verdien bestemmer du selv.
En skill som bare er morsom, teller også.

Ferdig tidlig:

- Del skillen opp i flere filer som lastes ved behov.
- Legg ved et script skillen kan kjøre.

**Ferdig når:** skillen er testet med `/navn` og med naturlig språk, og forbedret minst én gang.

**Recap:**

1. Hvilken prompt slutter du å skrive nå?
2. Når hentet agenten skillen, og når ikke?
3. Hvilken skill tar du med til kunden mandag?

### `REVIEW.md`

**Mål:** du vet hva du kan stole på en agent-review med, og storyen din har en PR.

**Start**

Du får tre PR-er fra fasilitator.
Finn det som er galt selv først.
Så med en agent i fersk kontekst.
Sammenlign.

**Utforsk**

- Review lokalt før PR, med en subagent uten forgiftet kontekst og uten forfatterens blikk. Sammenlign med Copilot code review på PR-en i GitHub.
- Legg inn en deny-regel som nekter agenten å lese secrets. I Leikan ligger de ikke i `.env`, men i `src/TronderLeikan.AppHost/zitadel-bootstrap/` og i user secrets under hjemmemappen (`~/.microsoft/usersecrets/`, på Windows `%APPDATA%\Microsoft\UserSecrets`).
- Tekst fra web, issues og PR-er kan inneholde instrukser. Prompt injection er ikke løst, så tillatelsene dine er grensen. Hva gjør agenten din med dem?
- Ferdigstill din egen story-PR.

**Ferdig når:** PR-en din er oppe, og du vet hva som mangler.

**Recap:**

1. Hvilken feil fant agenten som du overså, og omvendt?
2. Hva ville du stolt på en agent-review med hos kunden?
3. Lot agenten seg lure av teksten den leste?

### Hva lærte vi?

- Hva fungerte?
- Hva fungerte ikke?
- Hva tar vi med oss?
- Lærte du ingenting nytt? Hvorfor ikke?

## Andre harnesser

Prinsippene er de samme.
Bruker du noe annet enn Claude Code, må du gjøre en liten innsats selv.

| Begrep | Claude Code | Codex CLI | GitHub Copilot | pi |
|---|---|---|---|---|
| Instrukser | `AGENTS.md` fra 2.1.281, ellers `CLAUDE.md` med `@AGENTS.md` | `AGENTS.md` | `.github/copilot-instructions.md`, `AGENTS.md` | `AGENTS.md` |
| Planlegging | Plan mode, `Shift+Tab` | `/plan` | Plan-agent og plan mode | Extension |
| Skills | `.claude/skills/` | `.agents/skills/` | `.github/skills/`, `.claude/skills/`, `.agents/skills/` | Skills |
| Hooks | `.claude/settings.json` | `hooks.json` eller `config.toml` | `.github/hooks/*.json`; CLI leser også hooks i `.claude/settings.json` | TypeScript-extensions |
| Subagenter | Naturlig språk eller `.claude/agents/` | `.codex/agents/` | `.github/agents/*.agent.md` | Extension eller flere prosesser |
| Worktrees | `git worktree add`, eller `claude --worktree` med `worktree.baseRef: "head"` | `codex --worktree` eller `/worktree` (detached HEAD, lag en branch før du merger), eller `git worktree` | `git worktree` | `git worktree` |

## Vokabular

| Begrep | Betydning |
|---|---|
| Harness | Verktøyet som gir modellen hender: filsystem, shell, git, nettleser. Claude Code, Codex, Copilot, pi. |
| Brief | Hva som skal være sant etterpå, hva som ikke skal røres, og hvordan vi vet at det virker. |
| Plan mode | Agenten utforsker og planlegger uten å endre filer før du godkjenner. |
| `AGENTS.md` | Instruksene agenten leser ved oppstart. Kort, sant, gjelder alltid. |
| Skill | En prompt med navn og beskrivelse som agenten henter når den trengs. |
| Hook | Kommando som kjøres automatisk før eller etter en handling. Kan nekte agenten. |
| Deny | Regel som nekter agenten et verktøy eller en fil, uansett hva den vil. |
| Subagent | Agent startet av en agent, med egen fersk kontekst. Bare svaret kommer tilbake. |
| Hand-off | Instruksen du gir en subagent. Den må stå på egne ben. |
| Worktree | Egen arbeidskopi av repoet på egen branch, så to sesjoner kan jobbe parallelt. |
| Forgiftet kontekst | Konteksten har tatt med seg noe som styrer agenten feil. |
| `/context` | Viser hva agenten faktisk bærer med seg i sesjonen. |
