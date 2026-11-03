# 02. Konačni procesori (automat sa akcijama), implementacija, State pattern

**Izvor:** `PP1_P03.pdf` (str. 3–9 procesori i primer realnih konstanti, str. 10–19 implementacija: implicitna, eksplicitna, State), udžbenik `pp1_udzbenik.pdf` str. 49–64, vežbe `LeksickaAnaliza_V_dodatak.doc` (leksički procesor za jezik ISPIT, transliterator, prepoznavač ključnih reči), Zbirka 1.5 (leksički procesori).

## 1. Definicije (2–3 rečenice)

- **Prepoznavač** daje binarnu odluku (prihvata/odbija). **Procesor** je automat koji pored prepoznavanja izvršava **akcije** (kod koji menja registre/izlaz), pridružene ne-praznim ulazima tabele prelaza.
- Ulaznoj azbuci se dodaje **marker kraja** `─┤` (jednom, na kraju). Na njemu se obično završava obrada i daje rezultat. Prazni ulazi tabele su leksičke greške (po potrebi im se pridruže akcije za oporavak).
- Ulazni simboli se često grupišu u klase (cifra, slovo, znak). To radi **transliterator** (vektor indeksiran ASCII kodom), pa automat ima po jednu kolonu za klasu, ne za svaki znak.

## 2. Algoritam: kako se konstruiše procesor

1. Odredi ulazne klase (npr. `c` = cifra, `+ - * /`, `─┤`).
2. Konstruiši **prepoznavač**: kreni od karakterističnih ulaza i dodeljuj stanja ("šta sam do sada video"). Spoj stanja koja se ponašaju isto.
3. Odredi **registre** i njihove početne vrednosti (inicijalizacija se piše uz startno stanje ili u akciji prvog prelaza).
4. Za **svaki ne-prazan ulaz** tabele napiši akciju (jedna ili više naredbi). Prelaz bez efekta označi `–`.
5. Na `─┤` napiši završnu akciju (npr. upiši rezultat) i prihvatanje.
6. Proveri na dva-tri ulaza (jedan ispravan, jedan sa greškom). Označi pretpostavke koje si uveo (npr. celobrojno deljenje).

Savet: ako stanje ne mora da pamti ništa osim "u kom sam delu ulaza", sve ostalo ide u registre (broj stanja ostaje mali).

## 3. Primeri

### 3.1 Izraz bez zagrada, sleva nadesno (K nadoknada 22.1.2021, zadatak 1)

Zadatak: procesor računa aritmetički izraz sa `+ - * /` bez zagrada, svi operatori istog prioriteta, redosled sleva nadesno (`15+35*50 = 2500`). Ulazi: `+ - * / c ─┤` (`c` je cifra). Stanja se označavaju A, B, C.

Prepoznavač (stanja): **A** = start, očekuje se prva cifra; **B** = u broju (poslednji simbol je cifra); **C** = iza operatora, očekuje se cifra.

Registri: `R` (rezultat do sada, početno 0), `N` (tekući broj), `O` (poslednji operator, početno `+`). Trik sa `R:=0`, `O:='+'` ne traži poseban slučaj za prvi broj.

| stanje | `c` | `+` | `-` | `*` | `/` | `─┤` |
|---|---|---|---|---|---|---|
| → A | `N := val(c)`, → B | | | | | |
| B | `N := N*10 + val(c)` | `R := R O N; O := '+'`, → C | `R := R O N; O := '-'`, → C | `R := R O N; O := '*'`, → C | `R := R O N; O := '/'`, → C | `R := R O N`, ACCEPT, rezultat je `R` |
| C | `N := val(c)`, → B | | | | | |

**Format na kolokvijumu (po skeniranom rešenju):** list ima dva odvojena polja, "finalni automat bez akcija" (tabela prelaza + kolona prihvatanja) i "akcije koje odgovaraju prelazima" (tabela iste veličine sa `ak1`, `ak2`...), pa ispod napiši šta svaka akcija radi. Upiši i pretpostavku "prazna sekvenca se ne prihvata" (ovde stanje A na `─┤` je greška). Studentsko rešenje je koristilo 7 stanja (po jedno za svaki operator, A–G: `c+((+|-|*|/)c+)*`), a ovo ovde 3 stanja uz registre. Oba su tačna, ali manji automat znači manje posla.

