# Rešenja za `vezbanje.md`

Pogledaj tek pošto probaš sam. Sve vrednosti su proverene Python skriptama (BFS/UCS/A*/IDA*, CSP sa MRV+stepen+LCV+FC+AC-3, enumeracija NE/Pareto, alfa-beta). Gde je trag izjednačen, koristio sam pravilo iz zadatka (abecedno).

---

## Z1 Džbanovi

**a)** Stanje (a, b) = litara u A i B, 0 ≤ a ≤ 4, 0 ≤ b ≤ 3. Ukupno 5 · 4 = **20** stanja. Dostižnih iz (0,0) je **14**: (0,0), (0,1), (0,2), (0,3), (1,0), (1,3), (2,0), (2,3), (3,0), (3,3), (4,0), (4,1), (4,2), (4,3). Nedostižno: (1,1), (1,2), (2,1), (2,2), (3,1), (3,2).

**b) BFS** (cilj kad je a = 2). Redosled ekspandovanja (13 čvorova):
(0,0), (4,0), (0,3), (4,3), (1,3), (3,0), (1,0), (3,3), (0,1), (4,2), (4,1), (0,2), (2,3).
Rešenje: (0,0) →napuni A→ (4,0) →A→B→ (1,3) →isprazni B→ (1,0) →A→B→ (0,1) →napuni A→ (4,1) →A→B→ (2,3).
**6 koraka**, utrošeno **8 litara** (4 + 4).

**c)** Treba **grananje i ograničavanje / uniform-cost** (cena = litara iz izvora). Optimalno: (0,0) →napuni B→ (0,3) →B→A→ (3,0) →napuni B→ (3,3) →B→A→ (4,2) →isprazni A→ (0,2) →B→A→ (2,0).
Cena **6 litara**, takođe 6 koraka. Po broju koraka postoje tačno dva najkraća rešenja (oba 6 koraka): jedno košta 8, drugo 6. BFS je našao prvo koje je naišlo (8), pa je **optimalno po broju koraka, ali ne po ceni**; B&B garantuje optimum po ceni (cena ≥ 0), ali ne po broju koraka u opštem slučaju.
Ovo je isti obrazac kao Feb 2024 ("najmanje koraka" naspram "najmanji napor").

---

## Z2 Putna mreža

h* (prave cene do G): S 10, A 11, B 7, C 8, D 7, E 5, F 3.

| Algoritam | Redosled ekspandovanja | Putanja | Cena |
|---|---|---|---|
| a) DFS | S, A, D, G | SADG | 14 |
| b) BFS (cilj pri generisanju) | S, A, B, C, D (G se generiše pri ekspanziji D) | SADG | 14 |
| c) Prvo najbolji | S, B, E, G | SBEG | 12 |
| d) B&B + DP | S(0), C(2), A(3), B(5), D(7), E(7), F(7), G(10) | SCFG | 10 |
| e) A* + DP | S, C, A, B, E, F, G | SCFG | 10 |
| f) IDA* | pragovi 7, 9, 10 | SCFG | 10 |

**A* tabela** (`putanja: g + h = f`):
1. S: 0+7 = 7 → generiši SA 3+6=9, SB 5+4=9, SC 2+5=7.
2. Ekspanzija SC (7): SCF 7+3=10. Lista: SA9, SB9, SCF10.
3. Ekspanzija SA (9): SAD 7+4=11, SAE 9+3=12. Lista: SB9, SCF10, SAD11, SAE12.
4. Ekspanzija SB (9): SBE 7+3=10, SBF 9+3=12. DP: SBE (10) zamenjuje SAE (12), SCF (10) zamenjuje SBF (12). Lista: SBE10, SCF10, SAD11.
5. Ekspanzija SBE (10, E ispred F): SBEG 12+0=12 (SBEA 13+6=19). Lista: SCF10, SAD11, SBEG12, ...
6. Ekspanzija SCF (10): SCFG 10+0=10. Lista: SCFG10, SAD11, ...
7. SCFG je prvi i cilj: **SCFG, cena 10**.

