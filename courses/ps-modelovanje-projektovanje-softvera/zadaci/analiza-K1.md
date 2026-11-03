# Analiza K1 zadataka (projektni uzorci)

Izvori: PDF-ovi kolokvijuma `PS_2024_25_K1(P).pdf` i `PS_2025_26_K1(P).pdf` i njihov početni kod (`pocetni_sadrzaj_*.zip`) pročitani u celini; wiki stranice sa SI Wiki (K1 2019, 2021, 2022, 2023, 2024, K1P 2024, probni testovi 2021) pročitane preko alata za sažimanje, pa su svi podaci "sa wikija" ispod **sažeti i ne tvrdim da su doslovni**; tačni odgovori u pitanjima višestrukog izbora na wikiju nisu bili vidljivi u izvozu. Slajdovi (`PS_full_2026.pdf`, str. 6) potvrđuju: K1 = projektni obrasci, neobavezan, radi se pojedinačno, nosi 20% ocene, prva kolokvijumska nedelja na SI.

## 1. Dva formata

| | 2019–2023 (wiki) | 2024/25 i 2025/26 (PDF-ovi) |
|---|---|---|
| Format | test od 10 pitanja, višestruki izbor, spajanje, kratak odgovor; deo o UML-u i OO osnovama + 3–5 pitanja o uzorcima | **2 zadatka po 10 poena, programiranje u Javi** |
| Trajanje | 20 minuta (wiki: K1 2022 i K1 2023; za 2019 i 2021 nije navedeno) | 120 min (K1 i K1P 2024/25), **90 min (K1 i K1P 2025/26)** |
| Predaja | na sajtu | direktorijumi `zad1`, `zad2` sa `.java` fajlovima i `z1.txt`, `z2.txt` na disku `Rad (L:)`; početni kod u `pocetni_sadrzaj.zip` na disku `Materijali (N:)` |
| Dozvoljeno | nepoznato | wiki za K1 2024 i K1P 2024: prezentacije o uzorcima i Java dokumentacija. **Papirna literatura (iz grupe) nije potvrđena.** |
| Rokovi | | K1 27.10.2024., K1P 1.12.2024., K1 3.12.2025., K1P 11.1.2026. (odeljenja SI i IR) |

Poeni: svaki zadatak je označen sa `[10]`, dakle 20 poena na kolokvijumu; to se poklapa sa 20% ocene, ali zvaničan zbir poena po kolokvijumu nisam našao (pretpostavka). Format K1 2026 (26.11.2026.) nije potvrđen; realno je očekivati format kao 2025/26 (kodiranje, 90 min), ali nije potvrđeno.

Beleška: stariji format (teorija) i dalje može da se pojavi kao kratka pitanja na ispitu (feb 2026, iz sećanja studenata: prepoznati Dekorater iz opisa razloga, zadatak sa Šablonskom metodom i Komandom).

## 2. Struktura kodnog kolokvijuma

- **Zadatak 1: uzorak je imenovan** u tekstu ("Коришћењем пројектног обрасца Декоратер"; "Заступник (Proxy)"; "комбинацијом Састав и Посматрач"). Traži se: implementacija, `z1.txt` sa **raspodelom uloga** (klasa -> uloga), po potrebi **vrsta** (zastupnika) i **primer korišćenja** (`main`: napravi objekat, primeni, ispiši).
- **Zadatak 2: uzorak nije imenovan.** "Дорадити (и исправити) дату имплементацију система коришћењем одговарајућих пројектних образаца. Навести све примене у z2.txt (једна до две реченице)." Opis problema u tekstu je skriveni nagoveštaj (npr. "način igre se može konfigurisati", "ноте се цртају на исти начин независно од места").
- Početni kod: **delimičan i često neispravan**; tvoj posao je i da ga ispraviš ("дорадити и исправити"), a kod u K1P 2024/25 sme da se menja i ne mora da se koristi.

## 3. Pregled po kolokvijumu

Tumačenja uzoraka u zadatku 2 su **moja** (iz teksta i početnog koda); zvanična rešenja nisam imao.

