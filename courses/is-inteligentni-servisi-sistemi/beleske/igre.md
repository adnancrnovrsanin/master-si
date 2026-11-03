# Teorija igara i pretraga u igrama

**Status za K1:** po vežbama `0_Uvod.pdf` (sl. 3, plan SI: K1 = algoritmi pretraživanja + metodi zadovoljenja ograničenja, K2 = teorija igara simultane i sekvencijalne + rad u neizvesnom okruženju, K3 = mašinsko učenje) i po SI Wiki, **igre su verovatno K2**, ne K1. Ostavljam ih spremljene za slučaj da se K1 gradivo pomeri. Stari K 2023 (SI Wiki) je imao igre i alfa-beta u istom kolokvijumu, vidi `tipovi-zadataka.md`.

Izvori: `vezbe/3_Teorija_igara_simultane_igre.pdf` (62 sl.), `vezbe/4_Teorija_igara_sekvencijalne_igre.pdf` (227 sl., većina su animacije koraka). Predavanje `IS_P4_Igre.pdf` je opšte i na ćirilici. Brojevi ispod su provereni skriptom.

---

## A. Simultane igre (normalna forma)

### Pojmovi (sl. 5-13)
- **Strategija ≠ potez.** Strategija je pravilo izbora poteza. **Čista** = igra jednu opciju sa 100%. **Mešovita** = verovatnoće po čistim strategijama, zbir 100%. **Profil** = po jedna strategija za svakog igrača.
- **Matrica isplativosti**: redovi = strategije prvog igrača, kolone = drugog; ćelija = (dobitak prvog, dobitak drugog).
- Pretpostavke: bitan je samo sopstveni dobitak, igra je poznata (potpune informacije), igrači su racionalni, nekooperativni, jedan potez.
- Tipovi: kooperativne/nekooperativne, simetrične/asimetrične, zero-sum/non-zero-sum, simultane/sekvencijalne.

### Dominantna strategija (sl. 17)
- **Striktno dominantna**: za **svaku** strategiju protivnika daje strogo veći dobitak od svake druge moje strategije.
- **Slabo dominantna**: za bar jednu strategiju protivnika strogo veći, za ostale ne manji (jednak).
- Ako postoji striktno dominantna, racionalan igrač je bira. (Dilema zatvorenika: svedoči je striktno dominantna za oba, NE = (svedoči, svedoči), dobitak (−5, −5).)

### Nešov ekvilibrijum (NE) (sl. 13)
Profil u kome nijedan igrač ne može da poveća dobitak **jednostrano** menjajući svoju strategiju. Svaka strategija u NE je najbolji odgovor na ostale.

**Recept (podvlačenje najboljih odgovora):**
1. Za svaku **kolonu** nađi najveći dobitak **prvog** igrača u toj koloni i označi ga (to je najbolji odgovor reda na tu kolonu). Ako ima izjednačenja, označi sve.
2. Za svaki **red** nađi najveći dobitak **drugog** igrača u tom redu i označi.
3. NE su ćelije u kojima su **oba** broja označena.
4. Proveri jednu ćeliju kontrolno: "da li neko dobija ako sam promeni?"

Kod 3 igrača: fiksiraj treću promenljivu, imaš dve matrice (kao na slajdu "Gicina kafana", sl. 60). Za svaku ćeliju proveri da li bilo ko od trojice ima bolju promenu. (Računao: u toj igri postoje 3 čista NE, u svakom tačno jedan ide u kafanu, a sva tri su Pareto-optimalna; simetrični mešoviti NE: svako ide sa verovatnoćom 1/3, jer 3p² − 10p + 3 = 0.)

### Iterirana eliminacija strogo dominiranih strategija
Ponavljaj: ukloni red/kolonu koja je strogo dominirana nekom drugom (u preostaloj matrici). Ako ostane jedna ćelija, to je jedinstveni NE. (Vežbanje Z8 je ovakva igra.)

### Pareto-optimalnost (sl. 19)
Profil je Pareto-optimalan ako ne postoji drugi profil u kome je bar jednom igraču bolje, a nikome gore. Provera: za svaku ćeliju traži ćeliju koja je ≥ za oba i > bar za jednog. Pazi: NE ne mora biti Pareto-optimalan (Dilema: (svedoči, svedoči) nije, jer (ne, ne) = (−1, −1) je bolje za oba).

