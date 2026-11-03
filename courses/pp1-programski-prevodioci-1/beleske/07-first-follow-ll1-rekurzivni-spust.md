# 07. FIRST/FOLLOW, selekcioni skupovi, LL(1) transformacije i rekurzivni spust

**Izvor:** `PP1_P06.pdf` str. 3–7 (poništivost, FIRST, FOLLOW), `PP1_P08.pdf` (parsiranje od vrha ka dnu, strane PDF-a: koncept 3–10, rekurzivni spust 13–19, selekcioni skupovi i LL(1) 21–27, transformacije 29–41, oporavak 55–56), udžbenik `pp1_udzbenik.pdf` str. 96–97 (FIRST/FOLLOW) i 113–127 (parsiranje od vrha ka dnu), vežbe `TDParsiranje.doc` (zadaci 1–8), Zbirka 3.2. Delove P08 o sintaksno-upravljanom prevođenju (sl. 42–54, L-atributivne gramatike) ne obrađujem: prošlogodišnje obaveštenje isključuje P07, a to gradivo se nadovezuje na njega.

## 1. Definicije (2–3 rečenice)

- **Poništiv** neterminal ⟨X⟩ ⇒* ε. **FIRST(⟨X⟩)** je skup terminala kojima može početi sentencijalna forma izvedena iz ⟨X⟩. **FOLLOW(⟨X⟩)** je skup terminala (i `─┤`) koji se mogu naći neposredno iza ⟨X⟩ u nekoj sentencijalnoj formi izvedenoj iz `⟨S⟩ ─┤`.
- **SELECT(⟨A⟩ → α)** je skup ulaznih simbola pri kojima parser od vrha ka dnu bira tu smenu. `SELECT = FIRST(α)` ako α nije poništivo, a `FIRST(α) ∪ FOLLOW(⟨A⟩)` ako jeste.
- Gramatika je **LL(1)** ako za svaki neterminal smene sa istom levom stranom imaju **disjunktne** SELECT skupove. LL(1): čita se sleva nadesno, traži se levo izvođenje, jedan simbol unapred. Gramatika sa levom rekurzijom ili sa zajedničkim prefiksom nije LL(1). **Višeznačna gramatika nikad nije LL(1).** Po slajdovima i vežbama LR(0) ne dozvoljava prazne smene (praktično uvek nastaje konflikt), pa LL(1) gramatika sa ε-smenom ne može biti LR(0).

## 2. Algoritmi korak po korak

### 2.1 Poništivi neterminali, FIRST, FOLLOW (iterativno)

1. **Poništivi (P)**: u P stavi sve neterminale sa ε-smenom. Dok ima promene: ako su svi simboli desne strane smene neterminali iz P, dodaj levu stranu u P. Niz je poništiv ako su mu svi simboli iz P.
2. **FIRST**: FIRST svih neterminala je ∅. Dok ima promene, za svaku smenu ⟨X⟩ → α: `FIRST(X) ∪= FIRST(α)`, gde je `FIRST(A₁A₂…Aₙ) = FIRST(A₁) ∪ FIRST(A₂) ∪ …` do prvog neporništivog Aᵢ (uključujući njega). Za terminal t: FIRST(t) = {t}.
3. **FOLLOW**: `FOLLOW(S) = {─┤}`, ostali ∅. Dok ima promene, za svaku smenu ⟨Y⟩ → α ⟨X⟩ β: `FOLLOW(X) ∪= FIRST(β)`; ako je β poništivo (uključujući prazno), još i `FOLLOW(X) ∪= FOLLOW(Y)`. FOLLOW nikad ne sadrži ε.
4. Najpre ispiši tabelu (neterminal, poništiv, FIRST, FOLLOW), pa SELECT za svaku smenu. Ako se u zadatku traži samo "FOLLOW", ipak ispiši FIRST jer ga FOLLOW koristi.

### 2.2 Provera LL(1)

