# 01. Leksička analiza: regularni izrazi, Tompson, metoda pozicija, NKA → DKA, minimizacija

**Izvor:** `PP1_P02.pdf` (strane PDF-a: DKA 4–10, NKA 11–18, NKA→DKA 19–22, regularni izrazi 23–27, Tompson 28–31, automatizacija 32), `PP1_P02a.pdf` (metoda pozicija, svih 7 strana), udžbenik `pp1_udzbenik.pdf` str. 23–49 (poglavlje "Leksička analiza"), Zbirka (`ppzbirka.pdf`) odeljak 1.2 (minimizacija, zadatak 1.2.3 daje particioni metod), vežbe `Cas 2 - Leksicka analiza - 2 deo.pptx` i `Leksicka_Analiza.pdf`.

Napomena o izvorima: udžbenik (str. 37) za minimizaciju samo upućuje na Zbirku. Algoritam minimizacije (particioni metod) je zato uzet iz Zbirke 1.2.3 i sa vežbi (Cas 2, sl. 15–16).

## 1. Definicije (2–3 rečenice)

- **DKA** je petorka (S, U, δ, St, P): stanja, azbuka, funkcija prelaza δ: S×U→S, startno stanje i skup stanja prihvatanja. Prazno polje u tabeli prelaza znači prelaz u (neispisano) stanje greške. **NKA** ima ε-prelaze i skup mogućih sledećih stanja; ε-zatvaranje skupa je sve što se dostiže ε-granama (uključujući sam skup).
- **Regularni izraz** opisuje skup reči. Prioritet: `*`, `+`, `?` (najviši) > konkatenacija > `|` (najniži). `ε` (prazna reč) i `∅` (prazan jezik) su različiti izrazi.
- **Dva stanja su ekvivalentna** ako automat iz oba prihvata isti skup reči (uslov kompatibilnosti: oba prihvatajuća ili oba odbijajuća; uslov propagacije: prelazi za svaki simbol vode u ekvivalentna stanja). **Minimalni DKA** nema nedostižnih ni ekvivalentnih stanja.

## 2. Algoritmi korak po korak

### 2.1 Tompsonov algoritam (RI → NKA)

Svaki podizraz dobija NKA sa jednim startnim i jednim završnim stanjem.

1. Simbol `a`: dva stanja, grana `a`. Za `ε`: dva stanja, grana `ε`.
2. Konkatenacija `st`: ε-grana od završnog stanja `s` ka startnom stanju `t`. Startno je startno od `s`, završno je završno od `t`.
3. Unija `s|t`: novo startno stanje sa ε-granama ka startnim stanjima `s` i `t`; novo završno stanje u koje vode ε-grane iz završnih stanja `s` i `t`.
4. Zvezdica `s*`: novo startno i novo završno stanje, četiri ε-grane: novo start → staro start, staro kraj → novo kraj, novo start → novo kraj, staro kraj → staro start.
5. `s+`: isto kao `s*`, ali bez grane novo start → novo kraj. (`s?` je isto kao `s*` bez grane staro kraj → staro start.)
6. Gradi se od najmanjih podizraza ka većim, poštujući prioritete i zagrade.

*Na vežbama* se posle konstrukcije lanci ε-prelaza skraćuju (Cas 2, sl. 12: 19 → 14 stanja). Ako zadatak traži "Tompsonovim algoritmom", nacrtaj bar nekraćeni NKA ili jasno naznači koje si ε-grane spojio.

### 2.2 NKA → DKA (konstrukcija podskupova)

1. Startno stanje DKA = ε-zatvaranje startnog stanja NKA.
2. Za izabrano (još nepopunjeno) stanje DKA `X` i svaki ulazni simbol `u`: `Y = ε-zatvaranje( ∪ δ(s,u) za svako s iz X )`. Ako je `Y` prazan skup, ćelija ostaje prazna (greška). Ako je `Y` novi skup, dodaj ga kao novu vrstu.
3. Stanje DKA je prihvatajuće ako sadrži bar jedno prihvatajuće stanje NKA.
4. Ponavljaj dok postoji nepopunjena vrsta. Moguć je eksponencijalni rast broja stanja, u praksi retko.

