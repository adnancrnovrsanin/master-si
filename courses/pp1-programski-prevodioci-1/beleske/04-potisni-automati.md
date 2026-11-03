# 04. Potisni automati

**Izvor:** `PP1_P05.pdf` str. 5 (potisni automat = konačni automat + stek, jednako moćan kao KS gramatike) i str. 9–13 (elementi SR parsera, operacije); definicija i primeri sa vežbi: `Cas  4 - Potisni automati.pptx` (sl. 2–40) i `BottomUp.doc` poglavlje 3 (Zadaci 1–2, formalna definicija i algoritam rada); Zbirka odeljak 3.1 (zad. 3.1.1–3.1.8).

## 1. Definicije (2–3 rečenice)

- **Potisni automat** je šestorka (U, Y, Yₛ, S, Sₜ, δ): ulazni simboli (U ∪ marker kraja `─┤`), simboli steka Y, početni stek Yₛ (počinje sa `∇` koje je dno steka i nikad se ne skida), stanja S, startno stanje Sₜ i kontrolna funkcija δ koja za (ulazni simbol, vrh steka, stanje) daje akciju. Prepoznaje tačno bezkontekstne jezike.
- Akcija je ili `ACCEPT`/`REJECT`, ili trojka: **operacija nad stekom** (`POP`, `PUSH(x)`, `REPLACE(xyz)` ≡ `POP`, pa `PUSH(x)`, `PUSH(y)`, `PUSH(z)`; ili ništa), **promena stanja** `STATE(S)` (piše se samo kad se stanje menja) i **operacija nad ulazom** (`ADVANCE` ili `RETAIN`).
- Svaki potisni automat može da se napravi sa jednim stanjem (kontekst se čuva na steku), ali je često jasnije imati po jedno stanje za svaku "fazu" ulaza. Prazno polje tabele je `REJECT`. `POP` ili `REPLACE` kad je na vrhu `∇` je greška.

Tabela se piše kao **jedna tabela po stanju**: vrste su simboli steka (uključujući `∇`), kolone ulazni simboli (uključujući `─┤`).

## 2. Algoritam rada automata

```
stanje := Sₜ;  stek := Yₛ (= ∇);  ulaz := prvi simbol
ponavljaj:
   a := δ(ulaz, vrh steka, stanje)
   ako a = ACCEPT: prihvati;  ako a = REJECT: odbij
   inače a = (op_steka, novo_stanje, op_ulaza): primeni op_steka; stanje := novo_stanje; primeni op_ulaza
```

## 3. Algoritam: kako se projektuje potisni automat za jezik

1. **Razloži ulaz na faze** (npr. prvo slova a, pa b, pa c). Ako se faze ne mogu pomešati, svaka dobija stanje (S₁, S₂, S₃).
2. **Odredi šta se broji ili uparuje** i uvedi simbole steka. Standardno: `PUSH(A)` za svako slovo koje se broji, `POP` za svako slovo koje se uparuje; na kraju stek mora da bude prazan (`∇` na vrhu) ili da ima bar jedan `A` (za "veće od", npr. n > m).
3. **Pravilo "dva ili više simbola po slovu"** (npr. svaki par `bc` traži dva `a`): `PUSH` jedan marker (B) pa pri sledećem slovu `REPLACE(AA)`, ili više ulaza sa `RETAIN` kroz međustanja.
4. **`RETAIN`** koristi kad isti ulazni simbol treba da obradiš u dva koraka (npr. cifra 3 dodaje tri puta, svaki put jedna jedinica).
5. **Popuni tabelu po stanju**: za svaku kombinaciju (vrh steka, ulaz) napiši akciju ili ostavi `REJECT`. Ne zaboravi kolonu `─┤`.
6. **Prihvatanje** je akcija `ACCEPT` na `─┤` u odgovarajućem stanju i sa odgovarajućim vrhom steka. Uslov (npr. m ≥ 1, k > 0) ugradi tako što stanje prihvatanja nije dostižno bez potrebnog broja koraka.
7. Proveri: prazna sekvenca, najkraća ispravna, i jedna neispravna po svakom pravilu (premalo, previše, pogrešan redosled).
8. U odgovoru uvek navedi: ulazne simbole, simbole steka, stanja, početni stek, tabele, i **prikaži rad za izabranu sekvencu** (stek / ulaz / akcija).

## 4. Primeri (svi automati provereni simulatorom nad svim rečima do dužine 10–11)

