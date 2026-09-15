# Workshop: Advanced Agentic Workflow

Toscana, mandag 28. og tirsdag 29. september 2026.
Dette er styringsdokumentet for begge dagene.
Det finnes ingen storskjerm, så du følger dette på egen laptop i eget tempo.

Oppgavene ligger i [docs/backlog.md](docs/backlog.md).
Domenet er beskrevet i [docs/TRONDER_LEIKAN.md](docs/TRONDER_LEIKAN.md).
Teknisk oppsett står i [README.md](README.md).

> Klokkeslett og modulliste er et utgangspunkt og låses etter planleggingsmøtet 17. september.

## Før du reiser

Gjør dette hjemme, senest torsdag 24. september, og bekreft i Slack-tråden.

1. Lag ditt eget repo fra templaten: åpne `github.com/kongebra/leikan-template` og klikk «Use this template». Navn og synlighet velger du selv.
2. Klon repoet ditt.
3. Kjør `./bootstrap.sh` (macOS/Linux) eller `.\bootstrap.ps1` (Windows). Alt skal være grønt.
4. Kjør `dotnet run --project src/TronderLeikan.AppHost`. Første gang tar 2-5 minutter fordi containere lastes ned og Zitadel initialiseres. Målt 15. september på en Mac med containerne allerede lastet ned: under ett minutt fra kommando til grønt dashboard, rundt tre minutter uten cache.
5. Åpne Aspire-dashboardet fra lenken i terminalen. Alle ressurser skal bli grønne.
6. Åpne <http://localhost:3000>. Du skal se to turneringer med scoreboard.
7. Åpne <http://localhost:3000/admin>, logg inn med `zitadel-admin@zitadel.localhost` og `Password1!`. Du skal lande på admin-dashboardet.
8. Sørg for at agent-harnessen din er installert og innlogget. Claude Code er default, andre er tillatt på eget ansvar.

