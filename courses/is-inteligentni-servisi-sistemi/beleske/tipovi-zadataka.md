# Tipovi zadataka (stari kolokvijumi i rokovi, zadaci sa vežbi)

## Šta ulazi u K1: sada postoji dokaz

Dve nezavisne potvrde (README predmeta je do sada imao samo pretpostavku):

1. **Vežbe `0_Uvod.pdf`, sl. 3 ("Plan i program SI")**: K1 = Algoritmi pretraživanja + Metodi zadovoljenja ograničenja; K2 = Teorija igara (sekvencijalne i simultane) + Rad u neizvesnom okruženju; K3 = nadgledano, nenadgledano mašinsko učenje, učenje sa podrškom. (Slajd je slika; pročitao sam ga kao sliku.)
2. **SI Wiki, stranica predmeta**: tri bloka koja se testiraju redom; prvi blok = algoritmi pretraživanja i metodi zadovoljenja ograničenja; drugi = teorija igara (simultane i sekvencijalne), produkcioni sistemi (samo predavanja), odlučivanje u neizvesnom okruženju; treći = mašinsko učenje.

Zaključak: **K1 = pretraživanje + CSP**. Igre su K2. Ostaje da se (formalno) potvrdi kod asistenata da se ništa nije pomerilo ove godine.

Napomena o ocenjivanju (0_Uvod sl. 6-7): za SI kolokvijumi K1 i K2 po 25%, ispit (zadaci + teorija) i projekti; RTI studenti imaju jedan kolokvijum K od 50 poena (K1+K2 zajedno). Moguće je polagati K1/K2 ponovo na ispitnom roku.

## Šta se tražilo na starim kolokvijumima i rokovima

**Izvor: SI Wiki (siwiki.rs/wiki/Интелигентни_системи/...). Tekstove zadataka sam parafrazirao (pročitao preko alata za čitanje stranice), nema rešenja na wikiju. Original proveri na wikiju.**

### K 2023 (kolokvijum, tri zadatka)
| Zad. | Poeni | Tema | Šta se traži |
|---|---|---|---|
| 1 | 15 | Teorija igara, **simultane, 3 igrača** (Kevin, Stuart, Bob biraju banane/jabuke; Bobov izbor bira jednu od dve 3-igračke matrice) | dominantne strategije (striktno/slabo), broj i obrazloženje NE, Pareto-optimalni profili, mešoviti NE sa udelima čistih strategija i dobitkom svakog igrača |
| 2 | 20 | Pretraga u igrama | a) dopuniti delimično nacrtano stablo **minimax sa alfa-beta**; b) isto stablo **negascout** (precrtati deo koji se ponovo obilazi, koraci) |
| 3 | 15 | Neizvesno zaključivanje (faktori izvesnosti, MB, MD) | pravila R1-R4, izvesnost dokaza e1-e6, izračunati izvesnost dve hipoteze i popuniti tabelu |

(Ovaj kolokvijum je dakle bio "igre + neizvesnost", tj. po današnjoj podeli K2, a ne K1.)

### Rok januar 2024 (SI Wiki, nerešeno; stranica ima samo naslove za prva dva zadatka)
- Zad. 1: (deo 1) **teorija simultanih igara uz dopunjavanje matrice** (nepoznati x, y); (deo 2) **algoritmi pretraživanja nad grafom, A\* sa heuristikom minimalno obuhvatno stablo** (isto što i TSP na vežbama).
- Zad. 2: **zadatak iz metoda zadovoljenja ograničenja**.
- Zad. 3: k-NN, k=3, Manhattan, normalizacija, tabela, tačnost/preciznost/odziv (20 p). Zad. 4: linearna regresija analitički (10 p). Zad. 5: teorija, k-means po koracima, "model školske table" (20 p).

