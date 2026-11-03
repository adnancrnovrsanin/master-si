# Mašinsko učenje: uvod, k najbližih suseda, metrike (K3, ne K1)

Izvor: `vezbe/5_Uvod_u_mašinsko_učenje.pdf` (kNN sl. 8-25, metrike sl. 26-41), `predavanja/IS_P10`, `IS_P11`. Prema planu SI (`0_Uvod` sl. 3) mašinsko učenje je treći kolokvijum. Brojevi iz primera provereni skriptom.

## Pojmovi (sl. 3-7)
- **Nadgledano** (x, y): regresija (y kontinualno) i klasifikacija (y kategorija). **Nenadgledano** (samo x): klasterovanje, detekcija anomalija, asocijacija. Polunadgledano. Sa podrškom (agent + signal nagrade).
- Koraci: formulacija i čitanje podataka, analiza, čišćenje, transformacija atributa, izbor i treniranje modela, validacija i testiranje.

## kNN (sl. 8-10)
**Recept:**
1. Izaberi k (neparan zbog izjednačenja; čest izbor k ≈ √broj podataka).
2. Izračunaj rastojanje nepoznate instance do **svih** instanci. Euklid: √Σ(pᵢ−qᵢ)², Menhetn: Σ|pᵢ−qᵢ|, Čebišev: max|pᵢ−qᵢ|.
3. Sortiraj, uzmi k najbližih, klasa = većina (regresija: srednja vrednost).
- k = 1 nestabilno; preveliko k zahvata previše podataka i povećava grešku.
- **Normalizacija** (min-max): x' = (x − xmin)/(xmax − xmin). Obavezna kad atributi imaju različite opsege (sumpor-dioksid 18-102 poništava hlor 0.065-0.098). Jedan outlier uništava skalu ostalih atributa (sl. 20, Zadatak 2).
- **Kategorički atributi**: one-hot (za svaku vrednost nov 0/1 atribut), ne brojevi 0,1,2 jer to uvodi lažni poredak.

**Primer (sl. 11-14, "Mršava osoba"):** 8 označenih osoba (masa, visina, mršava). k = round(√8) = 3.
- Nepoznata (57, 170): tri najbliža su (58,169) Ne, d = 1.41; (57,173) Ne, d = 3.00; (56,174) Da, d = 4.12 → **Ne**.
- Nepoznata (66, 182): (62,182) Ne 4.00; (69,176) Ne 6.71; (64,173) Ne 9.22 → **Ne**.

## Metrike za klasifikaciju (sl. 26-41, Zadatak 4)
Matrica konfuzije za klasu "pozitivna": TP, TN, FP, FN.
- **Tačnost** = (TP + TN)/ukupno.
- **Preciznost** (klase) = TP/(TP + FP) = "od onih koje sam proglasio pozitivnim, koliko je tačno".
- **Odziv** (klase) = TP/(TP + FN) = "od svih stvarno pozitivnih, koliko sam našao".
- Za drugu klasu zamene se uloge (preciznost "ne" = TN/(TN + FN)).

**Primer (Medicinska dijagnostika, k = 3, Menhetn):** TP = 1, TN = 5, FP = 0, FN = 2. Tačnost 6/8 = 0.75; preciznost (da) 1/1 = 1.00; odziv (da) 1/3 = 0.33; preciznost (ne) 5/7 = 0.71; odziv (ne) 5/5 = 1.00. (Skripta potvrđuje predikcije: T16 i T18 pogrešno "ne", T17 tačno "da".)

## Tipične greške
- Nenormalizovani atributi različitih opsega.
- Mešanje preciznosti i odziva (preciznost gleda predikcije, odziv stvarne pozitive).
- Računanje metrika samo za jednu klasu kad zadatak traži za obe.
- Za tiebreak pri jednakim glasovima: neparno k.
