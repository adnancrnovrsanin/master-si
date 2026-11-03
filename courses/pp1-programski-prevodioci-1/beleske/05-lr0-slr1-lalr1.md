# 05. Parsiranje od dna ka vrhu: LR(0), SLR(1), LALR(1)

**Izvor:** `PP1_P05.pdf` (strane PDF-a: shift-reduce parser kao potisni automat str. 7–18, LR(0) konfiguracije i karakteristični automat str. 19–36, konflikti str. 38–40), `PP1_P06.pdf` (poništivost/FIRST/FOLLOW str. 3–7, SLR(1) str. 2 i 8–9, LALR(1): LR(1) konfiguracije, SLA i veze prosleđivanja str. 10–19, odnos klasa str. 20), `PP1_P06a.pdf` (oporavak, beleška 06), udžbenik `pp1_udzbenik.pdf` str. 78–105, vežbe `BottomUp.doc` (Zadaci 1–10), Zbirka 4.2 (konfiguracioni pristup).

**Razlika notacije (važno):** u slajdovima P05/P06 se `─┤` prvo SHIFT-uje pa se ACCEPT upisuje u stanju `─┤0` (konfiguracija `S' → S ─┤ •`). U `BottomUp.doc` (LALR zadaci) se na nekim mestima ACCEPT piše već u stanju `S0` (konfiguracija `S' → S • ─┤`) u koloni `─┤`. Oba načina prihvataju iste reči. Ovde se koristi varijanta sa slajdova (`─┤0`). Isto važi za imena simbola steka: kurs koristi **simbol + brojevi smena** čija konfiguracija ima tačku iza tog simbola (`S2`, `a1`, `(2`, `id12`); kad dva stanja dobiju isto ime, ovde dodajem `'` (kurs piše `x`, npr. `a_x`).

## 1. Definicije (2–3 rečenice)

- **LR(0) konfiguracija** (item) je smena sa tačkom na desnoj strani, npr. `S → ( • S R`. Konfiguracije sa tačkom na početku su **zatvaranja**, ostale **bazične** (jezgro). Za praznu smenu `X → ε` postoji jedna konfiguracija `X → •`. Gramatika se proširuje smenom **0. S' → S ─┤**.
- **Karakteristični automat** (detektor ručki) ima stanja = skupove konfiguracija i prelaze po gramatičkim simbolima; on je ujedno **potisna tabela** parsera. **Kontrolna tabela** (vrste = stanja, kolone = ulazni simboli) određuje akciju: `SHIFT` (`PUSH(potisna[vrh, ulaz])`, `ADVANCE`), `REDUCE(A → γ)` (|γ| puta `POP`, pa `PUSH(potisna[vrh, A])`, `RETAIN`), `ACCEPT`, `REJECT`.
- **LR(0)** ne gleda ulaz (jedna akcija po vrsti), **SLR(1)** redukuje samo ako je ulaz u FOLLOW leve strane, **LALR(1)** redukuje samo ako je ulaz u precizniji predikcioni (lookahead) skup te konfiguracije. Odnos: LR(0) ⊂ SLR(1) ⊂ LALR(1) ⊂ LR(1) ⊂ sve KS; generatori yacc/CUP prave LALR(1).

## 2. Algoritmi korak po korak

### 2.1 Karakteristični LR(0) automat

1. Numeriši smene i proširi gramatiku: `0. S' → S ─┤`.
2. `Closure0(I)`: dok u `I` postoji konfiguracija `A → α • B β` (B neterminal), dodaj sve `B → • γ`.
3. `Goto0(I, X)` = `Closure0({ A → α X • β | A → α • X β ∈ I })`.
4. Startno stanje `Closure0({S' → • S ─┤})`. Za svako stanje i svaki simbol `X` iza tačke izračunaj `Goto0`; **ako skup već postoji, to je isto stanje** (npr. `(2 –(→ (2`). Ponavljaj dok se ne pojave novi skupovi.
5. Imenovanje (kurs): stanje se zove **simbol kojim se ulazi + brojevi smena** čija konfiguracija ima tačku odmah iza tog simbola. Početno stanje je `∇` (dno steka).
6. **Potisna tabela** = automat: vrste su stanja (uključujući `∇`), kolone simboli gramatike (neterminali i terminali, i `─┤`); ćelija je stanje u koje se prelazi.

### 2.2 Kontrolne tabele

Za ćeliju (vrsta = stanje S, kolona x):