Za svaku smenu izračunaj SELECT (2.1, definicija iznad). Za svaki neterminal poredi SELECT skupove svih parova njegovih smena. Presek mora biti prazan. Navedi **konkretne konfliktne smene i zajednički simbol**.

### 2.3 Transformacije u LL(1) (redosled: suvišni → leva rekurzija → faktorizacija → provera)

0. Ukloni mrtve i nedostižne neterminale (beleška 03, recept 2.3).
1. **Direktna leva rekurzija.** `A → A α₁ | … | A αₘ | β₁ | … | βₙ` (βᵢ ne počinju sa A) postaje `A → β₁ A' | … | βₙ A'` i `A' → α₁ A' | … | αₘ A' | ε`. Ako je neki β prazan, `A → A'`.
2. **Indirektna leva rekurzija** (algoritam sa slajda 33; pretpostavka da nema ciklusa A ⇒⁺ A): poređaj neterminale A₁, …, Aₙ. Za i = 1..n: za j = 1..i−1 zameni svaku smenu `Aᵢ → Aⱼ γ` smenama `Aᵢ → δ₁ γ | … | δₖ γ` (δ su sve desne strane Aⱼ iz **tekućeg** stanja gramatike); zatim ukloni direktnu levu rekurziju po Aᵢ. Novi neterminali se dodaju na kraj niza.
3. **Leva faktorizacija.** `A → α β₁ | α β₂ | γ` postaje `A → α A' | γ` i `A' → β₁ | β₂` (β može biti ε). Ponavljaj dok postoji zajednički prefiks. Ako smene počinju neterminalom, a SELECT skupovi se poklapaju, najpre zameni neterminal njegovim smenama (ugaona zamena, vežbe zad. 4b), pa faktoriši.
4. Ponovo izračunaj FIRST/FOLLOW/SELECT i proveri. **Transformacija nije uvek moguća** (neodlučiv problem). Ako je gramatika višeznačna, standardnim transformacijama se LL(1) ne dobija (isti nizovi imaju dva izvođenja). Jezik `{aⁿ0bⁿ} ∪ {aⁿ1b²ⁿ}` nema LL(1) gramatiku uopšte (P08 sl. 41).

### 2.4 Parser metodom rekurzivnog spusta (P08 sl. 13–19)

1. Za **svaki neterminal** jedna procedura. Globalna promenljiva `IN` ima tekući ulazni simbol; `NEXTCHAR()` čita sledeći.
2. U proceduri za ⟨A⟩: `case IN of` sa svim simbolima iz `SELECT(⟨A⟩ → α)` → izvrši smenu α. Simboli koji ne pripadaju nijednom SELECT skupu: `REJECT`.
3. Desna strana smene α se prevodi **sleva nadesno**: neterminal ⟨B⟩ → `call PROC_B`; terminal t → `if IN = t then IN = NEXTCHAR() else REJECT`. Smena ε: ništa (samo `return`, SELECT je FOLLOW).
4. Glavni program: `IN = NEXTCHAR(); call PROC_S; if IN = ─┤ then ACCEPT else REJECT`.
5. Procedura `PROC_B` se završava (`return`) tek kad je cela desna strana uparena. Ne zaboravi da posle poziva proceduru ulaz već pokazuje na sledeći nepročitani simbol.

### 2.5 Oporavak od grešaka u rekurzivnom spustu (P08 sl. 55–56)

Svaka procedura dobija parametar `termset` (skup terminala koji mogu slediti iza neterminala). Kad procedura za ⟨A⟩ otkrije grešku, gutaju se ulazni simboli dok ne naiđe neki iz `termset`, pa se vrati iz procedure. Pri pozivu potprocedure `termset` se proširuje simbolima koji slede u datoj smeni (npr. u `S → [ E ]` se `E` zove sa `termset ∪ {']'}`); glavni program zove `S('$')`. U slajdu 56 u grani za zagradu piše `'}'` i poređenje sa `']'`: očigledna greška u slajdu, treba `')'` na oba mesta.

