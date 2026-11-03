# 03. Gramatike: KS gramatike, nedvosmislenost, prioritet i asocijativnost, pisanje gramatika, suvišni neterminali

**Izvor:** `PP1_P04.pdf` (strane PDF-a: BNF/EBNF 6–8, terminologija 9–13, višeznačnost 15–18, klasifikacija 20), udžbenik `pp1_udzbenik.pdf` str. 65–77, Zbirka odeljci 2.1–2.4 (izvođenja, zad. 2.2.3 jezici tipa 1ⁿ0ᵐ, zad. 2.3.1 suvišni neterminali, zad. 2.4.1–2.4.2 gramatike i automati), vežbe `Cas 3 - Sintaksna analiza.pptx` i `SintaksnaAnaliza_V.doc`, `SintaksnaAnaliza_V_dodatak.doc` (liste, izrazi, asocijativnost).

## 1. Definicije (2–3 rečenice)

- **Bezkontekstna gramatika** je četvorka G = (VN, VT, P, ⟨S⟩): neterminali, terminali, smene oblika ⟨X⟩ → α (α je niz od nula ili više simbola) i startni neterminal. Jezik L(G) je skup nizova terminala izvodljivih iz ⟨S⟩ u nula ili više koraka.
- **Levo izvođenje** zamenjuje uvek prvi neterminal sleva, **desno** krajnje desni. **Stablo izvođenja**: čvor ⟨X⟩ sa decom Y, Z, V za smenu ⟨X⟩ → Y Z V; listovi sleva nadesno daju sentencu.
- Gramatika je **višeznačna** ako za neku sentencu postoje dva različita stabla izvođenja (ekvivalentno: dva različita leva izvođenja). Višeznačnost je osobina gramatike, ne jezika. Za prevođenje je nepoželjna.
- Hijerarhija (Čomski): tip 0 neograničene, tip 1 kontekstne, **tip 2 bezkontekstne** (levo je tačno jedan neterminal), **tip 3 regularne** (desna strana ε, ili terminal(i), ili terminal pa neterminal). Za prevodioce su bitni tipovi 2 i 3. Svaka regularna je desno-linearna (najviše jedan neterminal i to na kraju), obrnuto ne.

## 2. Recepti

### 2.1 Pisanje gramatike za jezik (obrasci)

1. **Lista** jednog ili više elemenata: `L → L x | x` (leva rekurzija, leva asocijativnost) ili `L → x L | x` (desna). Sa separatorom: `L → L , x | x`. Nula ili više: `L → L x | ε`.
2. **Uparene (ugnježdene) delove** gradi rekurzija oko sredine: `S → a S c | ⟨sredina⟩` daje aⁿ … cⁿ.
3. **Nezavisni delovi** se spajaju konkatenacijom neterminala: `S → X Y`, svaki od X, Y opisuje svoj deo.
4. **Zavisnost dužina**: odredi koji simboli su "upareni" (isti brojač) i oko njih ugnezdi smenu; ostalo je slobodno ponavljanje.
5. **Nejednakost** (n > m): najkraća sentenca (npr. `110`) + smene koje "dodaju" par (`1 S 0`) ili samo višak (`1 S`).
6. **Parnost/višekratnik**: ponavljaj grupu (`B → b b B`, `U → c c U`).
7. **Različito (i ≠ j)**: razdvoj na slučajeve (i > j ili i < j).
8. **Uvek proveri**: izvedi najkraću sentencu i jednu običnu; proveri granične slučajeve (n = 0, m = 0) i to da li zadatak dozvoljava 0.

Obrasci, svi **provereni skriptom** nabrajanjem svih reči do dužine 9–10 i poređenjem sa definicijom jezika:

| Jezik | Gramatika |
|---|---|
| aⁿbᵐcⁿ, n,m ≥ 0 | `S → a S c \| B`, `B → b B \| ε` (za m ≥ 1: `B → b B \| b`) |
| aⁿbᵐcⁿ⁺ᵐ | `S → a S c \| B`, `B → b B c \| ε` |
| aⁿbᵐcⁿ, m parno (SI K1 2016/17) | `S → a S c \| B`, `B → b b B \| ε` |
| 1ⁿ0ᵐ, n > m > 0 (Zbirka 2.2.3a) | `S → 1 1 0 \| 1 S 0 \| 1 S` |
| aᵏbᵐcᵏ⁻¹, k ≥ 1 (SI K1 2017/18, za PDA) | `S → a S c \| a B`, `B → b B \| ε` |
| (ab)ⁿcᵐaᵏ, m > k > 0 (SI K1 2019/20) | `S → a b S \| T`, `T → c T a \| c T \| c c a` |
| aᵏbᵐc²ⁿbᵐaᵏ (SI K1 2020/21) | `S → a S a \| T`, `T → b T b \| U`, `U → c c U \| ε` |
| aⁱbʲ, i ≠ j | `S → a S b \| A \| B`, `A → a A \| a`, `B → b B \| b` |