Prazna polja su greške (npr. izraz počinje operatorom ili se završava operatorom). `R O N` znači "primeni operator `O` na `R` i `N`". **Pretpostavka (uokviriti na K):** deljenje je celobrojno, a `N = 0` pri deljenju je greška. Provera na `15+35*50`: `R:=0+15=15`, pa `15+35=50`, pa `50*50=2500`. Proverio sam implementacijom (State pattern, ispod) na `15+35*50`, `100/7/2 = 7`, `9-10*2 = -2`, `2*3-4 = 2`, a `1+`, `+1`, `8/0` se odbijaju.

Implementacija State patternom (Java, kompajlirano i testirano):

```java
public class CalcFSM {
    // registri procesora
    long R = 0, N = 0;
    char O = '+';
    boolean error = false;

    interface State {
        boolean accepting();
        void handleInput(CalcFSM fsm, char ch);   // ch == '$' je marker kraja
    }

    static boolean isDigit(char c) { return c >= '0' && c <= '9'; }
    static boolean isOp(char c) { return c == '+' || c == '-' || c == '*' || c == '/'; }

    void apply() {                       // R := R O N
        switch (O) {
            case '+': R = R + N; break;
            case '-': R = R - N; break;
            case '*': R = R * N; break;
            case '/': if (N == 0) { error = true; setState(ERROR); } else R = R / N; break;
        }
    }

    State A = new State() {              // start: ocekuje se prva cifra
        public boolean accepting() { return false; }
        public void handleInput(CalcFSM f, char ch) {
            if (isDigit(ch)) { f.N = ch - '0'; f.setState(f.B); }
            else f.setState(f.ERROR);
        }
    };
    State B = new State() {              // u broju
        public boolean accepting() { return false; }
        public void handleInput(CalcFSM f, char ch) {
            if (isDigit(ch)) { f.N = f.N * 10 + (ch - '0'); }
            else if (isOp(ch)) { f.apply(); if (!f.error) { f.O = ch; f.setState(f.C); } }
            else if (ch == '$') { f.apply(); if (!f.error) f.setState(f.END); }
            else f.setState(f.ERROR);
        }
    };
    State C = new State() {              // posle operatora: ocekuje se cifra
        public boolean accepting() { return false; }
        public void handleInput(CalcFSM f, char ch) {
            if (isDigit(ch)) { f.N = ch - '0'; f.setState(f.B); }
            else f.setState(f.ERROR);
        }
    };
    State END = new State() {
        public boolean accepting() { return true; }
        public void handleInput(CalcFSM f, char ch) { f.setState(f.ERROR); }
    };
    State ERROR = new State() {
        public boolean accepting() { return false; }
        public void handleInput(CalcFSM f, char ch) { }
    };

    State state = A;
    void setState(State s) { state = s; }

    static String run(String in) {
        CalcFSM f = new CalcFSM();
        for (char ch : in.toCharArray()) f.state.handleInput(f, ch);
        f.state.handleInput(f, '$');
        return f.state.accepting() ? "prihvata, R=" + f.R : "odbija";
    }
    public static void main(String[] a) {
        for (String s : new String[]{"15+35*50", "7", "100/7/2", "1+", "+1", "2*3-4", "8/0", "12 3", "9-10*2"})
            System.out.println(s + " -> " + run(s));
    }
}
```

### 3.2 Neoznačene realne konstante (PP1_P03, str. 5–9)

Konstante: `1257`, `.0392`, `1E+534`, `1.`, `1.E5`, `2.0E10`. Nedozvoljene: `-21`, `.E3`, `E`, `E10`, `12E.`. Ulazna azbuka {DIGIT, `.`, E, SIGN}. Registri: `NR` (celobrojna vrednost mantise bez tačke), `ER` (eksponent), `CR` (broj cifara iza tačke), `SR` (predznak eksponenta). Za `12.3E4`: NR=123, ER=4, CR=1, SR=+1.

Stanja: **0** početno; **1** cifre pre opcione tačke; **23** (spojena stanja 2 i 3) tačka je viđena ili su cifre iza tačke; **4** slovo E; **5** predznak eksponenta; **6** cifre eksponenta; **7** tačka na početku (iza koje mora doći cifra).