**IDA***: prag 7: S(7), SC(7) prolaze; SA 9, SB 9, SCF 10 odbačeni → novi prag 9. Prag 9: SA(9), SB(9), SC(7) prolaze, ostalo odbačeno (najmanje 10) → prag 10. Prag 10: SBE (10), SCF (10) prolaze, SCFG nađen. Redosled u poslednjem krugu: S, A, B, E, C, F, G.

**g)** Optimalno (10) nalaze B&B, A*, IDA*. DFS, BFS i prvo najbolji ne (14, 14, 12). h je **dopustiva**: h ≤ h* za svaki čvor (7≤10, 6≤11, 4≤7, 5≤8, 4≤7, 3≤5, 3≤3). Konzistentna je: za svaku granu h(n) ≤ c + h(n') (proveravano skriptom, ni jedna grana ne krši). Zato je A* optimalan.

---

## Z3 Trgovački putnik

**a)** Greedy: A→C (3), C→B (5; B je bliže od D 6), B→D (4), D→A (7): **ACBDA = 19**.

**b) A\*** (g + h = f; h = MST nad {neposećeni, poslednji, A}):

| Ekspanzija | Putanja | g | h | f | Generisane putanje (g+h=f) |
|---|---|---|---|---|---|
| 1 | A | 0 | 11 | 11 | AB 4+11=15, AC 3+11=14, AD 7+11=18 |
| 2 | AC (14) | 3 | 11 | 14 | ACB 8+8=16, ACD 9+8=17 |
| 3 | AB (15) | 4 | 11 | 15 | ABC 9+9=18, ABD 8+9=17 |
| 4 | ACB (16) | 8 | 8 | 16 | ACBD 12+7=19 |
| 5 | ABD (17, abecedno ispred ACD) | 8 | 9 | 17 | ABDC 14+3=17 |
| 6 | ABDC (17) | 14 | 3 | 17 | ABDCA 17+0=17 |
| 7 | ABDCA (17) | 17 | 0 | 17 | cilj |

(h za koren: MST({A,B,C,D}) = AC 3 + AB 4 + BD 4 = 11. h za ACB: MST({D,B,A}) = AB 4 + BD 4 = 8. h za ABDC: MST({C,A}) = 3.)
Rešenje: **ABDCA, cena 17** (provereno brute-force-om: optimum). Greedy je dao 19.

**c)** Svaki stvarni nastavak putanje (poslednji grad → svi neposećeni → A) povezuje taj skup gradova, pa je bar jedno razapinjuće stablo nad njim; MST je najjeftinije takvo, zato h ≤ stvarna cena preostalog puta.

---

## Z4 Heuristike

**a)** h*: S 7 (S-A-C-G), A 5 (A-C-G), B 8 (B-S-A-C-G = 1+2+2+3), C 3, G 0.

**b)**
- h1: S6≤7, A4≤5, B6≤8, C3≤3: **dopustiva**. Konzistentna: nijedna grana ne krši h(n) ≤ c + h(n'), **konzistentna**.
- h2: A=12 > 5: **nije dopustiva** (ostali čvorovi jesu). Krši konzistentnost na granama (S,B): 5 > 1+2, (A,S): 12 > 2+5, (A,C): 12 > 2+3, (A,G): 12 > 7+0.
- h3: S7≤7, A5≤5, B8≤8, C1≤3: **dopustiva**, ali **nije konzistentna**: (A,C): 5 > 2+1 i (B,C): 8 > 5+1.

**c) A\* (stablo, bez DP)**
- h1: S (7: A 2+4=6, B 1+6=7); A (6): C 4+3=7, G 9; lista B7, C7(SAC), G9, B pre C abecedno: ekspanzija SB: SBC 6+3=9; zatim SAC (7): SACG 7+0=7; cilj. Redosled **S, A, B, C, G**, putanja **SACG, cena 7**.
- h2: S: A 2+12=14, B 1+2=3; SB (3): SBC 6+3=9; SBC (9): SBCG 9+0=9; cilj pre SA (14). Redosled **S, B, C, G**, putanja **SBCG, cena 9** (neoptimalno).
- h3: S: A 2+5=7, B 1+8=9; SA (7): SAC 4+1=5, SAG 9+0=9; SAC (5): SACG 7; cilj. Redosled **S, A, C, G**, putanja **SACG, cena 7**.