### 2.3 Metoda pozicija (RI → DKA direktno)

Radi se nad izrazom sa dodatim markerom kraja `⊣` (u slajdovima `─┤`).

1. Napiši izraz `(izraz)⊣` i nacrtaj sintaksno stablo (najniži prioritet u koren).
2. **Pozicije**: numeriši listove sleva nadesno (svaka pojava simbola dobija svoj broj, `ε` se ne numeriše, `⊣` dobija poslednji broj).
3. **Poništivost** (čvor može dati praznu reč): list je poništiv samo ako je `ε`; `•` ako su oba sina poništiva; `|` ako je bar jedan sin poništiv; `*` i `?` uvek; `+` ako je sin poništiv.
4. **Prva pozicija**: `•(a,b)` = prva(a), a ako je a poništiv, prva(a) ∪ prva(b); `|` = unija; `*`, `+`, `?` = prva sina.
5. **Poslednja pozicija**: `•(a,b)` = poslednja(b), a ako je b poništiv, poslednja(a) ∪ poslednja(b); `|` = unija; `*`, `+`, `?` = poslednja sina.
6. **Sledeća pozicija** (po pozicijama, ne po čvorovima), samo čvorovi `•` i `*`/`+`: za `•(a,b)` svaka p iz poslednja(a) dobija prva(b); za `*` i `+` svaka p iz poslednja(sina) dobija prva(sina).
7. **DKA**: startno stanje = prva(koren). Za stanje `T` i simbol `a`: uzmi pozicije iz `T` koje nose simbol `a` i unija njihovih sledećih pozicija je novo stanje. Prazan skup = greška (prazno polje).
8. Prihvatajuća su stanja koja sadrže poziciju markera `⊣`. Marker se ne ispisuje kao kolona.
9. Ako je potrebno, minimizuj.

### 2.4 Minimizacija particionim metodom

1. Ukloni nedostižna stanja (BFS od startnog stanja).
2. P0 = (prihvatajuća, neprihvatajuća). Prazna polja se tretiraju kao prelaz u posebno stanje greške `∅` koje je sâmo svoj blok i nije ekvivalentno nijednom stanju koje može da prihvati reč.
3. Za svaki blok i svaki ulazni simbol: stanja bloka čiji prelazi vode u **različite** blokove tekuće particije razdvoji u zasebne blokove. Time nastaje sledeća particija.
4. Ponavljaj korak 3 dok se particija ne promeni. Stanja u istom bloku su ekvivalentna.
5. Svaki blok postaje jedno stanje (preimenuj ga). Stanja iz bloka greške (neprihvatajuća stanja iz kojih se ne može stići do prihvatanja) izbaci ili ostavi kao eksplicitno stanje greške.

### 2.5 Operacije nad DKA (pojavljivale se na K)

- **Komplement**: dopuni DKA do potpunog (eksplicitno stanje greške), pa zameni prihvatajuća i neprihvatajuća stanja.
- **Zvezdasto zatvaranje DKA M** (jedan start `S`, jedan kraj `Z`; K 26.11.2021): (1) dodaj novo startno stanje `S'` koje prihvata (da bi se prihvatila prazna reč) i ima iste izlazne prelaze kao `S`; (2) dodaj ε-prelaz `Z → S`; (3) konstrukcijom podskupova: kad god skup sadrži `Z`, dodaj mu i `S`; (4) prihvatajuća su stanja koja sadrže `Z` ili `S'`; (5) minimizuj.
- **Ekvivalencija dva DKA**: minimizuj oba i uporedi, ili tabela ekvivalencije od para startnih stanja (Zbirka 1.2.2): par (X,Y) je u redu ako su oba prihvatajuća ili oba odbijajuća, a za svaki simbol par prelaza (X',Y') ulazi u tabelu; ako se ikad pojavi nekompatibilan par, automati nisu ekvivalentni.
- **Unija/presek**: proizvod automata (parovi stanja); unija prihvata ako bar jedna komponenta prihvata.

