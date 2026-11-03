# 06. Oporavak od grešaka kod parsera od dna ka vrhu (panic mode, yacc/CUP)

**Izvor:** `PP1_P06a.pdf` (svih 8 slajdova), udžbenik `pp1_udzbenik.pdf` str. 106–112, vežbe `BottomUp.doc` (poglavlje "Oporavak od grešaka", zadaci 1–2), `PP1_P08.pdf` str. 55–56 (oporavak u rekurzivnom spustu, vidi i beleška 07).

## 1. Definicije (2–3 rečenice)

- **Simbol povrede** je ulazni simbol na kome je parser otkrio grešku (prazno polje, `REJECT`, u kontrolnoj tabeli). Parseri koje gradimo imaju **svojstvo ispravnog prefiksa**: niz pre simbola povrede je prefiks neke ispravne sekvence, pa oporavak nikad ne traži vraćanje na ulazu, samo izmenu steka i/ili preostalog ulaza.
- Odgovori kompajlera na grešku: **detekcija** (poruka: vrh steka, tekući simbol, linija), **oporavak** (nastavak analize da se nađu i druge greške, bez generisanja izlaznog programa) i **popravak** (pokušaj da se napravi ispravan program, teorijski). **Neprihvatljivo**: ne otkriti grešku, otkazati (greška u izvršavanju kompajlera), beskonačno ponavljati istu grešku. Kvalitet oporavka se meri time koliko malo se prijavljuje **nepostojećih** grešaka.
- **Panic mode**: pokušaj izlaska iz konstrukta u kome je greška nastala traženjem **sigurnog simbola** (terminator naredbe, `end`, `─┤`, …) od koga se može normalno nastaviti.

## 2. Algoritmi korak po korak

### 2.1 Jednostavan panic mode (PP1_P06a str. 3, udžbenik str. 108)

Zadaje se skup **sigurnih simbola** (npr. `;`, `end`, `b`, `d`).

1. **Greška** (ćelija kontrolne tabele je `REJECT`). Sa ulaza redom uklanjaj simbole **dok tekući nije siguran**. Ako je simbol povrede već siguran, ništa se ne uklanja.
2. Sa steka skidaj stanja (`POP`) **dok vršno stanje ne može da potisne siguran simbol** na stek: u **potisnoj tabeli**, vrsta vršnog stanja ima neprazan ulaz u koloni sigurnog simbola. Ako se skine sve do `∇` i ni `∇` ne može da potisne taj simbol, oporavak je neuspešan.
3. **Nastavi parsiranje na uobičajen način** (prva akcija je obično `SHIFT` sigurnog simbola, jer potisna tabela ima ulaz).

*Pretpostavka koju treba uokviriti na K:* `─┤` se smatra sigurnim simbolom (kraj ulaza se ne sme preskočiti). Slajdovi navode `─┤` među primerima sigurnih simbola.

Ne radi dobro kad su konstrukti ugnježdeni (dovoljna je zagrada ili blok unutar bloka): preskoči početak ugnježdenog konstrukta pa spoljašnji završetak upari sa unutrašnjim.

### 2.2 Poboljšani panic mode (sigurni simboli + simboli zaglavlja)

Dodatno se zadaje skup **simbola zaglavlja** (header), komplementarnih sigurnim (npr. `begin` ↔ `end`, `if` ↔ `endif`).

1. Greška: sa ulaza uklanjaj simbole dok se ne naiđe na **siguran simbol ili simbol zaglavlja** (ni jedan se ne preskače).
2. a) **Siguran simbol**: kao u 2.1 (skidaj stek dok vrh ne može da ga potisne). b) **Simbol zaglavlja**: potisni ga na stek i **markiraj** (nešto kao lažno dno steka; od njega se parsira kao da počinje nov konstrukt).
3. Parsiranje se nastavlja normalno. **Kada se redukcijom ukloni markirani simbol sa steka, vraćaš se na korak 1** (ponovo se uklanja ulaz do sigurnog/zaglavlja i popravlja stek, jer prvobitna greška još nije razrešena).