- **SHIFT** ako S ima `A → α • x β` (tačka ispred terminala x). Za `S' → S • ─┤` kolona `─┤` je SHIFT, a stanje `─┤0` (`S' → S ─┤ •`) daje **ACCEPT**.
- **LR(0)**: ako S ima `A → γ •` (A ≠ S'), celu vrstu popuni sa `REDUCE(A → γ)`.
- **SLR(1)**: `REDUCE(A → γ)` samo u kolonama x ∈ **FOLLOW(A)**.
- **LALR(1)**: `REDUCE(A → γ)` samo u kolonama x ∈ **LA(A → γ •)** u tom stanju.
- Sve ostalo je `REJECT`. Ako neka ćelija ima dve akcije: **konflikt** (shift/reduce ili reduce/reduce) i gramatika nije u toj klasi. Prazne smene `X → ε` prave konflikt u LR(0) (konfiguracija `X → •` je potpuna, a u istom stanju obično postoje i konfiguracije za pomeranje; slajd 39: "LR(0) ne dozvoljava prazne smene").

FOLLOW (PP1_P06 str. 3–7): poništivi neterminali (leve strane ε-smena, pa smene čije su desne strane sve poništive); FIRST(X) iterativno (`FIRST(A)` ⊇ `FIRST(α)` za A → α, gde se FIRST niza uzima do prvog neporništivog simbola); FOLLOW: `FOLLOW(S) ∋ ─┤`; za smenu `Y → α X β`: `FOLLOW(X) ⊇ FIRST(β)`, a ako je β poništivo još i `FOLLOW(X) ⊇ FOLLOW(Y)`. Iteriraj do fiksne tačke.

### 2.3 LALR(1): predikcioni (LA) skupovi metodom prosleđivanja

1. Konstruiši LR(0) automat.
2. **SLA** (spontani): za svaku konfiguraciju zatvaranja `B → • γ` u stanju s nađi sve konfiguracije `A → α • B β` u istom stanju; `SLA(B → • γ) ⊇ FIRST(β)` (samo terminali). Za `S' → • S ─┤`: `SLA(S → • γ) ∋ ─┤`.
3. **Veze prosleđivanja** (dve vrste): (a) `A → α • X β` ⇒ `A → α X • β` u stanju u koje se prelazi po X; (b) `A → α • B β`, β poništivo ⇒ `B → • γ` u istom stanju.
4. Inicijalno LA = SLA za konfiguracije zatvaranja, prazan za ostale (konfiguracija `S' → • S ─┤` ima samo oznaku ε i ne utiče na tabelu). Prosleđuj simbole duž veza dok ima promena.
5. Kontrolna tabela: `REDUCE(A → γ)` u koloni x ako je x ∈ LA(`A → γ •`); SHIFT/ACCEPT isto kao ranije.
6. Uvek važi `LA ⊆ FOLLOW(leva strana)`. LALR rešava one SLR konflikte koji nastaju jer FOLLOW sakupi sve kontekste. Isti automat (isti broj stanja) kao SLR, samo preciznije REDUCE.

(Skripta: LA skupove sam računao standardno (LR(1) pa spajanje po jezgru) i poredio sa metodom prosleđivanja na svim konfiguracijama svih stanja u primerima ispod. Poklapanje je potpuno.)

### 2.4 Rad parsera i panic mode

Stek počinje sa `∇`. U svakom koraku uzmi vrh steka i tekući ulaz: `SHIFT` (stavi stanje iz potisne tabele, napreduj), `REDUCE(A → γ)` (skini |γ| stanja, stavi stanje iz potisne tabele za (novi vrh, A), ulaz ostaje), `ACCEPT`, `REJECT`. Oporavak od grešaka je u beleški 06.

## 3. Primeri (sve tabele generisane i provereno skriptom)

### 3.1 LR(0) i SLR(1): gramatika sa predavanja

0. S' → S -|
1. S → a
2. S → ( S R
3. R → , S R
4. R → )

FIRST/FOLLOW:

| neterminal | poništiv | FIRST | FOLLOW |
|---|---|---|---|
| S | ne | {(, a} | {), ,, ─┤} |
| R | ne | {), ,} | {), ,, ─┤} |

Stanja (karakteristični automat):

- **∇**: `S' -> • S ─┤`;  `S -> • a`;  `S -> • ( S R`
- **S0**: `S' -> S • ─┤`
- **a1**: `S -> a •`
- **(2**: `S -> • a`;  `S -> • ( S R`;  `S -> ( • S R`
- **─┤0**: `S' -> S ─┤ •`
- **S2**: `S -> ( S • R`;  `R -> • , S R`;  `R -> • )`
- **R2**: `S -> ( S R •`
- **,3**: `S -> • a`;  `S -> • ( S R`;  `R -> , • S R`
- **)4**: `R -> ) •`
- **S3**: `R -> • , S R`;  `R -> , S • R`;  `R -> • )`
- **R3**: `R -> , S R •`

