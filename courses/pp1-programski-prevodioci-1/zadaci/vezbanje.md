# Programski prevodioci 1: zadaci za vežbanje (gradivo K1)

Zadaci su napravljeni po uzoru na stare IR kolokvijume (`analiza-starih-K.md`): isti format (zadatak od 10 poena, podtačke sa poenima), ista težina i isti tipovi (regularni izrazi i automati, gramatike, potisni automati, LR(0)/SLR(1)/LALR(1), panic mode, FIRST/FOLLOW/LL(1), rekurzivni spust, konačni procesor). **Rešenja nisu ovde**, nego u `vezbanje-resenja.md`. Prvo reši sam (na papiru, bez beleški), pa uporedi.

**Napomena sa kolokvijuma (važi i ovde):** ako u zadatku nešto nije dovoljno precizno definisano, uvedi razumnu pretpostavku, uokviri je i nastavi na njenim temeljima. Odgovaraj čitko i precizno. `─┤` je marker kraja ulaza, `ε` prazna sekvenca, `∇` dno steka potisnog automata.

**Probni kolokvijumi (3 zadatka, 90 minuta, bez literature):**

| Probni | Zadaci |
|---|---|
| 1 | 1, 4, 7 |
| 2 | 2, 6, 8 |
| 3 | 3, 5, 10 |
| Dodatno | 9 (panic mode), 11 (procesor), 12 (suvišni neterminali, automat → gramatika, višeznačnost) |

Pokrivenost: beleške `01` (zadaci 1–3), `02` (11), `03` (4, 12), `04` (5, 6), `05` (7, 8), `06` (9), `07` (10).

---

## Zadatak 1 (10 poena)

Dat je regularni izraz `(a|b)*abb(a|b)*`.

a) [2] Napisati izraz sa markerom kraja, nacrtati sintaksno stablo, numerisati pozicije i označiti poništive čvorove.
b) [3] Odrediti prvu i poslednju poziciju svakog čvora i tabelu sledećih pozicija.
c) [3] Metodom pozicija konstruisati DKA (tabela prelaza, označiti stanja prihvatanja i skupove pozicija).
d) [2] Particionim metodom minimizovati dobijeni automat.

## Zadatak 2 (10 poena)

Dat je regularni izraz `a(b|c)*(a|d)`.

a) [4] Tompsonovim algoritmom konstruisati NKA (označiti stanja brojevima, navesti sve prelaze).
b) [3] Konstruisati ekvivalentan DKA (tabela prelaza; uz svako stanje navesti skup stanja NKA).
c) [3] Particionim metodom odrediti minimalni DKA. Prikazati sve particije.

## Zadatak 3 (10 poena)

Dat je deterministički automat M (startno stanje A, jedino stanje prihvatanja B):

| stanje | `0` | `1` | prihv. |
|---|---|---|---|
| → A | B | C | 0 |
| B | C | A | 1 |
| C | A | C | 0 |
| D | A | C | 0 |

a) [2] Kratko opisati postupak kojim se za proizvoljan DKA sa jednim startnim i jednim završnim stanjem konstruiše automat M\* koji prihvata tačno zvezdasto zatvaranje jezika automata M (standardne algoritme sa predavanja samo pomenuti po imenu).
b) [6] Primeniti postupak na automat M i konstruisati DKA M\* (tabela, uz svako stanje navesti skup stanja automata M).
c) [2] Particionim metodom minimizovati M\*.

## Zadatak 4 (10 poena)

a) [2] Napisati gramatiku za jezik `L₁ = { aⁿ bᵐ c²ⁿ | n ≥ 0, m ≥ 1 }`.
b) [2] Napisati gramatiku za jezik `L₂ = { w c wᴿ | w ∈ {a, b}* }` (wᴿ je w zapisano unazad).
c) [6] Napisati nedvosmislenu gramatiku za program koji čini niz od jedne ili više naredbi dodele oblika `ID = izraz ;`. Izraz sadrži binarne operatore `+` i `-` (levo asocijativni, najniži prioritet), `*` i `/` (levo asocijativni), `^` (**desno** asocijativan, veći prioritet od `*` i `/`) i unarni prefiksni `-` (najviši prioritet, može se ponavljati, npr. `--x`). Dozvoljene su zagrade. Operand je `ID` ili `BROJ`. Prikazati stablo izvođenja za `a = -b ^ c ^ d * (e + 1) - 2 ;`.

## Zadatak 5 (10 poena)

Posmatra se jezik `L = { aⁿ bᵐ cᵏ | n, k ≥ 0, m = n + k }`.

a) [3] Napisati gramatiku koja opisuje jezik L.
b) [5] Konstruisati potisni automat koji prepoznaje tačno jezik L (navesti ulazne simbole, simbole steka, stanja, početni stek i kontrolne tabele).
c) [2] Prikazati rad automata (stek, ulaz, akcija) za sekvencu `aabbbc` i za neku sekvencu koja se odbija.

