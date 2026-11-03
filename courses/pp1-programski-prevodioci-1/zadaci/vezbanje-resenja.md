# Programski prevodioci 1: rešenja zadataka za vežbanje (K1)

Rešenja zadataka iz `vezbanje.md`. **Ne otvaraj dok ne probaš.** Svaki automat, tabela, skup i trag rada generisan je i proveren skriptama (Python 3, plus Java za kôd u zadacima 10 i 11): automati su upoređeni sa regularnim izrazima ili definicijama jezika na svim rečima do dužine 8–12, gramatike su upoređene nabrajanjem svih reči do dužine 7–11, LR/LALR tabele su generisane programski (LA skupovi metodom prosleđivanja i spajanjem LR(1) stanja, rezultat isti), a parser i oporavak simulirani. Notacija stanja LR parsera je kursna (simbol + brojevi smena, `'` kad se ime ponovi).

---

## Rešenje 1: `(a|b)*abb(a|b)*`, metoda pozicija

**a)** Izraz sa markerom: `(a|b)*abb(a|b)*⊣`. Pozicije (sleva nadesno): 1=a, 2=b, 3=a, 4=b, 5=b, 6=a, 7=b, 8=⊣. Poništiva su samo oba čvora `*` (zvezdica je uvek poništiva). `(a|b)` i sve konkatenacije koje sadrže `a`, `b`, `b` ili `⊣` nisu poništive.

**b)** Prva/poslednja pozicija ključnih čvorova: prvi `(a|b)*`: {1,2} / {1,2}. Podizraz `(a|b)*abb`: prva = {1,2,3} (prvi činilac je poništiv), poslednja = {5}. Drugi `(a|b)*`: {6,7} / {6,7}. Podizraz `(a|b)*abb(a|b)*`: prva = {1,2,3}, poslednja = {5,6,7} (drugi činilac je poništiv). Ceo izraz sa `⊣`: prva = {1, 2, 3}, poslednja = {8}.

Sledeće pozicije (zvezdice daju petlje, konkatenacije povezuju poslednje pozicije levog sa prvim pozicijama desnog):

| pozicija | simbol | sledeća pozicija |
|---|---|---|
| 1 | a | {1, 2, 3} |
| 2 | b | {1, 2, 3} |
| 3 | a | {4} |
| 4 | b | {5} |
| 5 | b | {6, 7, 8} |
| 6 | a | {6, 7, 8} |
| 7 | b | {6, 7, 8} |
| 8 | ⊣ | – |

**c)** DKA (startno stanje je prva(koren) = {1,2,3}; stanje prihvatanja sadrži poziciju 8):

| stanje | skup pozicija | `a` | `b` | prihv. |
|---|---|---|---|---|
| → A | {1, 2, 3} | B | A | 0 |
| B | {1, 2, 3, 4} | B | C | 0 |
| C | {1, 2, 3, 5} | B | D | 0 |
| D | {1, 2, 3, 6, 7, 8} | E | D | 1 |
| E | {1, 2, 3, 4, 6, 7, 8} | E | F | 1 |
| F | {1, 2, 3, 5, 6, 7, 8} | E | D | 1 |

**d)** Particije:

- P0 = ( {D, E, F}, {A, B, C} )
- P1 = ( {D, E, F}, {A, B}, {C} )
- P2 = ( {D, E, F}, {A}, {B}, {C} )

(P1: C se odvaja jer za `b` ide u blok prihvatajućih stanja, a A i B ne. P2: B se odvaja od A jer za `b` ide u C, a A u {A, B}. {D, E, F} se ne razdvaja: za `a` i `b` svi idu u blok {D, E, F}.) Minimalni DKA (6 → 4 stanja):

| stanje | `a` | `b` | prihv. |
|---|---|---|---|
| → A | B | A | 0 |
| B | B | C | 0 |
| C | B | D | 0 |
| D | D | D | 1 |

Blokovi: A = {A}, B = {B}, C = {C}, D = {D, E, F}. To je automat koji prepoznaje nizove koji sadrže `abb`.

---

## Rešenje 2: `a(b|c)*(a|d)`, Tompson

**a)** Tompsonov NKA:

Stanja 0..15, startno 0, završno 15.

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
| 9 | ε | 14 |
| 10 | a | 11 |
| 11 | ε | 15 |
| 12 | d | 13 |
| 13 | ε | 15 |
| 14 | ε | 10 |
| 14 | ε | 12 |

(`a` je 0→1; `(b|c)*` je 2…9: `b` 2→3, `c` 4→5, unija 6→{2,4} i {3,5}→7, zvezdica 8 (novo startno) i 9 (novo završno); `(a|d)` je 10…15: `a` 10→11, `d` 12→13, unija 14 (start) i 15 (kraj); ε-grane 1→8 i 9→14 su konkatenacije.)

**b)** ε-zatvaranje startnog stanja je {0}. Tabela podskupova:

| DKA | skup NKA stanja (ε-zatvaranje) | `a` | `b` | `c` | `d` | prihv. |
|---|---|---|---|---|---|---|
| → A | {0} | B |  |  |  | 0 |
| B | {1, 2, 4, 6, 8, 9, 10, 12, 14} | C | D | E | F | 0 |
| C | {11, 15} |  |  |  |  | 1 |
| D | {2, 3, 4, 6, 7, 9, 10, 12, 14} | C | D | E | F | 0 |
| E | {2, 4, 5, 6, 7, 9, 10, 12, 14} | C | D | E | F | 0 |
| F | {13, 15} |  |  |  |  | 1 |

**c)** Particije:

- P0 = ( {C, F}, {A, B, D, E} )
- P1 = ( {C, F}, {A}, {B, D, E} )

Blokovi: A = {A}, B = {B, D, E}, C = {C, F}. Minimalni DKA (provereno protiv regularnog izraza i metodom pozicija, isti automat, 3 stanja):

| stanje | `a` | `b` | `c` | `d` | prihv. |
|---|---|---|---|---|---|
| → A | B |  |  |  | 0 |
| B | C | B | B | C | 0 |
| C |  |  |  |  | 1 |

---

## Rešenje 3: zvezdasto zatvaranje

**a)** (1) Dodaj novo startno stanje `S'` koje prihvata (prazna reč pripada M\*) i ima iste izlazne prelaze kao staro startno stanje `S`. (2) Dodaj ε-prelaz iz završnog stanja `Z` u `S`. (3) Konstrukcijom podskupova (NKA → DKA): kad god skup sadrži `Z`, dodaj mu i `S`. (4) Prihvatajuća su stanja koja sadrže `Z` ili `S'`. (5) Po potrebi minimizuj. Pre toga se izbace nedostižna stanja (ovde `D`).

