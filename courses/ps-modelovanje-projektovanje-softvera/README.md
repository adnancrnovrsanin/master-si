# Modelovanje i projektovanje softvera (13M114PS)

- Sajt: https://ps.etf.bg.ac.rs/ (sajt predmeta "Projektovanje softvera", šifre 13E114PS / 13S113PS). Master šifra 13M114PS je iz servisa, pretpostavljam isti predmet. Potvrdi.
- Predavač: prof. dr Dragan Milićev
- Asistenti: Predrag Obradović, Mihajlo Ogrizović, Luka Hrvačević
- SI Wiki: https://siwiki.rs/wiki/Пројектовање_софтвера

**K1: 26.11.2026. (četvrtak), prvi deo.**

Obaveštenje sa sajta (3.11.2026.): vežbe te nedelje su u računarskim salama, priprema za kolokvijum i uvod u StarUML.

## Bodovanje (sa sajta)

- K1 20%: projektni uzorci (design patterns)
- K2 20%: UML modelovanje
- Pismeni ispit 30%
- Projekat 30%, opciono, brani se u januarskom, februarskom ili avgustovskom roku
- Ocena: `MAX(K1+K2+I+P, (K1+K2+I)*10/7)`

## Šta ulazi u K1

Prvi blok: **projektni uzorci**. Svi uzorci su podeljeni između predavanja i vežbi, pa treba oba izvora. Poslednja dva časa vežbi rade zadatke slične kolokvijumskim. Za spremanje: stare lab vežbe i knjiga Gang of Four (Design Patterns).

## Materijali

- Predavanja (slajdovi): http://afrodita.rcub.bg.ac.rs/~dmilicev/publishing/D.%20Milicev%20-%20Projektovanje%20softvera%202024./ (direktorijum, skini ručno)
- Vežbe K1 i stari K1 sa početnim sadržajem: `links.txt` (`scripts/fetch.sh ps k1`)
- Kod uzoraka u Javi i C++: https://github.com/Jovan11111/DesignPatterns
- Celokupna skripta (print verzija): Google Drive link na SI Wiki
- Stari K1 na SI Wiki: 2019, 2021, 2022, 2023, 2024 (`/К1_2024`, `/К1П_2024`), probni testovi 2021
- Alat: StarUML (za K2 i vežbe)

## Beleške

Napravi po jednu belešku po uzorku: namena, struktura (UML), učesnici, kad se koristi, primer koda, sa čim se meša. Na kolokvijumu se obično prepoznaje uzorak iz opisa problema ili implementira.

## Iz studentske grupe (nepotvrđeno, prepričavanje)

- **Literatura na kolokvijumu:** prošle godine se na K1P/K2 smelo "bilo šta papirno", kao i na K1. Prvobitno se pričalo samo o prezentacijama sa vežbi. Potvrdi za ovu godinu.
- **Novi slajdovi predavanja 2026 (`PS_full_2026.pdf`)** postoje i Milićev je nešto dodao u odnosu na prošlu godinu. Slajdovi na sajtu su iz 2024. Link iz grupe je Discord CDN, pa ga nisam skidao. Ubaci fajl ručno u `materijali/predavanja/` ili ga potraži na sajtu.
- **Vežbe do sada:** nedelja od 11.10. je bila Composite i Bridge (Pedja). Studenti vežbaju na zadacima po obrascima iz vežbi.
- **Snimci iz prošlih godina:** mišljenja su podeljena (jedan kaže "ne važe", drugi "treba da važe, ali redosled je drugačiji"). Sigurniji izvor su Milićevi slajdovi.
- **Prvi K1:** termin određuje Milićev, a raspored zavisi od toga da li RTI i SI imaju iste propozicije. Za SI je 2 kolokvijuma.
- **Ispit (januar/februar 2026., iz sećanja studenata):** vidi [zadaci/ispit-februar-2026-iz-secanja.md](zadaci/ispit-februar-2026-iz-secanja.md). Za K1 su relevantni samo zadaci 1 i 2 (obrasci).
- Google Drive PDF sa rezimeom obrazaca (`psi_design_patterns.pdf`), nepregledan: https://drive.google.com/file/d/1qCDXS6ackkQPy7T8BNPMPpSBvBHaLYJr/view

## Potvrđeno iz slajdova 2026 (`materijali/predavanja/PS_full_2026.pdf`)

- K1 je **projektni obrasci**, K2 UML (strana 6 slajdova). Kolokvijumi su neobavezni (lab vežbe), svaki 20%, rade se pojedinačno. K1 je u prvoj kolokvijumskoj nedelji na SI, nadoknada sa K2.
- Slajdovi obrađuju **16 obrazaca** (strane 15–99): Unikat/Singleton, Fasada, Strategija, Šablonski metod, Fabrička metoda, Prototip, Apstraktna fabrika, Komanda, Adapter, Dekorater, Posmatrač, Zastupnik, Sastav/Composite, Muva/Flyweight, Podsetnik/Memento, Graditelj/Builder.
- **State, Bridge, Visitor, Iterator, Mediator, Chain of Responsibility i Interpreter se ne pojavljuju kao obrasci u slajdovima.** Student iz grupe je rekao da je na vežbama bio "most" (Bridge), a u PDF-u vežbi ga nema. Proveri na sledećim vežbama.
- Beleške po obrascu: `beleske/obrasci/`, pregled: `beleske/K1-pregled-obrazaca.md`, analiza starih K1: `zadaci/analiza-K1.md`, vežbanje: `zadaci/vezbanje.md` (rešenja u `vezbanje-resenja.md`).
