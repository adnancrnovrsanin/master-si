# Handoff: priprema za kolokvijume (master SI), stanje 4.11.2026.

## Prompt za novu sesiju (zalepi ovo)

Nastavljamo rad u /Users/adnan/master-si, lični repo Adnana Crnovršanina (master ETF, softversko inženjerstvo). Prvo pročitaj CLAUDE.md, KOLOKVIJUMI.md i .lucy/handoffs/2026-11-04-master-si-kolokvijumi.md. Cilj je priprema za tri prva kolokvijuma: IS 25.11., PS 26.11., PP1 28.11.2026. Beleške i vežbanje za sva tri predmeta već postoje (K1 gradivo). Ne generiši ništa novo dok ne vidiš šta već postoji. Komuniciraj na srpskom (latinica). Pitaj me šta želim da radimo: ispitivanje po temi, rešavanje zadataka iz `zadaci/vezbanje.md`, provera mojih rešenja, ili proširenje beleški.

## Ko i šta

Adnan Crnovršanin, master Elektrotehnika i računarstvo, modul Softversko inženjerstvo. Piše na srpskom bez dijakritika. Sad mu je prioritet samo spremanje ova tri kolokvijuma. FP, OPJ i PKI su evidentirani ali namerno ostavljeni za posle (njihovi README fajlovi su jedino što postoji).

## Kolokvijumi (prvi deo, 2026/27)

| Datum | Predmet | Šta ulazi u K1 | Pouzdanost |
|---|---|---|---|
| sre 25.11. | Inteligentni servisi i sistemi (13M114IS) | Pretraživanje + CSP (K2 igre i neizvesno okruženje, K3 ML) | Potvrđeno u `0_Uvod.pdf` slajd 3, ali to je SI plan |
| čet 26.11. | Modelovanje i projektovanje softvera (13M114PS) | Projektni obrasci (16 obrazaca, slajdovi 2026 str. 15–99) | Potvrđeno u slajdovima |
| sub 28.11. | Programski prevodioci 1 (13E114PP1, IR varijanta) | Jedan kolokvijum K, 30 poena, 90 min. Prošle godine: P01–P08 bez P07/P07a, V1–V6 | **Nepotvrđeno za ovu godinu**, samo prošlogodišnje obaveštenje iz Discorda |

PP1 je 13E, dakle IR: jedan K, ne K1/K2. Alternativni termin za PP1 K je 23.1.2027. (po studentskoj grupi), ne mogu se raditi oba.

## Šta je gotovo

Struktura repoa: `courses/<predmet>/{README.md, links.txt, materijali/, beleske/, zadaci/}`, `resources/sajtovi.md`, `scripts/fetch.sh <pp1|ps|is> [folder]`.

- **PP1** (`courses/pp1-programski-prevodioci-1/`): `beleske/01..07` (leksika/automati, procesori, gramatike, PDA, LR/SLR/LALR, oporavak od grešaka, FIRST/FOLLOW/LL(1)/rekurzivni spust), `K1-cheatsheet.md`; `zadaci/vezbanje.md` (12 zadataka) + `vezbanje-resenja.md`, `analiza-starih-K.md`, `poredjenje-sa-skeniranim-resenjima.md`.
- **IS** (`courses/is-inteligentni-servisi-sistemi/`): `beleske/pretrazivanje.md`, `csp.md`, `K1-cheatsheet.md`, `tipovi-zadataka.md`, plus `igre.md` i tri ML beleške (bonus); `zadaci/vezbanje.md` (10) + `vezbanje-resenja.md`.
- **PS** (`courses/ps-modelovanje-projektovanje-softvera/`): `beleske/obrasci/*.md` (16), `K1-pregled-obrazaca.md`; `zadaci/analiza-K1.md`, `vezbanje.md` (10 zadataka + 10 pitanja) + `vezbanje-resenja.md`, `ispit-februar-2026-iz-secanja.md`.
- `KOLOKVIJUMI.md` ima raspored spremanja po danima (PP1 recepte treba savladati do 24.11., 27.11. je pun stari K na vreme).

Verifikacija koju su radili agenti: primeri proveravani Python/Java skriptama (regex, automati, LR tabele, simulacije, CSP, kod obrazaca). To nije isto što i zvanična rešenja. Skenirana rešenja 2020/21 za PP1 su pročitana i poređena sa beleškama, nema neslaganja.

## Šta NIJE potvrđeno (ne predstavljaj kao činjenicu)

