# Pretraživanje (prostor stanja, neinformisano i informisano)

K1 (potvrđeno, vidi `tipovi-zadataka.md`): ovo je prvi deo gradiva.
Glavni izvor: vežbe `1_Prostor_i_algoritmi_pretraživanja.pdf` (slajd = broj strane u PDF-u). Predavanja `IS_P2` i `IS_P3` su stariji slajdovi iz "Ekspertskih sistema", isti algoritmi, ali sa drugim imenima (planinarenje, prvo najbolji, grananje i ograničavanje).

Svi brojevi u primerima ispod provereni su Python skriptom (u `/private/tmp/.../scratchpad/is-agent/`, van repoa). Rezultati se poklapaju sa slajdovima vežbi (DFS, BFS, prvo najbolji, B&B, A*, IDA*, TSP).

## 1. Definicija problema

Problem pretraživanja čine (vežbe sl. 3-4):

- **inicijalno stanje**, **operatori** (akcije), **tranzicioni model** (šta akcija radi u svakom stanju). Zajedno definišu **prostor stanja** (graf: stanja = čvorovi, akcije = grane).
- **ciljno stanje** (ili test cilja), **cena putanje** (obično zbir cena grana).
- **Rešenje** = niz operatora od starta do cilja. **Optimalno** = najmanja cena.

Dva pojma koja se stalno mešaju:

- **graf pretrage** = ceo prostor stanja (petlje postoje, svako stanje jednom).
- **stablo pretrage** = ono što algoritam gradi: koren = start, svaka parcijalna putanja je poseban čvor. Isto stanje se može pojaviti više puta. Na vežbama se petlje po putanji ne prave (ne vraćaš se u čvor koji je već na toj putanji).
- **Ekspandovati** čvor = generisati sve njegove sledbenike. **Generisan** ≠ **ekspandovan**.

### Kako se modeluje stanje (Hanojske kule, Čamac)

Stanje treba da bude minimalno ali potpuno. Hanoj sa 2 diska: `(x, y)` = broj štapa velikog i malog diska (sl. 6-7). Čamac: `(p, h, č)` = policajci i huligani na levoj obali, obala čamca (sl. 16). Ako se u zadatku traži "ukupan broj stanja", prvo broji sve kombinacije, pa tek onda izbaci nedozvoljene.

## 2. Zajednička šema svih algoritama

Svi algoritmi sa vežbi imaju istu petlju, razlikuju se samo u tome gde ubacuješ nove putanje i po čemu sortiraš:

```
lista = [ [start] ]
dok lista nije prazna:
    p = lista.pop(0)               # prvi element
    ako je poslednji čvor p cilj  -> kraj (rešenje p)
    nove = [p + [s] za svakog sledbenika s poslednjeg čvora (abecedno, bez čvorova koji su već u p)]
    ubaci nove u listu (po pravilu algoritma)
```

| Algoritam (naziv na vežbama) | Gde ide `nove` / ključ sortiranja | Optimalan? | Napomena |
|---|---|---|---|
| Po dubini (DFS) | na **početak** liste (stek) | ne | može da zaglavi u beskonačnoj grani; memorija O(b·m) |
| Po širini (BFS) | na **kraj** liste (red) | da, samo u broju koraka (ne u ceni) | test cilja sme pri generisanju |
| Lokalno prvo najbolji (greedy local best first, planinarenje/hill-climbing) | `nove` sortiraj po h i stavi na **početak** | ne | bira samo među sledbenicima tekućeg čvora, ali ima povratak (lista) |
| Prvo najbolji (best first) | **cela** lista sortirana po **h** | ne | ne gleda cenu već pređenog puta |
| Grananje i ograničavanje (branch and bound, = uniform-cost) | cela lista sortirana po **g** (cena putanje) | da | test cilja **pri ekspanziji** |
| A* | cela lista sortirana po **f = g + h** | da, ako h ne precenjuje | test cilja pri ekspanziji |
| IDA* | DFS sa pragom na f | da, ako h ne precenjuje | malo memorije, ponavlja čvorove |