Potisna tabela (= automat):

| | `S` | `R` | `a` | `(` | `,` | `)` | `─┤` |
|---|---|---|---|---|---|---|---|
| ∇ | S0 |  | a1 | (2 |  |  |  |
| S0 |  |  |  |  |  |  | ─┤0 |
| a1 |  |  |  |  |  |  |  |
| (2 | S2 |  | a1 | (2 |  |  |  |
| ─┤0 |  |  |  |  |  |  |  |
| S2 |  | R2 |  |  | ,3 | )4 |  |
| R2 |  |  |  |  |  |  |  |
| ,3 | S3 |  | a1 | (2 |  |  |  |
| )4 |  |  |  |  |  |  |  |
| S3 |  | R3 |  |  | ,3 | )4 |  |
| R3 |  |  |  |  |  |  |  |

LR(0) kontrolna tabela (nema konflikata, gramatika je LR(0)):

| | akcija |
|---|---|
| ∇ | SHIFT |
| S0 | SHIFT |
| a1 | REDUCE(1) |
| (2 | SHIFT |
| ─┤0 | ACCEPT |
| S2 | SHIFT |
| R2 | REDUCE(2) |
| ,3 | SHIFT |
| )4 | REDUCE(4) |
| S3 | SHIFT |
| R3 | REDUCE(3) |

SLR(1) kontrolna tabela (nema konflikata):

| | `a` | `(` | `,` | `)` | `─┤` |
|---|---|---|---|---|---|
| ∇ | SHIFT | SHIFT |  |  |  |
| S0 |  |  |  |  | SHIFT |
| a1 |  |  | REDUCE(1) | REDUCE(1) | REDUCE(1) |
| (2 | SHIFT | SHIFT |  |  |  |
| ─┤0 |  |  |  |  | ACCEPT |
| S2 |  |  | SHIFT | SHIFT |  |
| R2 |  |  | REDUCE(2) | REDUCE(2) | REDUCE(2) |
| ,3 | SHIFT | SHIFT |  |  |  |
| )4 |  |  | REDUCE(4) | REDUCE(4) | REDUCE(4) |
| S3 |  |  | SHIFT | SHIFT |  |
| R3 |  |  | REDUCE(3) | REDUCE(3) | REDUCE(3) |

Rad SLR(1) parsera za `(a,(a))`:

| # | stek | preostali ulaz | akcija |
|---|---|---|---|
| 1 | ∇ | ( a , ( a ) ) ─┤ | SHIFT |
| 2 | ∇ (2 | a , ( a ) ) ─┤ | SHIFT |
| 3 | ∇ (2 a1 | , ( a ) ) ─┤ | REDUCE(1) |
| 4 | ∇ (2 S2 | , ( a ) ) ─┤ | SHIFT |
| 5 | ∇ (2 S2 ,3 | ( a ) ) ─┤ | SHIFT |
| 6 | ∇ (2 S2 ,3 (2 | a ) ) ─┤ | SHIFT |
| 7 | ∇ (2 S2 ,3 (2 a1 | ) ) ─┤ | REDUCE(1) |
| 8 | ∇ (2 S2 ,3 (2 S2 | ) ) ─┤ | SHIFT |
| 9 | ∇ (2 S2 ,3 (2 S2 )4 | ) ─┤ | REDUCE(4) |
| 10 | ∇ (2 S2 ,3 (2 S2 R2 | ) ─┤ | REDUCE(2) |
| 11 | ∇ (2 S2 ,3 S3 | ) ─┤ | SHIFT |
| 12 | ∇ (2 S2 ,3 S3 )4 | ─┤ | REDUCE(4) |
| 13 | ∇ (2 S2 ,3 S3 R3 | ─┤ | REDUCE(3) |
| 14 | ∇ (2 S2 R2 | ─┤ | REDUCE(2) |
| 15 | ∇ S0 | ─┤ | SHIFT |
| 16 | ∇ S0 ─┤0 |  | ACCEPT |

### 3.2 Gramatika koja nije SLR(1), ali jeste LALR(1) (PP1_P06 str. 10)

0. S' → S -|
1. S → A a
2. S → b c A c
3. A → b

| neterminal | poništiv | FIRST | FOLLOW |
|---|---|---|---|
| S | ne | {b} | {─┤} |
| A | ne | {b} | {a, c} |

Automat sa LA skupovima na potpunim konfiguracijama (jezgro `b23` je stanje posle `b` iz ∇ i sadrži `S → b • c A c` i `A → b •`):

- **∇**: `S' -> • S ─┤`;  `S -> • A a`;  `S -> • b c A c`;  `A -> • b`
- **S0**: `S' -> S • ─┤`
- **A1**: `S -> A • a`
- **b23**: `S -> b • c A c`;  `A -> b •` LA={a}
- **─┤0**: `S' -> S ─┤ •`
- **a1**: `S -> A a •` LA={─┤}
- **c2**: `S -> b c • A c`;  `A -> • b`
- **A2**: `S -> b c A • c`
- **b3**: `A -> b •` LA={c}
- **c2'**: `S -> b c A c •` LA={─┤}

**SLA i veze:** u `∇`: `SLA(A → • b) = FIRST(a) = {a}` (jer je `A` u `S → • A a`), pa veza (a) prosleđuje `a` u konfiguraciju `A → b •` u stanju `b23`. U stanju `c2` (`S → b c • A c`): `SLA(A → • b) = FIRST(c) = {c}`, pa `A → b •` u stanju `b3` dobija `{c}`. Zato je **LA(`A → b •`) u stanju `b23` = {a}**, a u `b3` = {c}.

SLR(1): `FOLLOW(A) = {a, c}`, pa u stanju `b23` kolona `c` ima i SHIFT (iz `S → b • c A c`) i REDUCE(3): konflikt (b23 / `c`: SHIFT / REDUCE(3)).

| | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|
| ∇ |  | SHIFT |  |  |
| S0 |  |  |  | SHIFT |
| A1 | SHIFT |  |  |  |
| b23 | REDUCE(3) |  | SHIFT / REDUCE(3) |  |
| ─┤0 |  |  |  | ACCEPT |
| a1 |  |  |  | REDUCE(1) |
| c2 |  | SHIFT |  |  |
| A2 |  |  | SHIFT |  |
| b3 | REDUCE(3) |  | REDUCE(3) |  |
| c2' |  |  |  | REDUCE(2) |

LALR(1): u `b23` REDUCE(3) samo u koloni `a` (LA = {a}), pa konflikta nema:

| | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|
| ∇ |  | SHIFT |  |  |
| S0 |  |  |  | SHIFT |
| A1 | SHIFT |  |  |  |
| b23 | REDUCE(3) |  | SHIFT |  |
| ─┤0 |  |  |  | ACCEPT |
| a1 |  |  |  | REDUCE(1) |
| c2 |  | SHIFT |  |  |
| A2 |  |  | SHIFT |  |
| b3 |  |  | REDUCE(3) |  |
| c2' |  |  |  | REDUCE(2) |

Rad LALR(1) parsera za `bcbc`:

| # | stek | preostali ulaz | akcija |
|---|---|---|---|
| 1 | ∇ | b c b c ─┤ | SHIFT |
| 2 | ∇ b23 | c b c ─┤ | SHIFT |
| 3 | ∇ b23 c2 | b c ─┤ | SHIFT |
| 4 | ∇ b23 c2 b3 | c ─┤ | REDUCE(3) |
| 5 | ∇ b23 c2 A2 | c ─┤ | SHIFT |
| 6 | ∇ b23 c2 A2 c2' | ─┤ | REDUCE(2) |
| 7 | ∇ S0 | ─┤ | SHIFT |
| 8 | ∇ S0 ─┤0 |  | ACCEPT |

### 3.3 LALR(1) za K 26.11.2021, zadatak 3: `S → A A`, `A → A a A b | c | d`

0. S' → S -|
1. S → A A
2. A → A a A b
3. A → c
4. A → d

| neterminal | poništiv | FIRST | FOLLOW |
|---|---|---|---|
| S | ne | {c, d} | {─┤} |
| A | ne | {c, d} | {─┤, a, b, c, d} |

Stanja sa LA skupovima (prikazani su samo za potpune konfiguracije):

- **∇**: `S' -> • S ─┤`;  `S -> • A A`;  `A -> • A a A b`;  `A -> • c`;  `A -> • d`
- **S0**: `S' -> S • ─┤`
- **A12**: `S -> A • A`;  `A -> • A a A b`;  `A -> A • a A b`;  `A -> • c`;  `A -> • d`
- **c3**: `A -> c •` LA={─┤, a, b, c, d}
- **d4**: `A -> d •` LA={─┤, a, b, c, d}
- **─┤0**: `S' -> S ─┤ •`
- **A12'**: `S -> A A •` LA={─┤};  `A -> A • a A b`
- **a2**: `A -> • A a A b`;  `A -> A a • A b`;  `A -> • c`;  `A -> • d`
- **A2**: `A -> A • a A b`;  `A -> A a A • b`
- **b2**: `A -> A a A b •` LA={─┤, a, b, c, d}

Kontrolna LALR(1) tabela (nema konflikata). Ova gramatika je i SLR(1) (isti sadržaj tabele), jer su LA skupovi jednaki FOLLOW skupovima (`A → c •`, `A → d •`, `A → A a A b •`: FOLLOW(A) = {─┤, a, b, c, d}; `S → A A •`: {─┤}). U LR(0) tabeli postoji konflikt u stanju `A12'` na ulazu `a` (SHIFT / REDUCE(1)), koji FOLLOW(S) = {─┤} rešava.

| | `a` | `b` | `c` | `d` | `─┤` |
|---|---|---|---|---|---|
| ∇ |  |  | SHIFT | SHIFT |  |
| S0 |  |  |  |  | SHIFT |
| A12 | SHIFT |  | SHIFT | SHIFT |  |
| c3 | REDUCE(3) | REDUCE(3) | REDUCE(3) | REDUCE(3) | REDUCE(3) |
| d4 | REDUCE(4) | REDUCE(4) | REDUCE(4) | REDUCE(4) | REDUCE(4) |
| ─┤0 |  |  |  |  | ACCEPT |
| A12' | SHIFT |  |  |  | REDUCE(1) |
| a2 |  |  | SHIFT | SHIFT |  |
| A2 | SHIFT | SHIFT |  |  |  |
| b2 | REDUCE(2) | REDUCE(2) | REDUCE(2) | REDUCE(2) | REDUCE(2) |

Potisna tabela (na K se **ne** crta, ali je deo automata):

| | `S` | `A` | `a` | `b` | `c` | `d` | `─┤` |
|---|---|---|---|---|---|---|---|
| ∇ | S0 | A12 |  |  | c3 | d4 |  |
| S0 |  |  |  |  |  |  | ─┤0 |
| A12 |  | A12' | a2 |  | c3 | d4 |  |
| c3 |  |  |  |  |  |  |  |
| d4 |  |  |  |  |  |  |  |
| ─┤0 |  |  |  |  |  |  |  |
| A12' |  |  | a2 |  |  |  |  |
| a2 |  | A2 |  |  | c3 | d4 |  |
| A2 |  |  | a2 | b2 |  |  |  |
| b2 |  |  |  |  |  |  |  |

Rad parsera za `cadbd` (prvi `A` je `c a d b`, drugi `A` je `d`):

| # | stek | preostali ulaz | akcija |
|---|---|---|---|
| 1 | ∇ | c a d b d ─┤ | SHIFT |
| 2 | ∇ c3 | a d b d ─┤ | REDUCE(3) |
| 3 | ∇ A12 | a d b d ─┤ | SHIFT |
| 4 | ∇ A12 a2 | d b d ─┤ | SHIFT |
| 5 | ∇ A12 a2 d4 | b d ─┤ | REDUCE(4) |
| 6 | ∇ A12 a2 A2 | b d ─┤ | SHIFT |
| 7 | ∇ A12 a2 A2 b2 | d ─┤ | REDUCE(2) |
| 8 | ∇ A12 | d ─┤ | SHIFT |
| 9 | ∇ A12 d4 | ─┤ | REDUCE(4) |
| 10 | ∇ A12 A12' | ─┤ | REDUCE(1) |
| 11 | ∇ S0 | ─┤ | SHIFT |
| 12 | ∇ S0 ─┤0 |  | ACCEPT |

Panic mode nad ovom gramatikom je u beleški 06.

### 3.4 Rekonstrukcija LR(0) parsera iz tabela (K 22.11.2019, zadatak 1)

Zadate su potisna i kontrolna LR(0) tabela (ovde u mojim imenima stanja, kurs u K koristi `E_x1`, `id_x` i sl.). Tražilo se: a) automat sa konfiguracijama, b) gramatika, c) FOLLOW i SLR(1) tabela.

| | `E` | `id` | `(` | `)` | `+` | `─┤` |
|---|---|---|---|---|---|---|
| ∇ | E03 | id12 |  |  |  |  |
| E03 |  |  |  |  | +3 | ─┤0 |
| id12 |  |  | (2 |  |  |  |
| +3 |  | id3 |  |  |  |  |
| ─┤0 |  |  |  |  |  |  |
| (2 | E23 | id12 |  |  |  |  |
| id3 |  |  |  |  |  |  |
| E23 |  |  |  | )2 | +3 |  |
| )2 |  |  |  |  |  |  |

| | akcija |
|---|---|
| ∇ | SHIFT |
| E03 | SHIFT |
| id12 | SHIFT / REDUCE(1) |
| +3 | SHIFT |
| ─┤0 | ACCEPT |
| (2 | SHIFT |
| id3 | REDUCE(3) |
| E23 | SHIFT |
| )2 | REDUCE(2) |

**Recept:**
1. Vrste tabele su stanja, `∇` je start. Potisna tabela daje prelaze (vrsta X, kolona s) = Y ⇔ X –s→ Y.
2. Kontrolna tabela: `REDUCE(p)` ⇒ stanje sadrži potpunu konfiguraciju smene p. `SHIFT` ⇒ tačka je ispred nekog simbola. `SHIFT/REDUCE(p)` ⇒ stanje ima i potpunu konfiguraciju smene p i konfiguraciju sa tačkom ispred terminala (ovde `id12`: `E → id •` i `E → id • ( E )`). `ACCEPT` stanje je `─┤0`.
3. Ime stanja `X_pq` govori koje smene imaju tačku iza X u jezgru. Rekonstruiši desne strane čitajući puteve: `+3 –id→ id3` znači da smena 3 završava sa `+ id`; `id12 –(→ (2 –E→ E23 –)→ )2` znači `E → id ( E )` (smena 2); `∇ –E→ E03 –+→ +3` znači da smena 3 počinje sa `E +`. Dakle `E → E + id`.
4. Smena 1 je `E → id` (stanje `id12` ima REDUCE(1) i prelazi po `id` iz ∇ i iz `(2`).
5. Dodaj zatvaranja (u stanju iza `(` tačka je ispred `E`, pa se dodaju sve smene za E) i proveri da automat izgrađen iz gramatike daje iste tabele.

Gramatika (b):

0. S' → E -|
1. E → id
2. E → id ( E )
3. E → E + id

Konfiguracije stanja (a):

- **∇**: `S' -> • E ─┤`;  `E -> • id`;  `E -> • id ( E )`;  `E -> • E + id`
- **E03**: `S' -> E • ─┤`;  `E -> E • + id`
- **id12**: `E -> id •`;  `E -> id • ( E )`
- **+3**: `E -> E + • id`
- **─┤0**: `S' -> E ─┤ •`
- **(2**: `E -> • id`;  `E -> • id ( E )`;  `E -> id ( • E )`;  `E -> • E + id`
- **id3**: `E -> E + id •`
- **E23**: `E -> id ( E • )`;  `E -> E • + id`
- **)2**: `E -> id ( E ) •`

FOLLOW (c):

| neterminal | poništiv | FIRST | FOLLOW |
|---|---|---|---|
| E | ne | {id} | {), +, ─┤} |