**b)** M ima nedostižno stanje D. M\* (startno stanje je `{S'}`):

| stanje | skup stanja M | `0` | `1` | prihv. |
|---|---|---|---|---|
| → A | {S'} | B | C | 1 |
| B | {A, B} | D | E | 1 |
| C | {C} | F | C | 0 |
| D | {A, B, C} | D | E | 1 |
| E | {A, C} | B | C | 0 |
| F | {A} | B | C | 0 |

**c)** Particije:

- P0 = ( {A, B, D}, {C, E, F} )
- P1 = ( {A, B, D}, {C}, {E, F} )
- P2 = ( {A}, {B, D}, {C}, {E, F} )

Blokovi: A = {A}, B = {B, D}, C = {C}, D = {E, F}. Minimalni M\* (provereno nad svim rečima {0,1}* do dužine 12 poređenjem sa definicijom zvezdastog zatvaranja):

| stanje | `0` | `1` | prihv. |
|---|---|---|---|
| → A | B | C | 1 |
| B | B | D | 1 |
| C | D | C | 0 |
| D | B | C | 0 |

---

## Rešenje 4: gramatike

**a)** `L₁ = { aⁿbᵐc²ⁿ, n ≥ 0, m ≥ 1 }`: spoljašnji par `a … cc`, unutra bar jedno `b`:

```
S → a S c c | B
B → b B | b
```

**b)** `w c wᴿ`: palindrom sa markerom u sredini:

```
S → a S a | b S b | c
```

(a) i b) proverene nabrajanjem: 26 odnosno 31 reči do dužine 11 odnosno 9 se poklapaju sa definicijom.)

**c)** Nivoi (od najnižeg): `+ -` (levo) → `* /` (levo) → `^` (desno) → unarni `-` (prefiks) → primarni.

1. Prog → Prog Stmt
2. Prog → Stmt
3. Stmt → ID = Expr ;
4. Expr → Expr + Term
5. Expr → Expr - Term
6. Expr → Term
7. Term → Term * Pow
8. Term → Term / Pow
9. Term → Pow
10. Pow → Un ^ Pow
11. Pow → Un
12. Un → - Un
13. Un → Prim
14. Prim → ( Expr )
15. Prim → ID
16. Prim → BROJ

(Nivoi: Expr = `+ -`, Term = `* /`, Pow = `^`, Un = unarni minus, Prim = zagrade/operand. `Pow → Un ^ Pow` je desna rekurzija (desna asocijativnost), `Un → - Un` dozvoljava `--x`.) Provereno: SLR(1) tabela bez konflikata (dakle nedvosmislena), a 500 slučajnih naredbi daje isto grupisanje kao referentni parser sa tačnim prioritetima.

Stablo izvođenja za `a = -b ^ c ^ d * (e + 1) - 2 ;` (lanci jednostrukih smena su spojeni ⇒; u odgovoru nacrtaj stablo grafički). Grupisanje: a = ((((-b) ^ (c ^ d)) * (e + 1)) - 2) ;.

- `<Prog> ⇒ <Stmt>`
    - `a`
    - `=`
    - `<Expr>`
        - `<Expr> ⇒ <Term>`
            - `<Term> ⇒ <Pow>`
                - `<Un>`
                    - `-`
                    - `<Un> ⇒ <Prim>`
                        - `b`
                - `^`
                - `<Pow>`
                    - `<Un> ⇒ <Prim>`
                        - `c`
                    - `^`
                    - `<Pow> ⇒ <Un> ⇒ <Prim>`
                        - `d`
            - `*`
            - `<Pow> ⇒ <Un> ⇒ <Prim>`
                - `(`
                - `<Expr>`
                    - `<Expr> ⇒ <Term> ⇒ <Pow> ⇒ <Un> ⇒ <Prim>`
                        - `e`
                    - `+`
                    - `<Term> ⇒ <Pow> ⇒ <Un> ⇒ <Prim>`
                        - `1`
                - `)`
        - `-`
        - `<Term> ⇒ <Pow> ⇒ <Un> ⇒ <Prim>`
            - `2`
    - `;`

---

## Rešenje 5: aⁿbᵐcᵏ, m = n + k

**a)** `aⁿbⁿ` pa `bᵏcᵏ`:

```
S → X Y
X → a X b | ε
Y → b Y c | ε
```

(proverena nabrajanjem: 21 reči do dužine 10.)

**b)** Ulazni simboli {a, b, c}; simboli steka {∇, A, B}; stanja {S₁, S₂, S₃, S₄}; početni stek ∇. S₁: čitaju se `a` (po jedan `A`); prvo `b` skida `A` (ako ga ima, prelaz u S₂) ili, ako je stek prazan (n = 0), stavlja `B` (prelaz u S₃). S₂: `b` skidaju preostale `A`; kad `A` ponestane, svako `b` stavlja `B` (prelaz u S₃, jer ostalih `b` ima koliko i `c`). S₃: `b` stavljaju `B`, prvo `c` skida `B` i prelazi u S₄. S₄: `c` skidaju `B`. Prihvata se u S₁, S₂ (k = 0, nema c) i S₄ sa praznim stekom (`∇`):

**S1**

| | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|
| A | PUSH(A), ADVANCE | POP, ADVANCE, STATE(S2) | REJECT | REJECT |
| B | REJECT | REJECT | REJECT | REJECT |
| ∇ | PUSH(A), ADVANCE | PUSH(B), ADVANCE, STATE(S3) | REJECT | ACCEPT |

**S2**

| | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|
| A | REJECT | POP, ADVANCE | REJECT | REJECT |
| B | REJECT | REJECT | REJECT | REJECT |
| ∇ | REJECT | PUSH(B), ADVANCE, STATE(S3) | REJECT | ACCEPT |

**S3**

| | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|
| A | REJECT | REJECT | REJECT | REJECT |
| B | REJECT | PUSH(B), ADVANCE | POP, ADVANCE, STATE(S4) | REJECT |
| ∇ | REJECT | REJECT | REJECT | REJECT |

**S4**

| | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|
| A | REJECT | REJECT | REJECT | REJECT |
| B | REJECT | REJECT | POP, ADVANCE | REJECT |
| ∇ | REJECT | REJECT | REJECT | ACCEPT |


**c)** Rad za `aabbbc` (n=2, m=3, k=1):

