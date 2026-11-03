# K1 cheatsheet: PP1, svi recepti na jednom mestu

Pregled za štampu (gradivo: P01–P06a, P08, V1–V6; beleške 01–07 imaju primere). `─┤` = marker kraja, `∇` = dno steka, `ε` = prazna reč. Prazno polje u tabeli = greška/REJECT.

## 1. Regularni izrazi i automati (beleška 01)

**Prioritet:** `* + ?` > konkatenacija > `|`.

**Tompson:** simbol `a`: `i –a→ j`. Konkatenacija `st`: ε od kraja s ka početku t. Unija `s|t`: novi start sa ε ka oba starta, ε iz oba kraja u novi kraj. `s*`: novi start i kraj; ε: novi start→stari start, stari kraj→novi kraj, novi start→novi kraj, stari kraj→stari start. `s+`: isto bez novi start→novi kraj. `s?`: bez stari kraj→stari start.

**NKA → DKA:** start = ε-zatvaranje(start). Za stanje X i simbol u: `ε-zatvaranje(∪ δ(s,u))`. Prihvata ako sadrži prihvatajuće stanje NKA. Prazan skup = greška.

**Metoda pozicija** (izraz + `⊣`):
1. Stablo, numeriši listove (svaka pojava svoj broj, ε bez broja).
2. Poništivo: `ε` da; `•` oba; `|` bar jedan; `*`, `?` da; `+` ako je sin poništiv; ostali listovi ne.
3. prva: `•(a,b)` = prva(a) [∪ prva(b) ako je a poništivo]; `|` unija; `* + ?` = prva(sina).
4. poslednja: `•(a,b)` = poslednja(b) [∪ poslednja(a) ako je b poništivo]; `|` unija; `* + ?` = poslednja(sina).
5. sledeća(p): `•(a,b)`: p ∈ poslednja(a) dobija prva(b). `* +`: p ∈ poslednja(sina) dobija prva(sina).
6. Start = prva(koren). Stanje T, simbol a: ∪ sledeća(p) za p ∈ T sa simbolom a. Prihvata ako sadrži poziciju `⊣`.

**Minimizacija (particije):** ukloni nedostižna. P0 = (prihvatajuća, ostala). Razdvajaj stanja bloka koja za neki simbol idu u različite blokove (prazno = poseban blok greške). Ponavljaj do stabilnosti. Blok = jedno stanje.

**Zvezdasto zatvaranje DKA (S start, Z kraj):** novo start `S'` (prihvata, prelazi kao S); ε Z→S; kad podskup sadrži Z dodaj S; prihvata ako sadrži Z ili `S'`; minimizuj. **Komplement:** potpun DKA, zameni prihvatanje. **Ekvivalencija:** minimizuj oba pa uporedi.

## 2. Konačni procesor (beleška 02)

Prepoznavač + akcije u ne-praznim ulazima + `─┤` (izlaz rezultata). Ulazne klase umesto pojedinačnih znakova (transliterator). Registri sa inicijalizacijom (npr. `R:=0, O:='+'`); poslednji broj se primeni na `─┤`. Pretpostavke uokviri (celobrojno deljenje, deljenje nulom = greška).
**State pattern:** `interface State { boolean accepting(); void handleInput(Ctx c, char ch); }`, klasa po stanju (`c.setState(...)`), `Ctx` čuva registre i tekuće stanje. Implicitno = `switch(state)`, eksplicitno = matrica `T[stanje][simbol]` + vektor prihvatanja.

## 3. Gramatike (beleška 03)

**Obrasci:** lista `L → L x | x`. Upareno `S → a S c | sredina` (aⁿ…cⁿ). Nezavisni delovi `S → X Y`. n > m: `S → 110 | 1 S 0 | 1 S`. Parnost: `B → b b B | ε`. i ≠ j: `a S b | A | B`. Palindrom: `S → a S a | b S b | c`.

**Izrazi:** nivo po prioritetu (najniži = start). Levo asoc.: `N → N op M | M`. Desno: `N → M op N | M`. Primarni: `( N₁ ) | operand`. Višeznačna: `E → E+E`, dangling else (reši Matched/Unmatched).

**Suvišni neterminali:** (1) mrtvi: iterativno žive Ž (desna strana ⊆ terminali ∪ Ž), izbaci smene sa mrtvim; (2) nedostižni iz S, izbaci. **Redosled: mrtvi pa nedostižni.**

**Automat → gramatika:** δ(A,x)=B ⇒ `A → x B`; prihvatajuće `B → ε`; izbaci mrtve i nedostižne. **Desno-linearna → regularna:** `A → w` ⇒ `A → w E`, `E → ε`; `A → a₁…aₙ B` ⇒ lanac novih neterminala; `A → B` ⇒ zameni desnim stranama B. **Regularna → NKA:** neterminal = stanje, `A → a B` = prelaz, `A → ε` = prihvata.

## 4. Potisni automat (beleška 04)