## 3. Primeri (svi skupovi izračunati i provereni skriptom)

### 3.1 FIRST/FOLLOW/SELECT sa predavanja (P06 str. 6, P08 str. 24–27)

1. A → a B C
2. A → b B
3. A → ε
4. B → a B b
5. B → ε
6. C → b C
7. C → c

| neterminal | poništiv | FIRST | FOLLOW |
|---|---|---|---|
| A | da | {a, b} | {─┤} |
| B | da | {a} | {─┤, b, c} |
| C | ne | {b, c} | {─┤} |

| # | smena | SELECT |
|---|---|---|
| 1 | A → a B C | {a} |
| 2 | A → b B | {b} |
| 3 | A → ε | {─┤} |
| 4 | B → a B b | {a} |
| 5 | B → ε | {─┤, b, c} |
| 6 | C → b C | {b} |
| 7 | C → c | {c} |

**Zaključak: gramatika JE LL(1)** (smene 1, 2, 3 imaju SELECT {a}, {b}, {─┤}; smene 4, 5: {a} i {─┤, b, c}; smene 6, 7: {b}, {c}).

### 3.2 Pun postupak: suvišni neterminali, leva rekurzija, faktorizacija (TDParsiranje zad. 3)

Početna gramatika (startni ⟨A⟩): `A → A c B | C c b | c D | D`, `B → b B | d`, `C → C c E`, `D → D a B | B b B | B`, `E → a b`.

1. **Mrtvi**: `C` je mrtav (jedina smena `C → C c E` nikad ne izvodi terminale). Izbacuju se smene `A → C c b` i `C → C c E`. **Nedostižni**: `E` (samo se pojavljuje u smeni za `C`). Gramatika: `A → A c B | c D | D`, `B → b B | d`, `D → D a B | B b B | B`.
2. **Leva rekurzija** po `A` (α = `c B`, β₁ = `c D`, β₂ = `D`): `A → c D A' | D A'`, `A' → c B A' | ε`. Po `D` (α = `a B`, β₁ = `B b B`, β₂ = `B`): `D → B b B D' | B D'`, `D' → a B D' | ε`. Indirektne rekurzije nema.
3. **Faktorizacija** `D → B b B D' | B D'` (zajednički prefiks `B`): `D → B D1`, `D1 → b B D' | D'`. (Ispod `D'` je preimenovano u `D2`.)
4. **Rezultat** (jezik proveren nabrajanjem do dužine 8: isti kao gramatika posle koraka 1; u tabelama je `D'` preimenovano u `D2`):

1. A → c D A1
2. A → D A1
3. A1 → c B A1
4. A1 → ε
5. B → b B
6. B → d
7. D → B D1
8. D1 → b B D2
9. D1 → D2
10. D2 → a B D2
11. D2 → ε

| neterminal | poništiv | FIRST | FOLLOW |
|---|---|---|---|
| A | ne | {b, c, d} | {─┤} |
| A1 | da | {c} | {─┤} |
| B | ne | {b, d} | {─┤, a, b, c} |
| D | ne | {b, d} | {─┤, c} |
| D1 | da | {a, b} | {─┤, c} |
| D2 | da | {a} | {─┤, c} |

| # | smena | SELECT |
|---|---|---|
| 1 | A → c D A1 | {c} |
| 2 | A → D A1 | {b, d} |
| 3 | A1 → c B A1 | {c} |
| 4 | A1 → ε | {─┤} |
| 5 | B → b B | {b} |
| 6 | B → d | {d} |
| 7 | D → B D1 | {b, d} |
| 8 | D1 → b B D2 | {b} |
| 9 | D1 → D2 | {─┤, a, c} |
| 10 | D2 → a B D2 | {a} |
| 11 | D2 → ε | {─┤, c} |

**gramatika JE LL(1).** Smene 8 i 9 imaju SELECT {b} i {─┤, a, c}.

### 3.3 Indirektna leva rekurzija (P08 sl. 34–38)