| # | stek | ulaz | stanje | akcija |
|---|---|---|---|---|
| 1 | ∇ | aabbbc─┤ | S1 | PUSH(A), ADVANCE |
| 2 | ∇A | abbbc─┤ | S1 | PUSH(A), ADVANCE |
| 3 | ∇AA | bbbc─┤ | S1 | POP, ADVANCE, STATE(S2) |
| 4 | ∇A | bbc─┤ | S2 | POP, ADVANCE |
| 5 | ∇ | bc─┤ | S2 | PUSH(B), ADVANCE, STATE(S3) |
| 6 | ∇B | c─┤ | S3 | POP, ADVANCE, STATE(S4) |
| 7 | ∇ | ─┤ | S4 | ACCEPT |

Za `abbbc` (m=3, ali n+k=2) automat odbija na `─┤` jer na steku ostaje `B`:

| # | stek | ulaz | stanje | akcija |
|---|---|---|---|---|
| 1 | ∇ | abbbc─┤ | S1 | PUSH(A), ADVANCE |
| 2 | ∇A | bbbc─┤ | S1 | POP, ADVANCE, STATE(S2) |
| 3 | ∇ | bbc─┤ | S2 | PUSH(B), ADVANCE, STATE(S3) |
| 4 | ∇B | bc─┤ | S3 | PUSH(B), ADVANCE |
| 5 | ∇BB | c─┤ | S3 | POP, ADVANCE, STATE(S4) |
| 6 | ∇B | ─┤ | S4 | REJECT |

(Automat proveren simulacijom nad svim rečima nad {a,b,c} do dužine 11.)

---

## Rešenje 6: suma cifara jednaka nuli

**a)** Ideja: stek čuva trenutnu sumu: `k` simbola `P` znači +k, `k` simbola `N` znači −k, `∇` znači 0. Stanja `POZ`/`NEG` kažu da li je sledeća cifra pozitivna ili negativna (svaki `-` prebacuje `POZ` ↔ `NEG`, posle cifre se ide u `POZ`). Cifra 1 menja sumu za ±1 (u `POZ`: ako je na vrhu `N`, `POP`, inače `PUSH(P)`; u `NEG`: ako je na vrhu `P`, `POP`, inače `PUSH(N)`). Cifre 2 i 3 se obrađuju jedinicu po jedinicu uz `RETAIN`: stanje `+2` znači "još dve jedinice za dodavanje", `+1` "još jedna" (isto `-2`, `-1`). Prihvata se na `─┤` samo u `POZ` (nema viseće `-`) i sa praznim stekom (`∇`). Ulazni simboli {1, 2, 3, -}; simboli steka {∇, P, N}; stanja {POZ, NEG, +2, +1, −2, −1}; početni stek ∇; startno stanje POZ.

**POZ**

| | `1` | `2` | `3` | `-` | `─┤` |
|---|---|---|---|---|---|
| P | PUSH(P), ADVANCE | PUSH(P), RETAIN, STATE(+1) | PUSH(P), RETAIN, STATE(+2) | ADVANCE, STATE(NEG) | REJECT |
| N | POP, ADVANCE | POP, RETAIN, STATE(+1) | POP, RETAIN, STATE(+2) | ADVANCE, STATE(NEG) | REJECT |
| ∇ | PUSH(P), ADVANCE | PUSH(P), RETAIN, STATE(+1) | PUSH(P), RETAIN, STATE(+2) | ADVANCE, STATE(NEG) | ACCEPT |

**NEG**

| | `1` | `2` | `3` | `-` | `─┤` |
|---|---|---|---|---|---|
| P | POP, ADVANCE, STATE(POZ) | POP, RETAIN, STATE(-1) | POP, RETAIN, STATE(-2) | ADVANCE, STATE(POZ) | REJECT |
| N | PUSH(N), ADVANCE, STATE(POZ) | PUSH(N), RETAIN, STATE(-1) | PUSH(N), RETAIN, STATE(-2) | ADVANCE, STATE(POZ) | REJECT |
| ∇ | PUSH(N), ADVANCE, STATE(POZ) | PUSH(N), RETAIN, STATE(-1) | PUSH(N), RETAIN, STATE(-2) | ADVANCE, STATE(POZ) | REJECT |


Stanja `+2`, `+1`, `−2`, `−1` imaju **iste** akcije za sve tri cifre (cifra je već "pročitana", a stanje pamti koliko još jedinica treba obraditi); na `-` i `─┤` je `REJECT`. Na vrhu `x`:

| stanje | vrh `P` ili `∇` | vrh `N` |
|---|---|---|
| `+2` | `PUSH(P)`, `RETAIN`, `STATE(+1)` | `POP`, `RETAIN`, `STATE(+1)` |
| `+1` | `PUSH(P)`, `ADVANCE`, `STATE(POZ)` | `POP`, `ADVANCE`, `STATE(POZ)` |

| stanje | vrh `N` ili `∇` | vrh `P` |
|---|---|---|
| `−2` | `PUSH(N)`, `RETAIN`, `STATE(−1)` | `POP`, `RETAIN`, `STATE(−1)` |
| `−1` | `PUSH(N)`, `ADVANCE`, `STATE(POZ)` | `POP`, `ADVANCE`, `STATE(POZ)` |

(U `POZ` i `NEG` cifra 2 obavlja prvu jedinicu i prelazi u `+1` odnosno `−1` sa `RETAIN`, cifra 3 u `+2` odnosno `−2`.) Proveren sa svim nizovima nad {1,2,3,-} do dužine 8 poređenjem sa definicijom ("suma = 0 i nema viseće `-`").

**b)** Rad za `12-3` (1 + 2 − 3 = 0, prihvata se):

| # | stek | ulaz | stanje | akcija |
|---|---|---|---|---|
| 1 | ∇ | 12-3─┤ | POZ | PUSH(P), ADVANCE |
| 2 | ∇P | 2-3─┤ | POZ | PUSH(P), RETAIN, STATE(+1) |
| 3 | ∇PP | 2-3─┤ | +1 | PUSH(P), ADVANCE, STATE(POZ) |
| 4 | ∇PPP | -3─┤ | POZ | ADVANCE, STATE(NEG) |
| 5 | ∇PPP | 3─┤ | NEG | POP, RETAIN, STATE(-2) |
| 6 | ∇PP | 3─┤ | -2 | POP, RETAIN, STATE(-1) |
| 7 | ∇P | 3─┤ | -1 | POP, ADVANCE, STATE(POZ) |
| 8 | ∇ | ─┤ | POZ | ACCEPT |

Rad za `1-2` (1 − 2 = −1, odbija se na `─┤` jer na steku ostaje `N`):