## Zadatak 6 (10 poena)

Ulazna sekvenca sadrži cifre `1`, `2` i `3` i znak `-` koji **negira sledeću cifru**. Paran broj uzastopnih znakova `-` ispred cifre znači da je cifra pozitivna, a neparan da je negativna. Konstruisati potisni automat koji proverava da li je **suma svih cifara jednaka nuli**.

Prihvataju se: `12-3`, `1-12-2`, `1--1-2`, `12-2-1`. Odbijaju se: `1-2`, `2-1`. (Znak `-` mora da stoji ispred neke cifre, niz ne sme da se završi znakom `-`.)

a) [7] Konstruisati potisni automat (simboli, stanja, početni stek, kontrolne tabele).
b) [3] Prikazati rad za `12-3` i za `1-2`.

## Zadatak 7 (10 poena)

Na slikama su prikazane potisna i LR(0) kontrolna tabela jednog parsera od dna ka vrhu za gramatiku sa startnim neterminalom ⟨S⟩ (smena 0. je `⟨S'⟩ → ⟨S⟩ ─┤`; imena stanja se sastoje od simbola i brojeva smena koje ga sadrže u jezgru).

Potisna tabela:

| | `S` | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|---|
| ∇ | S03 | a12 |  |  |  |
| S03 |  |  |  | c3 | ─┤0 |
| a12 | S23 | a12 |  |  |  |
| c3 |  |  |  |  |  |
| ─┤0 |  |  |  |  |  |
| S23 |  |  | b2 | c3 |  |
| b2 |  |  |  |  |  |

LR(0) kontrolna tabela:

| | akcija |
|---|---|
| ∇ | SHIFT |
| S03 | SHIFT |
| a12 | SHIFT / REDUCE(1) |
| c3 | REDUCE(3) |
| ─┤0 | ACCEPT |
| S23 | SHIFT |
| b2 | REDUCE(2) |

a) [3] Na osnovu datih podataka rekonstruisati karakteristični LR(0) automat (sa konfiguracijama u stanjima).
b) [2] Kako izgleda gramatika na osnovu koje je napravljen parser?
c) [3] Odrediti FOLLOW skupove i kontrolnu tabelu SLR(1) parsera. Da li ima konflikata?
d) [2] Prikazati rad SLR(1) parsera za ulaz `aabcc`.

## Zadatak 8 (10 poena)

Data je gramatika sa startnim neterminalom ⟨S⟩:

```
1. S → L = R        4. L → id
2. S → R            5. R → L
3. L → * R
```

a) [3] Konstruisati karakteristični LR(0) automat (stanja sa konfiguracijama).
b) [2] Odrediti FIRST/FOLLOW skupove i kontrolnu tabelu SLR(1) parsera. Da li gramatika pripada klasi SLR(1)?
c) [3] Odrediti predikcione skupove (metodom prosleđivanja) i konstruisati kontrolnu tabelu LALR(1) parsera. Da li gramatika pripada klasi LALR(1)?
d) [2] Prikazati rad LALR(1) parsera za ulaz `*id=id`.

## Zadatak 9 (10 poena)

Data je gramatika (blok je niz naredbi između `{` i `}`):

```
0. S' → P -|
1. P → P S
2. P → S
3. S → id = E ;
4. S → { P }
5. E → E + n
6. E → n
```

(nulta smena je proširenje; `─┤` je marker kraja ulaza). Dati su potisna i SLR(1) kontrolna tabela:

| | `P` | `S` | `E` | `id` | `=` | `;` | `{` | `}` | `+` | `n` | `─┤` |
|---|---|---|---|---|---|---|---|---|---|---|---|
| ∇ | P01 | S2 |  | id3 |  |  | {4 |  |  |  |  |
| P01 |  | S1 |  | id3 |  |  | {4 |  |  |  | ─┤0 |
| S2 |  |  |  |  |  |  |  |  |  |  |  |
| id3 |  |  |  |  | =3 |  |  |  |  |  |  |
| {4 | P14 | S2 |  | id3 |  |  | {4 |  |  |  |  |
| S1 |  |  |  |  |  |  |  |  |  |  |  |
| ─┤0 |  |  |  |  |  |  |  |  |  |  |  |
| =3 |  |  | E35 |  |  |  |  |  |  | n6 |  |
| P14 |  | S1 |  | id3 |  |  | {4 | }4 |  |  |  |
| E35 |  |  |  |  |  | ;3 |  |  | +5 |  |  |
| n6 |  |  |  |  |  |  |  |  |  |  |  |
| }4 |  |  |  |  |  |  |  |  |  |  |  |
| ;3 |  |  |  |  |  |  |  |  |  |  |  |
| +5 |  |  |  |  |  |  |  |  |  | n5 |  |
| n5 |  |  |  |  |  |  |  |  |  |  |  |

| | `id` | `=` | `;` | `{` | `}` | `+` | `n` | `─┤` |
|---|---|---|---|---|---|---|---|---|
| ∇ | SHIFT |  |  | SHIFT |  |  |  |  |
| P01 | SHIFT |  |  | SHIFT |  |  |  | SHIFT |
| S2 | REDUCE(2) |  |  | REDUCE(2) | REDUCE(2) |  |  | REDUCE(2) |
| id3 |  | SHIFT |  |  |  |  |  |  |
| {4 | SHIFT |  |  | SHIFT |  |  |  |  |
| S1 | REDUCE(1) |  |  | REDUCE(1) | REDUCE(1) |  |  | REDUCE(1) |
| ─┤0 |  |  |  |  |  |  |  | ACCEPT |
| =3 |  |  |  |  |  |  | SHIFT |  |
| P14 | SHIFT |  |  | SHIFT | SHIFT |  |  |  |
| E35 |  |  | SHIFT |  |  | SHIFT |  |  |
| n6 |  |  | REDUCE(6) |  |  | REDUCE(6) |  |  |
| }4 | REDUCE(4) |  |  | REDUCE(4) | REDUCE(4) |  |  | REDUCE(4) |
| ;3 | REDUCE(3) |  |  | REDUCE(3) | REDUCE(3) |  |  | REDUCE(3) |
| +5 |  |  |  |  |  |  | SHIFT |  |
| n5 |  |  | REDUCE(5) |  |  | REDUCE(5) |  |  |

Na ulaz parsera dovodi se niz tokena:

`id = n ; id = n + { id = n ; id = n ; } id = n ; id = n ;`

a) [5] Prikazati izgled steka, ulaza i akcije parsera ako se za oporavak od grešaka koristi **jednostavan panic mode** algoritam sa sigurnim simbolima `;` i `}`.
b) [5] Isto, ali sa **poboljšanim panic mode** algoritmom, sa sigurnim simbolima `;` i `}` i simbolom zaglavlja `{`.

(Prikaz može da počne od trenutka otkrivanja prve greške; prethodni deo opiši jednom rečenicom.)

## Zadatak 10 (10 poena)

Data je gramatika sa startnim neterminalom ⟨P⟩:

```
1. P → P ; I          4. I → id ( E )      7. E → T
2. P → I              5. I → print E       8. T → id
3. I → id := E        6. E → E + T         9. T → n
```

a) [2] Odrediti FIRST i FOLLOW skupove za sve neterminale. Objasniti zašto gramatika nije LL(1).
b) [4] Transformisati gramatiku u LL(1) oblik (uklanjanje leve rekurzije i leva faktorizacija).
c) [2] Za transformisanu gramatiku odrediti selekcione skupove svih smena i proveriti da li je LL(1).
d) [2] Realizovati parser metodom rekurzivnog spusta za neterminale koji su nastali od ⟨I⟩ (procedure za ⟨I⟩ i njegov novi neterminal).

## Zadatak 11 (10 poena)

Celobrojna konstanta ima oblik `[+-]? ( 0 | [1-9][0-9]* | 0x[0-9a-fA-F]+ )`: opcioni znak, pa ili nula, ili dekadni broj bez vodećih nula, ili heksadecimalni broj sa prefiksom `0x`. Ulazni simboli procesora su: `SIGN` (`+`, `-`), `ZERO` (`0`), `DEC` (`1`–`9`), `X` (`x`), `HEX` (`a`–`f`, `A`–`F`) i `─┤`.

a) [5] Konstruisati deterministički konačni procesor koji prepoznaje konstantu i izračunava njenu binarnu vrednost (sa znakom) u registru `V`. Stanja označavati redom slovima A, B, C, … Prikazati automat bez akcija i akcije koje odgovaraju prelazima (uz tabelu prelaza).
b) [3] Prikazati rad procesora za ulaz `-0x1F` (stanje, ulaz, akcija, vrednosti registara).
c) [2] Skicirati implementaciju procesora projektnim uzorkom State (Java): navesti interfejs i klase stanja, i napisati kod klase za stanje koje obrađuje heksadecimalne cifre.

## Zadatak 12 (10 poena)

a) [4] Naći suvišne neterminale (mrtve i nedostižne) u gramatici sa startnim ⟨S⟩ i dati ekvivalentnu gramatiku bez njih. Obrazložiti redosled.

```
1. S → a A       5. A → b        9. D → d D
2. S → B D       6. B → B d     10. D → e
3. S → A c       7. B → C       11. E → A D
4. A → a A       8. C → c C     12. E → S
```

b) [4] Data je desno-linearna gramatika sa startnim ⟨S⟩: `S → a b T | c`, `T → S | d T | ε`. Transformisati je u regularnu gramatiku, pa konstruisati odgovarajući NKA.
c) [2] Pokazati da je gramatika `E → E + E | E * E | ( E ) | id` višeznačna (dva stabla za `id + id * id`) i napisati nedvosmislenu gramatiku istog jezika u kojoj `*` ima veći prioritet od `+`, a obe operacije su levo asocijativne.