## 3. Primeri

### 3.1 Tompson + podskupovi + minimizacija za `a(b|c)*d`

Tompson (stanja su numerisana redom pravljenja): `b` je 2→3, `c` je 4→5; `b|c` dodaje novo startno 6 i novo završno 7; `(b|c)*` dodaje novo startno 8 i novo završno 9 (grane 8→6, 7→9, 8→9 i petlja 7→6); `a` je 0→1 i ε-granom 1→8 ulazi u zvezdicu; `d` je 10→11, a ε-grana 9→10 spaja zvezdicu sa `d`:

Stanja 0..11, startno 0, završno 11.

| iz | ulaz | u |
|---|---|---|
| 0 | a | 1 |
| 1 | ε | 8 |
| 2 | b | 3 |
| 3 | ε | 7 |
| 4 | c | 5 |
| 5 | ε | 7 |
| 6 | ε | 2 |
| 6 | ε | 4 |
| 7 | ε | 6 |
| 7 | ε | 9 |
| 8 | ε | 6 |
| 8 | ε | 9 |
| 9 | ε | 10 |
| 10 | d | 11 |

ε-zatvaranje startnog stanja 0 je {0}. Tabela podskupova:

| DKA | skup NKA stanja (ε-zatvaranje) | `a` | `b` | `c` | `d` | prihv. |
|---|---|---|---|---|---|---|
| → A | {0} | B |  |  |  | 0 |
| B | {1, 2, 4, 6, 8, 9, 10} |  | C | D | E | 0 |
| C | {2, 3, 4, 6, 7, 9, 10} |  | C | D | E | 0 |
| D | {2, 4, 5, 6, 7, 9, 10} |  | C | D | E | 0 |
| E | {11} |  |  |  |  | 1 |

Stanja B, C, D se ponašaju isto (sva tri imaju iste prelaze), pa se particionim metodom spajaju:

- P0 = ( {E}, {A, B, C, D} )
- P1 = ( {E}, {A}, {B, C, D} )

(P1: stanje A ima prelaz `a` u blok {B,C,D}, a B, C, D za `a` idu u grešku, pa se A odvaja.) Blokovi: A = {A}, B = {B, C, D}, C = {E}. Minimalni DKA (provereno i metodom pozicija, isti automat):

| stanje | `a` | `b` | `c` | `d` | prihv. |
|---|---|---|---|---|---|
| → A | B |  |  |  | 0 |
| B |  | B | B | C | 0 |
| C |  |  |  |  | 1 |

### 3.2 Metoda pozicija za `(a|b|ε)*d(c*d)+` (K 22.11.2019, zadatak 2)

Izraz sa markerom: `(a|b|ε)*d(c*d)+⊣`. Pozicije: 1=a, 2=b, 3=d, 4=c, 5=d, 6=⊣ (ε nema poziciju). Poništivi čvorovi: `ε`, `(a|b|ε)`, `(a|b|ε)*`, `c*`. Ostalo nije poništivo (`c*d` nije jer `d` nije).

- prva(`(a|b|ε)*`) = {1,2}, poslednja = {1,2}; prva(`c*d`) = {4,5} (jer je `c*` poništivo), poslednja(`c*d`) = {5}; prva(`(c*d)+`) = {4,5}, poslednja = {5}.
- prva(koren) = prva(`(a|b|ε)*`) ∪ prva(`d`) = {1,2,3} (jer je prvi činilac poništiv).

Sledeće pozicije:

| pozicija | simbol | sledeća pozicija |
|---|---|---|
| 1 | a | {1, 2, 3} |
| 2 | b | {1, 2, 3} |
| 3 | d | {4, 5} |
| 4 | c | {4, 5} |
| 5 | d | {4, 5, 6} |
| 6 | ⊣ | – |