| Kolokvijum | z1 | z2 | Početni kod |
|---|---|---|---|
| **K1 2024/25** (27.10.2024., 120 min) | **Dekorater**: filteri slike (Greyscale, Invert) nad nizom piksela | Kartaška igra, krupije. **Unikat** (`Croupier`), **Posmatrač** (igrači se prijavljuju i odjavljuju, obaveštavaju se o otkrivenoj karti, sinhrono), **Strategija** x2 (način klađenja po igraču; logika izbora pobednika) | z1: samo `Pixel` (r, g, b sa setterima). z2: `Card`, `Croupier`, `Player` (kompajlira se) |
| **K1P 2024/25** (1.12.2024., 120 min) | **Sastav + Posmatrač**: stablo fajl sistema, praćenje promena direktorijuma, `ObserverLogger` | Notni sistem na uređaju sa malo memorije, Piano/Forte. **Muva** (+ fabrika po vrsti nota; Apstraktna ili Fabrička metoda: nepotvrđeno) | z1: samo interfejs `FileSystemNode { write(); }`. z2: pseudokod (`...`, `HashMap.add`), **ne kompajlira se** |
| **K1 2025/26** (3.12.2025., 90 min) | **Dekorater**: efekti audio zapisa (Echo, VolumeBoost), uz primer sa nasumičnim uzorcima | Repozitorijum fajlova + polise pristupa. **Zaštitni Zastupnik** (bez menjanja `RealFileRepository`) + **Strategija** (polise: korisnička, direktorijumska; jedna aktivna, nove kasnije) | z1: `AudioStream` i `Util` (**ne kompajlira se**: `applyVolumeBoost` koristi nepostojeće `N`). z2: `FileRepository`, `RealFileRepository`, `User`, `UserRole`, `Policy.java` kao pseudokod |
| **K1P 2025/26** (11.1.2026., 90 min) | **Zastupnik**: lenjo učitavanje slika u veb pregledaču (+ navesti **vrstu** zastupnika) | Laboratorijske akcije iz dugmića i prečica. **Komanda** + **Sastav** (makrokomanda); `Unikat` već postoji | z1: `Element`, `ImageElement`, `TextElement`, `Viewport`, `WebBrowser`, `WebPage` (kompajlira se). z2: `Button`, `ShortcutManager` (dupli `switch`), dva Unikata |

### Kako se rešava svaki zadatak (skica)

- **Dekorater (K1 2024/25 z1, 2025/26 z1):** interfejs slike/zapisa je Komponenta; osnovna slika/zapis (nasumične vrednosti) je Subjekat; apstraktna `Dopuna` drži Komponentu; svaki filter/efekat je Konkretna dopuna. **Zamka (2024/25):** `Pixel` je promenljiv, pa dekorater mora da pravi **nove** `Pixel` objekte; inače će drugi poziv `getPixels()` da primeni filter dvaput na istim objektima. Greyscale daje celobrojne vrednosti (zaokruži). **Zamka (2025/26):** `Util.applyVolumeBoost` ne kompajlira (petlja od `N`, a treba od 0); `Util` se može iskoristiti u dekoraterima, ali prvo ga popravi; efekat radi nad `samples[i - N]` ulaza tog sloja, ne nad rezultatom.
- **Sastav + Posmatrač (K1P 2024/25 z1):** `FileSystemNode` je Element, `File` List, `Directory` Sklop i konkretan subjekat (`subscribe`, `unsubscribe`, poruke `File added: ...`, `File removed – ...`, `File content changed – ...`), `ObserverLogger` konkretan posmatrač. Tekst zadatka je jedini izvor tačnih poruka; na wikiju se rešenje razlikuje od teksta.
- **Posmatrač + Unikat + Strategija (K1 2024/25 z2):** `Croupier.getInstance()` u početnom kodu **uvek vraća `null`** (ispravi). `playersInGame` se nigde ne popunjava (dodaj prijavu/odjavu). Sinhrono obaveštavanje igrača posle svake otkrivene karte; `Player.update()` ima TODO i `numCardsOnTable = 0`. `boolean aggressive` -> `BettingStrategy` (agresivna, štedljiva); `defineWinner` -> `WinnerStrategy`. Ulog nikad ne ulazi u `moneyPot`.
- **Muva (K1P 2024/25 z2):** Piano/Forte se razlikuju samo po teksturi, tekstura zavisi samo od `NoteValue`, spoljašnje stanje (`index`, `solmization`) već dolazi kao parametar `draw`. Fabrika drži po jednu `Note` po `NoteValue` za tekuću vrstu; `NoteSystem.reset(...)` briše note i menja fabriku. Greške u početnom kodu: `calculateY(index)` treba `calculateY(sol)`; mape tekstura se nigde ne prave i pozivaju `add` umesto `put`.
- **Zastupnik + Strategija (K1 2025/26 z2):** `RepositoryProxy implements FileRepository`, drži `RealFileRepository` i `Policy` (Strategija); pre `read`/`write` pita politiku i baca izuzetak. Dve polise: korisnička (piše samo ADMIN, čitaju svi), direktorijumska (ako je **koreni** direktorijum `sys`, samo čitanje). **Zamka:** pseudokod `!path.startsWith("sys")` pogrešno tretira i `sysadmin/x` kao `sys`; koreni direktorijum je prva komponenta puta. `RealFileRepository` zaista piše po disku; u `main` ne piši u stvarne putanje.
- **Zastupnik (K1P 2025/26 z1):** virtuelni zastupnik `ImageElementProxy extends Element`; **mora da ima sopstvene koordinate i dimenzije** jer `Viewport.isInViewport` čita `getxTopLeft()` itd. pre `show()`; pri prvom `show()` pravi `ImageElement`, prenese geometriju i prosledi poziv. Upotreba je u `WebPage`, ostalo se ne menja. Slajdovi str. 94–95 su baš ovaj primer (`ImageProxy` čuva dimenzije). **Zamka:** konstruktor `ImageElement` pravi `new byte[path.hashCode()]`; negativan `hashCode` baca izuzetak, a `"hello".hashCode()` je 99162322 (~99 MB). Za test koristi kratke putanje.
- **Komanda + Sastav (K1P 2025/26 z2):** `Command { execute() }`, pet konkretnih komandi (start, stop, otkaz linka, povratak linka, stanje mreže), `MacroCommand` (Sastav) za scenario ("otkaz, analiza stanja, oporavak"), `Button` i `ShortcutManager` (Pokretači) drže `Command`. Primaoci su postojeći Unikati. `ShortcutManager` u početnom kodu baca `NullPointerException` za nepoznatu prečicu.

