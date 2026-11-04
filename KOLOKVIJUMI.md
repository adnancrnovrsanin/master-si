# Kolokvijumi — jesenji semestar 2026/27, prvi deo

Izvor datuma: studentski servis (Moji ispiti za Kolokvijume, 2026/27), provereno 4.11.2026. Kolona **Termin** je prazna — satnica još nije objavljena, proveri na sajtu predmeta i mejling listi bliže datumu.

| Datum | Dan | Predmet | Šifra | Do kolokvijuma (od 4.11.) |
|---|---|---|---|---|
| 25.11.2026. | **sreda** | [Inteligentni servisi i sistemi](courses/is-inteligentni-servisi-sistemi/README.md) | 13M114IS | 21 dan |
| 26.11.2026. | **četvrtak** | [Modelovanje i projektovanje softvera](courses/ps-modelovanje-projektovanje-softvera/README.md) | 13M114PS | 22 dana |
| 27.11.2026. | petak | — (nema ispita) | | jedini dan za PP1 između PS i PP1 |
| 28.11.2026. | **subota** | [Programski prevodioci 1](courses/pp1-programski-prevodioci-1/README.md) | 13E114PP1 | 24 dana (alternativni termin 23.1.2027.) |

Provereno kalendarom: 1.11.2026. je nedelja, pa 25. pada na sredu. **Samo PP1 je vikend** — IS i PS su radni dani.

Na vrhu servisa se vidi i red za K2 sa datumima 14.12.2026., 18.12.2026., 16.01.2027., 24.01.2027. Ne znam šta koji datum znači (prijava, polaganje?), proveri na servisu.

## Uslovi za spremanje

- Posao 9–5 svakog dana, **probni rad** — slobodni dani za učenje nisu mogući.
- Izlazak na ispite je dogovoren (25. i 26.11. se izlazi ranije), ali to su i dani bez učenja.
- Budžet: radne večeri 45–90 min (samo zadaci), vikendi ~4h. Ukupno **~40h** za sva tri.
- Vikend-dani za učenje: 7–8.11., 14–15.11., 21–22.11. Oni nose ~24h od 40h — ako propadne jedan, plan puca.

## Status gradiva za K1

| Predmet | Šta ulazi u K1 | Pouzdanost |
|---|---|---|
| Modelovanje i projektovanje softvera | Prvi blok: projektni uzorci (design patterns), svi uzorci sa predavanja i vežbi | Potvrđeno na sajtu, SI Wiki i slajdovima 2026 (16 obrazaca, str. 15–99) |
| Inteligentni servisi i sistemi | Pretraživanje + CSP. Igre i neizvesno okruženje su K2, ML je K3 | Potvrđeno u slajdu 3 `0_Uvod.pdf` (SI plan i program) |
| Programski prevodioci 1 | IR (13E): jedan kolokvijum K, 30 poena. Prošle godine: predavanja do P8 bez P7/P7a, vežbe V1–V6 (leksika, sintaksa, bottom-up, CUP, top-down) | **Prošlogodišnje obaveštenje**, potvrdi kod asistenata. Detalji u README predmeta |

## Projekti — istraženo na sajtovima 4.11.2026.

**Ništa ne pada pre kolokvijuma.** Novembar je čist; gužva je u decembru.

| Predmet | Projekat | Objavljeno za 26/27 | Rok | Napomena |
|---|---|---|---|---|
| PS | 30%, **opciono**, brani se u jan/feb/avg | Ne | Nema roka pre kolokvijuma | Na sajtu samo postavka 2024/25 (parking sistem). Prošle godine objavljena 3.11.2024. — može da se pojavi svakog dana |
| PP1 | **Obavezan**, 40 poena, odbrana je uslov za izlazak na ispit | Ne | Nema roka pre kolokvijuma; januarski rok | Postavka za jan. rok 2025/26 objavljena 31.12.2025. Kompajler za Mikrojava — realan rad u decembru |
| IS | 20%, **opciono**, 3 domaća, brane se u toku semestra | Ne | Nema roka pre kolokvijuma | 2025/26 rokovi: DZ1 22.12.2025., DZ2 29.1.2026., DZ3 26.2.2026. |

Decembar = IS DZ1 (~22.12.) + PP1 projekat + K2 rokovi. PP1 projekat početi odmah posle 28.11.

## Plan spremanja (dan po dan)

Termini su zbijeni: IS sreda, PS četvrtak, PP1 subota. Pošto nema dana za nadoknadu, sve mora biti naučeno do 24.11. — posle toga samo provera.

Redosled nije proizvoljan: **PP1 prvi** (mehaničko gradivo, ostaje uz drill), **PS u sredini** (16 obrazaca = obim), **IS poslednji** (najbliže prvom ispitu, a najmanji blok). PP1 je ograničen na ~10h jer mu formula odbacuje slab rezultat (vidi README: bira se bolja varijanta, sa ili bez kolokvijuma).

### Nedelja 1 (4–8.11.) — PP1, ~8.5h