### 2.2 Aritmetički izrazi: prioritet i asocijativnost

1. Poređaj operatore od **najnižeg** do **najvišeg** prioriteta. Za svaki nivo jedan neterminal ⟨N₁⟩ (najniži), ⟨N₂⟩, … Operatori istog prioriteta i iste asocijativnosti idu u isti nivo (npr. `+` i `-`).
2. Nivo sa **levo asocijativnim** operatorom: `Nᵢ → Nᵢ op Nᵢ₊₁ | Nᵢ₊₁` (leva rekurzija). **Desno asocijativnim**: `Nᵢ → Nᵢ₊₁ op Nᵢ | Nᵢ₊₁` (desna rekurzija).
3. Poslednji nivo (primarni): operand ili `( N₁ )`. Operandi (broj, identifikator) se rastavljaju na CIFRA/SLOVO ako zadatak to traži.
4. Startni neterminal je najniži nivo (ili lista izraza razdvojenih separatorom).
5. Provera: nacrtaj stablo za dati primer. Višeznačnost se prepoznaje po `T → F | T * T` (dva stabla za `id*id*id`) ili po pojavljivanju istog neterminala sa obe strane operatora na istom nivou.

Višeznačna `T → F | T * T` (2 stabla za `id * id * id`, proverio sam brojanjem stabala) se ispravlja u `T → F | T * F` (1 stablo). **Dangling else**: `Stmt → if E then Stmt | if E then Stmt else Stmt | other` daje 2 stabla za `if e then if e then other else other`. Rešenje (else se vezuje za najbliži neupareni then):

```
Stmt → Matched | Unmatched
Matched → if E then Matched else Matched | other
Unmatched → if E then Stmt | if E then Matched else Unmatched
```

(1 stablo za istu sentencu, proveren brojač.)

### 2.3 Suvišni neterminali (Zbirka 2.3.1, Cas 3 zad. 3)

**Redosled je obavezan: prvo mrtvi, pa nedostižni** (uklanjanjem mrtvih neki dostižni neterminali mogu postati nedostižni).

1. **Živi neterminali Ž**: Ž = ∅. Dok ima promene: ako smena ⟨A⟩ → α ima α sačinjeno samo od terminala, ε i neterminala iz Ž, dodaj ⟨A⟩ u Ž. Mrtvi = VN − Ž. Izbaci sve smene u kojima se mrtvi neterminal pojavljuje (i levo i desno).
2. **Dostižni D**: D = {⟨S⟩}. Dok ima promene: za svaki ⟨A⟩ iz D dodaj u D sve neterminale sa desnih strana njegovih smena. Nedostižni = (preostali neterminali) − D. Izbaci njihove smene.
3. Rezultat opisuje isti jezik.

### 2.4 Automat ↔ gramatika (Cas 3, zad. 4–5; Zbirka 2.4.1–2.4.2)

- **Automat → desno-linearna gramatika**: za svaki prelaz δ(A, x) = B smena ⟨A⟩ → x ⟨B⟩ (za NKA po jedna smena za svako stanje u skupu); startno stanje je startni neterminal; za svako stanje prihvatanja ⟨B⟩ → ε. Zatim izbaci mrtve i nedostižne neterminale (stanje greške je mrtvo).
- **Desno-linearna → regularna** (tri pravila): (1) ⟨A⟩ → w, w niz terminala, postaje ⟨A⟩ → w ⟨ε⟩ i ⟨ε⟩ → ε; (2) ⟨A⟩ → a₁a₂…aₙ⟨B⟩ (n > 1) se lanči novim neterminalima: ⟨A⟩ → a₁⟨a₂…aₙB⟩, …, ⟨aₙB⟩ → aₙ⟨B⟩; (3) ⟨A⟩ → ⟨B⟩ se zameni smenama ⟨A⟩ → β₁ | … | βₙ, gde su β desne strane smena za ⟨B⟩ (prethodno ukloni ⟨B⟩ → ⟨B⟩ ako postoji).
- **Regularna gramatika → NKA**: stanja su neterminali, ⟨A⟩ → a⟨B⟩ je prelaz A –a→ B, ⟨A⟩ → ε znači da je A stanje prihvatanja.

