# Master SI — kontekst za Claude

Adnan Crnovršanin, master Elektrotehnika i računarstvo, modul Softversko inženjerstvo, ETF Beograd. Ovaj repo je lično mesto za sve vezano za studije: materijali, beleške, vežbanje, projekti.

## Jezik

Komuniciraj na srpskom (latinica). Beleške pišem na srpskom, termine koji se na ETF-u koriste na engleskom (design patterns, parser, CSP...) ostavi kako su.

## Struktura

- `KOLOKVIJUMI.md`: nadolazeći kolokvijumi, status gradiva, plan. Ažuriraj ga kad se nešto promeni.
- `courses/<predmet>/README.md`: info o predmetu, bodovanje, linkovi, šta je potvrđeno a šta pretpostavljeno.
- `courses/<predmet>/materijali/`: sirovi PDF-ovi sa sajtova (gitignored, preuzimaju se sa `scripts/fetch.sh`).
- `courses/<predmet>/beleske/`: moje beleške i rezimei. Ovde pišeš kad pravimo rezime lekcije.
- `courses/<predmet>/zadaci/`: stari kolokvijumi i rešenja, vežbanje.
- `resources/sajtovi.md`: svi sajtovi predmeta + SI Wiki (https://siwiki.rs).

## Kako da radiš sa mnom

- Rezime lekcije: pročitaj PDF iz `materijali/`, napiši rezime u `beleske/` (ključni pojmovi, formule/algoritmi, tipični ispitni zadaci). Navedi iz kog slajda/predavanja je koja stvar.
- Vežbanje: kad tražim zadatke, pravi ih po uzoru na stare kolokvijume iz `zadaci/`. Ne otkrivaj rešenje dok ne probam. Kad ti pošaljem svoje rešenje, proveri ga i objasni gde grešim.
- Ne izmišljaj gradivo kolokvijuma. Ako nešto nije potvrđeno sa sajta predmeta ili od profesora, reci da je pretpostavka.
- Skeniranim PDF-ovima i rukom pisanim rešenjima ne veruj slepo. Reši zadatak sam pa uporedi.
- Domaće zadatke i projekte branim usmeno i individualno. Pomaži da razumem i napravim, ali nemoj pisati kod koji ne mogu da objasnim.

## Preuzimanje materijala

`scripts/fetch.sh <pp1|ps|is> [folder]` čita `courses/*/links.txt` (format `folder|url`) i preuzima u `materijali/<folder>/`. Prethodno pogledaj šta se preuzima.