### Koordinacione igre (sl. 20-28)
- Više NE; igrači moraju da usklade izbor. **Bitka polova**: NE (F,F) i (B,B), oba Pareto-optimalna. Rešenje iz dogovora: korelisani ekvilibrijum (bacanje novčića, naizmenično).
- **Lov na jelena** (5,5)/(0,4)/(4,0)/(2,2): NE (J,J) i (Z,Z). **Payoff-dominantan** = Pareto superiorniji (J,J). **Risk-dominantan** = manje rizičan (Z,Z). Uslov sa slajda 27: (PRVA,PRVA) je payoff-dominantan ako A ≥ D i a ≥ d (bar jedna stroga); (DRUGA,DRUGA) je risk-dominantan ako (D − C)(d − c) ≥ (A − B)(a − b). Ovde je A=a=5, B=b=4, C=c=0, D=d=2: (D − C)(d − c) = 2·2 = 4 ≥ (A − B)(a − b) = 1·1 = 1, pa je (Z,Z) risk-dominantan. Samo (J,J) je Pareto-optimalan.
- **Antikoordinaciona** (Kukavice): NE su parovi **različitih** strategija.

### Mešoviti NE u 2×2 (sl. 32-36)
Ideja: igrač bira verovatnoće tako da **protivnika učini ravnodušnim** između njegovih čistih strategija.

Primer Kukavice: redovi/kolone PRAVO, SKRENI; (0,0) (5,1) / (1,5) (3,3).
1. Neka drugi igrač igra PRAVO sa verovatnoćom q. Očekivani dobitak prvog: PRAVO: 0·q + 5(1−q); SKRENI: 1·q + 3(1−q).
2. Izjednači: 5 − 5q = q + 3 − 3q → 2 = 3q → q = 2/3.
3. Zbog simetrije i prvi igra PRAVO sa p = 2/3.
4. Očekivani dobitak oba: 0·2/3 + 5·1/3 = 5/3 (i 1·2/3 + 3·1/3 = 5/3). Verovatnoće profila: PRAVO–PRAVO 4/9, mešovito po 2/9, SKRENI–SKRENI 1/9; dobitak 4/9·0 + 2/9·5 + 2/9·1 + 1/9·3 = 15/9 = 5/3.
Evolucionarna simulacija sa slajdova 37-41 (populacija "hrabrih" i "kukavica") konvergira ka 66 : 33 = 2 : 1, tj. isto 2/3 : 1/3.

Opšti recept za 2×2: neka je a_ij dobitak prvog igrača u redu i, koloni j, a q = P(drugi igra kolonu 1):
q = (a22 − a12) / (a11 − a12 − a21 + a22); analogno p iz dobitaka drugog igrača (po redovima). Mora važiti 0 < p, q < 1, inače nema potpuno mešovitog NE.
Dodatno (nije rešavano na slajdovima, računao): Bitka polova ima i mešoviti NE: muž FUDBAL sa 2/3, žena FUDBAL sa 1/3, dobitak 2/3 za oba.

**Papir-kamen-makaze / novčić** (sl. 11, 44-45): nema čistog NE, jedini NE je mešovit (1/2, 1/2). Svaka konačna igra ima bar jedan NE, čist ili mešoviti (Nash, sl. 42).

### Racionalno donošenje odluka (sl. 43)
Dominantna strategija? → igraj je. Inače: znaš šta radi protivnik? → maksimizuj korist. Ne znaš: je li racionalan? Ako jeste i možete da se dogovorite oko NE → NE. Ako nije racionalan ili ne možete da se dogovorite → **maksimizuj najgori mogući ishod (maximin)**: za svaku svoju strategiju nađi minimalni dobitak po protivničkim strategijama, izaberi strategiju sa najvećim minimumom (Ulog, sl. 55: Miša bira strategiju 2).