| # | stek | ulaz | stanje | akcija |
|---|---|---|---|---|
| 1 | ∇ | 1-2─┤ | POZ | PUSH(P), ADVANCE |
| 2 | ∇P | -2─┤ | POZ | ADVANCE, STATE(NEG) |
| 3 | ∇P | 2─┤ | NEG | POP, RETAIN, STATE(-1) |
| 4 | ∇ | 2─┤ | -1 | PUSH(N), ADVANCE, STATE(POZ) |
| 5 | ∇N | ─┤ | POZ | REJECT |

Primer sa dva minusa za istu cifru (`1--1-2`: 1 + 1 − 2 = 0):

| # | stek | ulaz | stanje | akcija |
|---|---|---|---|---|
| 1 | ∇ | 1--1-2─┤ | POZ | PUSH(P), ADVANCE |
| 2 | ∇P | --1-2─┤ | POZ | ADVANCE, STATE(NEG) |
| 3 | ∇P | -1-2─┤ | NEG | ADVANCE, STATE(POZ) |
| 4 | ∇P | 1-2─┤ | POZ | PUSH(P), ADVANCE |
| 5 | ∇PP | -2─┤ | POZ | ADVANCE, STATE(NEG) |
| 6 | ∇PP | 2─┤ | NEG | POP, RETAIN, STATE(-1) |
| 7 | ∇P | 2─┤ | -1 | POP, ADVANCE, STATE(POZ) |
| 8 | ∇ | ─┤ | POZ | ACCEPT |

---

## Rešenje 7: rekonstrukcija iz tabela

**Gramatika (b):**

0. S' → S -|
1. S → a
2. S → a S b
3. S → S c

**Automat (a):** vrste potisne tabele su stanja, prelazi su ćelije. Stanje `a12` ima ćeliju `SHIFT/REDUCE(1)`: potpunu konfiguraciju smene 1 (`S → a •`, REDUCE(1)) i konfiguracije sa tačkom ispred terminala (`S → a • S b` sa zatvaranjem `S → • a`, `S → • a S b`, `S → • S c`, pa SHIFT na `a`). Iz imena stanja `S03`, `S23`, `c3`, `b2` se vidi da smena 3 ima oblik `S c`, a smena 2 `a S b`. Stanja:

- **∇**: `S' -> • S ─┤`;  `S -> • a`;  `S -> • a S b`;  `S -> • S c`
- **S03**: `S' -> S • ─┤`;  `S -> S • c`
- **a12**: `S -> • a`;  `S -> a •`;  `S -> • a S b`;  `S -> a • S b`;  `S -> • S c`
- **c3**: `S -> S c •`
- **─┤0**: `S' -> S ─┤ •`
- **S23**: `S -> a S • b`;  `S -> S • c`
- **b2**: `S -> a S b •`

**c)** FOLLOW (FIRST/poništivost):

| neterminal | poništiv | FIRST | FOLLOW |
|---|---|---|---|
| S | ne | {a} | {─┤, b, c} |

SLR(1) kontrolna tabela: LR(0) konflikt u stanju `a12` (vrsta `a12`, kolona `a`) nestaje jer `a ∉ FOLLOW(S) = {b, c, ─┤}`, pa se REDUCE(1) upisuje samo u kolonama `b`, `c`, `─┤`. **Gramatika je SLR(1)**, bez konflikata.

| | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|
| ∇ | SHIFT |  |  |  |
| S03 |  |  | SHIFT | SHIFT |
| a12 | SHIFT | REDUCE(1) | REDUCE(1) | REDUCE(1) |
| c3 |  | REDUCE(3) | REDUCE(3) | REDUCE(3) |
| ─┤0 |  |  |  | ACCEPT |
| S23 |  | SHIFT | SHIFT |  |
| b2 |  | REDUCE(2) | REDUCE(2) | REDUCE(2) |

**d)** Rad za `aabcc` (= `(a a b) c c`: `S → a`, `S → a S b`, dva puta `S → S c`):

| # | stek | preostali ulaz | akcija |
|---|---|---|---|
| 1 | ∇ | a a b c c ─┤ | SHIFT |
| 2 | ∇ a12 | a b c c ─┤ | SHIFT |
| 3 | ∇ a12 a12 | b c c ─┤ | REDUCE(1) |
| 4 | ∇ a12 S23 | b c c ─┤ | SHIFT |
| 5 | ∇ a12 S23 b2 | c c ─┤ | REDUCE(2) |
| 6 | ∇ S03 | c c ─┤ | SHIFT |
| 7 | ∇ S03 c3 | c ─┤ | REDUCE(3) |
| 8 | ∇ S03 | c ─┤ | SHIFT |
| 9 | ∇ S03 c3 | ─┤ | REDUCE(3) |
| 10 | ∇ S03 | ─┤ | SHIFT |
| 11 | ∇ S03 ─┤0 |  | ACCEPT |

---

## Rešenje 8: LALR(1) (`S → L = R | R`, `L → * R | id`, `R → L`)

**FIRST/FOLLOW:**

| neterminal | poništiv | FIRST | FOLLOW |
|---|---|---|---|
| S | ne | {*, id} | {─┤} |
| L | ne | {*, id} | {─┤, =} |
| R | ne | {*, id} | {─┤, =} |

**a)** Karakteristični LR(0) automat (11 stanja). Uz potpune konfiguracije je dat i predikcioni skup (vidi c)):

- **∇**: `S' -> • S ─┤`;  `S -> • L = R`;  `S -> • R`;  `L -> • * R`;  `L -> • id`;  `R -> • L`
- **S0**: `S' -> S • ─┤`
- **L15**: `S -> L • = R`;  `R -> L •` LA={─┤}
- **R2**: `S -> R •` LA={─┤}
- ***3**: `L -> • * R`;  `L -> * • R`;  `L -> • id`;  `R -> • L`
- **id4**: `L -> id •` LA={─┤, =}
- **─┤0**: `S' -> S ─┤ •`
- **=1**: `S -> L = • R`;  `L -> • * R`;  `L -> • id`;  `R -> • L`
- **L5**: `R -> L •` LA={─┤, =}
- **R3**: `L -> * R •` LA={─┤, =}
- **R1**: `S -> L = R •` LA={─┤}

Potisna tabela:

