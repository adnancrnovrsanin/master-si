# Metodi zadovoljenja ograničenja (CSP)

K1 (potvrđeno, vidi `tipovi-zadataka.md`): drugi deo gradiva uz pretraživanje. Stari rokovi (Feb 2024, Jan 2024) imaju "standardan zadatak iz metoda zadovoljenja ograničenja".
Glavni izvor: vežbe `2_Metodi_zadovoljenja_ograničenja.pdf` (sl. = strana u PDF-u). Predavanje `IS_P7_CSP.pdf` daje teoriju (AC-3, MAC, skakanje unazad, min-konflikti).

Primeri u ovoj belešci su provereni skriptom (backtracking + MRV + stepen + LCV + FC + AC-3), i poklapaju se sa tragovima na slajdovima vežbi 22-28 i 31-40.

## 1. Formulacija

CSP = (X, D, C) (P7):

- **X** = promenljive, **D** = domen svake promenljive, **C** = ograničenja (opseg promenljivih + dozvoljene kombinacije).
- **Konzistentna dodela** = ne krši nijedno ograničenje. **Potpuna** = sve promenljive imaju vrednost. **Rešenje** = konzistentna i potpuna.
- Tipovi: **unarno** (jedna promenljiva, "Estonija ne želi žutu"), **binarno** (dve), **globalno** (npr. alldiff).
- **Graf ograničenja**: čvor = promenljiva, grana = binarno ograničenje. Ograničenja sa 3+ promenljivih predstavljaju se posebnim čvorom ili se razlažu na binarna.
- Razlika u odnosu na običnu pretragu (sl. 3): stanje nije "crna kutija", već dodela vrednosti promenljivama; test cilja = sva ograničenja zadovoljena.

### Kako se pravi model (na vežbama)

| Zadatak | Promenljive | Domen | Ograničenja |
|---|---|---|---|
| Raspored (sale) | nastavnici | njihove željene sale | ≠ između svaka dva (ista učionica ne sme) |
| Bojenje mape | regioni | boje | ≠ između susednih |
| Bioskop | osobe | brojevi sedišta 1-6 | ≠ svi (jedno mesto = jedna osoba), pored: \|a−b\|=1, razmak najmanje dva mesta: \|a−b\|≥3, "ne na krajevima": unarno, domen {2..5} |
| Nova godina | pokloni | brojevi kuća | aritmetička: A > B, B + C > 2, D = E, A = C + 1, C < D |
| Ukrštene reči | reči (brojevi na slici) | ponuđene reči odgovarajuće dužine | isto slovo na preseku, reč se ne koristi dva puta |

**Unarna ograničenja primeni odmah** (konzistencija čvora, sl. 17): samo skratiš domen, bez propagacije. U zadatku se to piše kao prvi korak ("unarana ograničenja mogu se odmah primeniti", Baltik sl. 41).

## 2. Algoritmi

### Backtracking (sl. 9-10)
DFS po promenljivama, dubina = broj promenljivih. Dodela je komutativna, pa se u svakom koraku bira samo **jedna** promenljiva (ne sve). Dodela se prihvata ako ne krši nijedno ograničenje sa već dodeljenim promenljivama; ako nijedna vrednost ne prolazi, vrati se na prethodnu promenljivu.

### Heuristike izbora (sl. 11-12, P7)
Redosled **promenljivih**:
1. **MRV** (minimum remaining values, "najograničenija promenljiva"): ona sa najmanje preostalih vrednosti u domenu.
2. Izjednačenje: **stepen** (most constraining): ona koja učestvuje u najviše ograničenja sa **još nedodeljenim** promenljivama.
3. I dalje izjednačenje: leksikografski (na vežbama; slajdovi kažu "na slučajan način", ali u zadacima uvek piše kako).

Redosled **vrednosti**: **LCV** (least constraining value): ona koja iz domena suseda izbaci najmanje vrednosti. Izjednačenje: redosled navođenja u zadatku (npr. crvena, zelena, plava; ili "po redosledu želja").