(Poz. 1 i 2: zvezdica daje {1,2}, konkatenacija sa `d` dodaje {3}. Poz. 3: prva(`(c*d)+`) = {4,5}. Poz. 4: zvezdica nad `c` daje {4}, konkatenacija `c*`·`d` daje {5}. Poz. 5: plus daje {4,5}, konkatenacija sa `⊣` dodaje {6}.)

DKA (startno stanje je prva(koren)):

| stanje | skup pozicija | `a` | `b` | `c` | `d` | prihv. |
|---|---|---|---|---|---|---|
| → A | {1, 2, 3} | A | A |  | B | 0 |
| B | {4, 5} |  |  | B | C | 0 |
| C | {4, 5, 6} |  |  | B | C | 1 |

Provera particijama: - P0 = ( {C}, {A, B} )
- P1 = ( {C}, {A}, {B} ) (već minimalan, 3 stanja). Isti izraz preko Tompsona daje **22 stanja NKA**, DKA od 6 stanja, koji se minimizuje na 3 stanja:

| stanje | `a` | `b` | `c` | `d` | prihv. |
|---|---|---|---|---|---|
| → A | B | C |  | D | 0 |
| B | B | C |  | D | 0 |
| C | B | C |  | D | 0 |
| D |  |  | E | F | 0 |
| E |  |  | E | F | 0 |
| F |  |  | E | F | 1 |

- P0 = ( {F}, {A, B, C, D, E} )
- P1 = ( {F}, {A, B, C}, {D, E} )

Blokovi: A = {A, B, C}, B = {D, E}, C = {F}. Dobija se isti minimalni automat kao metodom pozicija (provereno skriptom na svim rečima nad {a,b,c,d} do dužine 9 i poređenjem sa Python `re`).

### 3.3 Zvezdasto zatvaranje i minimizacija (K 26.11.2021, zadatak 1b–c)

M1 (startno A, završno B; stanje D nije dostižno, pa ga odmah ne crtamo):

| stanje | `0` | `1` | prihv. |
|---|---|---|---|
| → A | B | A | 0 |
| B | C | B | 1 |
| C | B | A | 0 |

M1\*: novo start-stanje `S'` (prihvata, prelazi kao A), a svaki skup koji sadrži B dobija i A:

