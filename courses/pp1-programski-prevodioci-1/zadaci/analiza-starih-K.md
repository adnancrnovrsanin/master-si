# Analiza starih kolokvijuma — Programski prevodioci 1

Izvor: zadaci u `materijali/kolokvijumi/` (IR "K" 2019–2022, SI K1 2010–2020). Fajlovi sa imenima `13E114PP1_K_*` i `13S114PP1_K*_*` na sajtu su samo **rezultati** (imena i poeni), pa sam ih obrisao. Posle 2022. zadaci se ne objavljuju na sajtu, traži ih na SI Wiki (`/К_2023`, `/К1_2022`...).

## Format IR kolokvijuma

- 3 zadatka po 10 poena, ukupno 30, 90 minuta, bez literature, prvih sat vremena se ne sme izaći. Nadoknade (jan/feb 2021.): 2 zadatka po 15, 60 minuta.
- Napomena na svakom: ako nešto nije precizirano, uvedi razumnu pretpostavku, uokviri je i nastavi.
- Prethodna godina: kolokvijum se održavao kasno u novembru (22.11.2019., 26.11.2021.), kao i ove godine (28.11.2026.).

## Zadaci po godinama (IR)

| Godina | Zadatak 1 | Zadatak 2 | Zadatak 3 |
|---|---|---|---|
| 22.11.2019. | Rekonstruisati LR(0) automat iz potisne i kontrolne tabele, naći gramatiku, FOLLOW i SLR(1) tabelu | Regularni izraz `(a\|b\|ε)*d(c*d)+` → Tompson → minimalni DKA, pa gramatika | Gramatika sa levom rekurzijom: FIRST/FOLLOW, transformacija u LL(1), parser rekurzivnim spustom za `<A>` |
| nadoknada 22.1.2021. | Konačni procesor (DKA sa akcijama) koji računa izraz sa `+ - * /`, bez prioriteta, sleva nadesno | Gramatika `S→fAf, A→cB, B→fSc\|ε`: izvođenje, LR(0) automat i tabela, SLR(1) tabela, konflikti | — |
| nadoknada 12.2.2021. (varijanta u PDF-u; sken iste nadoknade ima LALR vrstu ▽ umesto toga) | Atributi za gramatiku polinoma (nasleđeni `x`, sintetizovana vrednost) | Potisni automat za niz celih brojeva deljivih sa 4 u binarnom zapisu, razdvojenih zarezom | — |
| 26.11.2021. | (a) Postupak za zvezdasto zatvaranje determinističkog automata, (b) primena na M1, (c) minimizacija particionom metodom | Gramatika za niz izraza sa `+ - *` i novim desno asocijativnim `#` (prioritet između), stablo izvođenja | LALR(1) automat i tabela za `S→AA, A→AaAb\|c\|d`, stek i panic mode oporavak sa sigurnim simbolima |

## Zadaci po godinama (SI K1, isto gradivo prvog dela)

| Godina | Teme |
|---|---|
| 2010/11 | Struktura prevodioca (dijagram), minDKA za binarne deljive sa 4, eliminacija suvišnih neterminala, desno-linearna → regularna gramatika → NKA |
| 2011/12 | Dvosmislenost gramatike, minDKA za binarne deljive sa 8 (regex, Tompson, DKA), suvišni neterminali, gramatika izraza sa `\|\|` i `$` (prioritet, asocijativnost) |
| 2012/13 | Robot (KA i gramatika), regex nad klasama znakova, gramatika sa `$`/`#`, LR(0) parser (automat, potisna, kontrolna) i rad na ulazu |
| 2015/16 | Operacije nad DKA (unija sa komplementom) + minimizacija, regularna gramatika za `a*\|b*`, KS gramatika `a^n c^m (b c^k)^n`, metoda pozicija + Tompson |
| 2016/17 | Metoda pozicija + minimizacija, regex i gramatika za listu identifikatora/konstanti, DKA → procesor sa akcijama (izračunavanje), gramatika i PDA za `a^n b^m c^n`, m parno |
| 2017/18 | PDA `a^k b^m c^(k-1)`, direktno na sintaksnom stablu: poništivost/prva/poslednja/sledeća pozicija → KA, ekvivalencija automata, NKA → DKA |
| 2019/20 | State pattern za automat (klasni dijagram + kod), metoda pozicija za `b(a\|(bc)*)+`, gramatika i PDA za `(ab)^n c^m a^k`, m>k>0 |
| 2020/21 | State pattern i eksplicitna funkcija prelaza u Javi, regex za skup prirodnih brojeva u vitičastim zagradama + metoda pozicija, gramatika `a^k b^m c^(2n) b^m a^k` + stablo |