### Forward checking, FC (sl. 13-15)
Kad dodeliš `X = v`, **izbaci nekonzistentne vrednosti iz domena svih nedodeljenih suseda** od X. Ako neki domen postane prazan: backtrack odmah. FC ne hvata sve greške (primer Australija: NT i SA ne mogu obe da budu plave, a FC to otkriva tek kasnije, sl. 14).

### Konzistentnost luka i AC-3 (sl. 17-19, P7)
- Luk (X, Y) je konzistentan ako za **svaku** vrednost x ∈ D(X) postoji **bar jedna** vrednost y ∈ D(Y) koja ne krši ograničenje. Ako ne postoji, **x se briše iz D(X)** (brišeš uvek iz **repa**, tj. iz prve promenljive u paru; P7: "Uvek brišemo iz repa!").
- Ograničenja su obično simetrična, pa za svaku granu imaš **dva luka** (X,Y) i (Y,X). Oba proveravaš.
- **AC-3**: red (queue) svih lukova. Skini luk (X,Y), učini ga konzistentnim. Ako si promenio D(X), dodaj u red lukove (Z,X) za sve susede Z od X. Prazan domen = nema rešenja. Kraj kad je red prazan. Složenost O(c·d³).
- AC-3 je jeftin kao **preprocesiranje** (pre pretrage), a skuplji kad se radi dinamički posle svake dodele (mora da se vraćaju domeni pri backtrack-u, sl. 20).
- **Redosled lukova ne menja konačne domene**, samo broj koraka. Zato je bezbedno da rezultat predstaviš kao "domeni posle AC-3".

### Backtracking + FC + AC (naziv na slajdovima: ARC-BACKTRACKING, a u literaturi MAC)
Posle svake dodele: (1) FC na susedima, (2) AC-3 nad lukovima. Hvata više grešaka ranije nego sam FC (sl. 19, P7 "MAC").

### Lokalna pretraga (sl. 4-8, P7), samo kratko
- **Hill climbing**: počni od potpune (nekonzistentne) dodele, menjaj vrednost promenljive koja krši ograničenja tako da je novo stanje bolje (manje prekršenih). Može da zaglavi u lokalnom optimumu ili na platou. Lek: restart iz novog slučajnog stanja.
- **Simulirano kaljenje**: dozvoljava i lošije stanje, sa verovatnoćom koja opada sa temperaturom/brojem koraka.
- **Min-konflikti** (P7): vrednost sa najmanje konflikata; za n-kraljica iznenađujuće brz.
- (P7, teorija) **Skakanje unazad usmereno konfliktom**: vrati se na najskoriju promenljivu iz konfliktnog skupa, ne na prethodnu u redosledu.

## 3. Recept za zadatak (FC + MRV + stepen + LCV, opciono AC)

Ponavljaj dok sve promenljive nemaju vrednost:

1. Napiši trenutne domene (tabela: jedna kolona po promenljivoj).
2. **Izaberi promenljivu**: MRV, pa stepen među nedodeljenima, pa leksikografski (ili kako piše). Obrazloži u jednoj rečenici ("A ima 2 vrednosti, B i C takođe, A ima 3 nedodeljena suseda...").
3. **Izaberi vrednost**: LCV (izbroji koliko vrednosti iz suseda ta vrednost izbacuje) ili po redosledu navođenja.
4. **Dodeli**, pa **FC**: izbaci vrednost iz domena nedodeljenih suseda. Zapiši koji domeni su se promenili.
5. (Ako se traži) **AC-3**: proveri lukove među nedodeljenim promenljivama (i od njih ka dodeljenoj), brišući iz repa. Ponavljaj dok ima promena.
6. Ako je neki domen prazan: **BACKTRACK**. Poništi dodelu (i FC/AC izmene iz tog koraka), probaj sledeću vrednost iste promenljive. Ako nema više vrednosti, vrati se na prethodnu promenljivu.
7. Kad su sve promenljive dodeljene, pročitaj rešenje i proveri ga po svim ograničenjima.