| stanje | DIGIT | E | `.` | SIGN | `─┤` |
|---|---|---|---|---|---|
| → 0 | 1 (a) | | 7 | | |
| 1 | 1 (b) | 4 (a) | 23 (c) | | YES1 |
| 23 | 23 (a) | 4 (b) | | | YES2 |
| 4 | 6 (a) | | | 5 | |
| 5 | 6 (b) | | | | |
| 6 | 6 (c) | | | | YES3 |
| 7 | 23 (b) | | | | |

Akcije (`val(cifra)` je binarna vrednost cifre): 1a: `NR := val(DIGIT)`; 1b: `NR := NR*10 + val(DIGIT)`; 23a: `CR := CR+1; NR := NR*10 + val(DIGIT)`; 23b: `CR := 1; NR := val(DIGIT)`; 23c: `CR := 0`; 4a: `CR := 0`; 4b: ništa; 5: `SR := val(SIGN)` (±1); 6a: `SR := +1; ER := val(DIGIT)`; 6b: `ER := val(DIGIT)`; 6c: `ER := ER*10 + val(DIGIT)`; YES1: `ER := 0; CR := 0`; YES2: `ER := 0`; YES3: ništa.

Rad na `12.3E4` (proveren simulacijom svih navedenih primera, prihvaćene i odbijene):

| stanje | ulaz | akcija | NR | ER | CR | SR |
|---|---|---|---|---|---|---|
| 0 | 1 | 1a | 1 | 0 | 0 | 0 |
| 1 | 2 | 1b | 12 | 0 | 0 | 0 |
| 1 | . | 23c | 12 | 0 | 0 | 0 |
| 23 | 3 | 23a | 123 | 0 | 1 | 0 |
| 23 | E | 4b | 123 | 0 | 1 | 0 |
| 4 | 4 | 6a | 123 | 4 | 1 | 1 |
| 6 | ┤ | YES3 | 123 | 4 | 1 | 1 |

Rad na `.9E-21` (mantisa počinje tačkom, eksponent sa predznakom): konačno `NR=9, ER=21, CR=1, SR=-1`, pa je vrednost 9·10^(−1−21).

| stanje | ulaz | akcija | NR | ER | CR | SR |
|---|---|---|---|---|---|---|
| 0 | . | 7 | 0 | 0 | 0 | 0 |
| 7 | 9 | 23b | 9 | 0 | 1 | 0 |
| 23 | E | 4b | 9 | 0 | 1 | 0 |
| 4 | - | 5 | 9 | 0 | 1 | -1 |
| 5 | 2 | 6b | 9 | 2 | 1 | -1 |
| 6 | 1 | 6c | 9 | 21 | 1 | -1 |
| 6 | ┤ | YES3 | 9 | 21 | 1 | -1 |

## 4. Implementacija konačnog automata (PP1_P03, str. 11–19)

- **Implicitna funkcija prelaza**: stanje je određeno mestom u kodu (`switch(state)` pa `if` po simbolu). Čitljivo, ali se menja kod kad se menja automat.
- **Eksplicitna**: matrica `T[stanje][simbol]` + vektor prihvatanja. Kod je isti za svaki automat, menja se samo tabela. Greška se često kodira posebnim stanjem `ERROR`.
- **State pattern (OO)**: interfejs `State { accepting(); handleInput(ctx, ch) }`, po jedna klasa za svako stanje (u `handleInput` se odlučuje o prelazu i poziva `ctx.setState(...)`), a `Context` (FSM) čuva tekuće stanje i registre i delegira `handleInput`. Klasni dijagram: `Context` ◇→ `State` (interfejs) ◁– `StateA`, `StateB`, `StateERROR`. Akcije procesora idu u `handleInput` konkretnih stanja (vidi 3.1).

Isti automat (A prihvata; A –a→ B; B –a→ A; B –b→ B) u sve tri varijante (kompajlirano, sve tri se slažu na svih 2047 reči do dužine 10):