| | `S` | `L` | `R` | `=` | `*` | `id` | `─┤` |
|---|---|---|---|---|---|---|---|
| ∇ | S0 | L15 | R2 |  | *3 | id4 |  |
| S0 |  |  |  |  |  |  | ─┤0 |
| L15 |  |  |  | =1 |  |  |  |
| R2 |  |  |  |  |  |  |  |
| *3 |  | L5 | R3 |  | *3 | id4 |  |
| id4 |  |  |  |  |  |  |  |
| ─┤0 |  |  |  |  |  |  |  |
| =1 |  | L5 | R1 |  | *3 | id4 |  |
| L5 |  |  |  |  |  |  |  |
| R3 |  |  |  |  |  |  |  |
| R1 |  |  |  |  |  |  |  |

**b)** SLR(1) kontrolna tabela. Konflikt: L15 / `=`: SHIFT / REDUCE(5). U stanju `L15` (`S → L • = R` i `R → L •`) simbol `=` je u FOLLOW(R) (jer R ⇒ L pa `L = R`), pa su moguće i SHIFT i REDUCE(5). **Gramatika nije SLR(1).**

| | `=` | `*` | `id` | `─┤` |
|---|---|---|---|---|
| ∇ |  | SHIFT | SHIFT |  |
| S0 |  |  |  | SHIFT |
| L15 | SHIFT / REDUCE(5) |  |  | REDUCE(5) |
| R2 |  |  |  | REDUCE(2) |
| *3 |  | SHIFT | SHIFT |  |
| id4 | REDUCE(4) |  |  | REDUCE(4) |
| ─┤0 |  |  |  | ACCEPT |
| =1 |  | SHIFT | SHIFT |  |
| L5 | REDUCE(5) |  |  | REDUCE(5) |
| R3 | REDUCE(3) |  |  | REDUCE(3) |
| R1 |  |  |  | REDUCE(1) |

**c)** Predikcioni skupovi (metod prosleđivanja). U stanju `∇`: `SLA(S → • L = R) = SLA(S → • R) = {─┤}` (iz `S' → • S ─┤`). Zato `SLA(L → • * R) ∋ FIRST(= R) = {=}` i `SLA(L → • id) ∋ {=}`. Veza prosleđivanja (b) vodi od `S → • R` do `R → • L` (iza R je ε), pa `LA(R → • L) = {─┤}`, a dalje od `R → • L` do `L → • * R` i `L → • id` (iza L je ε), pa one dobijaju i `─┤`. Veza (a) po simbolu `L` vodi od `R → • L` do `R → L •` u stanju `L15` (i do `S → L • = R`), pa je `LA(R → L •)` u `L15` = **{─┤}**. U stanjima `*3` i `=1` konfiguracija `R → • L` nasleđuje LA od `L → * • R` odnosno `S → L = • R`, tj. {─┤, =} odnosno {─┤}, pa u stanju `L5` (kuda vodi `L` iz oba stanja) `LA(R → L •) = {─┤, =}`. Dakle u `L15` REDUCE(5) je samo na `─┤`, a na `=` ostaje samo SHIFT. **Gramatika je LALR(1)** (provereno: oba načina računanja LA daju iste skupove).

| | `=` | `*` | `id` | `─┤` |
|---|---|---|---|---|
| ∇ |  | SHIFT | SHIFT |  |
| S0 |  |  |  | SHIFT |
| L15 | SHIFT |  |  | REDUCE(5) |
| R2 |  |  |  | REDUCE(2) |
| *3 |  | SHIFT | SHIFT |  |
| id4 | REDUCE(4) |  |  | REDUCE(4) |
| ─┤0 |  |  |  | ACCEPT |
| =1 |  | SHIFT | SHIFT |  |
| L5 | REDUCE(5) |  |  | REDUCE(5) |
| R3 | REDUCE(3) |  |  | REDUCE(3) |
| R1 |  |  |  | REDUCE(1) |

**d)** Rad za `*id=id`:

| # | stek | preostali ulaz | akcija |
|---|---|---|---|
| 1 | ∇ | * id = id ─┤ | SHIFT |
| 2 | ∇ *3 | id = id ─┤ | SHIFT |
| 3 | ∇ *3 id4 | = id ─┤ | REDUCE(4) |
| 4 | ∇ *3 L5 | = id ─┤ | REDUCE(5) |
| 5 | ∇ *3 R3 | = id ─┤ | REDUCE(3) |
| 6 | ∇ L15 | = id ─┤ | SHIFT |
| 7 | ∇ L15 =1 | id ─┤ | SHIFT |
| 8 | ∇ L15 =1 id4 | ─┤ | REDUCE(4) |
| 9 | ∇ L15 =1 L5 | ─┤ | REDUCE(5) |
| 10 | ∇ L15 =1 R1 | ─┤ | REDUCE(1) |
| 11 | ∇ S0 | ─┤ | SHIFT |
| 12 | ∇ S0 ─┤0 |  | ACCEPT |

---

## Rešenje 9: panic mode (G: `P → P S | S`, `S → id = E ; | { P }`, `E → E + n | n`)

Prvih 12 koraka su normalno parsiranje (`id = n ;` i početak druge naredbe `id = n +`). Greška nastaje u stanju `+5` (`E → E + • n`) na tokenu `{`.

**a) Jednostavan panic mode** (sigurni `;` i `}`). Simbol povrede `{` **nije siguran** (siguran je samo `}`), pa se sa ulaza odbacuju `{ id = n` do prvog sigurnog `;`. Stanje `+5` ne može da potisne `;` (POP), a `E35` može (`;3`), pa se `id = n + ;` pogrešno parsira kao naredba, a `{` je izgubljen. Kasnije stiže `}` (koji zatvara taj izgubljeni `{`), a ni `P01` ni `∇` ne mogu da ga potisnu: skida se ceo stek i **oporavak ne uspeva**.