Korak 2b i 3 omogućavaju da se ugnježdeni konstrukti (počinju zaglavljem, završavaju sigurnim simbolom) upare kako treba.

### 2.3 yacc/CUP oporavak (PP1_P06a str. 5–8)

- U gramatiku se dodaju smene sa specijalnim simbolom `error` (tretira se kao neterminal koji se ne izvodi smenama): `stmt : error ';'`, `primary : '(' error ')'`.
- **Algoritam**: po detekciji greške skidaju se stanja sa steka dok se ne nađe stanje koje ima konfiguraciju `X → … • error …`; `error` se potiskuje; preskaču se ulazni tokeni dok ne naiđe onaj koji parser očekuje; nastavlja se bez izvršavanja semantičkih akcija. Ako se uspešno procesira **bar 3 tokena**, ulaz se resetuje na mesto gde je počelo preskakanje i normalno se parsira (sa akcijama); ako ne, odbacuje se sledeći token. Ako se stigne do kraja ulaza ili se isprazni stek, parser neuspešno završava.
- Posle prve prijave greške **neće se prijavljivati nove** dok ne prođu 3 ispravno procesirana tokena (suzbijanje lažnih prijava). `yyerrok` u semantičkoj akciji odmah ponovo dozvoljava prijavu.
- Gde dodati pravila: `stmt: error ';'` (preskoči ostatak naredbe) i uparivanje zagrada `'(' error ')'` (da zatvorena zagrada ne izgleda kao neuparena).
- Primer iz vežbi: `I → a = b + c ;` i `I → a = error ;`, ulaz `a=b+d+c;`: posle `a = b +` i greške na `d`, stek se skida (`POP, POP`) do `a =` (iza koga može `error`), potisne se `error`, preskaču se `d + c`, `;` se potisne i `REDUCE(a = error ;)`, pa `REDUCE`/`ACCEPT`.

## 3. Primeri

### 3.1 Gramatika iz K 26.11.2021 (LALR(1), `S → A A`, `A → A a A b | c | d`) i sigurni simboli `b`, `d`

Stanja i tabele su u beleški 05 (primer 3.3). Potisna tabela (potrebna za korak 2 oporavka):

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

**(a) Samo odbacivanje ulaza**: ulaz `caccbd`. Posle `c a c` (stek `∇ A12 a2 A2` posle redukcije) stiže `c`, a stanje `A2` očekuje `a` ili `b`: greška. `c` nije siguran, odbacuje se. Sledeći `b` jeste siguran, a `A2` ima potisni ulaz za `b` (`b2`), pa se ništa ne skida sa steka:

| # | stek | preostali ulaz | akcija |
|---|---|---|---|
| 1 | ∇ | c a c c b d ─┤ | SHIFT |
| 2 | ∇ c3 | a c c b d ─┤ | REDUCE(3) A -> c |
| 3 | ∇ A12 | a c c b d ─┤ | SHIFT |
| 4 | ∇ A12 a2 | c c b d ─┤ | SHIFT |
| 5 | ∇ A12 a2 c3 | c b d ─┤ | REDUCE(3) A -> c |
| 6 | ∇ A12 a2 A2 | c b d ─┤ | GREŠKA: vrh A2, ulaz c |
| 7 | ∇ A12 a2 A2 | b d ─┤ | odbaci ulaz, sledeći je b |
| 8 | ∇ A12 a2 A2 | b d ─┤ | SHIFT |
| 9 | ∇ A12 a2 A2 b2 | d ─┤ | REDUCE(2) A -> A a A b |
| 10 | ∇ A12 | d ─┤ | SHIFT |
| 11 | ∇ A12 d4 | ─┤ | REDUCE(4) A -> d |
| 12 | ∇ A12 A12' | ─┤ | REDUCE(1) S -> A A |
| 13 | ∇ S0 | ─┤ | SHIFT |
| 14 | ∇ S0 ─┤0 |  | ACCEPT |