Gramatika `S → E`, `E → E + T | T`, `T → E - T | id`. Poredak ⟨S⟩, ⟨E⟩, ⟨T⟩.

- i=1 (S): nema šta da se menja.
- i=2 (E): direktna leva rekurzija: `E → T E'`, `E' → + T E' | ε`.
- i=3 (T): j=2: `T → E - T` ⇒ `T → T E' - T`; direktna rekurzija: `T → id T'`, `T' → E' - T T' | ε`.
- i=5 (T'): j=4 (E'): zamena `E' → + T E' | ε` u `T' → E' - T T'` daje `T' → + T E' - T T' | - T T' | ε`.

Rezultat (proveren jezik: isti nizovi do dužine 7, 15 reči):

1. S → E
2. E → T E1
3. E1 → + T E1
4. E1 → ε
5. T → id T1
6. T1 → + T E1 - T T1
7. T1 → - T T1
8. T1 → ε

SELECT:

| # | smena | SELECT |
|---|---|---|
| 1 | S → E | {id} |
| 2 | E → T E1 | {id} |
| 3 | E1 → + T E1 | {+} |
| 4 | E1 → ε | {-, ─┤} |
| 5 | T → id T1 | {id} |
| 6 | T1 → + T E1 - T T1 | {+} |
| 7 | T1 → - T T1 | {-} |
| 8 | T1 → ε | {+, -, ─┤} |

**gramatika NIJE LL(1): smene 6 i 8 dele {+}; smene 7 i 8 dele {-}.** Razlog: polazna gramatika je **višeznačna** (`id + id - id` ima dva stabla, brojač stabala daje 2), pa je LL(1) ne može imati. Primer sa slajdova ilustruje mehaniku algoritma, ne dovodi do LL(1).

### 3.4 K 22.11.2019, zadatak 3: `S → S c A | b`, `A → A a | A d A | ε`

**a)** Poništiv je samo A.

| neterminal | poništiv | FIRST | FOLLOW |
|---|---|---|---|
| S | ne | {b} | {─┤, c} |
| A | da | {a, d} | {─┤, a, c, d} |

SELECT polazne gramatike (nije LL(1): leva rekurzija, `S → S c A` i `S → b` dele {b}, a smene za A dele {a, d}):

| # | smena | SELECT |
|---|---|---|
| 1 | S → S c A | {b} |
| 2 | S → b | {b} |
| 3 | A → A a | {a, d} |
| 4 | A → A d A | {a, d} |
| 5 | A → ε | {─┤, a, c, d} |

**b)** (U tabelama su `S'` i `A'` zapisani kao `S1` i `A1`.) Eliminacija leve rekurzije: `S → b S'`, `S' → c A S' | ε`, a za A (α₁ = `a`, α₂ = `d A`, β = ε) `A → A'`, `A' → a A' | d A A' | ε`. Provera:

| # | smena | SELECT |
|---|---|---|
| 1 | S → b S1 | {b} |
| 2 | S1 → c A S1 | {c} |
| 3 | S1 → ε | {─┤} |
| 4 | A → A1 | {─┤, a, c, d} |
| 5 | A1 → a A1 | {a} |
| 6 | A1 → d A A1 | {d} |
| 7 | A1 → ε | {─┤, a, c, d} |

**gramatika NIJE LL(1): smene 5 i 7 dele {a}; smene 6 i 7 dele {d}**. Razlog: polazna gramatika je **višeznačna** (`A d A` je rekurzivno sa obe strane: iz A se `dd` izvodi na dva načina, brojač stabala za `dd` daje 2), pa standardnim postupkom LL(1) ne može da se dobije. Jezik koji A opisuje je ipak jednostavan: svi nizovi nad {a, d} (proverio sam nabrajanjem). Zato se **ekvivalentna LL(1) gramatika** (ne dobijena transformacijama nego prepisivanjem jezika) dobija ovako:

1. S → b S1
2. S1 → c A S1
3. S1 → ε
4. A → a A
5. A → d A
6. A → ε