## 3. Primeri

### 3.1 Izrazi sa novim operatorom `#` (K 26.11.2021, zadatak 2)

Zadatak: niz od jednog ili više izraza razdvojenih `;`. Operacije `+ - *` leva asocijativnost, `*` ima veći prioritet od `+` i `-`. Novi binarni `#` je **desno asocijativan**, prioritet **između**: veći od `+ -`, manji od `*`. Zagrade rade standardno. Operand je celobrojna konstanta (jedna ili više cifara) ili promenljiva (slovo, pa slova i cifre). Dozvoljeni terminali CIFRA i SLOVO.

Nivoi (od najnižeg): `;` lista → `+ -` (levo) → `#` (desno) → `*` (levo) → primarni.

1. Niz → Niz ; Izraz
2. Niz → Izraz
3. Izraz → Izraz + Hash
4. Izraz → Izraz - Hash
5. Izraz → Hash
6. Hash → Mul # Hash
7. Hash → Mul
8. Mul → Mul * Prim
9. Mul → Prim
10. Prim → ( Izraz )
11. Prim → Konst
12. Prim → Prom
13. Konst → CIFRA
14. Konst → Konst CIFRA
15. Prom → SLOVO
16. Prom → Prom SLOVO
17. Prom → Prom CIFRA

(Neterminali: Niz, Izraz (`+ -`), Hash (`#`), Mul (`*`), Prim, Konst, Prom.) Provereno skriptom: tabele su SLR(1) bez konflikata (dakle nedvosmislena) i na 400 slučajnih izraza stablo izvođenja se poklapa sa referentnim parserom (prioritet i asocijativnost su tačni).

Stablo izvođenja za `id # 2 * (x1y + 5) ; (tmp – 11) # x * 5` (lanci jednostrukih smena su spojeni sa ⇒, operandi su skraćeni na tekst; u odgovoru nacrtaj stablo grafički):

- `<Niz>`
    - `<Niz> ⇒ <Izraz> ⇒ <Hash>`
        - `<Mul> ⇒ <Prim>`
            - `<Prom>` (id)
        - `#`
        - `<Hash> ⇒ <Mul>`
            - `<Mul> ⇒ <Prim>`
                - `<Konst>` (2)
            - `*`
            - `<Prim>`
                - `(`
                - `<Izraz>`
                    - `<Izraz> ⇒ <Hash> ⇒ <Mul> ⇒ <Prim>`
                        - `<Prom>` (x1y)
                    - `+`
                    - `<Hash> ⇒ <Mul> ⇒ <Prim>`
                        - `<Konst>` (5)
                - `)`
    - `;`
    - `<Izraz> ⇒ <Hash>`
        - `<Mul> ⇒ <Prim>`
            - `(`
            - `<Izraz>`
                - `<Izraz> ⇒ <Hash> ⇒ <Mul> ⇒ <Prim>`
                    - `<Prom>` (tmp)
                - `-`
                - `<Hash> ⇒ <Mul> ⇒ <Prim>`
                    - `<Konst>` (11)
            - `)`
        - `#`
        - `<Hash> ⇒ <Mul>`
            - `<Mul> ⇒ <Prim>`
                - `<Prom>` (x)
            - `*`
            - `<Prim>`
                - `<Konst>` (5)

Čitanje: `id # (2 * (x1y + 5))` i `(tmp − 11) # (x * 5)`. Zagrade (koje se ne vide u gramatici) vraćaju se na početak nivoa preko `Prim → ( Izraz )`.

### 3.2 Suvišni neterminali (Zbirka 2.3.1)

Gramatika sa startnim ⟨S⟩ (16 smena): `S → aABC | bCES | aE`, `A → bE | SCD | d`, `B → dFS | aBC`, `C → aES | bE`, `D → aAC | d`, `E → aCE | ε`, `F → AB | aF`.

1. Živi: A, D, E (izvode se u terminale: A → d, D → d, E → ε), S (S → aE), C (C → bE). B i F nikad ne dobiju terminalni niz (B → dFS i B → aBC zavise od F odnosno B, F → AB i F → aF zavise od B odnosno F). **Mrtvi: B, F.** Izbacuju se smene sa B i F: S → aABC, B → …, F → …. Ostaje: `S → bCES | aE`, `A → bE | SCD | d`, `C → aES | bE`, `D → aAC | d`, `E → aCE | ε`.
2. Dostižni iz S: S → C, E, S; C → E, S; E → C, E. **Dostižni = {S, C, E}.** A i D su postali nedostižni jer su bili dostižni samo preko smene S → aABC (izbačene u koraku 1). **Nedostižni: A, D.**
3. Rezultat: `S → bCES | aE`, `C → aES | bE`, `E → aCE | ε`. Jezik je isti (proveren nabrajanjem: 33 reči do dužine 7 u obe gramatike).