Dodatno (nije na slajdovima vežbi, opšte znanje): iterative deepening DFS = DFS sa ograničenjem dubine 0, 1, 2, ... Potpun i optimalan u broju koraka, memorija O(b·d). Pomeni samo ako ti pitanje to traži.

### Konvencije sa vežbi (da ne izgubiš poene na sitnicama)

1. **Redosled sledbenika**: ako zadatak ne kaže drugačije, abecedno (npr. "alfabetski poredak kao heuristika", Agraba sl. 68). Ako zadatak kaže "prednost sever, istok, jug, zapad" (Artur sl. 60), to je redosled sledbenika za DFS.
2. **Bez petlji po putanji**: ne dodaješ sledbenika koji je već na putanji koja se produžava.
3. **Test cilja**: za B&B i A* mora na **ekspandovanom** čvoru (generisani cilj može biti na lošijoj putanji, sl. 34). BFS (i DFS) smeju na generisanom čvoru (sl. 34). U postavci piše "proveru ciljnog čvora na generisani čvor ... ukoliko navedene tehnike smeju da se koriste u odabranom algoritmu" (Koralovo/Agraba): odgovor je da za BFS sme, za B&B/A* ne sme.
4. **Dinamičko programiranje (DP)**: ako dve putanje u listi završavaju u istom čvoru, zadrži samo jeftiniju (P3 slajd A*, korak 2.2.6; vežbe Artur). Sme za B&B i A*. Rezultat ostaje isti, samo je manje čvorova.
5. **Izjednačenje**: slajdovi ne propisuju. Iz primera TSP (sl. 84-88) se vidi da kod jednakog f ide ispred **novije generisana** putanja (A* je tamo birao ABD pa ABE a ne starije AD i ACD). Zato u zadatku uvek piši kojim pravilom si razrešio izjednačenje, a ako u postavci piše pravilo (abecedno, leksikografski), njega slediš.
6. **Oznake u slajdovima**: čvorovi u stablima imaju oznaku `h+g` (prvo h, pa g, npr. `5+3`), kvadratić sa brojem je redosled ekspanzije.

## 3. Recepti korak po korak

### DFS
1. Lista = [start].
2. Skini prvi. Ako je cilj, kraj.
3. Sledbenike (abecedno) stavi na **početak** liste, tako da prvi sledbenik bude prvi u listi.
4. Ponavljaj. Redosled ekspanzije = redosled skidanja.

### BFS
Isto, ali sledbenike stavljaš na **kraj**. Možeš da proveravaš cilj pri generisanju (zapiši da to radiš).

### Prvo najbolji (global) i lokalno prvo najbolji (greedy)
- Global: posle dodavanja sledbenika **sortiraj celu listu** po h (rastuće).
- Lokalni (sl. 52, 76): sortiraš samo nove sledbenike po h i stavljaš ih na početak. Za TSP "prioritet najbližem neposećenom čvoru".
- Oba ignorišu g, pa nisu optimalni, čak i kad h potcenjuje (sl. 29).

### Grananje i ograničavanje (B&B / uniform-cost)
1. Lista parcijalnih putanja, sortirana po ceni putanje g.
2. Skini prvu. Ako dostiže cilj, kraj (cilj na ekspanziji).
3. Napravi putanje za sve sledbenike, izračunaj kumulativnu cenu, ubaci, sortiraj.
4. (DP) Za isti poslednji čvor zadrži jeftiniju.
Garancija optimuma: kad se čvor X ekspanduje, putanja do X je već optimalna (cene ≥ 0), sl. 32.

### A*
Isto kao B&B, ali ključ je **f(n) = g(n) + h(n)**. Optimalan ako h ne precenjuje. Ako je h = 0, A* postaje B&B (sl. 44).

### IDA* (sl. 45-49)
1. prag = f(start) = h(start).
2. DFS (stek) po stablu, u listu dodaješ samo sledbenike sa f ≤ prag; ostale **odbaci** i zapamti njihove f.
3. Ako nađeš cilj, kraj. Ako ne, novi prag = **minimum f odbačenih** čvorova, pa ceo postupak iz početka.
IDA* drži samo jednu putanju (malo memorije) ali ponovo obilazi iste čvorove; A* drži sve otvorene putanje (mnogo memorije, manje vremena, sl. 49).