**(b) Samo skidanje steka**: ulaz `cdd`. Posle `c d` oba `A` su gotova (stek `∇ A12 A12'`), pa treći simbol `d` nema prelaz u `A12'` (to stanje prima samo `a` ili `─┤`). `d` je siguran pa se ništa ne odbacuje. `A12'` ne može da potisne `d`, skida se; `A12` može (potisna: `d4`):

| # | stek | preostali ulaz | akcija |
|---|---|---|---|
| 1 | ∇ | c d d ─┤ | SHIFT |
| 2 | ∇ c3 | d d ─┤ | REDUCE(3) A -> c |
| 3 | ∇ A12 | d d ─┤ | SHIFT |
| 4 | ∇ A12 d4 | d ─┤ | REDUCE(4) A -> d |
| 5 | ∇ A12 A12' | d ─┤ | GREŠKA: vrh A12', ulaz d |
| 6 | ∇ A12 A12' | d ─┤ | POP |
| 7 | ∇ A12 | d ─┤ | SHIFT |
| 8 | ∇ A12 d4 | ─┤ | REDUCE(4) A -> d |
| 9 | ∇ A12 A12' | ─┤ | REDUCE(1) S -> A A |
| 10 | ∇ S0 | ─┤ | SHIFT |
| 11 | ∇ S0 ─┤0 |  | ACCEPT |

**(c) Neuspeh**: ulaz `cab`: posle `c a` simbol `b` je siguran, ali nijedno stanje na steku (`a2`, `A12`, `∇`) ne može da potisne `b` (samo `A2` ima `b2`, a nije na steku). Stek se prazni i oporavak ne uspeva:

| # | stek | preostali ulaz | akcija |
|---|---|---|---|
| 1 | ∇ | c a b ─┤ | SHIFT |
| 2 | ∇ c3 | a b ─┤ | REDUCE(3) A -> c |
| 3 | ∇ A12 | a b ─┤ | SHIFT |
| 4 | ∇ A12 a2 | b ─┤ | GREŠKA: vrh a2, ulaz b |
| 5 | ∇ A12 a2 | b ─┤ | POP |
| 6 | ∇ A12 | b ─┤ | POP |
| 7 | ∇ | b ─┤ | POP |
| 8 | (prazan) | b ─┤ | neuspeh: stek je prazan |

**(d) Ulaz iz zadatka (K 26.11.2021, zad. 3b): `cadbadbdacacb`**. Svaki prefiks ulaza je ispravan (ulaz ima 4 slova `a`, a samo 3 `b`; fali jedno `b`), pa se greška otkriva tek na `─┤`: stanje `A2` (`A → A a A • b`) očekuje `a` ili `b`. Rad od greške:

| # | stek | preostali ulaz | akcija |
|---|---|---|---|
| 1 | ∇ A12 A12' a2 A2 | ─┤ | GREŠKA: vrh A2, ulaz ─┤ |
| 2 | ∇ A12 A12' a2 A2 | ─┤ | POP |
| 3 | ∇ A12 A12' a2 | ─┤ | POP |
| 4 | ∇ A12 A12' | ─┤ | POP |
| 5 | ∇ A12 | ─┤ | POP |
| 6 | ∇ | ─┤ | POP |
| 7 | (prazan) | ─┤ | neuspeh: stek je prazan |

Rezultat moje simulacije (nije potvrđeno zvaničnim rešenjem, a skenirano rešenje za 2021/22 nije u materijalima): `─┤` je jedini preostali simbol i smatra se sigurnim, ali ga nijedno stanje na steku ne može potisnuti osim `S0` (`S' → S • ─┤`), kojeg nema na steku, pa se stek prazni i **oporavak ne uspeva**. Praktično: greška je "nedostaje `b` na kraju". Ako zadatak zahteva da se ceo ulaz obradi, treba jasno napisati ovu pretpostavku (da je `─┤` siguran simbol) ili pretpostaviti drugačiji skup sigurnih simbola.

### 3.2 Jednostavan i poboljšani algoritam: ugnježdeni `if` (BottomUp.doc, oporavak zad. 2)

Gramatika (terminali `v = + c ; if then endif`):