### Potpuno uračunat primer: Ulog (sl. 52-55, provereno)
Miša (redovi 0,1,2) i Pera (kolone 0,1,2): (5,5) (0,9) (0,8) / (9,0) (4,4) (−1,8) / (8,0) (8,−1) (3,3).
- Dominantne strategije: nema (ni striktne ni slabe).
- Čist NE: **(2,2)**, dobitak (3,3). Provera: kad Pera igra 2, Miša ima 0, −1, 3 → bira 2; i obrnuto.
- Pareto-optimalni: (0,0) (5,5), (0,1) (0,9), (1,0) (9,0). (1,1) nije: (0,0) je bolje za oba.
- Potpuno mešovit NE: Pera 0,1,2 sa p, q, 1−p−q. Dobici Miše: 5p, 10p+5q−1, 5p+5q+3. Iz 5p = 5p+5q+3 sledi q = −3/5 < 0, nema.
- Maximin za Mišu: minimumi redova 0, −1, 3 → strategija 2.

### Primer: Subotnje veče (sl. 50-51; računao)
Devojke (Bioskop, Večera) × Momci (Društvene, Bilijar, Kuglanje): (0,2) (3,3) (3,3) / (3,3) (2,4) (4,2).
- Devojke: nema dominantne. Momci: **Bilijar je slabo dominantna** (3 ≥ 3 za red Bioskop, 4 > 2 za Večeru nad Kuglanjem; nad Društvenim striktno).
- Jedini čist NE: (Bioskop, Bilijar), dobitak (3,3). (Bioskop, Kuglanje) nije NE jer Devojke tada vole Večeru (4 > 3).

---

## B. Sekvencijalne igre (zero-sum, savršene informacije)

### Stablo igre (sl. 4-5)
Čvor = pozicija, grana = potez, nivo = igrač koji je na potezu. **Terminalni** čvor ima tačan rezultat (npr. +1 pobeda MAX, −1 pobeda MIN, 0 nerešeno). Faktor grananja i dubina određuju težinu. Transpozicije (isto stanje različitim putem) mogu se koristiti za ubrzanje.

### Minimax (sl. 6-8)
MAX bira potez sa najvećom vrednošću, MIN sa najmanjom (zero-sum: dobitak jednog = gubitak drugog).

**Recept:** 1) Nacrtaj stablo do listova (ili do zadate dubine). 2) Listove oceni. 3) Idi odozdo naviše: čvor na potezu MAX = max dece, MIN = min dece. 4) Odigrani potez = grana korena koja daje vrednost korena; sekvenca = prati vrednosti naniže.

**Primer: Novčići** (sl. 41-42; provereno): 6 novčića, igrači naizmenično uzimaju 1 ili 2, ko uzme poslednji novčić gubi. Vrednost po broju novčića n za igrača na potezu: n=1 gubi, n=2 dobija (uzme 1), n=3 dobija (uzme 2), n=4 gubi, n=5 dobija (uzme 1), n=6 dobija (uzme 2). **Persival (počinje) uzima 2 i pobeđuje** (protivnik ostaje na 4).

### Progresivno produbljivanje i funkcija procene (sl. 43-50)
Razvijaš stablo do dubine d, ne-terminalne čvorove ocenjuješ funkcijom procene (mora ostati u opsegu terminalnih vrednosti [B, A], inače MAX bira loš potez). Iks-oks: S1 = Σ_{x=1..2} a·10^(x−1) (a = broj linija u kojima igrač ima x oznaka a protivnik nijednu), S2 = Σ_{y=1..2} b·10^y (isto za protivnika), procena = S1 − S2 (zavisi ko je na potezu), terminalno ±1000. Ponavljaš za d = 1, 2, ...

### Alfa-beta (sl. 51-57, 79-80)
- α = najbolja vrednost koju MAX već sigurno ima (donja granica), β = najbolja koju MIN već ima (gornja). Inicijalno (−∞, +∞).
- MAX čvor ažurira α = max(α, vrednost deteta). MIN čvor ažurira β = min(β, vrednost deteta).
- **Odsecanje kad je α ≥ β:** preostala deca tog čvora se ne razmatraju.
- Prosleđuje se (α, β) nadole, vrednost nagore. Rezultat je isti kao kod minimaksa.
- Najbolji slučaj: b^(d/2) listova (dvostruka dubina za iste resurse); najgori: b^d. Redosled dece presudan.

