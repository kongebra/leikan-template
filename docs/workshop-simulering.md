# Workshop v2: temaer, simulering og rytme

Arbeidsdokument for å omforme WORKSHOP.md.
Bygger på innspillene fra Svein 16. september og på task statements i CCAR-F eksamensguiden.
Ingen langkjøring over natten.
Alt skal kunne gjøres i arbeidstiden, slik hverdagen faktisk er.

## Svar på spørsmålene

**Tomt repo uten AGENTS.md.**
Ja, og det er den beste enkeltendringen i forslaget.
Da blir modul 1 «lag memory fra ingenting» i stedet for «verifiser arvet memory», og utfallet varierer mer mellom deltakere fordi de skriver ulike ting.
Det gir bedre diskusjon i recap.
To ting å vite før du fjerner filene.
Rot-CLAUDE.md, rot-AGENTS.md og src/frontend/CLAUDE.md kan fjernes.
src/frontend/AGENTS.md skrives på nytt av `next dev` hver gang stacken starter, så den kan ikke fjernes.
Behold den, og bruk den som poeng i modul 2: «denne fila laget ikke du, hva gjør den med agenten din?»
Konsekvensen er at oppgavene senere i workshopen ikke kan forutsette et bestemt innhold i memory.
Det er greit, fordi modul 1 leverer den fila hver deltaker selv trenger videre.

**Føringer i stedet for konkrete oppgaver.**
Ja, med én reservasjon.
De uerfarne trenger ett konkret første steg for å komme i gang.
Løsningen er at hver modul har «gjør dette først» som er konkret og tar ti minutter, og resten er føringer med spørsmål å svare på.
CCAR-F-mappingen står i en egen kolonne per føring, slik at de som skal ta eksamen ser hva de trener på, uten at det styrer oppgaven.

**A/B med og uten AGENTS.md.**
Som oppfordring, ikke krav.
Formuleringen «samme prompt, med og uten memory, hva endret seg?» er bedre enn en måletabell.
Den som vil måle tokens gjør det, de andre sammenligner output med øynene.

**Diskusjon om hva folk har i memory-filene sine.**
Legg det som en fast del av recap i modul 1.
Be tre personer vise sin ~/.claude/CLAUDE.md på laptopen til sidemannen.
Det er den samtalen deltakerne kommer til å huske.

**Kontekstforgiftning med blogglenke.**
Veldig godt eksperiment, og direkte relevant for 5.1 og 5.4 i CCAR-F.
Repoet bruker DbContext direkte i handlers uten repository-lag.
Om agenten bygger et generisk EF-repository etter å ha fått en blogglenke i prompten, så har konteksten overstyrt kodebasen.
Skriv ned prediksjonen først.

**KongleKnute på tre nivåer.**
Kjør eksperimentet, men vær forberedt på at teorien ikke holder.
Claude Code laster alle CLAUDE.md fra arbeidsmappa og oppover til rot ved oppstart, og undermappers CLAUDE.md lastes når agenten leser filer der.
Alle tre verdiene kan altså stå i konteksten samtidig, og modellen velger ikke deterministisk den nærmeste.
Det gjør eksperimentet bedre, ikke dårligere.
Læringen blir «hierarkiet er additivt, ikke overstyrende, så motstridende instruksjoner er en feil du må unngå selv».
Dette er nøyaktig det 3.1 tester.
Be deltakerne kjøre `/memory` for å se hva som faktisk er lastet.

**Slank rot og kontekst i undermapper.**
Ja, og det er allerede sluttmålet i modul 1.
Med .claude/rules/ og paths:-glob trenger du ikke CLAUDE.md i undermapper for konvensjoner som gjelder filtyper.
La deltakerne velge selv mellom mappe-CLAUDE.md og rules, og forsvare valget i recap.

**MCP og CLI.**
Behold en liten MCP-bygging, tidsboks på 45 minutter, med ett verktøy.
Målet er å se veien fra data til agent, ikke å lage en pen server.
CLI mot MCP holder som åpen diskusjon med tall for de som vil måle.
Din preferanse for CLI er én mening i rommet, la deltakerne konkludere selv.

## Ting alle må ha gjort før de reiser hjem