**d)** h2 daje neoptimalno rešenje, jer precenjuje (A=12 gura optimalnu putanju kroz A na dno liste, pa se SBCG pojavi kao prvi cilj). Za h3 (dopustiva, nekonzistentna) A* na **stablu pretrage** (bez DP / zatvorenog skupa) i dalje daje optimum; dopustivost je dovoljna za optimalnost stabla. Konzistentnost je potrebna kad se koristi graf-pretraga sa odbacivanjem već viđenih čvorova (zatvoreni skup).

---

## Z5 CSP: raspored sala

Graf ograničenja: potpun graf K5 (svaki par različit). Domeni: Ana {103,101}, Boris {104,102,103}, Dara {103,105}, Egon {101,103,105,104}, Filip {105,103}.

**FC (MRV, leksikografski, vrednosti po redosledu):**
1. Ana, Dara i Filip imaju po 2 → Ana. **Ana = 103.** FC: Boris {104,102}, Dara {105}, Egon {101,105,104}, Filip {105}.
2. Dara {105} i Filip {105} imaju po 1 → Dara. **Dara = 105.** FC: Egon {101,104}, Filip {} prazan → **BACKTRACK** (Dara nema drugu vrednost → nazad na Ana).
3. **Ana = 101.** FC: Egon {103,105,104}; ostalo isto: Boris {104,102,103}, Dara {103,105}, Filip {105,103}.
4. Dara i Filip po 2 → Dara. **Dara = 103.** FC: Boris {104,102}, Egon {105,104}, Filip {105}.
5. Filip (1) → **Filip = 105.** FC: Egon {104}.
6. Egon (1) → **Egon = 104.** FC: Boris {102}.
7. **Boris = 102.**

Rešenje: Ana 101, Boris 102, Dara 103, Egon 104, Filip 105. **7 dodela**, 2 vraćanja.

**FC + AC-3 posle dodele:** Ana = 103: posle FC AC proverava luk (Dara, Filip): oba imaju samo 105, pa Dara gubi 105 → prazan domen → backtrack **odmah**. Zatim Ana = 101; Dara = 103 (FC: Boris {104,102}, Egon {105,104}, Filip {105}; AC: Egon gubi 105 jer Filip mora 105 → {104}; Boris gubi 104 jer Egon mora 104 → {102}); Boris = 102, Egon = 104, Filip = 105. **6 dodela**, 1 vraćanje (Ana = 103, pa Ana = 101, Dara, Boris, Egon, Filip). Isto rešenje.

---

## Z6 CSP: bojenje mape

Posle unarnih ograničenja: AT {C,Z}, BE {C,P}, CH {C,P}, DE {C,Z,P}, FR {C,Z,P}, NL {C,Z,P}. (Početni AC-3 nema promena.)
Stepen (susedi): DE 5, BE 3, CH 3, FR 3, AT 2, NL 2.

**FC + AC:**
1. MRV (2 vrednosti): AT, BE, CH. Stepen: AT 2, BE 3, CH 3. Izjednačenje BE/CH, leksikografski **BE**. LCV: C i P utiču na po 3 suseda, uzmi **C**. **BE = C.** FC: FR {Z,P}, NL {Z,P}, DE {Z,P}. AC bez promena.
2. Sada sve nedodeljene imaju 2 vrednosti: AT {C,Z}, CH {C,P}, DE {Z,P}, FR {Z,P}, NL {Z,P}. Najveći stepen: **DE** (4 nedodeljena suseda). LCV: Z i P oba izbacuju po 3 vrednosti, uzmi **Z**. **DE = Z.** FC: FR {P}, NL {P}, AT {C}. AC: luk (CH,FR): CH gubi P → {C}; luk (CH,AT): AT mora C, pa CH gubi C → {} prazan → **BACKTRACK**.
3. **DE = P.** FC: FR {Z}, NL {Z}, CH {C}. AC: AT gubi C (CH mora C) → AT {Z}.
4. Svi sa 1 vrednošću: AT (stepen 1: CH), CH (2: FR, AT), FR (1), NL (0) → **CH = C.** FC: bez promena (AT {Z}, FR {Z}).
5. **AT = Z**, **FR = Z**, **NL = Z** (jedan po jedan, leksikografski).