Svoje skice rešenja `K1P 2025/26 z1 i z2`, `K1 2024/25 z2` i `K1P 2024/25 z2` sam kompajlirao i pokrenuo (Java 26, `--release 17`) u scratchpadu; **nisu zvanična rešenja**.

## 4. Učestalost uzoraka

Kodni kolokvijumi (4 roka, 8 zadataka). "Imenovan" = uzorak je u tekstu zadatka; "prepoznat" = moje tumačenje zadatka 2.

| Uzorak | K1 24/25 | K1P 24/25 | K1 25/26 | K1P 25/26 | Ukupno |
|---|---|---|---|---|---|
| Dekorater | z1 (imenovan) | | z1 (imenovan) | | 2 |
| Zastupnik | | | z2 (prepoznat) | z1 (imenovan) | 2 |
| Sastav | | z1 (imenovan) | | z2 (prepoznat) | 2 |
| Posmatrač | z2 (prepoznat) | z1 (imenovan) | | | 2 |
| Strategija | z2 (prepoznat) | | z2 (prepoznat) | | 2 |
| Komanda | | | | z2 (prepoznat) | 1 |
| Muva | | z2 (prepoznat) | | | 1 |
| Unikat | z2 (ispravka) | | | (već prisutan) | 1 |
| Šablonska metoda, Prototip, Apstraktna fabrika, Fabrička metoda, Adapter, Fasada, Podsetnik, Graditelj | | | | | 0 |

Obrazac: **z1 je jedan od "malih" uzoraka sa vežbi (Dekorater, Zastupnik, Sastav+Posmatrač)**, z2 je kombinacija 2–3 uzorka u koju moraš da se "uživiš" (Unikat, Posmatrač, Strategija, Muva, Komanda, Sastav, Zastupnik). Svi uzorci iz kolokvijuma imaju zadatak ili slajd na vežbama (Dekorater z2, Posmatrač z12, Strategija z4, Unikat z3/z12, Zastupnik z8/z9, Sastav z10/z13, Komanda z10/z11, Muva z7).

Teorijski K1 (wiki, sažeto; navedeni su zadaci u kojima se pojavljuje uzorak): Unikat (2019 z1, probni 2021 z8, 2023 z6), Šablonska metoda (2021 z6 i z7, 2022 z7, 2023 z7), Prototip (2021 z6 i z8, 2022 z8, 2023 z8, probni 2021 z9), Sastav (2019 z2 i z5, 2021 z6 i z9, 2022 z9, 2023 z9, probni 2021 z10), Dekorater (2021 z6 i z10, 2023 z10), opšta pitanja o uzorcima (2019 z8, 2022 z6). Prototip i Šablonska metoda su bili **samo teorija**, a u kodnim kolokvijumima ih nema; ne treba ih ostaviti bez čitanja jer ulaze u "svi obrađeni uzorci".

## 5. Praktične napomene

- Pre predaje **kompajliraj sve** (`javac`) i pokreni `main` primer.
- `z1.txt` i `z2.txt` pišu se sa imenima klasa i ulogama; koristi nazive uloga sa vežbi, GoF u zagradi (tabela u `beleske/K1-pregled-obrazaca.md`).
- Iz direktorijuma `zad1`/`zad2` izbaci IDE fajlove; ne arhiviraj (K1P 2024/25 napomena).
- Redosled u 90 minuta: 5 min čitanje oba zadatka; z1 (~30 min uključujući `z1.txt` i `main`); z2 (~45 min): prvo prepoznaj uzorke, nađi greške u početnom kodu, tek onda kodiraj; poslednjih 10 min kompajliranje i `.txt`.
- Tekst traži da u `z2.txt` navedeš **sve** primene uzoraka u sistemu. Nije jasno da li se računaju i uzorci koji su već u početnom kodu (npr. postojeći Unikat u K1P 2025/26); bezbedno je navesti ih i označiti kao već postojeće (pretpostavka).