- Skrevet en AGENTS.md eller CLAUDE.md fra bunnen og forbedret den etter observasjon.
- Skrevet én SKILL.md som en annen har brukt.
- Skrevet én hook som stoppet noe.
- Levert minst én feature i koden gjennom plan, bygg og bevis.
- Sett hvordan minst én annen deltaker jobber, og fortalt om sin egen arbeidsmåte.

## Dag 1

### Temaer du skal gjennom i teoridelene

**Før modul 1, 20 minutter.**
Hva en harness er, og hva som skiller Claude Code, Copilot, Codex og Pi.
Hva som lastes ved oppstart: memory-hierarkiet på bruker, prosjekt og mappe.
Rules med paths:-glob mot mappe-CLAUDE.md.
Skills mot memory: på forespørsel mot alltid.
Permission-nivåer og deny-regler.
Prediksjon før observasjon og correct-to-store som arbeidsmetode.
CCAR-F: 3.1, 3.2, 3.3.

**Før modul 2, 15 minutter.**
Hva som faktisk ligger i kontekstvinduet: system, memory, samtale, tool results.
Degradering: «lost in the middle», glemte beslutninger, generiske svar.
Kontekstforgiftning: alt du limer inn er en instruksjon, også det du mente som bakgrunn.
Frisk sesjon med oppsummering mot å fortsette.
Utforskningssubagent for å holde hovedkonteksten ren.
/compact, /memory og /context som verktøy.
CCAR-F: 5.1, 5.4, 1.7, 3.4.

**Før modul 3, 15 minutter.**
Innebygde verktøy og hva de koster: Grep, Glob, Read, Edit, Bash.
MCP: hva det er, hvordan en tool call ser ut, hva som ligger i .mcp.json.
Verktøybeskrivelsen er det agenten velger på.
Strukturerte feil: isError, errorCategory, isRetryable.
CLI mot MCP: ikke hvilken som er best, men hvordan du måler.
CCAR-F: 2.1, 2.2, 2.4, 2.5, 5.3.

### Hands-on simulering dag 1

Tre deltakertyper brukes gjennom hele dokumentet.
Nora har brukt Copilot chat, aldri en agent som endrer filer, og kjenner .NET godt.
Erik bruker Claude Code daglig, har egne skills og hooks, og kjenner ikke denne kodebasen.
Siri er senior .NET-arkitekt, skeptisk, bruker Codex, og har sterke meninger om lag og struktur.

**Modul 1, 90 minutter.**

Gjør dette først: start en frisk sesjon i et repo uten memory, og be agenten legge til feltet «Kallenavn» på Person med migrasjon, API og admin-side.
Skriv ned tre ting du tror den gjør annerledes enn deg før du trykker enter.

Nora ser at agenten skriver engelske kommentarer, legger migrasjonen i feil prosjekt og hopper over admin-siden fordi den ikke fant den.
Nora bruker 20 minutter på å forstå hva som gikk feil, og skriver sin første AGENTS.md med fem konkrete setninger om hvor ting ligger.
Nora kjører samme prompt i frisk sesjon igjen og ser at to av tre feil er borte.
Nora rekker ikke skills, og det er greit.

Erik får nesten riktig resultat første gang fordi Erik gir mye kontekst i prompten selv.
Erik ser at det er poenget: alt Erik skrev i prompten skulle vært i memory.
Erik lager AGENTS.md, splitter i .claude/rules/frontend.md og .claude/rules/migrations.md, og skriver skill ny-migrasjon med frontmatter.
Erik kjører A/B med og uten memory, tre ganger hver, og poster tabellen i Slack.
Erik oppdager at variansen er større enn effekten, og det blir et godt recap-poeng.