Rešenje: BE C, DE P, CH C, AT Z, FR Z, NL Z. Redosled: BE, DE, CH, AT, FR, NL. **7 dodela** (računajući neuspešnu DE = Z), 1 backtrack.
**Samo FC:** BE = C; DE = Z (FC: FR {P}, NL {P}, AT {C}); AT = C (FC: CH {P}); CH = P → FR prazan (backtrack); DE = P; CH = C; AT = Z; FR = Z; NL = Z. **9 dodela**, 3 backtrack-a. AC je uštedeo 2 dodele.

---

## Z7 AC-3 (aritmetika)

**a)** Red lukova: (A,B), (A,D), (B,A), (B,C), (C,B), (C,D), (C,E), (D,A), (D,C), (D,E), (E,C), (E,D). Brisanja redom:
1. (A,B): A = 4 nema B > 4 → D(A) = {1,2,3}.
2. (A,D): A = 3 daje D = 5, van domena → D(A) = {1,2}.
3. (B,A): B = 1 nema A < 1 → D(B) = {2,3,4}.
4. (C,B): C = 1 nema B sa B+1 > 5 → D(C) = {2,3,4}.
5. (D,A): D mora biti A+2 ∈ {3,4} → D(D) = {3,4}.
6. (E,C): E = 4 nema C > 4 → D(E) = {1,2,3}.
7. (E,D): E ≥ D ≥ 3 → D(E) = {3}.
8. (C,E): C > 3 → D(C) = {4}.
9. (D,E): D ≤ E = 3 → D(D) = {3}.
10. (A,D): A = D − 2 = 1 → D(A) = {1}.
(Redosled brisanja zavisi od discipline reda, ali **konačni domeni ne zavise**.) Posle toga u redu su samo lukovi koji ne menjaju ništa.

Konačni domeni: **A {1}, B {2,3,4}, C {4}, D {3}, E {3}.**

**b)** Rešenja su (A,B,C,D,E) = (1,2,4,3,3), (1,3,4,3,3), (1,4,4,3,3): **3 rešenja** (B slobodno u {2,3,4}). Pretraga unazad po rastućim vrednostima daje prvo rešenje **(1,2,4,3,3)** bez ijednog backtrack-a; AC-3 je skoro ceo problem rešio.

---

## Z8 Simultana igra 3×3

**a)** Nema dominantne strategije (ni striktne ni slabe) ni za Marka ni za Jelenu.

**b)** Eliminacija: (1) K2 je striktno dominirana sa K1 (Jelena: 9>2, 7>5, 5>3), izbaci K2. (2) Bez K2, R3 je striktno dominirana sa R1 (Marko: 6>3, 9>8), izbaci R3. (3) Bez R3, K3 je striktno dominirana sa K1 (Jelena: 9>0, 7>5), izbaci K3. (4) U koloni K1, R2 je dominirana sa R1 (Marko: 6>4), izbaci R2. Ostaje (R1, K1).

**c)** Jedinstveni NE: **(R1, K1) = (6, 9)** (provera: Marko u koloni K1 ima 6, 4, 3 → R1; Jelena u redu R1 ima 9, 2, 0 → K1).

**d)** Pareto-optimalni profili: **(R2, K3) = (9, 5)** i **(R3, K3) = (8, 9)**. NE (6, 9) **nije** Pareto-optimalan: (R3, K3) = (8, 9) je bolje za Marka, a Jeleni isto.

