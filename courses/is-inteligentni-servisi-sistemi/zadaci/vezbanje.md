# Vežbanje za K1 (pretraživanje + CSP), plus igre

Deset zadataka po uzoru na vežbe i stare K/rokove. **Bez rešenja.** Rešenja su u `vezbanje-resenja.md` (pogledaj tek kad probaš). Svi zadaci su moji, a rešenja su proverena Python skriptama.

Težina: ★ lakše, ★★★ kao na ispitu.
Redosled: Z1-Z4 pretraživanje, Z5-Z7 CSP, Z8-Z10 igre (K2, za svaki slučaj).

Zajednička pravila ako u zadatku ne piše drugačije (kao na vežbama):
- sledbenici se razvijaju **abecedno**; ne vraćaš se u čvor koji je već na putanji koju produžavaš;
- pri **izjednačenju** vrednosti (f, g ili h) prednost ima putanja čiji je poslednji čvor abecedno ispred;
- test cilja je na **ekspandovanom** čvoru, osim ako je izričito dozvoljeno drugačije.

---

## Z1 ★★ Džbanovi (formulacija stanja, BFS naspram uniform-cost)

Imaš dva džbana bez oznaka: A zapremine 4 litra i B zapremine 3 litra, oba prazna na početku, i neograničen izvor vode. Cilj je da u džbanu **A** bude tačno 2 litra (u B može biti bilo šta). Akcije, redom kojim se razvijaju: (1) napuni A do vrha, (2) napuni B do vrha, (3) isprazni A, (4) isprazni B, (5) preliti iz A u B dok se A ne isprazni ili B ne napuni, (6) preliti iz B u A na isti način. Cena akcije je broj litara koji se uzme sa izvora (akcije 1 i 2 koštaju koliko se litara doda, ostale 0).

a) Predstavi stanje. Koliko ima mogućih stanja, a koliko je dostižnih iz početnog?
b) Primeni **BFS** (FIFO, stanje koje je već generisano se ne generiše ponovo). Navedi redosled ekspandovanja, nađeno rešenje (niz akcija), broj koraka i ukupno utrošenu vodu.
c) Koji algoritam daje rešenje sa najmanjom potrošnjom vode? Nađi to rešenje i njegovu cenu. Da li je rešenje iz b) optimalno po ceni? Da li je optimalno po broju koraka?

---

## Z2 ★★★ Putna mreža (svi algoritmi)

Mreža puteva (neusmereni): S–A 3, S–B 5, S–C 2, A–D 4, A–E 6, B–E 2, B–F 4, C–F 5, D–G 7, E–G 5, F–G 3.
Procena udaljenosti do cilja G: h(S)=7, h(A)=6, h(B)=4, h(C)=5, h(D)=4, h(E)=3, h(F)=3, h(G)=0.

Za putanju od S do G primeni sledeće algoritme. Za svaki navedi redosled ekspandovanja čvorova, nađenu putanju i njenu cenu:
a) po dubini (DFS)
b) po širini (BFS), uz proveru cilja na generisanom čvoru
c) prvo najbolji (best first, cela lista sortirana po h)
d) grananje i ograničavanje, uz dinamičko programiranje
e) A*, uz dinamičko programiranje (prikaži f = g + h za svaku generisanu putanju)
f) IDA* (navedi pragove)
g) Koji su algoritmi našli optimalnu putanju? Da li je h dopustiva i konzistentna? (kratko obrazloži)

---

## Z3 ★★★ Trgovački putnik, A* sa MST heuristikom (kao rok januar 2024)

Kurir treba da obiđe gradove A, B, C i D tačno jednom i da se vrati u A. Rastojanja: AB 4, AC 3, AD 7, BC 5, BD 4, CD 6.

a) Primeni **lokalno prvo najbolji** (najbliži neposećeni grad; pri izjednačenju abecedno). Koja je cena?
b) Primeni **A\*** gde je h(putanja) = cena minimalnog razapinjućeg stabla nad skupom {neposećeni gradovi, poslednji grad putanje, grad A}. Prikaži stablo, g, h i f za svaku generisanu putanju, redosled ekspandovanja, i rešenje.
c) Zašto ova h ne precenjuje stvarnu cenu preostalog puta?

---

## Z4 ★★ Heuristike: dopustivost i konzistentnost

Graf (neusmeren): S–A 2, S–B 1, A–C 2, B–C 5, A–G 7, C–G 3. Cilj je G.
Heuristike:

| čvor | S | A | B | C | G |
|---|---|---|---|---|---|
| h1 | 6 | 4 | 6 | 3 | 0 |
| h2 | 5 | 12 | 2 | 3 | 0 |
| h3 | 7 | 5 | 8 | 1 | 0 |

a) Odredi stvarnu cenu do cilja h*(n) za svaki čvor.
b) Koje od heuristika su dopustive? Koje su konzistentne? Navedi grane koje krše konzistentnost.
c) Primeni A* (stablo pretrage, bez dinamičkog programiranja) sa svakom od njih: redosled ekspandovanja, putanja, cena.
d) Koja heuristika daje neoptimalno rešenje i zašto? Da li A* sa nekonzistentnom, ali dopustivom heuristikom (h3) mora da da optimalno rešenje u stablu pretrage?

---

## Z5 ★★ CSP: raspored sala (kao vežbe Zadatak 1)