Hvis noe stopper: sjekk «Feilsøking» i [README.md](README.md#feilsøking) først, og skriv så i Slack-tråden med feilmeldingen.
Søndag 27. september har vi oppsamling på stedet for de som ikke fikk det til.

## Den røde tråden: fra sjømann til kaptein

Du slutter å skrive all koden selv og blir kaptein for et mannskap av agenter.
Du påvirker kvalitet gjennom kultur og prosess: memory, skills og verifiseringsløkker, ikke linje-for-linje-review.
Innsatsen din samles i starten (klar plan) og slutten (kvalitetsbar).
Midten delegeres.
Når flaskehalsen forsvinner flytter den til deg, og jobben blir å vite hva som er verdt å bygge.

Oppgavene er bevisst åpne user stories.
Den som bare limer inn storyen og trykker enter er meat-proxy.
Tolk, still spørsmål til deg selv, gi agenten kontekst.

## Dag 1: single-agent mastery

| Tid | Hva |
|---|---|
| 08:30 | M1 Harness og oppsett |
| 09:30 | M2 Memory og skills |
| 11:30 | Lunsj |
| 12:15 | M3 Plan, build, verifiser |
| 14:45 | Oppsummering i plenum |
| 15:00 | Slutt |

### M1: Harness og oppsett (60 min)

**Mål:** Alle har grønt dashboard, kjenner harnessen sin og har kaptein-rammen i hodet.

**Teori:** En harness er verktøyet som gir modellen hender: filsystem, shell, git, nettleser.
Alle harnesser har samme primitiver med ulike navn: memory-filer, skills, hooks, subagents, plan mode.
Konseptene er verktøy-agnostiske, det er derfor Copilot og Codex er lov.

**Hands-on:**

1. Kjør bootstrap og AppHost hvis du ikke gjorde det hjemme.
2. Be agenten forklare hva som kjører: «Hva starter AppHost, og hvordan henger frontend, API og Zitadel sammen?»
3. Be agenten finne ut hvordan poeng beregnes, og sammenlign med [docs/TRONDER_LEIKAN.md](docs/TRONDER_LEIKAN.md).
4. Se `dsh`-demoen (DeepSeek Harness med tool-call-graf) i huddle eller opptak. Lenke kommer.

**Verifiser slik:** Dashboard grønt, innlogget i admin, agenten svarte riktig på poengreglene uten at du pekte den til fila.

**Gå dypere:** Kjør samme spørsmål i en annen harness og sammenlign hvilke filer den leste.

### M2: Memory og skills (120 min)

**Mål:** Repoet ditt har en `CLAUDE.md`/`AGENTS.md` du stoler på, og minst én egen skill.

**Teori:** Memory-fila er kulturen agenten arver ved oppstart.
Den skal være kort, sann og bare inneholde det som gjelder hver gang.
Betinget kunnskap («når du lager en migrasjon, gjør slik») hører hjemme i en skill som lastes ved behov.
Correct-to-store-loopen: når du korrigerer agenten, be den lagre lærdommen i memory eller en skill.
Skill-skepsis: en skill som ikke brukes er støy.

**Hands-on:**

1. Les `AGENTS.md` kritisk. Stemmer alt med koden? Be agenten sjekke hver påstand mot repoet.
2. Rett det som er feil. Be agenten lagre korreksjonen selv.
3. Gjør en liten endring med agenten, for eksempel et nytt felt på `Person`. Legg merke til hva du måtte forklare underveis.
4. Flytt det du forklarte ut i en skill, for eksempel «legg til EF Core-migrasjon» eller «legg til ny admin-side».
5. Test skillen i en frisk sesjon.

**Verifiser slik:** En frisk agent-sesjon gjør steg 3 riktig på første forsøk ved hjelp av memory og skill, uten at du forklarer noe.

**Gå dypere:** Legg til en hook som kjører `dotnet build` etter hver filendring i `src/`, og vurder om det var verdt det.

### M3: Plan, build, verifiser (150 min)

**Mål:** Én user story levert som PR med plan i forkant og E2E-bevis i etterkant.

**Teori:** Kapteinen bruker tiden i starten og slutten.
Plan mode tvinger fram tolkning før kode.
Beviset skal være så nært brukeropplevelsen som mulig: E2E foran unit, skjermbilde foran «testene er grønne».
ACI (agent-computer interface) er hvordan agenten når verden.
Målt i tokens og tid er `gh` CLI ofte billigere enn GitHub MCP for samme jobb.

**Hands-on:**

1. Velg en kort story fra [docs/backlog.md](docs/backlog.md), for eksempel 6, 11 eller 13.
2. Lag en GitHub Issue med `gh issue create` i ditt eget repo. Skriv den slik produkteieren ville.
3. Start agenten i plan mode. Godkjenn ikke planen før den svarer på: hva endres, hvordan bevises det, hva kan gå galt.
4. La agenten bygge. Krev at den beviser endringen mot kjørende AppHost, for eksempel via API-kall eller Playwright.
5. Åpne PR med `gh pr create`. CI skal bli grønn.
6. Underveis: gjør én GitHub-operasjon via MCP og én via `gh`, og noter tokens og tid.

**Verifiser slik:** PR-en har plan, bevis (output eller skjermbilde) og grønn CI. En kollega kan lese PR-en og forstå hva som ble gjort uten å se koden.

**Gå dypere:** Se på `lavish` for strukturerte plan-artefakter.

## Dag 2: multi-agent og autonomi

| Tid | Hva |
|---|---|
| 08:30 | M4 Parallelle agenter og worktrees |
| 10:00 | M5 Autonom validering og risikoreview |
| 11:45 | Start langkjøring (M6) |
| 12:00 | Lunsj |
| 12:45 | M6 Orkestrering og capstone |
| 14:15 | Plenumsdeling |
| 15:00 | Slutt |

### M4: Parallelle agenter og worktrees (90 min)

**Mål:** To user stories levert samtidig av to agenter i samme repo uten at de tråkker på hverandre.

**Teori:** Git worktrees gir hver agent sin egen arbeidskopi på egen branch.
Tenk worktree-pool, ikke bokføring: opprett, bruk, merge, slett.
Velg stories som ikke berører samme filer.

**Hands-on:**

1. Velg to stories som er uavhengige, for eksempel 2 og 9, eller 13 og 14.
2. Start én agent per story, hver i sin worktree.
3. Observer: hvor mye må du følge med? Hva gjør du mens de jobber?
4. Merge begge. Løs konflikter om det ble noen, og reflekter over hvorfor.

**Verifiser slik:** Begge PR-er grønne på CI. Du kan forklare hva som var vanskeligst med parallellitet.

**Gå dypere:** Observer rate limits. Noter når du ble strupet og hva som utløste det.

### M5: Autonom validering og risikoreview (120 min)

**Mål:** En review-agent i frisk kontekst leser PR-ene fra M3 og M4 og finner noe du ikke fant.

**Teori:** Agenten som skrev koden er blind for sine egne antakelser.
En subagent med frisk kontekst og et adversarisk oppdrag finner andre ting.
Gi den en risikoskala, ikke bare «finn feil».
Hooks kan trigge review automatisk på PR-opprettelse.

**Hands-on:**

1. Skriv en review-subagent: frisk kontekst, adversarisk, rangerer funn etter risiko.
2. Kjør den på PR-ene dine fra M3 og M4.
3. Legg til en hook som kjører den når en PR opprettes eller oppdateres.
4. Plenum: hva leser du faktisk selv, og hva slipper du gjennom?

**Verifiser slik:** Review-agenten fant minst ett reelt problem. Hooken kjørte uten at du startet den.

**Gå dypere:** La review-agenten poste funnene som PR-kommentarer via `gh`.

### M6: Langkjøring, orkestrering og capstone (120 min)

**Mål:** En langkjøring med objektiv og token-cap har levert noe brukbart mens du var på lunsj. Fritt arbeid etterpå.

**Teori:** Langkjøring krever et tydelig objektiv, en stoppregel og en måte å verifisere seg selv.
First-mate-mønsteret: én agent styrer mannskapet, du styrer den.

**Hands-on:**

1. Før lunsj: velg en stor story, for eksempel 1, 3, 5 eller 7. Gi agenten objektiv, token-cap og krav om selvverifisering. Start den.
2. Etter lunsj: vurder resultatet. Hva gjorde den, hva stoppet den, hva ville du gjort annerledes i oppdraget?
3. Capstone: fritt valg fra backloggen. Bruk alt fra begge dager.
4. Plenumsdeling siste 45 minutter: én ting som overrasket, én ting du tar med hjem.

**Verifiser slik:** Langkjøringen etterlot en PR eller en tydelig rapport om hvorfor den stoppet. Capstone er demonstrert for minst én annen.

## Vokabular

| Begrep | Betydning |
|---|---|
| Harness | Verktøyet som gir modellen hender: filsystem, shell, git, nettleser. Claude Code, Codex CLI, Copilot, Pi. |
| Memory | `CLAUDE.md`/`AGENTS.md`. Lastes ved oppstart. Kort, sant, gjelder alltid. |
| Skill | Instruksjoner som lastes ved behov for én type oppgave. |
| Hook | Kommando som kjøres automatisk før eller etter en handling i harnessen. |
| Subagent | Agent startet av en agent, med egen frisk kontekst. |
| Plan mode | Agenten utforsker og planlegger uten å endre filer før du godkjenner. |
| Worktree | Egen arbeidskopi av repoet på egen branch. Én per parallell agent. |
| ACI | Agent-computer interface. Hvordan agenten når verden: CLI, MCP, API. |
| MCP | Model Context Protocol. Standard for å gi agenten verktøy. Ikke alltid billigere enn CLI. |
| Correct-to-store | Når du korrigerer agenten, be den lagre lærdommen. |
| Meat-proxy | Den som limer inn oppgaven og trykker enter uten å tolke. |
| Kaptein | Deg. Styrer gjennom plan, kultur og kvalitetsbar. |
| First mate | Agenten som styrer andre agenter på dine vegne. |
| Token-cap | Øvre grense for hvor mye en langkjøring får bruke før den stopper. |
| Adversarisk review | Review med oppdrag om å finne feil, ikke bekrefte at det er bra. |