Šestorka (ulaz+`─┤`, simboli steka, početni stek `∇`, stanja, start, δ). Akcije: `POP`, `PUSH(x)`, `REPLACE(xyz)` (= POP, PUSH x,y,z), `ADVANCE`/`RETAIN`, `STATE(S)` (samo kad se menja), `ACCEPT`, `REJECT`. **Jedna tabela po stanju**, vrste = vrh steka (+`∇`), kolone = ulaz (+`─┤`). `POP` na `∇` nije dozvoljen.
**Recept:** faze ulaza = stanja; `PUSH(A)` po slovu koje se broji, `POP` po uparenom; prihvatanje na `─┤` sa `∇` na vrhu (za „veće od“: `A` na vrhu i obavezno stanje); 2 simbola po slovu: marker B + `REPLACE(AA)`, ili `RETAIN` kroz međustanja. Prikaži rad: stek / ulaz / akcija.

## 5. LR(0), SLR(1), LALR(1) (beleška 05)

1. Proširi: `0. S' → S ─┤`. 2. `Closure`: za `A → α • B β` dodaj sve `B → • γ`. 3. `Goto(I,X)` = `Closure(A → αX•β)`. 4. Isti skup = isto stanje. 5. Ime stanja = simbol + brojevi smena iz jezgra. **Potisna tabela = automat.**
**Kontrolna:** `A → α • x β` ⇒ SHIFT(x). `A → γ •` ⇒ REDUCE: LR(0) cela vrsta; **SLR** x ∈ FOLLOW(A); **LALR** x ∈ LA(`A → γ •`). `S' → S ─┤ •` (stanje `─┤0`) ⇒ ACCEPT. Dve akcije u ćeliji = konflikt. ε-smena = konflikt u LR(0).
**Rad:** SHIFT = `PUSH(potisna[vrh, ulaz])`, ADVANCE. REDUCE(A→γ) = |γ| × POP, `PUSH(potisna[vrh, A])`, RETAIN.
**LALR (LA):** SLA(`B → •γ`) ⊇ FIRST(β) za svako `A → α • B β` u istom stanju; veze: `A → α•Xβ ⇒ A → αX•β` (u goto-stanju) i `A → α • B β` (β poništivo) ⇒ `B → •γ`; propagiraj; LA ⊆ FOLLOW.
**Rekonstrukcija iz tabela:** vrste = stanja, potisna = prelazi, `REDUCE(p)` = potpuna smena p, ime `X_pq` = smene sa tačkom iza X; desne strane čitaj duž puteva.
**Klase:** LR(0) ⊂ SLR(1) ⊂ LALR(1) ⊂ LR(1). yacc/CUP = LALR(1). Konflikt: yacc S/R → shift, R/R → prva smena.

## 6. Oporavak od grešaka (beleška 06)

**Jednostavan panic mode** (sigurni simboli): (1) odbaci ulaz do sigurnog (ako je tekući već siguran, ništa); (2) **POP** dok vrh steka u **potisnoj** tabeli nema ulaz za siguran simbol (prazan stek = neuspeh); (3) nastavi. `─┤` smatraj sigurnim (uokviri pretpostavku). **Poboljšani:** dodatno simboli zaglavlja: ulaz se odbacuje do sigurnog ili zaglavlja; zaglavlje se potiskuje i markira; kad se redukcijom ukloni marker, ponovo korak 1. **CUP:** smene sa `error`; skidaš stanja do `X → … • error …`; 3 tokena do ponovne prijave; `yyerrok`.

## 7. FIRST, FOLLOW, SELECT, LL(1), rekurzivni spust (beleška 07)

**Poništivi** (ε-smena, pa desne strane iz poništivih). **FIRST(A) ⊇ FIRST(α)** (niz do prvog neporništivog). **FOLLOW(S) ∋ ─┤**; za `Y → α X β`: FOLLOW(X) ⊇ FIRST(β), a ako je β poništivo još i FOLLOW(Y). **SELECT(A → α) = FIRST(α)** (α neporništivo) ili **FIRST(α) ∪ FOLLOW(A)**. **LL(1):** SELECT smena istog neterminala disjunktni (navedi konflikt).
**Leva rekurzija:** `A → Aα | β` ⇒ `A → βA'`, `A' → αA' | ε`. **Indirektna:** poređaj A₁…Aₙ; za i, j<i zameni `Aᵢ → Aⱼγ` desnim stranama Aⱼ; ukloni direktnu po Aᵢ. **Faktorizacija:** `A → αβ | αγ` ⇒ `A → αA'`, `A' → β | γ`. Višeznačna gramatika nije LL(1); proveri SELECT posle transformacije.
**Rekurzivni spust:** procedura po neterminalu; `case IN of` SELECT skupovi → smena; terminal: `if IN=t then IN=NEXTCHAR() else REJECT`; neterminal: `call`; ε-smena: samo `return` (FOLLOW u case). Glavni: `IN=NEXTCHAR(); call S; if IN=─┤ ACCEPT else REJECT`. Oporavak: parametar `termset`, gutaj do člana termseta.

## 8. Checklist na K

- Pročitaj sva 3 zadatka, počni od najsigurnijeg (regex/automat, pa gramatika/PDA, pa LR).
- Piši pretpostavke u okvir. Označi stanja, navedi koja su prihvatajuća.
- Proveri na jednoj kratkoj reči (ε i najkraća ispravna).
- LR: ne zaboravi `─┤` kolonu, `S' → S ─┤`, ime stanja, trag rada ako traže.
- 90 min / 3 zadatka ≈ 25 min po zadatku + 15 min rezerve.