**e)** Maximin za Marka: minimumi po redovima R1 min(6,2,9)=2, R2 min(4,5,9)=4, R3 min(3,7,8)=3 → bira **R2** (garantuje 4).

---

## Z9 Dopuni matricu

**a)** Petar: B striktno dominira A ⇔ 2 > −2 (jeste) i x > 0, dakle x ≥ 1. Maja: C slabo (ali ne striktno) dominira D ⇔ 4 > 0 (u redu A) i 4 ≥ y u redu B, uz jednakost (inače bi bilo striktno), dakle y = 4. (B, D) = (x, 4) nije Pareto-optimalan ⇔ postoji profil bolji za nekog, a ne gori za druge; (B, C) = (2, 4) to ispunjava ako je x < 2. Zajedno: **x = 1, y = 4.**

**b)** Provera ćelija: (A,C) = (−2,4): Petar prelazi na B (2 > −2), nije NE. (A,D) = (0,0): Maja prelazi na C (4 > 0), nije NE. (B,C) = (2,4): NE osim ako Maja dobije više prelaskom na D, tj. NE ⇔ y ≤ 4. (B,D) = (x,y): NE ⇔ x ≥ 0 (inače Petar prelazi na A za 0) i y ≥ 4. Nema čistog NE ⇔ y > 4 i x < 0, tj. **x ≤ −1 i y ≥ 5**.

**c)** Petar je ravnodušan kad Maja igra (1/2, 1/2): A: (−2 + 0)/2 = −1, B: (2 + x)/2 → x = −4. Maja je ravnodušna kad Petar igra (1/2, 1/2): C: (4 + 4)/2 = 4, D: (0 + y)/2 → y = 8. **x = −4, y = 8.** Očekivani dobitak: **Petar −1, Maja 4**.

---

## Z10 Minimax i alfa-beta

**a)** MAX čvorovi (drugi nivo ispod MIN): MIN-1: max(8,1)=8, max(7,9)=9 → MIN-1 = 8. MIN-2: max(4,−2)=4, max(3,2)=3 → 3. MIN-3: max(6,−3)=6, max(−1,−5)=−1 → −1. Koren = max(8, 3, −1) = **8**, MAX bira prvi potez (ka MIN-1).

**b)** Alfa-beta (α, β):
- Koren (−∞, +∞). MIN-1 (−∞, +∞). Prvi MAX [8,1]: (−∞, +∞) → 8 (listovi 8, 1). MIN-1: β = 8.
- Drugi MAX [7,9] sa (−∞, 8): list 7 → α = 7; list 9 → α = 9 ≥ β = 8 (odsecanje, ali nema više listova). Vraća 9. MIN-1 = min(8, 9) = **8**. Koren α = 8.
- MIN-2 (8, +∞). MAX [4,−2] (8, +∞): oba lista evaluirana, vraća 4. MIN-2: β = 4, α = 8 ≥ β = 4 → **odseci drugo MAX dete [3,2]** (oba lista). MIN-2 vraća 4.
- MIN-3 (8, +∞). MAX [6,−3]: vraća 6. β = 6, α = 8 ≥ 6 → **odseci drugo MAX dete [−1,−5]**. MIN-3 vraća 6.
- Koren = max(8, 4, 6) = **8**.
Evaluirano **8 od 12** listova (8, 1, 7, 9, 4, −2, 6, −3); odsečeno 4 (3, 2, −1, −5). Vrednosti odsečenih MIN čvorova (4 i 6) su samo granice, tačne vrednosti su 3 i −1, ali ne utiču na ishod.

**c)** Redosled dece korena (MIN-1, MIN-2, MIN-3 → broj listova): (1,2,3) **8**, (1,3,2) **8**, (2,1,3) **10**, (2,3,1) **12**, (3,1,2) **10**, (3,2,1) **12**. Najbolje je da se prvo obradi najbolja grana (MIN-1), jer dobijaš veliko α rano i odsecaš više. Ako se najbolja grana obrađuje poslednja, ne odsečeš skoro ništa (12 = svi listovi).
