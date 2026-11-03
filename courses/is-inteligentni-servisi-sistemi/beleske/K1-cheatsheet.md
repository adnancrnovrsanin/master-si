# K1 cheatsheet (cilj: 2 štampane strane)

K1 = **pretraživanje + CSP** (vežbe `0_Uvod` sl. 3, SI Wiki). Igre su K2. Detalji: `pretrazivanje.md`, `csp.md`, `igre.md`, `tipovi-zadataka.md`.

## 1. Pretraživanje

**Svaki algoritam = ista petlja:** lista putanja → skini prvu → cilj? → sledbenici (abecedno, bez čvorova već na putanji) → ubaci po pravilu.

| Algoritam | Ubacivanje / ključ | Optimalan | Cilj testiraj |
|---|---|---|---|
| DFS | nove na početak (stek) | ne | gen. ili eksp. |
| BFS | nove na kraj (red) | samo po broju grana | **gen. sme** |
| Lokalno prvo najbolji (greedy) | nove sortirane po h na početak | ne | eksp. |
| Prvo najbolji | cela lista po **h** | ne | eksp. |
| Grananje i ogr. (B&B, uniform-cost) | cela lista po **g** | da | **eksp.** |
| A* | cela lista po **f = g + h** | da ako h ne precenjuje | **eksp.** |
| IDA* | DFS sa pragom f; prag = min odbačenih f | da ako h ne precenjuje | eksp. |

- **DP**: dve putanje u listi sa istim poslednjim čvorom → zadrži jeftiniju (B&B, A*).
- Izjednačenje: u postavci; inače napiši pravilo (na slajdovima TSP ide ispred novije generisana putanja).
- Oznaka u stablima sa slajdova: `h+g` (npr. `5+3`), kvadratić = redosled ekspanzije.
- **IDA***: prag0 = h(start); u DFS-u pamti samo sledbenike sa f ≤ prag; novi prag = **min f odbačenih**. Malo memorije, ponavlja čvorove.
- h = 0 ⇒ A* = B&B. Tačna h ⇒ najmanje ekspanzija. h precenjuje ⇒ nema garancije optimuma.
- **Dopustiva**: h(n) ≤ h*(n). **Konzistentna**: h(n) ≤ c(n,n') + h(n') (⇒ dopustiva).
- **Pažnja:** heuristika sa slajda 18 (vežbe 1) NIJE dopustiva (h(C)=8>5, h(D)=9>6); A* ipak nađe optimum (SAECFG, 9). Proveri dopustivost sam.
- Putna mreža (provereno): DFS SACEG 17, BFS SBG 15, prvo najbolji SAEG 13, B&B/A*/IDA* SAECFG 9, IDA* pragovi 8-10-12.
- **TSP**: stanje = putanja; h = **MST nad {neposećeni, poslednji čvor, start}** (Kruskal); greedy = najbliži neposećeni. Primer sa vežbi: greedy ACBDEA 42, A* ABEDCA 37, h(koren) = 27.
- Modelovanje: stanje minimalno a potpuno; Hanoj 2 diska (x,y) = 9 stanja; Čamac (p,h,č) = 32 stanja, 20 bezbednih, 11 prelazaka; "min koraka" = BFS, "min napora/mase" = B&B.

## 2. CSP

**CSP = (X, D, C).** Konzistentna dodela = ne krši ograničenja; rešenje = potpuna + konzistentna. Unarna ograničenja primeni odmah (skrati domen).
Model: promenljive = ono što dodeljuješ (nastavnici, regioni, osobe), domen = vrednosti (sale, boje, sedišta), ograničenja binarna (≠, |a−b|=1, |a−b|≥3, aritmetika).

**Backtracking po receptu (jedna iteracija):**
1. **Promenljiva:** MRV (najmanje preostalih vrednosti) → stepen (najviše ograničenja sa **nedodeljenim**) → leksikografski / kako piše.
2. **Vrednost:** LCV (izbaci najmanje vrednosti iz suseda) → redosled navođenja (npr. crvena, zelena, plava).
3. **Dodeli + FC:** izbaci vrednost iz domena nedodeljenih suseda.
4. **AC-3 (ako se traži):** red lukova; luk (X,Y): za svako x ∈ D(X) mora postojati y ∈ D(Y); inače **briši x iz D(X)** (iz repa). Ako D(X) promenjen → dodaj (Z,X) za sve susede Z. Prazan domen = neuspeh.
5. **Prazan domen ⇒ BACKTRACK:** vrati domene, sledeća vrednost; nema je → nazad na prethodnu promenljivu.
6. Na kraju proveri sva ograničenja.

- Redosled lukova ne menja konačne domene (menja samo broj koraka).
- FC ne vidi sve (npr. NT i SA ne mogu obe biti plave); FC + AC (= MAC) vidi više.
- AC-3 složenost O(c·d³). AC kao preprocesiranje je jeftin, dinamički skuplji (vraćanje domena).
- Lokalna pretraga: hill climbing (zaglavi u lokalnom optimumu/platou, lek: restart), simulirano kaljenje (prihvata i lošije), min-konflikti.
- Provereno: raspored sala (Adrian Lola-AMF, Boško 61, Vladimir 309, Dražen 57; 6 dodela, sa AC 5). Afrika: IA R, K G, E G, JA B, SA B, M R (redosled IA, K, E, JA, SA, M).

**Tipične greške:** stepen po svim susedima (treba po nedodeljenim) · brisanje iz pogrešnog domena u AC · zaboravljene (Z,X) posle promene · pogrešan nivo backtrack-a · test cilja na generisanom čvoru za A*/B&B · A* optimalan bez provere h · petlje po putanji.

## 3. Igre (K2, ako se pomeri)

- **NE** = niko ne dobija jednostranom promenom. U svakoj koloni podvuci najveći prvi broj, u svakom redu najveći drugi broj; NE = ćelija sa oba podvučena. **Dominantna:** striktna (veća za svaku protivnikovu) / slaba (veća za bar jednu, ne manja za ostale). **Pareto:** nema profila bolje za nekog a ne gore za druge. NE ≠ Pareto (Dilema).
- **Mešoviti 2×2:** bira p tako da je **protivnik** ravnodušan. Kukavice: p = q = 2/3, dobitak 5/3. q = (a22 − a12)/(a11 − a12 − a21 + a22).
- **Maximin** (protivnik neracionalan): max po svojim strategijama od min po protivnikovim.
- **Koordinacione:** payoff-dominantan (Pareto bolji) vs risk-dominantan: (D−C)(d−c) ≥ (A−B)(a−b).
- **Minimax:** MAX max, MIN min, odozdo naviše. **Alfa-beta:** α (MAX), β (MIN), (−∞,+∞), odseci kad **α ≥ β**; najbolji slučaj b^(d/2). **Negamax:** −negamax(dete), prozor (−β,−α). **Negascout:** prvo dete pun prozor, ostala (−α−1,−α), ponovi ako α < val < β. **Expectimax:** čvor šanse = težinska suma. **MaxN:** torke, igrač i maksimizuje i-tu komponentu.