## Učestalost tema (IR 4 + SI K1 8 kolokvijuma)

| Tema | Pojavljivanje | Napomena |
|---|---|---|
| Regularni izraz → DKA (metoda pozicija ili Tompson + NKA→DKA) i minimizacija particionom metodom | Skoro svaki K | Najsigurniji zadatak, vežbaj mehanički |
| Pisanje KS gramatike (jezici tipa `a^n b^m c^n`, izrazi sa prioritetom i asocijativnošću, nedvosmislena) | Skoro svaki K | Obe varijante |
| Potisni automat (PUSH/POP/ADVANCE/STATE/ACCEPT/REJECT) | 4 od 12 | Za jezike sa brojačem |
| LR(0), SLR(1), LALR(1): karakteristični automat, kontrolna i potisna tabela, konflikti | 3 od 4 IR | Svi IR K osim nadoknade iz februara 2021. |
| Konačni procesor (automat sa akcijama), izračunavanje vrednosti | 2 | |
| Operacije nad automatima (ekvivalencija, komplement, zvezdasto zatvaranje, NKA→DKA) | 3 | |
| FIRST/FOLLOW, LL(1) transformacija, rekurzivni spust | 1 IR (2019) | Pokriva P8 (top-down) |
| Oporavak od grešaka (panic mode) | 1 IR (2021/22) | |
| State pattern za automat | 2 SI K1 (2019, 2020) | Ne u IR, ali moguće |
| Atributivne gramatike | 1 IR (feb 2021) | Prošlogodišnje obaveštenje isključuje P7 |
| Teorija: dvosmislenost, struktura prevodioca, suvišni neterminali | 2010–2011 | Retko |

## Zaključak za K1 28.11.

- Najverovatnije tri zadatka iz: (1) regex/automat/minimizacija, (2) gramatika ili potisni automat, (3) LR(0)/SLR(1)/LALR(1) ili LL(1)/rekurzivni spust. To se poklapa sa gradivom do top-down parsiranja (P08/V6).
- Uvežbaj mehanički: metodu pozicija, Tompsona, particionu minimizaciju, konstrukciju LR(0) automata i SLR/LALR tabele, FIRST/FOLLOW, LL(1) transformaciju (eliminacija leve rekurzije, faktorizacija).
- Atributivne gramatike i sintaksno-upravljano prevođenje su van prošlogodišnjeg obima (P7/P7a), ali su se pojavile u starijem IR K (feb 2021). Ostavi za kraj.
- Rešenja: `Resenje_*.pdf` su skenirana studentska rešenja (ne zvanična). Pročitao sam ih i poredio sa beleškama, vidi [poredjenje-sa-skeniranim-resenjima.md](poredjenje-sa-skeniranim-resenjima.md). Možeš ih koristiti da uporediš sopstvena rešenja.

## Stare K koje još fale

SI Wiki ima K 2023, K1 2012, 2015, 2017, 2019, 2022 (neki bez rešenja). Pogledaj `https://siwiki.rs/wiki/Програмски_преводиоци_1` i tražene podstranice.