| Dan | Šta | Fajl / zadatak |
|---|---|---|
| sre 4. | Pročitaj sve recepte | `beleske/K1-cheatsheet.md` |
| čet 5. | Metod pozicija + minimizacija | Z1 (`(a\|b)*abb(a\|b)*`) |
| pet 6. | LR(0) automat, SLR(1)/LALR(1) tabela | Z7 |
| sub 7. | Gramatike + probni K | Z4, pa probni #1 (Z1+Z4+Z7) na 90 min |
| ned 8. | **IS pretraživanje** | `beleske/pretrazivanje.md` + Z2 (putna mreža, svih 7 algoritama) |

Zašto ovo: `analiza-starih-K.md` — na IR kolokvijumu skoro uvek (1) regex→DKA + minimizacija, (2) pisanje gramatike, a LR tabele u 3 od 4 IR roka. To je tačno 8 sati i pokriva 2–3 od 3 zadatka. PDA, panic mode i konačni procesor su ✂ ako zaostaneš.

### Nedelja 2 (9–15.11.) — PS, ~15.5h

| Dan | Obrasci / zadaci |
|---|---|
| pon 9. | Unikat, Fasada, Strategija, Šablonski metod |
| uto 10. | Fabrička metoda, Prototip, Komanda, Adapter |
| sre 11. | Dekorater, Posmatrač, Zastupnik, Apstraktna fabrika |
| čet 12. | Sastav, Muva, Podsetnik, Graditelj |
| pet 13. | `K1-pregled-obrazaca.md` — tabela „opis → uzorak", napamet |
| sub 14. | `vezbanje.md` Z1–Z5 |
| ned 15. | Z6–Z10 + „Kratka pitanja" sa kraja fajla |

Četiri obrasca po večeri, ne više. Za svaki: namena → struktura → kad se koristi → sa čim se meša.

### Nedelja 3 (16–22.11.) — IS, ~13h

| Dan | Šta |
|---|---|
| pon 16. | `beleske/csp.md` — backtracking, FC, AC-3, MRV |
| uto 17. | Z1 (džbanovi: formulacija stanja, BFS vs uniform-cost) |
| sre 18. | Z5 (CSP raspored sala, FC + AC-3) |
| čet 19. | Z6 (bojenje mape) + Z7 (AC-3 aritmetika) |
| pet 20. | Z3 (TSP, A* + MST) + Z4 (heuristike) |
| sub 21. | Z1–Z7 **bez gledanja rešenja**, pa `K1-cheatsheet.md` |
| ned 22. | PP1 probni #1 ponovo + PS kratka pitanja (recall) |

Z8–Z10 preskočiti — to su igre, K2.

### Ispitna nedelja

| Dan | Šta |
|---|---|
| pon 23. | IS: samo greške iz Z1–Z7 + cheat sheet. Ništa novo. |
| uto 24. | PS: tabela 16 obrazaca + kratka pitanja. Posle toga **stop**. |
| sre 25. | **IS ispit** — nula učenja |
| čet 26. | **PS ispit** — nula učenja |
| pet 27. | PP1 probni #1, na vreme, pa analiza |
| sub 28. | **PP1 ispit** |

## Pravila

- **Ako zaostaneš — prvo seku PP1.** Konkretno: Z2, Z4 i petak 27. IS i PS su zaključani.
- Rešenja (`vezbanje-resenja.md`) gledaj tek posle celog zadatka, ne posle svake stavke.
- Vikend se ne pomera; radne večeri mogu da se preskoče.
- Ispitni dan = nula učenja. Ako u sredu uveče sedneš za PS posle IS-a, u četvrtak ideš iscrpljen.
- Ako danas imaš samo sat vremena: `K1-cheatsheet.md` za PP1.

## Rizici / šta potvrditi

1. Gradivo PP1 i IS za ovu godinu — pitaj asistente (najveći rizik, nepotvrđeno).
2. Satnica kolokvijuma — kolona „Termin" je prazna; od nje zavisi koliko ranije treba izaći s posla.
3. Da li je na PS K1 dozvoljena papirna literatura (prošle godine „bilo šta papirno", nepotvrđeno).

## Checklist

- [x] Materijali preuzeti (PP1, IS, PS)
- [x] Datumi kolokvijuma i dani u nedelji provereni (25. sre, 26. čet, 28. sub)
- [x] Istraženi rokovi projekata (nijedan pre kolokvijuma)
- [x] Plan spremanja dan po dan
- [ ] Potvrditi gradivo K1 kod asistenata (PP1, IS) i satnicu kolokvijuma
- [ ] PS slajdovi 2026 u `materijali/predavanja/`
- [ ] Ja radim: PP1 — cheatsheet, Z1, Z7, Z4, probni #1
- [ ] Ja radim: PS — 16 obrazaca, `K1-pregled-obrazaca.md`, Z1–Z10
- [ ] Ja radim: IS — `pretrazivanje.md`, `csp.md`, Z1–Z7, cheat sheet
- [ ] Posle 28.11.: PP1 projekat + IS DZ1 + K2