SLR(1) tabela (c) (nema konflikata): shift/reduce konflikt LR(0) tabele u stanju `id12` nestaje jer `( ∉ FOLLOW(E)`:

| | `id` | `(` | `)` | `+` | `─┤` |
|---|---|---|---|---|---|
| ∇ | SHIFT |  |  |  |  |
| E03 |  |  |  | SHIFT | SHIFT |
| id12 |  | SHIFT | REDUCE(1) | REDUCE(1) | REDUCE(1) |
| +3 | SHIFT |  |  |  |  |
| ─┤0 |  |  |  |  | ACCEPT |
| (2 | SHIFT |  |  |  |  |
| id3 |  |  | REDUCE(3) | REDUCE(3) | REDUCE(3) |
| E23 |  |  | SHIFT | SHIFT |  |
| )2 |  |  | REDUCE(2) | REDUCE(2) | REDUCE(2) |

Rad za `id ( id + id ) + id`:

| # | stek | preostali ulaz | akcija |
|---|---|---|---|
| 1 | ∇ | id ( id + id ) + id ─┤ | SHIFT |
| 2 | ∇ id12 | ( id + id ) + id ─┤ | SHIFT |
| 3 | ∇ id12 (2 | id + id ) + id ─┤ | SHIFT |
| 4 | ∇ id12 (2 id12 | + id ) + id ─┤ | REDUCE(1) |
| 5 | ∇ id12 (2 E23 | + id ) + id ─┤ | SHIFT |
| 6 | ∇ id12 (2 E23 +3 | id ) + id ─┤ | SHIFT |
| 7 | ∇ id12 (2 E23 +3 id3 | ) + id ─┤ | REDUCE(3) |
| 8 | ∇ id12 (2 E23 | ) + id ─┤ | SHIFT |
| 9 | ∇ id12 (2 E23 )2 | + id ─┤ | REDUCE(2) |
| 10 | ∇ E03 | + id ─┤ | SHIFT |
| 11 | ∇ E03 +3 | id ─┤ | SHIFT |
| 12 | ∇ E03 +3 id3 | ─┤ | REDUCE(3) |
| 13 | ∇ E03 | ─┤ | SHIFT |
| 14 | ∇ E03 ─┤0 |  | ACCEPT |