```java
public class Fsm3 {
    // Automat sa slajda: A (prihvata) --a--> B ; B --a--> A ; B --b--> B ; sve ostalo: greska
    enum State { A(true), B(false), ERROR(false);
        final boolean accepting;
        State(boolean acc) { accepting = acc; } }

    // 1) EKSPLICITNA funkcija prelaza: matrica [stanje][simbol]
    static final State[][] T = {
        /* A */     { State.B,     State.ERROR },
        /* B */     { State.A,     State.B     },
        /* ERROR */ { State.ERROR, State.ERROR }
    };
    static boolean explicit(String w) {
        State s = State.A;
        for (char ch : w.toCharArray()) {
            int col = ch == 'a' ? 0 : ch == 'b' ? 1 : -1;
            s = col < 0 ? State.ERROR : T[s.ordinal()][col];
        }
        return s.accepting;
    }

    // 2) IMPLICITNA funkcija prelaza: switch po stanju + if po simbolu
    static boolean implicit(String w) {
        State s = State.A;
        for (char ch : w.toCharArray()) {
            switch (s) {
                case A: s = (ch == 'a') ? State.B : State.ERROR; break;
                case B: s = (ch == 'a') ? State.A : (ch == 'b') ? State.B : State.ERROR; break;
                case ERROR: break;
            }
        }
        return s.accepting;
    }

    // 3) State pattern
    interface St { boolean accepting(); void handle(Ctx c, char ch); }
    static class Ctx {
        St A = new St() { public boolean accepting() { return true; }
            public void handle(Ctx c, char ch) { c.set(ch == 'a' ? c.B : c.ERR); } };
        St B = new St() { public boolean accepting() { return false; }
            public void handle(Ctx c, char ch) { c.set(ch == 'a' ? c.A : ch == 'b' ? c.B : c.ERR); } };
        St ERR = new St() { public boolean accepting() { return false; }
            public void handle(Ctx c, char ch) { } };
        St cur = A;
        void set(St s) { cur = s; }
        boolean run(String w) { for (char ch : w.toCharArray()) cur.handle(this, ch); return cur.accepting(); }
    }

    public static void main(String[] args) {
        int n = 0;
        for (int len = 0; len <= 10; len++)
            for (int m = 0; m < (1 << len); m++) {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < len; i++) sb.append(((m >> i) & 1) == 0 ? 'a' : 'b');
                String w = sb.toString();
                boolean e = explicit(w), i = implicit(w), p = new Ctx().run(w);
                if (e != i || i != p) throw new RuntimeException(w);
                n++;
            }
        System.out.println("saglasno na " + n + " reci; aab=" + explicit("aab") + " aa=" + explicit("aa") + " abb a=" + explicit("abba"));
    }
}
```

## 5. Leksički procesor za pravi jezik (vežbe, `LeksickaAnaliza_V_dodatak.doc`)

Leksički analizator izdvaja leksemu omeđenu prazninama i vraća interni kod `(klasa, vrednost)`: promenljiva → `(P, redni broj u tabeli simbola)`, konstanta → `(C, binarna vrednost)`, ključna reč/operator → `(IF, –)` itd. Stanja: A (start), B (ključna reč ili promenljiva), C (konstanta), D (specijalni znak). Transliterator preslikava znak u klasu slovo/cifra/spec. Akcija u stanju B prvo konsultuje prepoznavač ključnih reči (savršena heš funkcija ili lista prelaza) i tek ako reč nije ključna, a dužina je 1, ubacuje je u tabelu simbola.

## 6. Tipične greške

- Akcija za `─┤` izostavljena: procesor nikad ne "izda" rezultat.
- Poslednji broj se ne primeni na rezultat (u 3.1 treba `R := R O N` i pri prelazu na `─┤`, ne samo pri operatoru).
- Pogrešan redosled operacija u akciji: `N := N*10 + val(c)`, ne `val(c)*10 + N`.
- Prioritet operatora uveden iako zadatak kaže "bez prioriteta, sleva nadesno".
- Registri se ne inicijalizuju (`R:=0`, `O:='+'`).
- Dodavanje stanja za svaki znak umesto za klasu znakova.
- U State patternu: zaboravljeno stanje `ERROR` (nepoznat ulaz), ili `accepting()` u pogrešnom stanju.

## 7. Pojavljivalo se na K

- **IR nadoknada 22.1.2021, zad. 1**: procesor za izraze sa `+ - * /` (primer 3.1).
- **SI K1 2016/17**: DKA → procesor sa akcijama (izračunavanje).
- **SI K1 2019/20**: State pattern za automat (klasni dijagram + kod). **SI K1 2020/21**: State pattern i eksplicitna funkcija prelaza u Javi.
- Primer iz predavanja (3.2) je klasika: može biti zadat sličan zadatak (moja pretpostavka, nije potvrđeno): npr. celi brojevi sa predznakom ili heksadecimalne konstante sa registrima kao NR/ER/CR/SR.
