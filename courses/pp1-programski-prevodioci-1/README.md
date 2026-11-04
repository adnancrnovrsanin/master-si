# Programski prevodioci 1 (13E114PP1)

- Sajt: http://ir4pp1.etf.bg.ac.rs/ (predavanja, vežbe, domaći, rokovi)
- Predavači: prof. dr Dragan Bojić, doc. dr Maja Vukasović
- Asistenti: Mihajlo Ogrizović, Luka Hrvačević, Anastasija Đudurović
- Obaveštenja: https://lists.etf.bg.ac.rs/wws/info/13e114pp1 (IR) i https://lists.etf.bg.ac.rs/wws/info/13s114pp1 (SI)
- Teams tim sa snimcima: link na početnoj strani sajta
- SI Wiki: https://siwiki.rs/wiki/Програмски_преводиоци_1

Šifra **13E** je **IR varijanta** (SI je 13S). Za tebe važe IR pravila i IR kolokvijumi (`..13E114PP1_K_*.pdf`), ne SI K1/K2.

## Kolokvijum

**Samo jedan kolokvijum (K), 30 poena.** Termin: **28.11.2026. (subota)**, ili 23.1.2027. (po studentskoj grupi). Radi se u jednom od ta dva termina, ne u oba. Popravlja se u januarskom ispitnom roku. Prijava je ranije bila preko eStudent, Prijava ispita (26–30.10.), a tvoj servis već pokazuje kolokvijum, pa je prijava verovatno gotova.

### Gradivo (nepotvrđeno za ovu godinu)

Prošlogodišnje obaveštenje asistenta (prepisano iz studentske grupe, datum u poruci je nejasan):
- Predavanja zaključno sa P8, **bez P7 i P7a**
- Vežbe zaključno sa V6

Brojevi P u obaveštenju odgovaraju **nazivima fajlova** (`PP1_P08.pdf`), a ne oznakama na sajtu (na sajtu je isto predavanje "P6"). Poklapa se sa V6 (parsiranje od vrha ka dnu). Moj zaključak, ne potvrda:

| Ulazi (fajl) | Tema |
|---|---|
| PP1_P01 | Uvod |
| PP1_P02, P02a | Leksička analiza, algoritam pozicija |
| PP1_P03 | Konačni procesori |
| PP1_P04 | Sintaksna analiza |
| PP1_P05, P06, P06a | Parsiranje od dna ka vrhu 1 i 2, oporavak od grešaka |
| PP1_P08 | Parsiranje od vrha ka dnu |
| **ne ulazi:** PP1_P07, P07a | Sintaksno-upravljano prevođenje, AST |

Vežbe V1–V6: leksička analiza, JFlex, sintaksna analiza i gramatike, bottom-up, CUP, top-down.

Studenti kažu da je ove godine prva kolokvijumska nedelja dve nedelje kasnije nego inače i da obično asistenti jave pred kolokvijum dokle se stiglo. **Pitaj asistente da potvrde ovo gradivo.**

## Bodovanje (IR)

- Projekat: max 40 poena, obavezan, individualan, usmeno se brani. Minimum 20 poena za izlazak na ispit.
  - **Rok je januarski, ne novembarski** (provereno 4.11.2026): prošlogodišnja postavka za januarsko-februarski rok objavljena je 31.12.2025. na `Domaci.html`; za 2026/27 još nije objavljena. Odbrana je uslov za izlazak na ispit i organizuje se u svakom roku. Dakle projekat ne odlaže kolokvijum K (28.11.), ali je obiman (kompajler za Mikrojava) — realan rad je decembar.
- Ispit: 60 poena, pokriva celo gradivo.
- Kolokvijum: 30 poena. Uzima se bolja varijanta:
  - sa kolokvijumom: `P + K + ispit/2`
  - bez: `P + ispit`
- Za prolaz >= 31 poen sa kolokvijuma i ispita, ukupno >= 51.

Pročitaj `materijali/vezbe/13E114PP1_2025_26_predispitne_obaveze.pdf` (to je za prošlu godinu, 2026/27 verziju potraži na sajtu).

## Napomene

- Stari zadaci su u `materijali/kolokvijumi/`. Za tebe su relevantni `13E114PP1_K_*` i stariji `pp1-*-k.pdf` (IR). Fajlove `13S114PP1_K1/K2` koristi samo kao dodatnu vežbu, jer je SI gradivo podeljeno na dva kolokvijuma.
- Prezentacije sa vežbi 2, 3 i 4 (`Cas 2/3/4 *.pptx`) postavlja Anastasija i nisu na istom mestu kao ostalo. Studenti kažu da se nove prezentacije ne vide u Chrome-u zbog keša (Ctrl+F5 ili Edge). Ako se pojave nove, ponovo pokreni `scripts/fetch.sh pp1` posle ažuriranja `links.txt`.
- SI Wiki: JFlex, CUP i AST se retko pojavljuju na kolokvijumima, a S- i L-atributivne gramatike češće na ispitu.
- Student iz grupe pominje zadatak: niz brojeva na ulazu sa predznacima gde paran broj minusa daje pozitivnu cifru, proverava se suma cifara = 0. Pogledaj stare K za sličan tip.

## Redosled predavanja (sajt)

Uvod, leksička analiza, konačni procesori, sintaksna analiza, parsiranje od dna ka vrhu (2), oporavak od grešaka, parsiranje od vrha ka dnu, sintaksno-upravljano prevođenje, AST, tabela simbola, prevođenje OO jezika, Mikrojava tabela simbola, izvršno okruženje, Mikrojava VM, međukod, generisanje koda (x86, Mikrojava).

Alati: JFlex (leksika), CUP (parser), Mikrojava (jezik za projekat).

## Materijali

Preuzeto u `materijali/`: `predavanja/`, `vezbe/`, `knjige/` (zbirka), `kolokvijumi/`. Udžbenik je `predavanja/pp1_udzbenik.pdf`. Arhive `.rar` treba otpakovati (`brew install unar`, pa `unar fajl.rar`).

Eksterno: Box folder sa rešenjima, YouTube lista rešenja zadataka, Google Sheet sa pitanjima po temama (u [resources/sajtovi.md](../../resources/sajtovi.md)).

## Beleške i vežbanje (napravljeno)

- `beleske/01..07`: leksika i automati, konačni procesori, gramatike, potisni automati, LR(0)/SLR(1)/LALR(1), oporavak od grešaka, FIRST/FOLLOW/LL(1)/rekurzivni spust. `beleske/K1-cheatsheet.md`: svi recepti na jednom mestu.
- `zadaci/vezbanje.md`: 12 zadataka po 10 poena (rešenja u `vezbanje-resenja.md`). `zadaci/analiza-starih-K.md`: šta se tražilo po godinama.
- Primere su proveravane skriptama (regex, automati, LR tabele, simulacije), ali zvanična skenirana rešenja nisu čitana.

Nejasnoće: K 2019 zadatak 3 ima dvosmislenu gramatiku (`A → A d A`), pa LL(1) transformacija nije moguća i odgovor je "nije moguće". K 2021/22 zadatak 3b (`cadbadbdacacb`, sigurni b i d): po agentovoj simulaciji greška se otkriva tek na kraju ulaza i oporavak ne uspeva, a zvaničnog rešenja nema. Slajd P08 str. 56 ima štamparsku grešku (`'}'` umesto `')'`).