### 3.5 Konflikti (K nadoknada 22.1.2021, zadatak 2)

0. S' → S -|
1. S → f A f
2. A → c B
3. B → f S c
4. B → ε

**Pažnja na numeraciju:** u originalnom zadatku smene su numerisane 1, 2, 4, 5 (broj 3 je preskočen: `4. B → f S c`, `5. B → ε`), pa su tamo `REDUCE(4)` za B → f S c i `REDUCE(5)` za B → ε, a redosled primenjenih smena je 1, 2, 4, 1, 2, 5. Ovde su renumerisane 1–4. Na kolokvijumu uvek koristi brojeve iz teksta zadatka.

Pitanje (a): da li se `fcffcfcf` prepoznaje? **Da.** Izvođenje: `S ⇒ f A f ⇒ f c B f ⇒ f c f S c f ⇒ f c f f A f c f ⇒ f c f f c B f c f ⇒ f c f f c f c f` (B → ε u poslednjem koraku; proveren brojač izvođenja: tačno 1 stablo).

| neterminal | poništiv | FIRST | FOLLOW |
|---|---|---|---|
| S | ne | {f} | {─┤, c} |
| A | ne | {c} | {f} |
| B | da | {f} | {f} |

- **∇**: `S' -> • S ─┤`;  `S -> • f A f`
- **S0**: `S' -> S • ─┤`
- **f1**: `S -> f • A f`;  `A -> • c B`
- **─┤0**: `S' -> S ─┤ •`
- **A1**: `S -> f A • f`
- **c2**: `A -> c • B`;  `B -> • f S c`;  `B -> •` LA={f}
- **f1'**: `S -> f A f •` LA={─┤, c}
- **B2**: `A -> c B •` LA={f}
- **f3**: `S -> • f A f`;  `B -> f • S c`
- **S3**: `B -> f S • c`
- **c3**: `B -> f S c •` LA={f}