| neterminal | poništiv | FIRST | FOLLOW |
|---|---|---|---|
| S | ne | {b} | {─┤} |
| S1 | da | {c} | {─┤} |
| A | da | {a, d} | {─┤, c} |

| # | smena | SELECT |
|---|---|---|
| 1 | S → b S1 | {b} |
| 2 | S1 → c A S1 | {c} |
| 3 | S1 → ε | {─┤} |
| 4 | A → a A | {a} |
| 5 | A → d A | {d} |
| 6 | A → ε | {─┤, c} |

**gramatika JE LL(1)** (proverio sam da je jezik gramatike S istovremeno jednak polaznom nabrajanjem svih reči do dužine 7: 365 reči).

(Ovo je moja analiza zadatka, nije službeno rešenje. Postavka pita "da li je moguće transformisati … i ako jeste sprovesti". Bezbedno rešenje na K: pokaži da standardna transformacija daje SELECT konflikt, objasni višeznačnost, pa daj ekvivalentnu LL(1) gramatiku iz koje radiš tačku c.)

**c) Rekurzivni spust** za deo koji odgovara neterminalu `A` (po LL(1) gramatici iznad: `A → a A | d A | ε`, SELECT: {a}, {d}, {c, ─┤}):

```
procedure PROC_A:
   case IN of
      'a':       IN = NEXTCHAR(); call PROC_A; return;      /* smena A → a A */
      'd':       IN = NEXTCHAR(); call PROC_A; return;      /* smena A → d A */
      'c', '─┤': return;                                    /* smena A → ε  */
      'b':       REJECT;
   end case;
end procedure;
```

Isti kod u Javi, kao deo punog parsera za celu gramatiku `S → b S'`, `S' → c A S' | ε`, `A → a A | d A | ε` (kompajlirano i testirano: saglasan sa regularnim izrazom `b(c[ad]*)*` na svih 349525 reči nad {a,b,c,d} do dužine 9):

```java
public class RD {
    // Rekurzivni spust za LL(1) gramatiku:
    //   1. S  -> b S'            4. A  -> a A
    //   2. S' -> c A S'          5. A  -> d A
    //   3. S' -> ε               6. A  -> ε
    // SELECT: 1:{b} 2:{c} 3:{-|} 4:{a} 5:{d} 6:{c,-|}
    static String in; static int pos; static char cur;
    static final char END = '$';                      // marker kraja ulaza  ─┤
    static void advance() { cur = pos < in.length() ? in.charAt(pos++) : END; }
    static void error() { throw new RuntimeException("REJECT"); }
    static void terminal(char t) { if (cur == t) advance(); else error(); }

    static void S() {
        switch (cur) {
            case 'b': terminal('b'); Sp(); break;       // smena 1
            default: error();
        }
    }
    static void Sp() {
        switch (cur) {
            case 'c': terminal('c'); A(); Sp(); break;  // smena 2
            case END: break;                            // smena 3 (ε): SELECT = FOLLOW(S') = {─┤}
            default: error();
        }
    }
    static void A() {
        switch (cur) {
            case 'a': terminal('a'); A(); break;        // smena 4
            case 'd': terminal('d'); A(); break;        // smena 5
            case 'c': case END: break;                  // smena 6 (ε): SELECT = FOLLOW(A) = {c, ─┤}
            default: error();
        }
    }
    static boolean parse(String s) {
        in = s; pos = 0; advance();
        try { S(); if (cur != END) error(); return true; } catch (RuntimeException e) { return false; }
    }
    public static void main(String[] a) throws Exception {
        // poredjenje sa regularnim izrazom  b(c(a|d)*)*
        java.util.regex.Pattern p = java.util.regex.Pattern.compile("b(c[ad]*)*");
        int n = 0;
        for (int len = 0; len <= 9; len++)
            for (long m = 0; m < Math.pow(4, len); m++) {
                StringBuilder sb = new StringBuilder(); long x = m;
                for (int i = 0; i < len; i++) { sb.append("abcd".charAt((int) (x % 4))); x /= 4; }
                String w = sb.toString();
                if (parse(w) != p.matcher(w).matches()) throw new RuntimeException("razlika: " + w);
                n++;
            }
        System.out.println("saglasno na " + n + " reci");
        System.out.println(parse("bcaddacd") + " " + parse("bca") + " " + parse("bcc") + " " + parse("ab"));
    }
}
```

