# Poređenje naših beleški sa skeniranim rešenjima (2020/21)

Skenovi u `materijali/kolokvijumi/2020-2021_Resenje_*.pdf` su **rukom pisana studentska rešenja** sa crvenim kvačicama (naslovna strana nadoknade iz feb 2021. ima upisano 15 i 15 poena). Nisu zvanična rešenja asistenata. Neki delovi su mutni (npr. potisni automat u IR nadoknadi iz feb 2021.).

| Zadatak | Skenirano rešenje | Naše beleške | Ishod |
|---|---|---|---|
| IR nadoknada 22.1.2021., z1: konačni procesor (kalkulator) | Regex `c+((+\|-\|*\|/)c+)*`, DKA sa 7 stanja (A–G), dve tabele: automat i akcije `ak1..ak7`; pretpostavka "prazna sekvenca se ne prihvata" | `beleske/02` §3.1: 3 stanja uz registre `R`, `N`, `O` | Oba tačna. Dodato: format sa dve tabele i pretpostavka o praznoj sekvenci |
| IR nadoknada 22.1.2021., z2: gramatika `S→fAf, A→cB, B→fSc\|ε` | Izvođenje, LR(0) automat, SLR(1) tabela, FOLLOW(S)={─┤,c}, FOLLOW(A)=FOLLOW(B)={f}, konflikt shift/reduce u stanju `c2` na `f` | `beleske/05` §3.5: isti automat, FOLLOW skupovi i konflikt | Slaže se. Razlika samo u numeraciji smena (original: 1, 2, 4, 5), dodato upozorenje |
| nadoknada 12.2.2021.: LALR vrsta ▽ za `S→AS\|ε, A→BbBc\|CcCB, B→aD, C→aD, D→ε` | LR(0) stanje ▽, SLR(1) i LALR(1) vrsta: `a` SHIFT, `─┤` REDUCE(2), bez konflikta; FOLLOW(A)={a,─┤}, FOLLOW(B)={b,c,a,─┤}, FOLLOW(C)={c} | `beleske/05` §3.6: isti skupovi i ista vrsta | Slaže se |
| nadoknada 12.2.2021., PDA za brojeve deljive sa 4 | Pristup sa markerom `A` na steku i tri tabele (mutan sken) | `beleske/04` §4.5: jedno stanje sa `∇/A/B/C` ili četiri stanja | Mutan sken, ne mogu da potvrdim detalje. Oba pristupa u načelu rade |
| SI K1 2020/21, z1: State pattern i eksplicitna tabela | Enum + matrica `[stanje][ulaz]` i State interfejs sa `goNext(int)` | `beleske/02` i State pattern kod | Slaže se |
| SI K1 2020/21, z2: skup prirodnih brojeva, metoda pozicija | Izraz `{(bd*(,bd*)*\|ε)}─┤`, 8 pozicija, DKA S1–S6 (S3 ≡ S6) | Nije bilo u beleškama | Student-ov DKA je tačan (provereno skriptom, 0 neslaganja na 47 mil. niski). Dodato u `beleske/01` |
| SI K1 2020/21, z3: `a^k b^m c^(2n) b^m a^k`, m>0 | `S→aSa\|T`, `T→bTb\|bCb`, `C→ccC\|ε` | Nije posebno obrađeno (opšti obrasci u `beleske/03`) | Gramatika je tačna: `T` daje `b^m C b^m`, `C` daje `c^(2n)` |
| SI K2 nadoknade (22.1. i 12.2.2021.) | LL(1): leva faktorizacija i eliminacija leve rekurzije na gramatici sa `CONST`, `IDENT`, `LIST`; SELECT skupovi | `beleske/07` | Nisam detaljno poredio. LL(1) transformacija ulazi u K1 (IR 2019) |

## Šta ovo menja za K1

- Rezultati naših beleški se poklapaju sa skeniranim rešenjima gde sam mogao da poredim. Nisam našao grešku u beleškama.
- Format odgovora na listu: odvojene tabele (automat, akcije), LR automat sa imenovanim stanjima, kontrolna tabela. Pretpostavke se upisuju u okvir.
- `analiza-starih-K.md` kaže da je zadatak 1 nadoknade od 12.2.2021. atributivna gramatika (polinom), a sken iste nadoknade ima LALR zadatak 1. Verovatno postoje dve varijante lista (ili je sken iz druge grupe). Nije rešeno, a za K1 je bitno samo da oba tipa mogu da se pojave.
