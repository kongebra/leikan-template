# Fan-out review av workshop v2

Åtte personas leste WORKSHOP.md og docs/workshop-simulering.md og ga tilbakemelding, med forbehold om at workshopen holdes.
Personas: Nora (ny på agenter, Copilot), Erik (Claude Code daglig), Siri (skeptisk senior arkitekt), Jonas (frontend, kan ikke C#), Kari (leder som betaler), Marit (erfaren fasilitator), Amir (skal ta CCAR-F), Per (konsulent hos streng offentlig kunde).

## Enighet på tvers

Disse punktene kom fra tre eller flere personas uavhengig av hverandre.

**Behold fra v2.**
Tomt repo uten memory i modul 1 (Nora, Erik, Siri, Marit).
Forgiftningseksperimentet i modul 2 (Erik, Siri, Jonas, Per).
Fasit-oppgaven med plantede feil i modul 4, og den bør alle gjøre, ikke bare Siri (Erik, Siri, Kari, Per).
Langkjøringen borte (alle).
Logging-hook og /standup-skill som Nora-spor i modul 5 (Nora, Jonas, Per).
Rytmen teori, hands-on, recap samme dag (Jonas, Marit).

**Feil i v2 som må rettes.**
Dokumentet motsier seg selv: Nora «rekker ikke skills, og det er greit», men alle må ha skrevet én SKILL.md (Nora, Siri, Kari, Marit).
«Ikke Claude Code?»-boksene, «Bevis» og «Ta med hjem» falt ut av v2 og må tilbake (Nora, Kari, Per).
Deny-regelen for zitadel-bootstrap og .env, og hooken som nekter git push og commit, falt ut (Per).
KongleKnute er ikke forklart noe sted (Nora).
Eriks spor i modul 5 bruker worktrees samtidig som teksten sier worktrees kuttes først (Erik, Marit).
Simuleringen er skrevet som om utfallene er kjent, og bør merkes som hypoteser med en «hva skjedde faktisk»-rad i recap (Siri, Erik).

**Manglende deltakertyper.**
Alle tre personas kan .NET (Jonas).
Ingen persona er Copilot-bruker uten git-tilgang for agenten og med Azure DevOps (Per).
Par-oppsettet er borte fra simuleringen, og mentor-leveransen med det (Marit, Nora).

## Prioriterte endringer, sammenstilt

1. Rett selvmotsigelsen om skills.
   Flytt kravet til modul 5, der Nora faktisk lager /standup, eller sett av tid i modul 1-recap til at partneren bruker skillen din.
2. Ta tilbake per modul: «Ikke Claude Code?», «Bevis», «Ta med hjem».
   Merk hver oppgave med krav: GitHub, internett, Claude Code, eller ingen.
3. Legg til to personas i simuleringen: Jonas (frontend) og Per (Copilot, ingen git for agenten, Azure DevOps).
   Gi modul 1 en frontend-variant av «gjør dette først», og gi modul 2 en frontend-forgiftning (React Query-blogg mot fetch i Server Components).
4. Krev tester i modul 4.
   Planen godkjennes ikke før den sier hvilke tester som skrives, og PR-en viser en test som feilet før og går etter.
   Poengberegningen er stedet.
5. Gi de erfarne et skarpt mål i modul 1: skriv memory så partneren, med sitt verktøy, får endringen riktig første gang.
6. Flytt PreToolUse-hooken til dag 2 morgen som 30 minutters oppvarming.
   Da kortes modul 5 til 90 minutter med fan-out og dekomponering som kjerne, og worktrees blir gå dypere.
7. Strukturer recap som par-først: fem minutter i paret med tre faste spørsmål, så ti minutter plenum der tre par trekkes ved navn.
   Ta mentor-leveransen tilbake.
8. Kutt MCP-byggingen til 45 minutter nå, og gjør prompt injection via issue-tekst til «gjør dette først» i modul 3 for alle.
9. Legg 15 minutter buffer i hver blokk, tatt fra teori.
   Uten storskjerm må teorien kuttes til 10 minutter og deles ut skriftlig på forhånd, eller skaff en TV.
10. Effektmåling: hver deltaker skriver i siste recap én setning «dette tar jeg inn i kundeprosjekt X innen uke Y», følges opp i Slack fire uker etter.
11. For CCAR-F-kandidatene: 45 minutter gå dypere i modul 3 med en agentisk løkke i C# mot Messages API med stop_reason-styring og tool_choice, og ti minutter i teorien før modul 5 med eksplisitt liste over det eksamen har som workshopen ikke har.
12. Verifiser i plenum-teorien hvordan undermappers CLAUDE.md faktisk lastes i dagens Claude Code-versjon før du sier det.

## Uenighet

Erik vil ha MCP-bygging som gå dypere og prompt injection som kjerne.
Kari vil kutte MCP-bygging til fordel for at alle fullfører review-agenten.
Siri vil ha den fordi hun vil forstå protokollen.
Anbefaling: 45 minutter, ett verktøy, agenten skriver transporten, og prompt injection som «gjør dette først».

Marit vil flytte hook til dag 2 morgen.
Nora og Per vil ha hook-sporet fordi det er det de tar med hjem.
De er forenlige: hooken som oppvarming dag 2, logging-hook og /standup i modul 5.

Amir vil ha API-kode inn.
Kari og Per bryr seg ikke om eksamen.
Anbefaling: gå dypere, ikke kjerne.

## Rådata

Fulle tilbakemeldinger per persona ligger i samtaleloggen, og er oppsummert over.