### Rok februar 2024 (10.2.2024, 150 min, SI Wiki, nerešeno)
- Zad. 1 (**25 p, pretraga**): "zadatak sličan hanojskim kulama": rešenje sa **najmanje koraka** i rešenje sa **najmanjim naporom** (najmanja ukupna masa pomerenih kontejnera). Dakle: formulacija stanja + BFS (koraci) naspram B&B/UCS (cena = masa).
- Zad. 2 (**25 p, CSP**): "standardan zadatak iz metoda zadovoljenja ograničenja".
- Zad. 3: stablo odlučivanja entropijom + tačnost, odziv, preciznost. Zad. 4: k-means. Zad. 5 (teorija, 20 p): gradient descent i promena alfa; povratno i direktno ulančavanje.

### Studentska grupa (nepotvrđeno, iz README predmeta)
Ispit feb 2026: CSP, Nešov ekvilibrijum (simultane igre), ML zadaci (stablo odlučivanja, kNN).

### Zadaci sa vežbi (SI Wiki kaže da su stari K zadaci prebačeni u slajdove vežbi)
Pretraživanje (vežbe 1): Hanojske kule (modelovanje, graf i stablo), Čamac (broj stanja, bezbedna stanja), putna mreža (DFS, BFS, prvo najbolji, B&B, A*, IDA*), Svemir, Artur (B&B/DFS/BFS na mapi sa poljima), Planinari, Koralovo, Agraba (koji algoritam koristi koji lik), GoT (B&B za pokrivanje svih čvorova), **TSP** (greedy, A* sa MST heuristikom).
CSP (vežbe 2): raspored sala (FC), bojenje Afrike (FC+AC), Baltik, Bioskop, Keba (restoran, AC), Nova godina (aritmetika, FC+AC), ukrštene reči.

## Kako se rešava svaki tip (recepti su u beleškama)

| Tip zadatka | Šta je ključ | Gde je recept |
|---|---|---|
| "Formuliši stanje, broj stanja, graf prelaza" | Minimalno potpuno stanje, tabela n×n prelaza | `pretrazivanje.md` §1, §6 |
| "Koji algoritam koristi lik X?" (opis ponašanja) | "ide na sever pa istok" = DFS sa zadatim redosledom; "najmanje sela/koraka" = BFS; "najkraći/najbrži put iz mape" = B&B (ili A* ako ima h); "dobio je procenu pa ide ka njoj" = prvo najbolji; "lutaju, uvek najmanja oznaka, ne vraćaju se" = DFS sa abecednim redosledom | §2 konvencije |
| "Prikaži stablo, redosled obilaska, putanju, cenu" | Brojevi ekspanzije u čvorovima, cena putanje, napomena o DP i testu cilja | `pretrazivanje.md` §3, §5 |
| "Predloži heuristiku / da li je dopustiva" | Relaksacija problema; dokaz h ≤ h*; MST za TSP | §4 |
| "TSP: greedy i A*" | h = MST(neposećeni + tekući + start); izjednačenje navedi | §6, `zadaci/vezbanje.md` Z3 |
| "Min koraka vs min napora" (Hanoj-slično, Feb 2024) | BFS za korake, B&B/UCS za cenu poteza | `zadaci/vezbanje.md` Z1 |
| CSP raspored/bojenje, FC | MRV, stepen, LCV, FC, backtrack | `csp.md` §3-5 |
| CSP + AC-3 | red lukova, brisanje iz repa, ponovno dodavanje (Z, X) | `csp.md` §2, §7 |
| Aritmetička ograničenja, ukrštenice, Bioskop | model: promenljive, domeni, binarna ograničenja | `csp.md` §1, §6 |
| (K2) NE, dominantne, Pareto, mešoviti NE | podvuci najbolje odgovore, indiferentnost | `igre.md` A |
| (K2) minimax, alfa-beta, negascout | (α, β) i odsecanje kad α ≥ β | `igre.md` B |
| Dopuni matricu (x, y) uslovima (Jan 2024) | svaki uslov daje nejednakosti/jednakosti po x, y | `zadaci/vezbanje.md` Z9 |

## Šta nije potvrđeno
- Da li će ove godine K1 stvarno imati samo pretraživanje i CSP (po slajdu da).
- Koliko poena nosi koji zadatak na K1 (Feb 2024: pretraga 25, CSP 25 od ispita; K1 je 25% od ukupno).
- Da li K1 sadrži teoriju (po Uvodu: kolokvijumi se sastoje od zadataka, teorija je na ispitu).