Siri får en migrasjon Siri ikke liker og et endepunkt som legger logikk i controlleren.
Siri skriver en lang AGENTS.md med arkitekturregler, og oppdager i neste kjøring at agenten ignorerer halvparten fordi fila er for lang.
Siri kutter den til det som gjelder alltid, og flytter Clean Architecture-reglene til en rule med paths: src/TronderLeikan.*/**.
Siri tester intervju-mønsteret på story 8 og får spørsmål Siri ikke hadde tenkt på.

Recap, 20 minutter.
Tre viser sin brukernivå CLAUDE.md til sidemannen.
Spørsmål i plenum: hva la du i memory, hva la du i rules, hva ble skill, og hvorfor.
Erik viser A/B-tabellen.
Du oppsummerer 3.1 til 3.3 mot det folk faktisk gjorde.

**Modul 2, 75 minutter.**

Gjør dette først: spør agenten hvordan poeng beregnes, men skriv ned først hvilke filer du tror den leser.
Be den så liste filene den faktisk leste.

Nora ser at agenten leste docs/TRONDER_LEIKAN.md og to C#-filer, og at Nora bare hadde gjettet C#-filene.
Nora kjører KongleKnute-eksperimentet med partneren, ser at agenten svarer med én verdi og nevner at det finnes andre, og lærer at hierarkiet er additivt.
Nora kjører /memory og ser lista.

Erik kjører forgiftningseksperimentet.
Erik limer inn lenke til en bloggpost om generisk EF-repository og ber om et datalag for Player-oppslag fra en handler.
Erik får et generisk repository med interface og ser at kodebasen bruker DbContext direkte.
Erik prøver igjen i frisk sesjon uten lenken og får en ren handler.
Erik bruker resten på utforskningssubagent mot direkte utforskning og sammenligner kontekstbruk med /context.

Siri lar partneren endre én regel i sin kopi av domenedokumentet.
Siri stiller spørsmål til agenten til den røper at dokument og kode er uenige, og ser at den stolte på dokumentet uten å si det.
Siri legger en setning i AGENTS.md om at koden er kilden når de er uenige.
Siri tar story 2 i én lang sesjon og noterer turen der agenten glemte at de hadde valgt ett endepunkt i stedet for to.

Recap, 15 minutter.
Hvem fikk repository-mønsteret, og hvem fikk det ikke?
Hva sa /memory hos deg mot hos partneren?
Når startet du frisk, og hva måtte du gjenta?

**Modul 3, 90 minutter.**

Gjør dette først: hent scoreboard for en turnering med curl mot API-et og med Aspire MCP, og noter tokens og tid for begge.

Nora lager MCP-serveren med ett verktøy, hent_deltakere, og lar agenten skrive all transport.
Nora bruker tiden på beskrivelsen og på hva som skjer når turneringen ikke finnes.
Nora ser at agenten prøver igjen tre ganger på en 404 før den gir opp, og legger til isRetryable: false.
Det er hele læringen for Nora, og den sitter.

Erik lager to verktøy, hent_scoreboard og hent_spill, og skriver beskrivelser Erik tror er tydelige.
Erik gir agenten tre oppgaver og ser den velge feil på én fordi begge beskrivelsene bruker ordet «resultater».
Erik skriver om, tester igjen, treffer tre av tre.
Erik går videre og planter en instruksjon i en issue-tekst for å se om en lesende agent lar seg lure.

Siri bruker mest tid på CLI mot MCP og har tall for begge.
Siri bygger MCP-serveren fordi Siri vil forstå protokollen, ikke fordi Siri vil bruke den.
Siri konkluderer med at gh og curl er billigere for det som finnes som CLI, og at MCP gir mest der det ikke finnes CLI.
Siri ber agenten finne alle steder poengregler brukes, og sjekker om den brukte Grep eller leste hele filer.

Recap, 20 minutter.
Tallene for CLI mot MCP på tavla.
Hvem fikk agenten til å velge riktig verktøy, og hva var forskjellen i beskrivelsen?
Én overraskelse fra hver, én setning.

## Dag 2

### Temaer du skal gjennom i teoridelene

**Før modul 4, 20 minutter.**
Hvorfor one-shot av features feiler: ingen risikovurdering, ingen bevis, ingen review.
Plan først: plan mode, brainstorm-skill eller grilling, alle tre er fine.
Hva en god plan svarer på: hva endres, hvordan bevises det, hva kan gå galt.
Bevis mot kjørende system: API-kall eller Playwright, ikke «det kompilerer».
Review av egen kode i samme sesjon mot frisk instans.
Eksplisitte kriterier slår «vær konservativ».
Strukturert output: schema, validering, retry med feilmelding.
CCAR-F: 3.4, 3.5, 3.6, 4.1, 4.2, 4.3, 4.4, 4.6.

**Før modul 5, 20 minutter.**
Hooks: PreToolUse, PostToolUse, Stop, og hva som er deterministisk mot prompt-basert.
Hooks som observasjon: logging til fil for audit, standup og timeføring.
Subagenter: isolert kontekst, eksplisitt kontekst i prompten, verktøy per rolle.
Fan-out: flere agenter på samme spørsmål, aggregering etterpå.
Worktrees: hva de gir, og hva de koster i hodet.
Dekomponering: hva kan gå parallelt, hva må gå i sekvens.
CCAR-F: 1.2, 1.3, 1.4, 1.5, 1.6, 1.7.

### Hands-on simulering dag 2

**Modul 4, 150 minutter, med lunsj midt i.**

Gjør dette først: velg én story fra backloggen og skriv issue i eget repo som produkteieren ville skrevet den.
Skriv ned tre risikoer selv før du starter planlegging.

Nora tar story 13, søk og filter i spillerlista.
Nora bruker plan mode, godkjenner ikke før planen sier hvordan det bevises, og får en Playwright-sjekk i planen.
Nora bygger, kjører Playwright mot AppHost, og ser at filteret ikke nullstilles ved bytte av side.
Nora ber agenten fikse og bevise igjen, åpner PR med plan og bevis.
Nora rekker review-agenten mot egen PR, og den finner en manglende null-sjekk Nora ikke så.

Erik tar story 6, bare de N beste tellende, fordi den treffer poengberegningen.
Erik bruker grilling-skill før plan og får avdekket at «N» må lagres per turnering, ikke globalt.
Erik bygger, beviser med API-kall som sammenligner scoreboard før og etter.
Erik skriver review.md med schema, kjører mot egen PR, og lar så hovedagenten reviewe egen kode.
Erik ser at den friske instansen fant en migrasjon som ikke er reversibel, og at hovedagenten ikke nevnte det.
Erik gjør ugyldig output-eksperimentet og bygger retry-løkke med jq -e.

Siri tar story 11, avslutt sesongen, fordi den har invarianter.
Siri planlegger uten agent først, så med, og sammenligner.
Siri bygger med agenten, men skriver review-kriteriene selv før koden er ferdig.
Siri kjører den morsomme oppgaven: bytter repo med partneren, som har tre PR-er med én plantet feil hver.
Siri finner to av tre manuelt på ti minutter, agenten finner to av tre med én falsk positiv, og det er ikke samme to.
Siri justerer agenten med to few-shot-eksempler og kjører igjen.

Recap, 20 minutter.
Hvem fant den friske instansen noe hos som forfatteren ikke fant?
Treff og falske positiver på tavla for de som gjorde fasit-oppgaven.
Hvilken planleggingsmetode brukte du, og ville du brukt den igjen?

**Modul 5, 120 minutter.**

Gjør dette først: skriv en PreToolUse-hook som nekter AppHost-start utenfor hovedklonen, og test at den faktisk stopper.

Nora skriver hooken med hjelp fra agenten, og bruker ti minutter på å forstå hvorfor exit-koden betyr det den gjør.
Nora lager så logging-hooken: PostToolUse som appender verktøynavn og tidsstempel til en fil.
Nora skriver /standup-skill som leser fila og oppsummerer dagen.
Nora har noe Nora kommer til å bruke på jobb mandag, og det er nok.

Erik gjør fan-out review: tre subagenter med ulike roller reviewer PR-en fra modul 4, sikkerhet, ytelse og lesbarhet, og en orkestrator samler.
Erik ser at to av tre fant det samme, og at den tredje fant noe ingen andre gjorde.
Erik kjører story 12 og 9 parallelt i worktrees, én direkte og én via orkestrator med subagent.
Erik merger begge fra hovedklonen og beviser E2E.
Erik forteller i recap at parallelt er tungt, og at det er et valg, ikke et mål.

Siri dekomponerer story 1, avdelingskamp, på papir først: hva kan gå parallelt, hvilke filer berøres.
Siri ber agenten gjøre det samme og sammenligner.
Siri ser at agenten ikke så at scoreboard-komponenten berøres av begge delene, og at det ville kollidert.
Siri skriver Stop-hook som krever grønn dotnet test og sjekker stop_hook_active.
Siri kjører 10-persona fan-out på workshopopplegget selv, og leverer tilbakemeldingene til deg.

Recap for alt, 30 minutter.
Én ting du tar med til kundeprosjektet mandag, én setning hver.
Tre viser hooken sin.
Du viser CCAR-F-mappingen på ett ark, og sier tydelig hva workshopen ikke dekket.

## Rytme og omfang

Forslaget ditt med teori, hands-on og recap per modul er riktig.
Bytt én ting: ikke la modul 3 gå over dagsskillet.
En modul som slutter uten recap samme dag mister læringen over natten, og det å starte dag 2 med gammelt stoff gjør at folk gruer seg.
Fem moduler i seks blokker går ikke, men fem moduler i fem blokker gjør det, når langkjøringen er borte.

| Dag | Blokk | Innhold | Tid |
|---|---|---|---|
| 1 | Morgen | Teori M1, hands-on M1, recap | 2 t 10 min |
| 1 | Før lunsj | Teori M2, hands-on M2, recap | 1 t 45 min |
| 1 | Ettermiddag | Teori M3, hands-on M3, recap, plenum | 2 t 15 min |
| 2 | Morgen og etter lunsj | Teori M4, hands-on M4 med lunsj midt i, recap | 3 t 10 min |
| 2 | Ettermiddag | Teori M5, hands-on M5, recap for alt | 2 t 50 min |

Dag 1 er 6 timer og 10 minutter pluss pauser.
Dag 2 er 6 timer pluss lunsj.
Det er fullt, men ikke for mye, av tre grunner.
Kjerneoppgavene er kuttet fra tre til «gjør dette først» pluss føringer, så de uerfarne kommer i mål.
Gå dypere er ubegrenset, så de erfarne har alltid noe.
Modul 4 er lengst fordi det er der featuren bygges, og det er der folk skal glede seg.

Skal du kutte noe, kutt i denne rekkefølgen.
Først MCP-byggingen i modul 3, behold CLI mot MCP som diskusjon med tall.
Så worktrees i modul 5, behold hooks og fan-out.
Ikke kutt modul 2, det er der forgiftning og hierarki bor, og det er det som endrer hvordan folk jobber.

Skal du utvide, legg til en frivillig kveldsøkt dag 1 der de som vil bygger review-agenten i GitHub Actions.
Det er den eneste oppgaven som trenger API-nøkkel og ro.

## Avgjørelser etter fan-out-gjennomgangen

Tatt 16. september, se docs/workshop-fanout-review.md for grunnlaget.
Disse gjelder foran teksten over der de er i konflikt, og skal inn i v3.

- Dagene skilles med moduler: dag 1 er modul 1 til 3, dag 2 er modul 4 og 5.
- Skill-kravet oppfylles i modul 5 med /standup-skillen på loggen fra hooken. Skills i modul 1 er bonus.
- Bevis, Ta med hjem og Ikke Claude Code? kommer tilbake per modul. Copilot og Pi må ha ekvivalent eller «finnes ikke».
- Én prereq-liste for hele workshopen før start. Ingen krav-merking per oppgave.
- Deny-regel for secrets i modul 1 som første møte med permission-modellen. Git-forbud forklares som deny i teorien før modul 5, med skillet deny for statiske regler og hook for regler som trenger logikk.
- TDD-krav i modul 4: planen sier hvilke tester som skrives, fortrinnsvis integrasjonstester med WebApplicationFactory, og PR-en viser rød før grønn.
- Dag 2 starter med «skriv én hook som hadde stoppet noe som gikk galt for deg i går». Modul 5 kortes til fan-out og dekomponering som kjerne, worktrees blir gå dypere.
- Recap i små grupper først, så plenum.
- Erfarne får to valg per modul: hjelp partneren, eller go wild og vis det i recap.
- MCP-bygging tidsbokses til 45 minutter med ett verktøy. Prompt injection via issue-tekst blir «gjør dette først» i modul 3.
- Simuleringen merkes som hypoteser, med en «hva skjedde faktisk»-rad per modul som fylles i recap.
- Eksplisitt liste over det CCAR-F har som workshopen ikke dekker, i teorien før modul 5.
- Frontend-forgiftning i modul 2 som valgfritt alternativ, ikke krav.
- Ut: persona-spesifikke spor, API-kode mot Messages API til abonnementsspørsmålet er avklart, krav-merking per oppgave.
- Tidsplan, buffer, storskjerm og oppfølging etter workshopen ligger i The Vault under projects/toscana-workshop, ikke i dette repoet.
- Sjekkes før v3: hvordan undermappers CLAUDE.md lastes i gjeldende Claude Code-versjon.