0. S' → S -|
1. S → S I
2. S → I
3. I → v = v + c ;
4. I → v = c ;
5. I → if E then S endif ;
6. E → v = = c

Ulaz (u izvornom zadatku `a=1; if a==0 then b=1% if b==3 then x=a+1; endif; x=2; endif;`, ovde zapisano tokenima): `v = c ; if v = = c then v = c % if v = = c then v = v + c ; endif ; v = c ; endif ;`. Greška je simbol `%` posle `v = c` (fali `;`). Sigurni simboli su `;` i `endif`, simbol zaglavlja je `if`.

**Jednostavan algoritam**: odbacuje se 12 simbola (`% if v = = c then v = v + c`) do prvog `;`. Stanje `c4` (`I → v = c • ;`) može da potisne `;`, nastavlja se `v = c ;` → `I`, `S`, `endif ;` i **spoljašnji `if` se pogrešno uparuje sa unutrašnjim `endif`**. Kasnije, kad stigne spoljašnji `endif`, stek je `∇ S01` koji ga ne može potisnuti, skida se do `∇`, oporavak ne uspeva (u mojoj simulaciji, isti rezultat kao `REJECT` u vežbama).

**Poboljšani algoritam** (`if` zaglavlje): posle greške na `%` odbacuje se samo `%`, pa `if` (zaglavlje) se potisne i markira, i parsira se unutrašnji `if v = = c then v = v + c ; endif ;` do `I`. Redukcijom je markirani `if` uklonjen, vraćaš se na korak 1 (red 21 ispod): odbacuje se ulaz `v = c` do `;` (siguran), stek se skida (`POP` skine `I2`), `c4` može da potisne `;`, i posle toga se normalno završava (ACCEPT). Ostatak ulaza (`endif ;`) se uparuje sa spoljašnjim `if`.