## 4. Heuristike

Definicije (sl. 27, 37):

- **h(n)** = procena cene najjeftinije putanje od n do cilja. **g(n)** = cena putanje od starta do n. **f = g + h**.
- **Dopustiva** (potcenjuje, "ne precenjuje"): h(n) ≤ h*(n) za svako n, gde je h* prava cena do cilja. Slajdovi to zovu "heuristika potcenjuje cenu rešenja".
- **Konzistentna**: h(n) ≤ c(n, n') + h(n') za svaku granu n→n' (i h(cilj) = 0). Konzistentna ⇒ dopustiva (obrnuto ne važi). Na slajdovima vežbi konzistentnost nije pomenuta pod tim imenom; to je standardna definicija iz Russell & Norvig i može da se pita kao teorija.
- Precenjivanje: A* ne garantuje optimum (sl. 38-40), iako se ponekad desi da ga nađe.
- Tačna heuristika (h = h*) daje optimum sa najmanje ekspandovanih čvorova; što je h bliže h* (a ispod njega), to manje ekspanzija (sl. 41-44). Poređenje dve dopustive heuristike: veća (dominantna) je bolja, jer ekspanduje manje čvorova.
- **Dobra heuristika za TSP** (sl. 78-83): h = cena **minimalnog razapinjućeg stabla (MST)** nad skupom {neposećeni čvorovi, tekući (poslednji) čvor putanje, start}. Ne može da bude veća od stvarne cene preostalog puta, pa je dopustiva. MST kreiraš Kruskalom: biraj najjeftiniju granu koja ne pravi petlju, dok se sve ne poveže.
- Druga heuristika za TSP (sl. 76): najbliži neposećeni sused (greedy), ali to nije dopustiva procena, nego strategija.

**Važan nalaz (proverio skriptom):** heuristika iz Zadatka 2 (sl. 18: A=5, B=6, C=8, D=9, E=5, F=2, S=8) **nije dopustiva**: h(C)=8 > 5 (stvarno C→F→G = 5) i h(D)=9 > 6. A* ipak pronalazi optimum (SAECFG, 9), ali to je sreća, ne garancija. Slajd 37 to ilustruje: kad bi E-G bilo 8 umesto 10, A* bi vratio SAEG (cena 11), a optimum je i dalje 9. Na ispitu se ne oslanjaj na to da su date h dopustive, proveri.

## 5. Potpuno uračunat primer: putna mreža (vežbe, Zadatak 2, sl. 18-49)

Grane (cene): S-A 2, S-B 4, A-C 4, A-E 1, C-D 1, C-E 1, C-F 3, E-G 10, F-G 2, B-G 11.
Heuristika h: A=5, B=6, C=8, D=9, E=5, F=2, G=0, a S=8 (sl. 48 "Neka je S = 8").
Sledbenici abecedno.

| Algoritam | Redosled ekspanzije | Putanja | Cena |
|---|---|---|---|
| DFS | S, A, C, D, E, G | SACEG | 17 |
| BFS | S, A, B, C, E, G | SBG | 15 (optimalno po broju grana) |
| Prvo najbolji | S, A, E, G | SAEG | 13 |
| B&B (sa DP) | S, A, E, C, B, D, F, G (cene 0, 2, 3, 4, 4, 5, 7, 9) | SAECFG | 9 |
| A* | S, A, E, B, C, F, G | SAECFG | 9 |
| IDA* | pragovi 8, 10, 12 | SAECFG | 9 |

(Tačan redosled B&B pri izjednačenju zavisi od pravila za izjednačenje.)

**A* korak po korak** (oznaka `putanja: g + h = f`):