| # | stek | preostali ulaz | akcija |
|---|---|---|---|
| 1 | ∇ | id = n ; id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 2 | ∇ id3 | = n ; id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 3 | ∇ id3 =3 | n ; id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 4 | ∇ id3 =3 n6 | ; id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | REDUCE(6) E -> n |
| 5 | ∇ id3 =3 E35 | ; id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 6 | ∇ id3 =3 E35 ;3 | id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | REDUCE(3) S -> id = E ; |
| 7 | ∇ S2 | id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | REDUCE(2) P -> S |
| 8 | ∇ P01 | id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 9 | ∇ P01 id3 | = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 10 | ∇ P01 id3 =3 | n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 11 | ∇ P01 id3 =3 n6 | + { id = n ; id = n ; } id = n ; id = n ; ─┤ | REDUCE(6) E -> n |
| 12 | ∇ P01 id3 =3 E35 | + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 13 | ∇ P01 id3 =3 E35 +5 | { id = n ; id = n ; } id = n ; id = n ; ─┤ | GREŠKA: vrh +5, ulaz { |
| 14 | ∇ P01 id3 =3 E35 +5 | id = n ; id = n ; } id = n ; id = n ; ─┤ | odbaci ulaz, sledeći je id |
| 15 | ∇ P01 id3 =3 E35 +5 | = n ; id = n ; } id = n ; id = n ; ─┤ | odbaci ulaz, sledeći je = |
| 16 | ∇ P01 id3 =3 E35 +5 | n ; id = n ; } id = n ; id = n ; ─┤ | odbaci ulaz, sledeći je n |
| 17 | ∇ P01 id3 =3 E35 +5 | ; id = n ; } id = n ; id = n ; ─┤ | odbaci ulaz, sledeći je ; |
| 18 | ∇ P01 id3 =3 E35 +5 | ; id = n ; } id = n ; id = n ; ─┤ | POP |
| 19 | ∇ P01 id3 =3 E35 | ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 20 | ∇ P01 id3 =3 E35 ;3 | id = n ; } id = n ; id = n ; ─┤ | REDUCE(3) S -> id = E ; |
| 21 | ∇ P01 S1 | id = n ; } id = n ; id = n ; ─┤ | REDUCE(1) P -> P S |
| 22 | ∇ P01 | id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 23 | ∇ P01 id3 | = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 24 | ∇ P01 id3 =3 | n ; } id = n ; id = n ; ─┤ | SHIFT |
| 25 | ∇ P01 id3 =3 n6 | ; } id = n ; id = n ; ─┤ | REDUCE(6) E -> n |
| 26 | ∇ P01 id3 =3 E35 | ; } id = n ; id = n ; ─┤ | SHIFT |
| 27 | ∇ P01 id3 =3 E35 ;3 | } id = n ; id = n ; ─┤ | REDUCE(3) S -> id = E ; |
| 28 | ∇ P01 S1 | } id = n ; id = n ; ─┤ | REDUCE(1) P -> P S |
| 29 | ∇ P01 | } id = n ; id = n ; ─┤ | GREŠKA: vrh P01, ulaz } |
| 30 | ∇ P01 | } id = n ; id = n ; ─┤ | POP |
| 31 | ∇ | } id = n ; id = n ; ─┤ | POP |
| 32 | (prazan) | } id = n ; id = n ; ─┤ | neuspeh: stek je prazan |

**b) Poboljšani panic mode** (sigurni `;`, `}`; zaglavlje `{`). Simbol povrede `{` je zaglavlje: potiskuje se na stek i markira, i unutrašnji blok `{ id = n ; id = n ; }` se parsira normalno. Redukcijom `S → { P }` markirani `{` je uklonjen, pa se vraća na korak 1: odbacuju se `id = n` do sigurnog `;` (sledeći simbol u ulazu je `id`), stek se skida (`POP`: `S2`, pa `+5`) do `E35`, koji može da potisne `;`, i parsiranje se normalno završava (ACCEPT):