Ako se redosled zameni (prvo dostižnost), svi neterminali ispadnu "dostižni" i A, D se pogrešno zadrže.

### 3.3 Automat → gramatika (Cas 3 zad. 4)

Automat (NKA, startno A, stanja prihvatanja B i D, E je stanje greške): A: 0→{A,B}, 1→{E}; B: 0→{E}, 1→{C}; C: 0→{C}, 1→{B,C}; D: 0→{E}, 1→{C,D}; E: 0→{E}, 1→{E}. Desno-linearna gramatika po prelazima + ⟨B⟩ → ε, ⟨D⟩ → ε. D nije dostižno iz A, E je mrtvo (iz njega se ne stiže do prihvatanja). Posle uklanjanja:

```
A → 0 A | 0 B
B → 1 C | ε
C → 0 C | 1 B | 1 C
```

(proveren jezik: gramatika i NKA prihvataju iste reči nad {0,1} do dužine 8.)

Isti postupak za DKA iz beleške 01 (`(a|b|ε)*d(c*d)+`, K 22.11.2019 zad. 2b): `A → a A | b A | d B`, `B → c B | d C`, `C → c B | d C | ε` (A start; provereno protiv regularnog izraza do dužine 8).

### 3.4 Desno-linearna → regularna → NKA (Cas 3 zad. 5)

Data: `A → ab B | ac`, `B → A | ε`. Primena pravila: A → ab B postaje `A → a X`, `X → b B`; A → ac postaje `A → a Y`, `Y → c E`, `E → ε`; B → A zamenjujemo smenama za A: `B → a X | a Y`; ostaje `B → ε`. Regularna gramatika:

```
A → a X | a Y      X → b B      Y → c E
B → a X | a Y | ε  E → ε
```

NKA: stanja A, X, Y, B, E; prelazi A –a→ X, A –a→ Y, X –b→ B, Y –c→ E, B –a→ X, B –a→ Y; prihvataju B i E. Jezik: (ab)⁺ | (ab)*ac (provereno do dužine 8).

## 4. Tipične greške

- Desna rekurzija tamo gde se traži leva asocijativnost (ili obrnuto): `a-b-c` se grupiše kao `a-(b-c)`.
- Isti neterminal na obe strane operatora (`E → E + E`): višeznačnost.
- Sabiranje i oduzimanje u različitim nivoima (menja se prioritet).
- `#` (desna asocijativnost): `Hash → Mul # Hash`, a **ne** `Hash → Hash # Mul`.
- Zagrade vraćaju na **najniži** nivo (`Prim → ( Izraz )`).
- Ne proveri se n = 0 (da li je prazna reč u jeziku) i da li zadatak traži bar jedan element liste.
- Suvišni neterminali: pogrešan redosled (prvo nedostižni).
- Gramatika regularnog jezika ne mora da bude regularna: dozvoljena je svaka KS gramatika, ali ako traže regularnu, mora biti oblika ⟨A⟩ → a⟨B⟩ | ε.
- Nepotpune smene za operande (promenljiva koja počinje slovom, a ostatak slova ili cifre).

## 5. Pojavljivalo se na K

- **IR 22.11.2019, zad. 2b**: gramatika koja opisuje isti jezik kao RI (3.3).
- **IR 26.11.2021, zad. 2**: izrazi sa `;`, `+ - *`, novi desno asocijativni `#`, stablo izvođenja (3.1).
- **SI K1**: 2010/11 eliminacija suvišnih neterminala, desno-linearna → regularna → NKA; 2011/12 dvosmislenost, suvišni neterminali, izrazi sa `||` i `$`; 2012/13 gramatika sa `$`/`#`; 2015/16 regularna za `a*|b*`, KS za aⁿcᵐ(bcᵏ)ⁿ; 2016/17 lista identifikatora/konstanti i aⁿbᵐcⁿ (m parno); 2019/20 (ab)ⁿcᵐaᵏ, m>k>0; 2020/21 aᵏbᵐc²ⁿbᵐaᵏ + stablo.
- Najčešće traženo (skoro svaki K): jedna gramatika sa uparenim delovima i jedna sa prioritetima/asocijativnošću.