1. Ekspanzija S: A (2+5=7), B (4+6=10). Lista: A7, B10.
2. Ekspanzija A (7): SAC (6+8=14), SAE (3+5=8). Lista: SAE8, SB10, SAC14.
3. Ekspanzija SAE (8): SAEC (4+8=12), SAEG (13+0=13). Lista: SB10, SAEC12, SAEG13, SAC14.
4. Ekspanzija SB (10): SBG (15+0=15). Lista: SAEC12, SAEG13, SAC14, SBG15.
5. Ekspanzija SAEC (12): SAECD (5+9=14), SAECF (7+2=9). Lista: SAECF9, SAEG13, SAECD14, SAC14, SBG15.
6. Ekspanzija SAECF (9): SAECFG (9+0=9). Lista: SAECFG9, ...
7. Prvi u listi je cilj: SAECFG, cena 9. Ovo je tačno redosled 1-7 sa slajda 36.

**IDA***: prag 8: S(8), A(7), E(8) prolaze; B(10), C(14), SAEC(12), SAEG(13) odbačeni, novi prag = min(10, 14, 12, 13) = 10. Prag 10: dodatno B (10), odbačeni SBG 15, ..., novi prag 12. Prag 12: SAEC (12) prolazi, SAECF (9), cilj SAECFG. (Pragovi 8, 10, 12 kao na sl. 46-48.)

## 6. Drugi primeri sa vežbi (provereno)

- **Hanoj, 2 diska** (sl. 5-14): 9 stanja (x, y), x,y ∈ {1,2,3}; start (1,1), cilj (3,3); 12 grana prostora stanja. Iz (1,1): (1,2), (1,3). Iz (1,2): (1,1), (1,3), (3,2). Najkraće rešenje 3 poteza: (1,1)→(1,2)→(3,2)→(3,3). Prelaz (1,2)→(2,2) nije moguć (veliki disk ne sme na mali).
- **Čamac** (sl. 15-17): 4·4·2 = 32 stanja, bezbedno 20 (svi policajci na jednoj obali: 8+8, ili p = h za p ∈ {1,2}: 4). Najmanje 11 prelazaka (BFS).
- **TSP** (sl. 74-88), učionice A-E, grane AB 7, BC 7, BD 10, BE 10, AE 13, AC 6, CE 9, CD 8, AD 10, DE 6: greedy najbliži sused daje ACBDEA = 42, A* sa MST heuristikom daje ABEDCA = 37 (optimum, proverio brute-force). h(koren) = MST({A,B,C,D,E}) = 27. Redosled ekspanzije A*: A, AC, AB, ABC, ACB, ABD, ABE, ABED, ABEDC, ABEDCA (tačno kao brojevi na sl. 88).

## 7. Tipične greške

- Zaboraviš da A*/B&B proveravaju cilj pri **ekspanziji**: čim generišeš G, staneš. Pogrešno.
- Praviš petlje (vraćaš se u roditelja). Na vežbama se ne vraća po putanji.
- Sortiraš A* po h ili po g umesto po f. Ili B&B po f.
- Pomešaš `h+g` sa `g+h` na crtežu (ista suma, ali rđavo prepisivanje).
- Tvrdiš da je BFS optimalan "uvek". Optimalan je samo kad su sve cene grana jednake.
- Kažeš da je A* optimalan bez provere da h ne precenjuje.
- IDA*: novi prag je **minimum** odbačenih f, ne najmanji prethodni prag + 1.
- Ne napišeš kojim pravilom razrešavaš izjednačenje.

## 8. Šta još može da se pita (teorija sa vežbi)

- Koja struktura odgovara DFS / BFS: stek (LIFO) / red (FIFO) (sl. 22, 25).
- Da li test cilja ide na generisan ili ekspandovan čvor (sl. 34).
- Razlika A* i IDA* (sl. 49), šta ako h precenjuje (sl. 38-40), kad h=0 (sl. 44).
- TSP je NP-težak, brute-force n! (sl. 75).

Izvor: `materijali/vezbe/1_Prostor_i_algoritmi_pretraživanja.pdf` (sl. 3-4 definicije, 18-49 Zadatak 2, 74-88 TSP), `materijali/predavanja/IS_P3_Strategije_pretrazivanja.pdf` (opisi algoritama, A* korak 2.2.6 DP), `IS_P2` (faktor grananja, funkcija procene, S = H + Ctot).