| # | stek | preostali ulaz | akcija |
|---|---|---|---|
| 1 | ∇ | id = n ; id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 2 | ∇ id3 | = n ; id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 3 | ∇ id3 =3 | n ; id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 4 | ∇ id3 =3 n6 | ; id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | REDUCE(6) E -> n |
| 5 | ∇ id3 =3 E35 | ; id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 6 | ∇ id3 =3 E35 ;3 | id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | REDUCE(3) S -> id = E ; |
| 7 | ∇ S2 | id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | REDUCE(2) P -> S |
| 8 | ∇ P01 | id = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 9 | ∇ P01 id3 | = n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 10 | ∇ P01 id3 =3 | n + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 11 | ∇ P01 id3 =3 n6 | + { id = n ; id = n ; } id = n ; id = n ; ─┤ | REDUCE(6) E -> n |
| 12 | ∇ P01 id3 =3 E35 | + { id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 13 | ∇ P01 id3 =3 E35 +5 | { id = n ; id = n ; } id = n ; id = n ; ─┤ | GREŠKA: vrh +5, ulaz { |
| 14 | ∇ P01 id3 =3 E35 +5 {4 | id = n ; id = n ; } id = n ; id = n ; ─┤ | PUSH header { (markiran) |
| 15 | ∇ P01 id3 =3 E35 +5 {4 | id = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 16 | ∇ P01 id3 =3 E35 +5 {4 id3 | = n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 17 | ∇ P01 id3 =3 E35 +5 {4 id3 =3 | n ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 18 | ∇ P01 id3 =3 E35 +5 {4 id3 =3 n6 | ; id = n ; } id = n ; id = n ; ─┤ | REDUCE(6) E -> n |
| 19 | ∇ P01 id3 =3 E35 +5 {4 id3 =3 E35 | ; id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 20 | ∇ P01 id3 =3 E35 +5 {4 id3 =3 E35 ;3 | id = n ; } id = n ; id = n ; ─┤ | REDUCE(3) S -> id = E ; |
| 21 | ∇ P01 id3 =3 E35 +5 {4 S2 | id = n ; } id = n ; id = n ; ─┤ | REDUCE(2) P -> S |
| 22 | ∇ P01 id3 =3 E35 +5 {4 P14 | id = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 23 | ∇ P01 id3 =3 E35 +5 {4 P14 id3 | = n ; } id = n ; id = n ; ─┤ | SHIFT |
| 24 | ∇ P01 id3 =3 E35 +5 {4 P14 id3 =3 | n ; } id = n ; id = n ; ─┤ | SHIFT |
| 25 | ∇ P01 id3 =3 E35 +5 {4 P14 id3 =3 n6 | ; } id = n ; id = n ; ─┤ | REDUCE(6) E -> n |
| 26 | ∇ P01 id3 =3 E35 +5 {4 P14 id3 =3 E35 | ; } id = n ; id = n ; ─┤ | SHIFT |
| 27 | ∇ P01 id3 =3 E35 +5 {4 P14 id3 =3 E35 ;3 | } id = n ; id = n ; ─┤ | REDUCE(3) S -> id = E ; |
| 28 | ∇ P01 id3 =3 E35 +5 {4 P14 S1 | } id = n ; id = n ; ─┤ | REDUCE(1) P -> P S |
| 29 | ∇ P01 id3 =3 E35 +5 {4 P14 | } id = n ; id = n ; ─┤ | SHIFT |
| 30 | ∇ P01 id3 =3 E35 +5 {4 P14 }4 | id = n ; id = n ; ─┤ | REDUCE(4) S -> { P } |
| 31 | ∇ P01 id3 =3 E35 +5 S2 | id = n ; id = n ; ─┤ | markirani header uklonjen redukcijom -> ponovo korak (1) |
| 32 | ∇ P01 id3 =3 E35 +5 S2 | = n ; id = n ; ─┤ | odbaci ulaz, sledeći je = |
| 33 | ∇ P01 id3 =3 E35 +5 S2 | n ; id = n ; ─┤ | odbaci ulaz, sledeći je n |
| 34 | ∇ P01 id3 =3 E35 +5 S2 | ; id = n ; ─┤ | odbaci ulaz, sledeći je ; |
| 35 | ∇ P01 id3 =3 E35 +5 S2 | ; id = n ; ─┤ | POP |
| 36 | ∇ P01 id3 =3 E35 +5 | ; id = n ; ─┤ | POP |
| 37 | ∇ P01 id3 =3 E35 | ; id = n ; ─┤ | SHIFT |
| 38 | ∇ P01 id3 =3 E35 ;3 | id = n ; ─┤ | REDUCE(3) S -> id = E ; |
| 39 | ∇ P01 S1 | id = n ; ─┤ | REDUCE(1) P -> P S |
| 40 | ∇ P01 | id = n ; ─┤ | SHIFT |
| 41 | ∇ P01 id3 | = n ; ─┤ | SHIFT |
| 42 | ∇ P01 id3 =3 | n ; ─┤ | SHIFT |
| 43 | ∇ P01 id3 =3 n6 | ; ─┤ | REDUCE(6) E -> n |
| 44 | ∇ P01 id3 =3 E35 | ; ─┤ | SHIFT |
| 45 | ∇ P01 id3 =3 E35 ;3 | ─┤ | REDUCE(3) S -> id = E ; |
| 46 | ∇ P01 S1 | ─┤ | REDUCE(1) P -> P S |
| 47 | ∇ P01 | ─┤ | SHIFT |
| 48 | ∇ P01 ─┤0 |  | ACCEPT |

---

## Rešenje 10: LL(1) transformacija i rekurzivni spust

**a)** Poništivih neterminala nema.

| neterminal | poništiv | FIRST | FOLLOW |
|---|---|---|---|
| P | ne | {id, print} | {─┤, ;} |
| I | ne | {id, print} | {─┤, ;} |
| E | ne | {id, n} | {), +, ─┤, ;} |
| T | ne | {id, n} | {), +, ─┤, ;} |

Nije LL(1): smene 1 i 2: {id, print}, smene 3 i 4: {id}, smene 6 i 7: {id, n} (smene 1 i 2 imaju levu rekurziju, 3 i 4 imaju zajednički prefiks `id`, 6 i 7 imaju levu rekurziju).

**b)** Leva rekurzija po `P` (α = `; I`, β = `I`): `P → I P'`, `P' → ; I P' | ε`. Po `E` (α = `+ T`, β = `T`): `E → T E'`, `E' → + T E' | ε`. Leva faktorizacija `I → id := E | id ( E )` (prefiks `id`): `I → id I'`, `I' → := E | ( E )`. Rezultat (u tabelama `P'`, `I'`, `E'` su zapisani kao `P1`, `I1`, `E1`; jezik proveren nabrajanjem: isti skup od 74 reči do dužine 7):

1. P → I P1
2. P1 → ; I P1
3. P1 → ε
4. I → id I1
5. I → print E
6. I1 → := E
7. I1 → ( E )
8. E → T E1
9. E1 → + T E1
10. E1 → ε
11. T → id
12. T → n

**c)**

| neterminal | poništiv | FIRST | FOLLOW |
|---|---|---|---|
| P | ne | {id, print} | {─┤} |
| P1 | da | {;} | {─┤} |
| I | ne | {id, print} | {─┤, ;} |
| I1 | ne | {(, :=} | {─┤, ;} |
| E | ne | {id, n} | {), ─┤, ;} |
| E1 | da | {+} | {), ─┤, ;} |
| T | ne | {id, n} | {), +, ─┤, ;} |

| # | smena | SELECT |
|---|---|---|
| 1 | P → I P1 | {id, print} |
| 2 | P1 → ; I P1 | {;} |
| 3 | P1 → ε | {─┤} |
| 4 | I → id I1 | {id} |
| 5 | I → print E | {print} |
| 6 | I1 → := E | {:=} |
| 7 | I1 → ( E ) | {(} |
| 8 | E → T E1 | {id, n} |
| 9 | E1 → + T E1 | {+} |
| 10 | E1 → ε | {), ─┤, ;} |
| 11 | T → id | {id} |
| 12 | T → n | {n} |

SELECT skupovi smena istog neterminala su disjunktni (npr. `P1`: {;} i {─┤}; `E1`: {+} i {;, ), ─┤}; `I1`: {:=} i {(}), **gramatika je LL(1)**.

**d)** Rekurzivni spust za `I` i `I'` (u pseudokodu kursa; `IN` je tekući ulaz):

```
procedure PROC_I:
   case IN of
      'id':    IN = NEXTCHAR(); call PROC_I1; return;         /* I → id I' */
      'print': IN = NEXTCHAR(); call PROC_E;  return;         /* I → print E */
      default: REJECT;
   end case;
end procedure;

procedure PROC_I1:
   case IN of
      ':=': IN = NEXTCHAR(); call PROC_E; return;             /* I' → := E */
      '(':  IN = NEXTCHAR(); call PROC_E;                     /* I' → ( E ) */
            if IN = ')' then IN = NEXTCHAR(); return; else REJECT; end if;
      default: REJECT;
   end case;
end procedure;
```

Pun parser u Javi (kompajliran, testiran na 541 ulaza: 146 ispravnih i 395 neispravnih, poklapa se sa gramatikom):