### 3.5 Pitanja tipa "koja je gramatika" i "da li je LL(1)" (TDParsiranje zad. 5 i 8)

- **Rekurzivni prepoznavač → gramatika** (zad. 8): iz `case` grana se čitaju smene (`'a','c','d': call PROCA; if IN <> 'a' then REJECT else ADVANCE; call PROCA` ⇒ `S → A a A`; `'b': ADVANCE` ⇒ `S → b`; `'c': call PROCA; if IN <> 'c' …` ⇒ `A → A c`; `'d': ADVANCE` ⇒ `A → d`; prazna grana ⇒ `A → ε`). Dobija se `S → A a A | b`, `A → A c | d | ε`. SELECT: smena 3 `{c, d}`, smena 4 `{d}`, smena 5 `{a, c, ─┤}`; konflikti 3–4 (d) i 3–5 (c), **nije LL(1)** (leva rekurzija), pa takav prepoznavač može da uđe u beskonačnu rekurziju kad je `c` tekući ulaz (SELECT skupovi izračunati skriptom poklapaju se sa onima iz vežbi).
- **LL(1) a ne LR(0)**: `S → a | ε` (LL(1): SELECT {a} i {─┤}; nije LR(0): u stanju `∇` smena `S → •` je potpuna, a istovremeno postoji `S → • a`, proveren konflikt shift/reduce).
- **LR(0) a ne LL(1)**: `S → S a | a` (leva rekurzija; proverio sam da su LR(0), SLR(1) i LALR(1) tabele bez konflikata).
- **LL(1) a ne SLR(1)**: `S → A a A b | b`, `A → ε` (SELECT: {a}, {b}, FOLLOW(A) = {a, b}; u stanju `∇` kolona `b` ima SHIFT/REDUCE konflikt jer FOLLOW(A) sadrži `b`). Napomena: ova gramatika jeste LALR(1).

## 4. Tipične greške

- U FOLLOW se zaboravi `FOLLOW(Y)` kad je β poništivo, ili se u FOLLOW upiše ε. Zaboravljen `─┤` u FOLLOW startnog neterminala.
- `SELECT` ε-smene se uzme kao `FOLLOW` bez `FIRST(α)`, ili za poništivo α se zaboravi FOLLOW.
- Leva rekurzija: pogrešno se ostave α-ovi u novim smenama (αᵢ idu u `A'`, βᵢ ispred `A'`); zaboravi se `A' → ε`.
- Faktorizacija radi samo kad **sama prva** pojava prefiksa (terminala ili neterminala) isto stoji u više smena; ako smene počinju različitim neterminalima koji se oba izvode u isti terminal, prvo uradi ugaonu zamenu.
- Rekurzivni spust: ne zaboravi da `PROC` vraća kontrolu tek kad je cela desna strana uparena; ε-smena = prazna grana sa FOLLOW simbolima (ne `REJECT`); glavni program mora proveriti `IN = ─┤`.
- Zaključak "gramatika je LL(1)" bez provere svih parova smena istog neterminala.

## 5. Pojavljivalo se na K

- **IR 22.11.2019, zad. 3**: FIRST/FOLLOW za ⟨S⟩ i ⟨A⟩, provera i transformacija u LL(1), parser rekurzivnim spustom za neterminal ⟨A⟩ (3.4). Ovo je jedini IR K sa ovom temom.
- Teme P08 spadaju u prošlogodišnje obaveštenje (gradivo "zaključno sa P8"), pa su verovatne i ove godine. Ali ne mogu da tvrdim da će zadatak biti na K (nepotvrđeno).