### 4.1 Čitanje tabele (Cas 4, zad. 1): jedno stanje, stek {A, B, C, ∇}

**S0**

| | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|
| A | PUSH(A), ADVANCE | REJECT | POP, ADVANCE | REJECT |
| B | PUSH(C), ADVANCE | POP, RETAIN | PUSH(A), ADVANCE | REJECT |
| C | PUSH(B), ADVANCE | PUSH(C), ADVANCE | POP, ADVANCE | REJECT |
| ∇ | PUSH(A), ADVANCE | PUSH(B), ADVANCE | REJECT | ACCEPT |


Rad za `aaccac` (prihvata se):

| # | stek | ulaz | stanje | akcija |
|---|---|---|---|---|
| 1 | ∇ | aaccac─┤ | S0 | PUSH(A), ADVANCE |
| 2 | ∇A | accac─┤ | S0 | PUSH(A), ADVANCE |
| 3 | ∇AA | ccac─┤ | S0 | POP, ADVANCE |
| 4 | ∇A | cac─┤ | S0 | POP, ADVANCE |
| 5 | ∇ | ac─┤ | S0 | PUSH(A), ADVANCE |
| 6 | ∇A | c─┤ | S0 | POP, ADVANCE |
| 7 | ∇ | ─┤ | S0 | ACCEPT |

Za `ab` automat odbija odmah (`b` kad je `A` na vrhu), za `bac` na `─┤` jer na vrhu ostaje `B`, a za `aaaaccccc` (četiri `a`, pet `c`) peto `c` dolazi na `∇`. Proveren je i prihvatni skup (prazna reč, `aaaacccc`, `aaccac` se prihvataju).

### 4.2 1ⁿ0ᵐ, n > m > 0 (Zbirka 3.1.4, Cas 4 zad. 2)

S₁ čita jedinice (po jedan `A` za svaku), prvi `0` prelazi u S₂ (od tada samo nule, svaka skida `A`). Prihvata se samo u S₂ kad na `─┤` na vrhu ostane `A` (znači n > m) i bar jedna nula je pročitana (m > 0, jer je S₂ jedino mesto sa `ACCEPT`).

**S1**

| | `0` | `1` | `─┤` |
|---|---|---|---|
| A | POP, ADVANCE, STATE(S2) | PUSH(A), ADVANCE | REJECT |
| ∇ | REJECT | PUSH(A), ADVANCE | REJECT |

**S2**

| | `0` | `1` | `─┤` |
|---|---|---|---|
| A | POP, ADVANCE | REJECT | ACCEPT |
| ∇ | REJECT | REJECT | REJECT |


Rad za `11100`:

| # | stek | ulaz | stanje | akcija |
|---|---|---|---|---|
| 1 | ∇ | 11100─┤ | S1 | PUSH(A), ADVANCE |
| 2 | ∇A | 1100─┤ | S1 | PUSH(A), ADVANCE |
| 3 | ∇AA | 100─┤ | S1 | PUSH(A), ADVANCE |
| 4 | ∇AAA | 00─┤ | S1 | POP, ADVANCE, STATE(S2) |
| 5 | ∇AA | 0─┤ | S2 | POP, ADVANCE |
| 6 | ∇A | ─┤ | S2 | ACCEPT |

### 4.3 aᵏ(bc)ᵖa²ᵖ, k ≥ 0, p > 0 (Cas 4 zad. 4, januar 2021)

S₁: početna slova `a` (broj k nije ni za šta vezan, stek se ne menja). S₂: parovi `bc`; `b` stavlja `B` kao podsetnik da sledi `c`, a `c` sa `B` na vrhu radi `REPLACE(AA)` (za svaki par dva `A` za završna `a`). Prvo `a` posle parova skida `A` i prelazi u S₃, gde svako `a` skida po jedan `A`. Prihvata se u S₃ kad je stek prazan (tačno 2p završnih `a`). Gramatika istog jezika: `S → a S | B`, `B → b c B a a | b c a a`.

**S1**

| | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|
| A | ADVANCE | PUSH(B), ADVANCE, STATE(S2) | REJECT | REJECT |
| B | ADVANCE | PUSH(B), ADVANCE, STATE(S2) | REJECT | REJECT |
| ∇ | ADVANCE | PUSH(B), ADVANCE, STATE(S2) | REJECT | REJECT |

**S2**

| | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|
| A | POP, ADVANCE, STATE(S3) | PUSH(B), ADVANCE | REJECT | REJECT |
| B | REJECT | PUSH(B), ADVANCE | REPLACE(AA), ADVANCE | REJECT |
| ∇ | REJECT | PUSH(B), ADVANCE | REJECT | REJECT |

**S3**

| | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|
| A | POP, ADVANCE | REJECT | REJECT | REJECT |
| B | REJECT | REJECT | REJECT | REJECT |
| ∇ | REJECT | REJECT | REJECT | ACCEPT |


Rad za `abcbcaaaa` (prihvata se):

| # | stek | ulaz | stanje | akcija |
|---|---|---|---|---|
| 1 | ∇ | abcbcaaaa─┤ | S1 | ADVANCE |
| 2 | ∇ | bcbcaaaa─┤ | S1 | PUSH(B), ADVANCE, STATE(S2) |
| 3 | ∇B | cbcaaaa─┤ | S2 | REPLACE(AA), ADVANCE |
| 4 | ∇AA | bcaaaa─┤ | S2 | PUSH(B), ADVANCE |
| 5 | ∇AAB | caaaa─┤ | S2 | REPLACE(AA), ADVANCE |
| 6 | ∇AAAA | aaaa─┤ | S2 | POP, ADVANCE, STATE(S3) |
| 7 | ∇AAA | aaa─┤ | S3 | POP, ADVANCE |
| 8 | ∇AA | aa─┤ | S3 | POP, ADVANCE |
| 9 | ∇A | a─┤ | S3 | POP, ADVANCE |
| 10 | ∇ | ─┤ | S3 | ACCEPT |

Za `bcbcaaa` (samo tri završna `a`, treba četiri) automat odbija na `─┤` jer na vrhu ostaje `A`:

| # | stek | ulaz | stanje | akcija |
|---|---|---|---|---|
| 1 | ∇ | bcbcaaa─┤ | S1 | PUSH(B), ADVANCE, STATE(S2) |
| 2 | ∇B | cbcaaa─┤ | S2 | REPLACE(AA), ADVANCE |
| 3 | ∇AA | bcaaa─┤ | S2 | PUSH(B), ADVANCE |
| 4 | ∇AAB | caaa─┤ | S2 | REPLACE(AA), ADVANCE |
| 5 | ∇AAAA | aaa─┤ | S2 | POP, ADVANCE, STATE(S3) |
| 6 | ∇AAA | aa─┤ | S3 | POP, ADVANCE |
| 7 | ∇AA | a─┤ | S3 | POP, ADVANCE |
| 8 | ∇A | ─┤ | S3 | REJECT |

### 4.4 aⁿbᵐcⁿ (n, m ≥ 0)

Tri stanja za faze, `A` po jedno za svako `a`:

**S1**

| | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|
| A | PUSH(A), ADVANCE | ADVANCE, STATE(S2) | POP, ADVANCE, STATE(S3) | REJECT |
| ∇ | PUSH(A), ADVANCE | ADVANCE, STATE(S2) | REJECT | ACCEPT |

**S2**

| | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|
| A | REJECT | ADVANCE | POP, ADVANCE, STATE(S3) | REJECT |
| ∇ | REJECT | ADVANCE | REJECT | ACCEPT |

**S3**

| | `a` | `b` | `c` | `─┤` |
|---|---|---|---|---|
| A | REJECT | REJECT | POP, ADVANCE | REJECT |
| ∇ | REJECT | REJECT | REJECT | ACCEPT |


### 4.5 Brojevi deljivi sa 4 u binarnom zapisu sa vodećom jedinicom, razdvojeni zarezima (Cas 4 zad. 5, K nadoknada 12.2.2021, zad. 2)

Deljivost sa 4 znači da zapis završava sa `00`. Jezik je regularan, pa potisni automat radi kao konačni (stek je samo `∇`). Dva rešenja se mogu dati: (a) **jedno stanje**, simboli steka pamte kraj broja (`∇` početak broja, `A` poslednja cifra je 1, `B` jedna nula na kraju, `C` bar dve nule; prva jedinica broja radi `PUSH(A)`, zarez dozvoljen samo kad je `C` na vrhu: `POP`, kraj `─┤` sa `∇`), ili (b) **četiri stanja** (ispod; kraj broja pamte stanja):