```java
import java.util.*;
import java.nio.file.*;

public class RD10 {
    // LL(1) gramatika (tokeni: id := ( ) print + ; n); ─┤ je END
    //   P  -> I P'           P' -> ; I P' | ε
    //   I  -> id I' | print E        I' -> := E | ( E )
    //   E  -> T E'           E' -> + T E' | ε
    //   T  -> id | n
    static String[] tok; static int pos; static String cur;
    static final String END = "$";
    static void advance() { cur = pos < tok.length ? tok[pos++] : END; }
    static void error() { throw new RuntimeException("REJECT"); }
    static void terminal(String t) { if (cur.equals(t)) advance(); else error(); }

    static void P()  { switch (cur) { case "id": case "print": I(); Pp(); break; default: error(); } }
    static void Pp() { switch (cur) { case ";": terminal(";"); I(); Pp(); break;
                                      case END: break;                       // ε: FOLLOW(P') = {─┤}
                                      default: error(); } }
    static void I()  { switch (cur) { case "id": terminal("id"); Ip(); break;
                                      case "print": terminal("print"); E(); break;
                                      default: error(); } }
    static void Ip() { switch (cur) { case ":=": terminal(":="); E(); break;
                                      case "(": terminal("("); E(); terminal(")"); break;
                                      default: error(); } }
    static void E()  { switch (cur) { case "id": case "n": T(); Ep(); break; default: error(); } }
    static void Ep() { switch (cur) { case "+": terminal("+"); T(); Ep(); break;
                                      case ";": case ")": case END: break;   // ε: FOLLOW(E') = {;, ), ─┤}
                                      default: error(); } }
    static void T()  { switch (cur) { case "id": terminal("id"); break;
                                      case "n": terminal("n"); break;
                                      default: error(); } }
    static boolean parse(String s) {
        tok = s.trim().isEmpty() ? new String[0] : s.trim().split(" "); pos = 0; advance();
        try { P(); if (!cur.equals(END)) error(); return true; } catch (RuntimeException e) { return false; }
    }
    // (testni main koji poredi parser sa gramatikom je izostavljen)
}
```

---

## Rešenje 11: konačni procesor za celobrojne konstante

**a)** Registri: `V` (vrednost, početno 0), `S` (znak, početno +1). Stanja: **A** start; **B** iza znaka; **C** iza nule; **D** dekadne cifre; **E** iza `0x` (očekuje se bar jedna heksadecimalna cifra); **F** heksadecimalne cifre. Prihvatajuća su C, D, F na `─┤`. Prazna polja su greške (npr. vodeća nula `012`, `0x` bez cifara, dva znaka).

| stanje | `SIGN` | `ZERO` | `DEC` | `X` | `HEX` | `─┤` |
|---|---|---|---|---|---|---|
| → A | `S := ±1`, → B | `V := 0`, → C | `V := val(c)`, → D | | | |
| B | | `V := 0`, → C | `V := val(c)`, → D | | | |
| C | | | | → E | | `V := S·V`, ACCEPT |
| D | | `V := 10·V + val(c)` | `V := 10·V + val(c)` | | | `V := S·V`, ACCEPT |
| E | | `V := val(c)`, → F | `V := val(c)`, → F | | `V := val(c)`, → F | |
| F | | `V := 16·V + val(c)` | `V := 16·V + val(c)` | | `V := 16·V + val(c)` | `V := S·V`, ACCEPT |

(`val` daje vrednost cifre; za `a`–`f`, `A`–`F` to je 10–15; `S := ±1` znači +1 za `+` i −1 za `-`.) Proverio sam na svim rečima nad azbukom `+ - 0 1 5 9 x a F` do dužine 7 da procesor prihvata tačno reči izraza i za svih 37014 ispravnih računa tačnu vrednost.

**b)** Rad za `-0x1F` (rezultat −31):

| stanje | ulaz | akcija | S | V |
|---|---|---|---|---|
| A | - | S := ±1 | -1 | 0 |
| B | 0 | V := 0 | -1 | 0 |
| C | x | – | -1 | 0 |
| E | 1 | V := val(c) | -1 | 1 |
| F | F | V := 16·V + val(c) | -1 | 31 |
| F | ─┤ | V := S·V | -1 | -31 |

**c)** Projektni uzorak State: interfejs `State { boolean accepting(); void handleInput(ConstFSM f, char ch); }`, po jedna klasa (ili anonimna klasa) za svako stanje A–F, plus `ACCEPT` (prihvata) i `ERROR`; kontekst `ConstFSM` čuva registre `v`, `s` i tekuće stanje (`setState`). Stanje F (kompajlirano u kompletnom programu zajedno sa ostalim stanjima; testirano na `-0x1F` → −31, `+305` → 305, `0xAbC` → 2748, `0x`, `012`, `+-1` se odbijaju):

```java
final State F = new State() {                // heksadecimalne cifre
    public boolean accepting() { return false; }
    public void handleInput(ConstFSM f, char ch) {
        if (isHex(ch)) f.v = f.v * 16 + val(ch);                  // ZERO, DEC ili HEX
        else if (ch == END) { f.v = f.s * f.v; f.setState(f.ACCEPT); }
        else f.setState(f.ERROR);
    } };
```

---

## Rešenje 12: suvišni neterminali, automat ↔ gramatika, višeznačnost

**a)** Prvo mrtvi: `A` (A → b), `D` (D → e) i `S` (S → a A), `E` (E → A D) su živi. `B` (B → B d | C, C → c C) i `C` nikad ne izvode terminalni niz: **mrtvi su B i C**. Izbacuju se smene 2, 6, 7, 8 (sve u kojima se B ili C pojavljuje):

```
S → a A
S → A c
A → a A
A → b
D → d D
D → e
E → A D
E → S
```

Zatim dostižni iz `S` (na gramatici bez mrtvih): S → A, A → A, pa su dostižni {A, S}. Neterminali D, E **nisu dostižni** (nijedna preostala smena za S i A ih ne sadrži): **nedostižni su D, E**. Rezultat:

```
S → a A
S → A c
A → a A
A → b
```

Redosled: prvo mrtvi, pa nedostižni. Da se prvo traži dostižnost, `D` bi pogrešno ostao (dostižan je preko smene `S → B D`, ali ta smena sadrži mrtvo `B` i izbacuje se), a tek bi `E` otpao. Jezik je isti (proveren nabrajanjem do dužine 8).

**b)** `S → a b T | c`, `T → S | d T | ε`. Pravilo 2: `S → a b T` postaje `S → a X`, `X → b T`. Pravilo 1: `S → c` postaje `S → c E`, `E → ε`. Pravilo 3: `T → S` zamenjujemo desnim stranama smena za `S`: `T → a X | c E`. Regularna gramatika:

```
S → a X | c E        X → b T
T → a X | c E | d T | ε        E → ε
```

NKA: stanja S, X, T, E; startno S; prelazi S –a→ X, S –c→ E, X –b→ T, T –a→ X, T –c→ E, T –d→ T; prihvataju T i E. (Provereno: gramatika polazna i regularna generišu iste reči, a NKA prihvata iste reči: 88 reči do dužine 9.)

**c)** `id + id * id` ima dva stabla: `(id + id) * id` i `id + (id * id)` (proveren brojač: 2). Nedvosmislena gramatika (levo asocijativno, `*` veće prioriteta):

```
E → E + T | T
T → T * F | F
F → ( E ) | id
```

(isti niz ima tačno 1 stablo).