LR(0) (c2 / `f`: SHIFT / REDUCE(4)) i SLR(1) tabela:

| | `f` | `c` | `─┤` |
|---|---|---|---|
| ∇ | SHIFT |  |  |
| S0 |  |  | SHIFT |
| f1 |  | SHIFT |  |
| ─┤0 |  |  | ACCEPT |
| A1 | SHIFT |  |  |
| c2 | SHIFT / REDUCE(4) |  |  |
| f1' |  | REDUCE(1) | REDUCE(1) |
| B2 | REDUCE(2) |  |  |
| f3 | SHIFT |  |  |
| S3 |  | SHIFT |  |
| c3 | REDUCE(3) |  |  |

SLR(1) i LALR(1) tabele imaju isti konflikt: **u stanju `c2` na ulazu `f`** (`SHIFT` zbog `B → • f S c` i `REDUCE(4)` zbog `B → ε •`, jer je `FOLLOW(B) = LA(B → •) = {f}`). Dakle gramatika nije SLR(1), ni LALR(1) (ni LR(1) jer je i kontekstni predikcioni simbol `f`).

### 3.6 Veći LALR primer (PP1_P06 str. 12–18, BottomUp zad. 4): SLR konflikt koji LALR rešava

0. S' → S -|
1. S → A S
2. S → ε
3. A → B b B c
4. A → C c B
5. B → a D
6. C → a D
7. D → ε

