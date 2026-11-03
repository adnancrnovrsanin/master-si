# Stabla odlučivanja (K3, ne K1)

Izvor: `vezbe/6_Stabla_odlučivanja.pdf` (ID3, entropija, Gini), `predavanja/IS_P9_Indukcioni_sistemi`. Feb 2024 rok: "stablo odlučivanja entropijom + tačnost, odziv, preciznost". Brojevi provereni skriptom.

## Ideja
Unutrašnji čvor = atribut, grana = vrednost atributa, list = klasa. Gradi se od korena **pohlepno** (ID3): u svakom koraku izabere se najbolji atribut, skup se podeli po njegovim vrednostima, rekurzivno se ponavlja dok se ne stigne do listova (čistih skupova) ili kriterijuma zaustavljanja. Strategije izbora atributa: random, least-values, most-values, **max-gain** (dobit informacija ili Gini).

## Formule
- Entropija: **E(S) = −Σ pᵢ log₂ pᵢ** (0·log 0 = 0). Čist skup 0, 50:50 binarno = 1.
- Dobit informacija: **Gain(S, F) = E(S) − Σ_v (|S_v|/|S|)·E(S_v)**. Bira se atribut sa **najvećom** dobiti.
- Gini: **Gini(S) = 1 − Σ pᵢ²** (binarno max 0.5). Podela: **Gini(S, F) = Σ_v (|S_v|/|S|)·Gini(S_v)**. Bira se atribut sa **najmanjim**.
- Gini je brži (nema logaritma), entropija po slajdu za nijansu bolja na testu; danas se češće koristi Gini.

## Recept
1. Izračunaj E(S) (ili Gini) celog skupa.
2. Za **svaki** atribut: podeli po vrednostima, izračunaj E (Gini) svakog podskupa, težinski prosek po veličinama, dobit.
3. Izaberi najbolji atribut kao koren. Atribut "ime/životinja" koji je jedinstven ne daje informaciju, izbaci ga.
4. Za svaku granu ponovi sa podskupom (bez već iskorišćenog atributa). List kad je podskup čist.
5. Za kontinualne atribute: izaberi prag (kandidati su granice gde se menja klasa, ili medijana), pa tretiraj kao da/ne atribut (npr. "kosa veća od 12").
6. Za test skup primeni stablo, napravi matricu konfuzije, računaj tačnost, preciznost, odziv.

## Primer: životinje koje ležu jaja (sl. 11-26)
Podaci: Noj, Krokodil, Gavran, Albatros leže jaja (Da); Delfin, Koala ne. Atributi: toplokrvna, pernata, krzno, pliva.

| Atribut | Gini podele | Dobit informacija |
|---|---|---|
| toplokrvna | 0.4 | 0.10917 |
| **pernata** | **0.22222** | **0.45915** |
| ima krzno | 0.26667 | 0.31669 |
| pliva | 0.41667 | 0.04411 |

E(S) = E(4 Da, 2 Ne) = 0.91830. Koren = **pernata** (i po Giniju i po dobiti). Pernata = Da → svi leže jaja (list). Pernata = Ne → {Krokodil Da, Delfin Ne, Koala Ne}: **toplokrvna** razdvaja potpuno (Gain 0.9183, Gini 0), pa je to sledeći čvor: toplokrvna = Ne → leže jaja (krokodil), toplokrvna = Da → ne leže (delfin, koala).

## Još na vežbama (samo pregled)
- **Simpsonovi (sl. 29-35):** kontinualni atributi, test na 4 primera: masa ≤ 75 daje Gain 0.5900 (najveća, pa je koren), a starost ≤ 40 samo 0.0183, tačnost 75%, preciznost M 100% / odziv M 67%, preciznost Ž 50% / odziv Ž 100%.
- **Regresivna stabla (sl. 36-51):** kad je izlaz kontinualan, umesto entropije koristi se **standardno odstupanje** S(A) = √(Σ(x − x̄)²/|A|) (formula u PDF-u izgleda bez korena zbog ekstrakcije, proveri na slajdu), koeficijent varijacije CV = S/x̄·100%. Biraš atribut sa najvećom **redukcijom standardnog odstupanja** S(T) − Σ P(c)·S(c). Zaustavljanje: CV ispod praga (npr. 10%) ili veličina skupa ≤ prag (npr. 3). List = srednja vrednost.
- **Random forest (sl. 52-58):** više stabala (bagging: podskupovi primeraka sa ponavljanjem + nasumični podskup atributa), klasa = većina (regresija: prosek). Smanjuje preobučavanje. Boosting je sekvencijalno (greške prethodnog modela ulaze u sledeći).

## Tipične greške
- Mešanje: **max** dobit ali **min** Gini.
- Zaboraviš težinski prosek po veličini podskupa.
- Ponovo koristiš atribut u istoj grani.
- Entropija sa log₁₀ umesto log₂.
- Ne označiš listove čistim klasama ili ostaviš grane bez primera.
