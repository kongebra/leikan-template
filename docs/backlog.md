# Backlog: user stories til TrønderLeikan

Oppgavene til workshopen. Se [WORKSHOP.md](../WORKSHOP.md) for hvilken modul som bruker hva.

> **Hensikt**
> Oppgaver deltakerne plukker fra i M3-M6.
> Skrevet som en produkteier ville bestilt dem: kort, i brukerens språk, uten teknisk løsning.
> Åpenheten er med vilje. Deltakeren må tolke, stille spørsmål til seg selv, og gi agenten kontekst.
> Den som bare limer inn storyen og trykker enter er meat-proxy.

## Produkteierens innledning

Trønder Leikan brukes på hver lagtur og på fredagspils gjennom året.
Vi har turneringer, spill, personer og avdelinger, og et scoreboard som funker.
Nå vil vi at det skal føles som et ekte produkt, ikke et admin-skjema.
Under er det jeg vil ha, i den rekkefølgen jeg tenker på det.
Spør hvis noe er uklart, men jeg er på ferie.

## Stories

### 1. Avdelingskamp

Som avdelingsleder vil jeg se hvilken avdeling som leder turneringen, ikke bare hvilke personer.
Det skal være rettferdig selv om avdelingene er ulike i størrelse.

### 2. Min historikk

Som deltaker vil jeg se alt jeg har vært med på over tid, hvilke plasseringer jeg har fått og hvordan poengene mine har utviklet seg fra turnering til turnering.

### 3. Logg inn før du endrer

Som administrator vil jeg at bare innloggede administratorer kan opprette og endre turneringer, spill og resultater.
Alle skal fortsatt kunne se scoreboardet uten å logge inn.
Vi har allerede en innloggingsløsning, bruk den.

### 4. Resultat fra mobilen

Som arrangør av et spill vil jeg registrere hvem som kom på pallen fra mobilen mens vi står i hagen, på under et minutt.

### 5. Scoreboard som lever

Som tilskuer vil jeg at scoreboardet på storskjermen oppdaterer seg selv når et spill blir ferdig, uten at noen må trykke refresh.

### 6. Bare de beste tellende

Som turneringsansvarlig vil jeg kunne sette at bare de N beste spillene til hver person teller, slik at de som er borte en dag ikke er ute av konkurransen.

### 7. Egne regler for simracing

Som simracing-ansvarlig vil jeg ha et eget poengoppsett for racing-kveldene, der rundetid og antall løp betyr noe, uten at det ødelegger for de vanlige lekene.

### 8. Påmelding

Som deltaker vil jeg melde meg på kommende spill selv, og se hvem andre som er påmeldt, så arrangøren ikke må mase i Slack.

### 9. Si det i Slack

Som lagmedlem vil jeg få en melding i Slack-kanalen når et spill er ferdig, med pallplassene og hvem som nå leder turneringen.

### 10. Til ledelsen

Som fagansvarlig vil jeg hente ut sluttresultatet for en turnering til Excel, med poeng per person og per avdeling, så jeg kan legge det i årsrapporten.

### 11. Avslutt sesongen

Som turneringsansvarlig vil jeg kunne avslutte en turnering slik at den fryses, vinneren kåres og den vises som historisk, og ingen kan endre den etterpå ved et uhell.

### 12. Hvem gjorde hva

Som administrator vil jeg se hvem som endret et resultat og når, fordi vi har hatt diskusjoner om det.

### 13. Finn spilleren

Som administrator vil jeg søke og filtrere i spillerlista på navn og avdeling, det er blitt for mange å bla i.

### 14. Bilder fra leken

Som deltaker vil jeg se bilder fra hvert spill, og arrangøren skal kunne laste opp flere bilder etter at spillet er ferdig.

### 15. Rekorder og streaks

Som lagmedlem vil jeg se morsom statistikk: flest seire, lengst seiersrekke, flest ganger på sisteplass, mest lojale tilskuer.

### 16. Hent inn folk

Som administrator vil jeg importere alle ansatte fra en liste i stedet for å taste inn en og en, og oppdatere lista når noen begynner eller slutter.

## Bruk i modulene

| Modul | Anbefalt bruk |
|---|---|
| 1 Konfigurasjon | Nytt felt på Person uten story. Gå dypere: story 8 i plan mode mot story 15 direkte. |
| 2 Kontekst | Story 2 i én lang sesjon for å se når konteksten degraderer. |
| 4 Plan, tester, bevis og review | Én story, plan først, tester, E2E-bevis til slutt. Korte stories som 6, 11 eller 13. |
| 5 Orkestrering | Story 1 dekomponeres på papir. Gå dypere: story 12 og 9 parallelt i worktrees. |