Pet asistenata čuva ispit u istom terminu; svaki ima spisak željenih sala (po prioritetu) i dva asistenta ne mogu biti u istoj sali:
- Ana: 103, 101
- Boris: 104, 102, 103
- Dara: 103, 105
- Egon: 101, 103, 105, 104
- Filip: 105, 103

Nacrtaj graf ograničenja i, primenom pretrage unazad sa **forward checking-om**, dodeli svakom asistentu salu. Promenljivu biraš sa minimalnim brojem preostalih vrednosti (izjednačenje leksikografski), vrednost po redosledu navođenja u listi. Piši domene posle svake dodele, i označi svaki backtrack.
Zatim ponovi sa **forward checking + konzistencija luka (AC-3) posle svake dodele** i uporedi broj dodela.

---

## Z6 ★★★ CSP: bojenje mape, FC + AC (kao vežbe Zadatak 2)

Mapa 6 država (susedstva): FR–BE, FR–DE, FR–CH, BE–NL, BE–DE, NL–DE, CH–DE, CH–AT, DE–AT. Boje: C (crvena), Z (zelena), P (plava). Susedne države ne mogu imati istu boju. Dodatno: Austrija ne želi plavu, Belgija ne želi zelenu, Švajcarska ne želi zelenu (unarna ograničenja primeni odmah).

Promenljive biraj po pravilu: najmanje preostalih vrednosti; ako je izjednačeno, ona koja učestvuje u najviše ograničenja sa nedodeljenim promenljivama; ako je i dalje izjednačeno, leksikografski. Vrednost biraj da najmanje ograničava susede (C, Z, P ako je izjednačeno). Posle svake dodele radi forward checking, pa AC-3. Prikaži domene posle svakog koraka i označi backtrack. Uporedi sa slučajem kada se radi samo forward checking (broj dodela).

---

## Z7 ★★ CSP: aritmetička ograničenja i AC-3 (kao Nova godina)

Promenljive A, B, C, D, E sa domenom {1, 2, 3, 4}. Ograničenja: A < B; B + C > 5; D = A + 2; C ≠ D; E ≥ D; C > E.

a) Primeni **AC-3** kao preprocesiranje. Početni red lukova: svi lukovi (X,Y), po abecedi; kad se domen od X smanji, na kraj reda se dodaju lukovi (Z,X) za sve susede Z (abecedno), ako već nisu u redu. Za svako brisanje napiši koja vrednost i zbog kojeg luka. Koji su konačni domeni?
b) Koliko ima rešenja? Nađi prvo rešenje pretragom unazad (promenljive A..E redom, vrednosti rastuće) nad domenima iz a). Da li je bio potreban backtrack?

---

## Z8 ★★ Simultana igra 3×3 (K2)

Marko (redovi R1-R3) i Jelena (kolone K1-K3) istovremeno biraju strategiju. Prva vrednost je Markov dobitak, druga Jelenin:

|  | K1 | K2 | K3 |
|---|---|---|---|
| **R1** | (6, 9) | (2, 2) | (9, 0) |
| **R2** | (4, 7) | (5, 5) | (9, 5) |
| **R3** | (3, 5) | (7, 3) | (8, 9) |

a) Postoji li dominantna strategija (striktna ili slaba) za nekog igrača?
b) Primeni iterativnu eliminaciju striktno dominiranih strategija; navedi redosled eliminacije.
c) Koji profil je Nešov ekvilibrijum? Koliko ih ima?
d) Koji su profili Pareto-optimalni? Da li je NE Pareto-optimalan? Zašto?
e) Marko ne zna da li je Jelena racionalna. Koju strategiju bira ako maksimizuje najgori mogući ishod?

---

## Z9 ★★★ Dopuni matricu (kao rok januar 2024, "Tajni spisi")

Matrica dobitaka (prva vrednost za Petra, druga za Maju), deo je oštećen:

|  | C | D |
|---|---|---|
| **A** | (−2, 4) | (0, 0) |
| **B** | (2, 4) | (x, y) |

Odredi sve celobrojne vrednosti x i y (uz kratko objašnjenje postupka) tako da važi, svaki uslov nezavisno:
a) Petar ima striktno dominantnu strategiju, Maja ima slabo (ali ne striktno) dominantnu strategiju, i profil (B, D) nije Pareto-optimalan.
b) U matrici ne postoji nijedan Nešov ekvilibrijum čistih strategija.
c) Profil mešovitih strategija u kome oba igrača igraju svoje dve strategije sa verovatnoćom 1/2 je mešoviti NE. Koliki je tada očekivani dobitak svakog igrača?

---

## Z10 ★★ Minimax i alfa-beta (kao K 2023, zadatak 2)

Stablo igre: koren (MAX) ima tri deteta (MIN), svako MIN dete ima dva deteta (MAX), a svako MAX dete ima dva lista. Listovi, redom sleva nadesno:

MIN-1: [8, 1] [7, 9] MIN-2: [4, −2] [3, 2] MIN-3: [6, −3] [−1, −5]

(Na primer, prvo MAX dete MIN-1 ima listove 8 i 1.)

a) Primeni minimax: vrednost svakog čvora, vrednost korena i potez MAX igrača.
b) Primeni alfa-beta odsecanje (sleva nadesno): za svaki čvor napiši (α, β), označi odsečene grane i navedi koliko je listova evaluirano.
c) Da li promena redosla dece korena menja broj evaluiranih listova? Navedi broj za svaku od 6 permutacija.