S₁ = početak broja (očekuje se `1`), S₂ = poslednja cifra je 1, S₃ = tačno jedna nula na kraju, S₄ = bar dve nule na kraju (zarez i kraj dozvoljeni samo ovde).

**S1**

| | `0` | `1` | `,` | `─┤` |
|---|---|---|---|---|
| ∇ | REJECT | ADVANCE, STATE(S2) | REJECT | REJECT |

**S2**

| | `0` | `1` | `,` | `─┤` |
|---|---|---|---|---|
| ∇ | ADVANCE, STATE(S3) | ADVANCE | REJECT | REJECT |

**S3**

| | `0` | `1` | `,` | `─┤` |
|---|---|---|---|---|
| ∇ | ADVANCE, STATE(S4) | ADVANCE, STATE(S2) | REJECT | REJECT |

**S4**

| | `0` | `1` | `,` | `─┤` |
|---|---|---|---|---|
| ∇ | ADVANCE | ADVANCE, STATE(S2) | ADVANCE, STATE(S1) | ACCEPT |


Rad za niz od tri broja `100,1100,1000`:

| # | stek | ulaz | stanje | akcija |
|---|---|---|---|---|
| 1 | ∇ | 100,1100,1000─┤ | S1 | ADVANCE, STATE(S2) |
| 2 | ∇ | 00,1100,1000─┤ | S2 | ADVANCE, STATE(S3) |
| 3 | ∇ | 0,1100,1000─┤ | S3 | ADVANCE, STATE(S4) |
| 4 | ∇ | ,1100,1000─┤ | S4 | ADVANCE, STATE(S1) |
| 5 | ∇ | 1100,1000─┤ | S1 | ADVANCE, STATE(S2) |
| 6 | ∇ | 100,1000─┤ | S2 | ADVANCE |
| 7 | ∇ | 00,1000─┤ | S2 | ADVANCE, STATE(S3) |
| 8 | ∇ | 0,1000─┤ | S3 | ADVANCE, STATE(S4) |
| 9 | ∇ | ,1000─┤ | S4 | ADVANCE, STATE(S1) |
| 10 | ∇ | 1000─┤ | S1 | ADVANCE, STATE(S2) |
| 11 | ∇ | 000─┤ | S2 | ADVANCE, STATE(S3) |
| 12 | ∇ | 00─┤ | S3 | ADVANCE, STATE(S4) |
| 13 | ∇ | 0─┤ | S4 | ADVANCE |
| 14 | ∇ | ─┤ | S4 | ACCEPT |

## 5. Tipične greške

- `POP` na `∇` (greška; dno se ne skida) i `PUSH` simbola `∇`.
- Prihvatanje bez provere steka (npr. `aⁿbⁿ` prihvaćeno i kad je na vrhu `A`).
- Zaboravljena kolona `─┤` ili prihvatanje na pogrešnom stanju.
- Zaboravljeno `RETAIN`: ulazni simbol se "potroši" a trebalo je još jednom da se obradi.
- Za uslove n > m ili m ≥ 1: nema stanja/provere koja garantuje da su obe faze ispunjene.
- Nedovoljno stanja: faze se mešaju (npr. `c` dozvoljen pre `b`).
- U tabeli nije jasno koja je akcija za nepredviđene kombinacije (treba `REJECT`).

## 6. Pojavljivalo se na K

- **IR nadoknada 12.2.2021, zad. 2**: PA za niz celih brojeva deljivih sa 4 u binarnom zapisu razdvojenih zarezima (4.5).
- **SI K1**: 2016/17 gramatika i PA za aⁿbᵐcⁿ (m parno); 2017/18 PA za aᵏbᵐcᵏ⁻¹; 2019/20 gramatika i PA za (ab)ⁿcᵐaᵏ, m>k>0.
- Na vežbama (Cas 4): zagrade `()[]` (jul 2020; jedno stanje, `A` za `(`, `B` za `[`), aᵏ(bc)ᵖa²ᵖ (januar 2021; 4.3), brojevi deljivi sa 4 (4.5), **suma cifara jednaka nuli sa znakom `-` koji negira sledeću cifru** (februar 2023; ovo je zadatak koji pominje student iz grupe, vidi vežbanje i rešenje u `zadaci/vezbanje.md` i `zadaci/vezbanje-resenja.md`).
- U ovoj godini se PA lako može pojaviti uz gramatiku iste vrste ("Napisati gramatiku i potisni automat za …").