Na slajdovima se stanje pre/posle svake dodele piše kao spisak `Promenljiva – {domen}`. To je format koji treba da koristiš.

## 4. Primer 1: raspored sala (vežbe Zadatak 1, sl. 21-28; FC, MRV leksikografski, vrednosti po redosledu)

Promenljive: Adrian, Boško, Dražen, Vladimir. Ograničenje: svaki par ima različitu salu.
Domeni: Boško {61, 309}, Dražen {57, 59, 61, Lola-AMF}, Vladimir {61, 309}, Adrian {61, Lola-AMF}.

| Korak | Izbor | Domeni posle FC |
|---|---|---|
| 1 | MRV: Adrian, Boško, Vladimir imaju po 2, leksikografski Adrian. Adrian = 61 | Boško {309}, Vladimir {309}, Dražen {57, 59, Lola-AMF} |
| 2 | Boško (1 vrednost) = 309 | Vladimir {} prazan, **BACKTRACK** (Boško nema drugu vrednost, nazad na Adrian) |
| 3 | Adrian = Lola-AMF | Dražen {57, 59, 61}, Boško {61, 309}, Vladimir {61, 309} |
| 4 | Boško = 61 (od Boško i Vladimir, leksikografski Boško) | Dražen {57, 59}, Vladimir {309} |
| 5 | Vladimir = 309 | bez promene |
| 6 | Dražen = 57 | kraj |

Rešenje: Adrian Lola-AMF, Boško 61, Vladimir 309, Dražen 57. Ukupno **6 dodela**, 2 vraćanja (korak 2 i poništavanje Adrian = 61). Sa FC + AC-3 posle dodele, greška Adrian = 61 otkriva se **odmah** (AC propagira Boško {309} i Vladimir {309} → sukob), pa je ukupno **5 dodela** (skripta). To je odgovor na "uporediti broj koraka" sa sl. 29.

## 5. Primer 2: bojenje Afrike (vežbe Zadatak 2, sl. 30-40; FC + AC, MRV pa stepen pa leksikografski, LCV)

Regioni: SA, E, K, IA, JA, M; boje {R, G, B}. Susedi (iz grafa): IA–SA, IA–E, IA–K, IA–JA, SA–E, SA–K, K–JA. M nema suseda.

1. Svi domeni imaju 3 vrednosti. Stepen: IA = 4 (najviše), SA = 3, K = 3, E = 2, JA = 2, M = 0. Biramo **IA**. Sve boje utiču na 4 suseda isto, pa po redosledu **R**. FC: SA, E, K, JA postaju {G, B}. AC: svi lukovi među njima su konzistentni, nema promene.
2. Domeni: SA, E, K, JA po 2, M 3. Stepen među nedodeljenim: SA 2 (E, K), K 2 (SA, JA), E 1, JA 1. Izjednačenje SA/K, leksikografski **K**. Vrednost **G** (obe utiču isto). FC: SA {B}, JA {B}. AC: luk (E,SA): E = B nema podršku (SA mora biti B), brišem B iz D(E) → E {G}.
3. SA {B}, E {G}, JA {B} imaju po 1. Stepen: E 1 (SA), SA 1 (E), JA 0. Leksikografski **E = G**. Bez promena.
4. SA i JA, nijedna nema nedodeljene susede, leksikografski **JA = B**.
5. **SA = B**.
6. **M = R** (jedina preostala, prva boja).

Rešenje: IA R, K G, E G, JA B, SA B, M R. Redosled promenljivih: IA, K, E, JA, SA, M. (Skripta daje isti redosled i isto rešenje.)

## 6. Primer 3: Bioskop (vežbe sl. 42-43, nema rešenja na slajdovima, rešio skriptom)