1. Gradivo PP1 K1 za ovu godinu. Treba pitati asistente (Ogrizović, Hrvačević, Anastasija Đudurović) ili proveriti sajt `http://ir4pp1.etf.bg.ac.rs/` i predispitne obaveze za 2026/27.
2. Da li je na PS K1 dozvoljena papirna literatura (prošle godine je bilo "bilo šta papirno", ali nije potvrđeno za ovu).
3. State, Bridge, Visitor, Iterator, Mediator, Chain of Responsibility i Interpreter se ne pojavljuju u PS slajdovima 2026. Student iz grupe je rekao da je na vežbama bio "most" (Bridge). Proveriti.
4. IS: poeni po zadatku i da li K1 ima teoriju. Heuristika sa slajda 18 vežbi 1 nije dopustiva (A* ipak nađe optimum), pravilo za izjednačenje u A* nije eksplicitno.
5. PP1 K 2021/22 zadatak 3b (`cadbadbdacacb`, sigurni b i d): agentova simulacija kaže da oporavak ne uspeva. K 2019 zadatak 3: gramatika je dvosmislena (proveren), pa je odgovor "LL(1) nije moguć".
6. Nadoknada PP1 12.2.2021. ima dve varijante lista (atributivna gramatika vs LALR vrsta ▽). Nije rešeno koja je pravi.
7. Sav tekst iz Discord prepiske (u README fajlovima označeno kao "nepotvrđeno, prepričavanje") je kazivanje studenata.

## Zamke i napomene

- `WebFetch` pada na SSL-u za `ri4es.etf.rs` i `ms1pki.etf.rs` (stari HTTP serveri). Koristi `curl`.
- Fajlovi na sajtu PP1 sa imenima `13E114PP1_K_*` i `13S114PP1_K*_*` su REZULTATI sa imenima studenata, bez zadataka. Obrisani su i izbačeni iz `links.txt`. Ne vraćaj ih.
- `Resenje_*.pdf` u `materijali/kolokvijumi/` su skenirana studentska rešenja, 20–40 MB po fajlu. Za čitanje renderuj sa `pdftoppm -scale-to 1500 -jpeg` (PNG na 70 dpi je 15 MB po strani). Nije zvanično rešenje.
- PS slajdovi (`materijali/predavanja/PS_full_2026.pdf`, 384 strane) postoje, ali stari Keynote player na `afrodita.rcub.bg.ac.rs` ne može da se skine automatski.
- Sirovi `materijali/` su u `.gitignore` (PP1 oko 235 MB, od toga ~150 MB skenovi). Korisnik je već jednom privremeno ukinuo ignorisanje, pa pre commitovanja proveri `git status` i veličinu.
- Git: repo ima commitove `bc3d7d1`, `9b98838`, `af6f6c0` (korisnikovi). U trenutku handoffa je bilo 5 necommitovanih izmena. Ne commituj osim ako korisnik traži.
- Notacija u PP1 slajdovima: `─┤` marker kraja, `∇` dno steka, ACCEPT u stanju `─┤0`. Brojeve smena uvek uzimaj iz teksta zadatka, ne iz beleški (u originalu je numeracija `1,2,4,5`).
- Domaće i projekte korisnik brani usmeno i individualno. Pomaži da razume, ne piši ono što ne može da objasni.
- Modelom pisane beleške mogu da imaju greške. Kad se korisnikovo rešenje ne slaže sa beleškom, proveri slajdove ili predloži da pita asistenta, ne brani belešku.

## Sledeći koraci (po prioritetu)

1. Korisnik treba da potvrdi gradivo za PP1 i IS (poruka asistentima / mejling lista). Ovo je najveći rizik.
2. Ispitivanje i vežbanje: počni od PP1 (najviše mehaničkog gradiva), `zadaci/vezbanje.md` bez gledanja rešenja, pa uporedi. Ponavljaj za IS (pretraživanje, CSP) i PS (obrasci).
3. Po dogovoru: proširiti beleške tamo gde korisnik greši, ili napraviti dodatne zadatke iz tema u kojima je slab.
4. Posle 28.11.: FP (Scala), OPJ i PKI. Materijali za njih nisu preuzeti. Napomena: sajtovi FP i OPJ prikazuju raspored za prolećni semestar, proveriti da li se sada slušaju.
5. K2 gradivo (UML za PS, igre i neizvesno okruženje za IS, SDT/tabela simbola za PP1) nije pokriveno u beleškama, osim bonus beleški za IS igre i ML.