**Primer (provereno):** koren MAX → 3 MIN čvora → po 2 MAX čvora → po 2 lista. Listovi redom: [−6, 1] [8, −5] | [3, 4] [5, 9] | [2, 0] [−4, −2].
- MIN-1: MAX(−6,1) = 1, β = 1. Drugi MAX čvor: list 8 daje α = 8 ≥ β = 1 → **odseci list −5**. MIN-1 = 1. Koren α = 1.
- MIN-2 (α = 1): MAX(3,4) = 4, β = 4. Drugi MAX čvor: list 5 daje α = 5 ≥ β = 4 → **odseci list 9**. MIN-2 = min(4, 5) = 4. Koren α = 4.
- MIN-3 (α = 4): MAX(2,0) = 2, β = 2 ≤ α = 4 → **odseci ceo drugi MAX čvor** (−4, −2). MIN-3 = 2.
- Koren = max(1, 4, 2) = **4**, potez ka MIN-2. Evaluirano 8 od 12 listova, odsečeno 4.

### Negamax (sl. 82-85, 114-145)
Isti rezultat kao minimax, jedan kod za oba igrača. Vrednost čvora iz ugla igrača na potezu: `score = max(−negamax(dete))`; terminalna vrednost se množi sa +1 (MAX) ili −1 (MIN) u zavisnosti ko je na potezu. Sa alfa-beta: poziv deteta ide sa prozorom (−β, −α). Odsecanje: α ≥ β.

### Negascout / PVS (sl. 146-210)
Unapređenje alfa-beta: **prvo dete** se ocenjuje punim prozorom (α, β); **ostala deca** prozorom nulte širine (−α−1, −α), samo da se potvrdi da nisu bolja. Ako se za neko dete ispostavi α < val < β (dete je bolje od prvog), mora se **ponoviti pretraga punim prozorom**. Dobro radi kad je prvo dete zaista najbolje (10-30% bolje od alfa-beta); sa slučajnim redosledom sporije jer ponavlja pretrage. Ne razmatra čvorove koje alfa-beta ne razmatra. (K 2023, SI Wiki, je tražio i alfa-beta i negascout na istom stablu.)

### Expectimax (stohastičko okruženje) (sl. 213-217)
Čvor šanse = **težinska suma** vrednosti dece (verovatnoće ishoda). MAX = max, MIN = min (ili čvor šanse umesto MIN kad protivnik nije optimalan). Alfa-beta se u opštem slučaju ne može primeniti, jer čvor šanse nije max/min.
Primer sa kockicom (sl. 216-217; provereno): P(mali broj 1-4) = 4/6, P(veliki 5-6) = 2/6. Igrač 1 bira M ili V; zatim igrač 2 bira (M ili V, različito od prvog) ili odustaje (O); zatim kockica.
- I1 = M: I2 = V → 4/6·12 + 2/6·(−3) = 7; I2 = O → 4/6·3 + 2/6·0 = 2. MIN bira 2.
- I1 = V: I2 = M → 4/6·(−6) + 2/6·15 = 1; I2 = O → 4/6·(−3) + 2/6·6 = 0. MIN bira 0.
- MAX bira M, vrednost igre **2**.

### MaxN (igre sa više igrača) (sl. 221-224)
Čvor sadrži **torku** dobitaka za sve igrače; na potezu je igrač i, bira dete sa najvećom i-tom komponentom i tu torku propagira nagore. (Ne postoji alfa-beta u opštem obliku.)

---

## Tipične greške
- Pobrkati strategiju i potez; ne naznačiti koja je strategija striktno, a koja slabo dominantna.
- Označiti NE gledajući samo jednog igrača (moraju biti označena oba broja u ćeliji).
- Pareto-optimalnost proveriti samo u odnosu na NE, a ne na sve ćelije.
- Mešoviti NE: verovatnoće računati iz **svog** dobitka umesto iz **protivnikovog** (igrač bira p tako da protivnik bude ravnodušan).
- Alfa-beta: odsecati kad je α > β umesto α ≥ β, ili preneti pogrešan (α, β) u dete. Zaboraviti da MAX čvor menja samo α, a MIN samo β.
- Negamax: zaboraviti negaciju listova ili zameniti redosled (−β, −α).
- Negascout: zaboraviti ponovnu pretragu kad je α < val < β.

Izvor: `vezbe/3_Teorija_igara_simultane_igre.pdf` sl. 5-61, `vezbe/4_Teorija_igara_sekvencijalne_igre.pdf` sl. 3-225.