| neterminal | poništiv | FIRST | FOLLOW |
|---|---|---|---|
| S | da | {a} | {─┤} |
| A | ne | {a} | {─┤, a} |
| B | ne | {a} | {─┤, a, b, c} |
| C | ne | {a} | {c} |
| D | da | {} | {─┤, a, b, c} |

SLR(1) ima **jedan konflikt**: D56 / `c`: REDUCE(5) / REDUCE(6) (FOLLOW(B) = {─┤, a, b, c} i FOLLOW(C) = {c} se oba nađu u koloni c). LALR(1) predikcioni skupovi: `B → a D •` u stanju `D56` ima LA = {b}, `C → a D •` u istom stanju LA = {c}, pa konflikta nema (nema konflikata). Stanja i LA:

- **∇**: `S' -> • S ─┤`;  `S -> • A S`;  `S -> •` LA={─┤};  `A -> • B b B c`;  `A -> • C c B`;  `B -> • a D`;  `C -> • a D`
- **S0**: `S' -> S • ─┤`
- **A1**: `S -> • A S`;  `S -> A • S`;  `S -> •` LA={─┤};  `A -> • B b B c`;  `A -> • C c B`;  `B -> • a D`;  `C -> • a D`
- **B3**: `A -> B • b B c`
- **C4**: `A -> C • c B`
- **a56**: `B -> a • D`;  `C -> a • D`;  `D -> •` LA={b, c}
- **─┤0**: `S' -> S ─┤ •`
- **S1**: `S -> A S •` LA={─┤}
- **b3**: `A -> B b • B c`;  `B -> • a D`
- **c4**: `A -> C c • B`;  `B -> • a D`
- **D56**: `B -> a D •` LA={b};  `C -> a D •` LA={c}
- **B3'**: `A -> B b B • c`
- **a5**: `B -> a • D`;  `D -> •` LA={─┤, a, c}
- **B4**: `A -> C c B •` LA={─┤, a}
- **c3**: `A -> B b B c •` LA={─┤, a}
- **D5**: `B -> a D •` LA={─┤, a, c}