| # | stek | preostali ulaz | akcija |
|---|---|---|---|
| 1 | ∇ S01 if5 E5 then5 v34 =34 c4 | % if v = = c then v = v + c ; endif ; v = c ; endif ; ─┤ | GREŠKA: vrh c4, ulaz % |
| 2 | ∇ S01 if5 E5 then5 v34 =34 c4 | if v = = c then v = v + c ; endif ; v = c ; endif ; ─┤ | odbaci ulaz, sledeći je if |
| 3 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 | v = = c then v = v + c ; endif ; v = c ; endif ; ─┤ | PUSH header if (markiran) |
| 4 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 | v = = c then v = v + c ; endif ; v = c ; endif ; ─┤ | SHIFT |
| 5 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 v6 | = = c then v = v + c ; endif ; v = c ; endif ; ─┤ | SHIFT |
| 6 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 v6 =6 | = c then v = v + c ; endif ; v = c ; endif ; ─┤ | SHIFT |
| 7 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 v6 =6 =6' | c then v = v + c ; endif ; v = c ; endif ; ─┤ | SHIFT |
| 8 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 v6 =6 =6' c6 | then v = v + c ; endif ; v = c ; endif ; ─┤ | REDUCE(6) E -> v = = c |
| 9 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 E5 | then v = v + c ; endif ; v = c ; endif ; ─┤ | SHIFT |
| 10 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 E5 then5 | v = v + c ; endif ; v = c ; endif ; ─┤ | SHIFT |
| 11 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 E5 then5 v34 | = v + c ; endif ; v = c ; endif ; ─┤ | SHIFT |
| 12 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 E5 then5 v34 =34 | v + c ; endif ; v = c ; endif ; ─┤ | SHIFT |
| 13 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 E5 then5 v34 =34 v3 | + c ; endif ; v = c ; endif ; ─┤ | SHIFT |
| 14 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 E5 then5 v34 =34 v3 +3 | c ; endif ; v = c ; endif ; ─┤ | SHIFT |
| 15 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 E5 then5 v34 =34 v3 +3 c3 | ; endif ; v = c ; endif ; ─┤ | SHIFT |
| 16 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 E5 then5 v34 =34 v3 +3 c3 ;3 | endif ; v = c ; endif ; ─┤ | REDUCE(3) I -> v = v + c ; |
| 17 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 E5 then5 I2 | endif ; v = c ; endif ; ─┤ | REDUCE(2) S -> I |
| 18 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 E5 then5 S15 | endif ; v = c ; endif ; ─┤ | SHIFT |
| 19 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 E5 then5 S15 endif5 | ; v = c ; endif ; ─┤ | SHIFT |
| 20 | ∇ S01 if5 E5 then5 v34 =34 c4 if5 E5 then5 S15 endif5 ;5 | v = c ; endif ; ─┤ | REDUCE(5) I -> if E then S endif ; |
| 21 | ∇ S01 if5 E5 then5 v34 =34 c4 I2 | v = c ; endif ; ─┤ | markirani header uklonjen redukcijom -> ponovo korak (1) |
| 22 | ∇ S01 if5 E5 then5 v34 =34 c4 I2 | = c ; endif ; ─┤ | odbaci ulaz, sledeći je = |
| 23 | ∇ S01 if5 E5 then5 v34 =34 c4 I2 | c ; endif ; ─┤ | odbaci ulaz, sledeći je c |
| 24 | ∇ S01 if5 E5 then5 v34 =34 c4 I2 | ; endif ; ─┤ | odbaci ulaz, sledeći je ; |
| 25 | ∇ S01 if5 E5 then5 v34 =34 c4 I2 | ; endif ; ─┤ | POP |
| 26 | ∇ S01 if5 E5 then5 v34 =34 c4 | ; endif ; ─┤ | SHIFT |
| 27 | ∇ S01 if5 E5 then5 v34 =34 c4 ;4 | endif ; ─┤ | REDUCE(4) I -> v = c ; |
| 28 | ∇ S01 if5 E5 then5 I2 | endif ; ─┤ | REDUCE(2) S -> I |
| 29 | ∇ S01 if5 E5 then5 S15 | endif ; ─┤ | SHIFT |
| 30 | ∇ S01 if5 E5 then5 S15 endif5 | ; ─┤ | SHIFT |
| 31 | ∇ S01 if5 E5 then5 S15 endif5 ;5 | ─┤ | REDUCE(5) I -> if E then S endif ; |
| 32 | ∇ S01 I1 | ─┤ | REDUCE(1) S -> S I |
| 33 | ∇ S01 | ─┤ | SHIFT |
| 34 | ∇ S01 ─┤0 |  | ACCEPT |

(Ulaz posle reda 21 je `v = c ; endif ; ─┤`: u izvornom zadatku to je `x=2;`.)

## 4. Tipične greške

- Skidanje steka dok se ne nađe stanje koje **može da potisne** siguran simbol: gleda se **potisna** tabela (vrsta vršnog stanja, kolona sigurnog simbola), ne kontrolna.
- Odbacivanje simbola povrede iako je on već siguran.
- Posle oporavka se "zaboravi" da se prvo uradi `SHIFT` sigurnog simbola pa tek onda dalja redukcija (ili obrnuto: da se siguran simbol preskoči).
- Kod poboljšanog algoritma: simbol zaglavlja se ne markira (ili se ne vraća na korak 1 kad se markirani simbol ukloni redukcijom).
- Prijavljuje se više istih grešaka (kod yacc/CUP posle prve prijave potrebna su 3 ispravna tokena).
- Ne piše se pretpostavka o `─┤` kao sigurnom simbolu kad se greška otkrije na kraju ulaza.

## 5. Pojavljivalo se na K

- **IR 26.11.2021, zad. 3b**: stek i panic mode sa sigurnim simbolima `b` i `d` za LALR parser, ulaz `cadbadbdacacb` (3.1d).
- Ranije nema oporavka na IR K (stariji SI K1 su ga imali retko). Na vežbama (BottomUp.doc) postoje oba algoritma (jednostavan i poboljšani) i CUP `error`.
- **Verovatnoća za 28.11.:** srednja. Zadatak je kratak (3 boda), a mehanički: nauči da skidaš stek preko potisne tabele.