Promenljive: Pata, Paja, Šilja, Mini, Pluton, Miki; domen sedišta 1-6, sva različita. Pata ∈ {2,3,4,5} (unarno). Miki–Mini susedni; Paja–Pata susedni; |Šilja−Mini| ≥ 3; |Pata−Miki| ≥ 3.
Pravilo: MRV, izjednačenje Pata, Paja, Šilja, Mini, Pluton, Miki; vrednost najmanja; FC posle dodele.

1. Pata (4 vrednosti, ostali 6) = 2. FC: Paja {1,3}, Miki {5,6}, ostali {1,3,4,5,6}.
2. Paja (2 vrednosti) = 1. FC: Šilja, Mini, Pluton {3,4,5,6}.
3. Miki (2 vrednosti) = 5. FC: Mini {4,6}, Šilja {3,4,6}, Pluton {3,4,6}.
4. Mini = 4: FC prazni Šilju (|Šilja−4| ≥ 3 nema u {3,4,6}) → **BACKTRACK**; Mini = 6: Šilja {3}, Pluton {3,4}.
5. Šilja = 3, FC: Pluton {4}. 6. Pluton = 4.

Rešenje: Paja 1, Pata 2, Šilja 3, Pluton 4, Miki 5, Mini 6. Ukupno 7 dodela, 1 vraćanje. (Ukupno postoji 14 rešenja, ali pravilo daje ovo.)

## 7. Primer 4: AC-3 na aritmetičkim ograničenjima

X, Y, Z ∈ {1, 2, 3}, X < Y, Y < Z.
- (X,Y): x = 3 nema y > 3 → D(X) = {1, 2}.
- (Y,X): y = 1 nema x < 1 → D(Y) = {2, 3}. (Y,Z): y = 3 nema z > 3 → D(Y) = {2}.
- (Z,Y): z = 1, 2 nemaju y < z (jedino y = 2, pa z = 2 nema) → D(Z) = {3}.
- Ponovo (X,Y): x = 2 nema y > 2 → D(X) = {1}.
Rezultat: X = 1, Y = 2, Z = 3 (čitav problem rešen samo propagacijom, bez pretrage; vežbe sl. 20: propagacija ponekad sama rešava problem, ali na to ne treba računati). Skripta potvrđuje.

## 8. Tipične greške

- Biraš promenljivu po abecedi umesto po MRV, i tek onda izjednačenje po stepenu.
- Stepen brojiš po **svim** susedima, a treba po **nedodeljenim**.
- FC radiš i na već dodeljenim promenljivama, ili zaboraviš da vratiš domene pri backtrack-u.
- AC-3: brišeš iz pogrešnog domena (treba iz repa, tj. promenljive koja nema podršku), ili ne vratiš u red lukove (Z, X) posle promene.
- Backtrack: vraćaš se na pogrešan nivo. Ako Boško nema drugu vrednost, ne menjaš Boška nego prethodnu dodelu (Adrian).
- LCV: brojiš vrednosti koje **tebi** ostaju umesto vrednosti koje **susedi** gube.
- Zaboraviš unarna ograničenja na početku.
- Ne proveriš konačno rešenje po svim ograničenjima.

## 9. Teorijska pitanja koja su moguća

- Razlika običnog pretraživanja i CSP; šta je konzistentna/potpuna dodela.
- Zašto je backtracking DFS sa ograničenom dubinom (komutativnost).
- MRV vs stepen vs LCV: šta rade i zašto (MRV = "neuspeh prvo", LCV = "najviše slobode").
- FC vs AC vs MAC; zašto FC ne hvata sve.
- Hill climbing vs simulirano kaljenje; lokalni optimum; plato.

Izvor: `materijali/vezbe/2_Metodi_zadovoljenja_ograničenja.pdf` (teorija sl. 3-20, Zadatak 1 sl. 21-29, Zadatak 2 sl. 30-40, samostalni zadaci sl. 41-48), `materijali/predavanja/IS_P7_CSP.pdf` (definicije, AC-3, MAC, lokalna pretraga).