| stanje | skup stanja M1 | `0` | `1` | prihv. |
|---|---|---|---|---|
| → A | {S'} | B | C | 1 |
| B | {A, B} | D | B | 1 |
| C | {A} | B | C | 0 |
| D | {A, B, C} | D | B | 1 |

Minimizacija:

- P0 = ( {A, B, D}, {C} )
- P1 = ( {A}, {B, D}, {C} )

Blokovi: A = {A}, B = {B, D}, C = {C}. Rezultat (provereno nad svim rečima {0,1}* do dužine 11 poređenjem sa definicijom zvezdastog zatvaranja):

| stanje | `0` | `1` | prihv. |
|---|---|---|---|
| → A | B | C | 1 |
| B | B | B | 1 |
| C | B | C | 0 |

## 4. Tipične greške

- **Marker kraja izostavljen** u metodi pozicija: nema stanja prihvatanja.
- Ista oznaka simbola dobije **istu poziciju** (Cas 2, sl. 28: `AA⊣` bi tada prihvatao `A+`). Svaka pojava u izrazu ima svoju poziciju.
- Zaboravljen čvor `+` (isto kao `*`, ali ne poništiv ako sin nije poništiv) ili zaboravljena petlja `staro kraj → staro start` kod Tompsonovog `+`.
- ε-zatvaranje se ne primeni na rezultat prelaza (samo na startno stanje).
- U particionoj minimizaciji se prazno polje (greška) pomeša sa nekim blokom. Stanje koje ima prelaz za simbol nije ekvivalentno stanju koje za taj simbol ide u grešku.
- Startno stanje je prihvatajuće kad izraz prihvata `ε`; kod `ε` u izrazu proveri prvu poziciju markera (npr. `a*⊣`: start sadrži poziciju markera).
- Zvezdasto zatvaranje DKA bez novog startnog stanja: ako `S` ima ulazne grane, prihvatila bi se pogrešna reč; prazna reč se ne bi prihvatala.
- Metod pozicija daje DKA sa stanjima-skupovima; student zaboravi da preimenuje stanja i da navede koji su prihvatajući.

## 5. Pojavljivalo se na K

- **IR 22.11.2019, zad. 2**: `(a|b|ε)*d(c*d)+`, Tompson → minimalni DKA, pa gramatika (primer 3.2 gore; gramatika je u beleški 03).
- **IR 26.11.2021, zad. 1**: postupak za zvezdasto zatvaranje DKA, primena na M1, minimizacija particijama (primer 3.3).
- **SI K1** (isto gradivo): 2010/11 minDKA za binarne brojeve deljive sa 4; 2011/12 deljivi sa 8 (RI, Tompson, DKA); 2015/16 operacije nad DKA (unija sa komplementom) + minimizacija i metoda pozicija + Tompson; 2016/17 metoda pozicija + minimizacija; 2017/18 poništivost/prva/poslednja/sledeća pozicija → KA, ekvivalencija, NKA→DKA; 2019/20 `b(a|(bc)*)+` metodom pozicija; 2020/21 RI za skup prirodnih brojeva u vitičastim zagradama + metoda pozicija.
- Vežbe (Cas 2) pominju i zadatke sa ispita: septembar 2017 zad. 1 (`A*(B+|(CA*))D⊣`, metoda pozicija) i jul 2023 zad. 2 (`(a|ε)+((a|b)*c)*⊣`).
- **Verovatnoća za 28.11.:** vrlo visoka, ovo je najčešći zadatak. Vežbaj metodu pozicija (najbrža) i Tompsona.

## Dodatak: skup prirodnih brojeva u vitičastim zagradama (SI K1 2020/21, zadatak 2)

Zadatak: regularni izraz za skup prirodnih brojeva (celobrojne konstante > 0): prazan skup je `{}`, inače brojevi odvojeni zarezima, npr. `{}`, `{1}`, `{23, 10, 1590}`; zatim DKA metodom pozicija.

Rešenje (po skeniranom studentskom rešenju, proveren skriptom): uvedi klase `d = [0-9]`, `b = [1-9]`, `Num = b d*`. Izraz: `{ ( Num (, Num)* | ε ) } ─┤`, odnosno `{ ( b d* (, b d*)* | ε ) } ─┤`.

Pozicije: 1 `{`, 2 `b`, 3 `d`, 4 `,`, 5 `b`, 6 `d`, 7 `}`, 8 `─┤`. Poništivo je samo `ε`, `prva(koren) = {1}`. Sledeća pozicija:

| pozicija | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|---|---|---|
| sledeća | {2,7} | {3,4,7} | {3,4,7} | {5} | {4,6,7} | {4,6,7} | {8} | ∅ |

DKA (stanje = skup pozicija; prihvata ako sadrži poziciju 8):

| stanje | `{` | `b` | `d` | `,` | `}` | prihvata |
|---|---|---|---|---|---|---|
| S1 = {1} | S2 | | | | | ne |
| S2 = {2,7} | | S3 | | | S4 | ne |
| S3 = {3,4,7} | | | S3 | S5 | S4 | ne |
| S4 = {8} | | | | | | da |
| S5 = {5} | | S6 | | | | ne |
| S6 = {4,6,7} | | | S6 | S5 | S4 | ne |

Ovo je ono što se traži (minimizacija nije tražena). Particionom metodom se vidi da su S3 i S6 ekvivalentni (isto ponašanje na `d`, `,` i `}`), pa je minimalan DKA sa 5 stanja. Napomena: `b` i `d` se preklapaju (cifre 1–9 su oba), pa se pri izvođenju sekvence stanje prati kao skup ili se prvo odluči na kojoj poziciji je cifra (prva cifra broja je `b`, ostale `d`).