| | `b` | `c` | `a` | `─┤` |
|---|---|---|---|---|
| ∇ |  |  | SHIFT | REDUCE(2) |
| S0 |  |  |  | SHIFT |
| A1 |  |  | SHIFT | REDUCE(2) |
| B3 | SHIFT |  |  |  |
| C4 |  | SHIFT |  |  |
| a56 | REDUCE(7) | REDUCE(7) |  |  |
| ─┤0 |  |  |  | ACCEPT |
| S1 |  |  |  | REDUCE(1) |
| b3 |  |  | SHIFT |  |
| c4 |  |  | SHIFT |  |
| D56 | REDUCE(5) | REDUCE(6) |  |  |
| B3' |  | SHIFT |  |  |
| a5 |  | REDUCE(7) | REDUCE(7) | REDUCE(7) |
| B4 |  |  | REDUCE(4) | REDUCE(4) |
| c3 |  |  | REDUCE(3) | REDUCE(3) |
| D5 |  | REDUCE(5) | REDUCE(5) | REDUCE(5) |

## 4. Tipične greške

- Zaboravljena proširena smena `0. S' → S ─┤` (nema ACCEPT stanja) ili `─┤` se ne uključi u potisnu tabelu.
- **Nepotpuno zatvaranje**: kad je tačka ispred neterminala, moraju se dodati sve njegove smene (i rekurzivno, ako počinju neterminalom).
- Dva ista skupa konfiguracija nacrtana kao dva stanja (ili obrnuto, spojena dva različita).
- U SLR tabeli se REDUCE upiše u ceo red (to je LR(0)), ili se FOLLOW računa po pogrešnoj smeni/sa greškom u poništivosti.
- U LALR: SLA se računa sa FOLLOW umesto sa FIRST(β) (zaboravi se β), a zaboravi se veza prosleđivanja kroz poništivo β. LA skup mora ostati podskup FOLLOW.
- Kod `REDUCE` se skida pogrešan broj stanja (dužina desne strane, 0 za ε-smenu), ili se posle redukcije konsultuje ulazni simbol umesto potisne tabele po neterminalu.
- Kod `SHIFT/REDUCE` u LR(0) tabeli se ćelija ne obeleži kao konflikt, nego se proglasi `SHIFT`.

## 5. Pojavljivalo se na K

- **IR 22.11.2019, zad. 1**: LR(0) automat iz potisne i kontrolne tabele, gramatika, FOLLOW, SLR(1) tabela (3.4).
- **IR nadoknada 22.1.2021, zad. 2**: `S → fAf, A → cB, B → fSc | ε`: izvođenje, LR(0) automat i tabela, SLR(1), konflikti (3.5).
- **IR 26.11.2021, zad. 3**: LALR(1) automat i kontrolna tabela za `S → AA, A → AaAb | c | d` + stek sa panic modom (3.3, beleška 06).
- **SI K1**: 2012/13 LR(0) parser (automat, potisna, kontrolna) i rad na ulazu.
- 3 od 4 IR kolokvijuma imaju ovaj tip zadatka. **Najverovatnije i na 28.11.**: vežbaj konstrukciju automata do kraja (stanja, potisna, kontrolna) i trag rada parsera.
