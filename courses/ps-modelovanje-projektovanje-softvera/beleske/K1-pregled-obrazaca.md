# K1: pregled uzoraka (za štampu)

Izvori: slajdovi predavanja `PS_full_2026.pdf` (str. 9–99), vežbe `Vezbe_PS_ProjektniUzorci.pdf` (14 zadataka), kodovi sa vežbi, stari K1 (PDF 2024/25, 2025/26; wiki 2019–2024). Pojedinačne beleške: `obrasci/`.

## 1. Šta je gde obrađeno

| Uzorak (slajdovi / vežbe) | Slajdovi | Vežbe | Beleška |
|---|---|---|---|
| Unikat / Singleton (+ Multiton) | str. 15–21 | z3 (+ z6, z11, z12) | `unikat.md` |
| Fasada / Facade | str. 22–27 | z6 | `fasada.md` |
| Strategija / Strategy (= Politika) | str. 28–38 | z4 | `strategija.md` |
| Šablonska metoda / Template Method | str. 39–46 | z1, z7, z13 | `sablonski-metod.md` |
| Fabrička metoda / Factory Method | str. 47–53 | z7, z13 | `fabricka-metoda.md` |
| Prototip / Prototype | str. 54–60 | z5, z8 | `prototip.md` |
| Komanda / Command | str. 61–68 | z10, z11 | `komanda.md` |
| Adapter | str. 69–77 | z6, z9 | `adapter.md` |
| Dekorater / Decorator | str. 78–84 | z2 | `dekorater.md` |
| Posmatrač / Observer | str. 85–92 | z12 | `posmatrac.md` |
| Zastupnik / Proxy | str. 93–99 | z8, z9 (+ z7) | `zastupnik.md` |
| Apstraktna fabrika / Abstract Factory | samo pomen (60) | z5, z7 | `apstraktna-fabrika.md` |
| Sastav / Composite | samo pomen (67) | z10, z13 | `sastav.md` |
| Muva / Flyweight | samo pomen (38) | z7 | `muva.md` |
| Podsetnik / Memento | nema | z11 | `podsetnik.md` |
| Graditelj / Builder | nema | z14 | `graditelj.md` |

**Nije u materijalu** (nema ni na slajdovima ni u PDF vežbama): Bridge, State, Chain of Responsibility, Iterator, Visitor, Mediator (samo pomen na str. 368 uz Observer), Interpreter. Bridge je u README-u naveden kao rađen na vežbama 11.10. (iz grupe, nepotvrđeno); PDF vežbi koji imam ga nema, pa beležku o njemu nisam pisao. Pitaj asistenta ili proveri novije vežbe.

Klasifikacija (slajdovi, str. 14 i "Namena" svakog uzorka): **kreacioni** (Singleton, Factory Method [klasni], Prototype; po GoF-u i Abstract Factory, Builder), **strukturni** (Facade, Adapter [klasni/objektni], Decorator, Proxy; po GoF-u i Composite, Flyweight), **ponašanja** (Strategy, Template Method [klasni], Command, Observer; po GoF-u i Memento). Samo Template Method, Factory Method i klasna varijanta Adaptera su "klasni", ostalo su objektni.

## 2. Opis problema -> uzorak

| Piše u zadatku / vidiš u kodu | Uzorak |
|---|---|
| "proizvoljan broj (i redosled) dodataka/efekata/filtera, ostatku sistema transparentno" | **Dekorater** |
| "lazy loading", "učitava se tek kad je potrebno" | **Zastupnik** (virtuelni) |
| "prava pristupa", korisnik/admin/gost, nema menjanja postojeće implementacije | **Zastupnik** (zaštitni) + polise kao **Strategija** |
| "objekat na serveru, klijentu transparentno" | **Zastupnik** (udaljeni) (+ Adapter za biblioteku) |
| copy on write | **Zastupnik** (pametna referenca) |
| stablo, "deca su fajlovi ili direktorijumi", "ista operacija nad delom i celinom", torba u torbi | **Sastav** |
| "prijavljuju se / odjavljuju, svi prijavljeni dobiju obaveštenje o promeni" | **Posmatrač** |
| `if/else` ili `boolean` zastavica po načinu rada ("agresivan/štedljiv", "nasumično/redom"), "nove načine kasnije" | **Strategija** |
| "politika" koja se menja, "u jednom trenutku primenjuje se samo jedna" | **Strategija** (Politika) |
| akcija koja se pokreće iz više mesta (dugme, prečica), `switch` po akciji, undo | **Komanda** |
| "složena akcija od više akcija izvršenih redom" | **Komanda + Sastav** (makrokomanda) |
| "sačuvaj i vrati stanje", undo bez izlaganja stanja | **Podsetnik** (+ Komanda) |
| "isti koraci istim redom, neki koraci variraju" | **Šablonska metoda** |
| "pre svake operacije provera prava, posle logovanje, hvatanje grešaka" | **Šablonska metoda + Komanda** (str. 68) |
| "tačno jedna instanca, globalni pristup" | **Unikat**; po imenu / konačan broj: Multiton |
| "porodica srodnih objekata, u jednom trenutku jedna varijanta (zemaljska/marsovska, Piano/Forte)" | **Apstraktna fabrika** |
| "klasa ne zna koju klasu da napravi, podklasa odlučuje" | **Fabrička metoda** |
| "kopirati postojeći objekat, ne zna se konkretna klasa", dete-proces (fork) | **Prototip** |
| "mnogo istih objekata, crta se uvek isto nezavisno od mesta, mala memorija" | **Muva** (+ fabrika) |
| "mnogo atributa, deo obavezan, mnogo konstruktora" | **Graditelj** |
| "gotova biblioteka/klasa čiji interfejs ne odgovara" | **Adapter** |
| "pojednostaviti rad sa složenim podsistemom (više drajvera/klasa)" | **Fasada** |

U zadatku 1 kolokvijuma uzorak je imenovan, u zadatku 2 se traži da ga ti prepoznaš i da u `z2.txt` navedeš **sve primene** sa 1–2 rečenice.

## 3. Razlike između sličnih uzoraka

| Par / trojka | Razlika |
|---|---|
| **Dekorater / Zastupnik / Adapter** | Sva tri drže objekat i prosleđuju poziv. Dekorater: isti interfejs, **dodaje ponašanje**, lančano (proizvoljno mnogo slojeva), klijent ne zna. Zastupnik: isti interfejs, **kontroliše pristup** jednom objektu (lenjo pravljenje, prava, daljina), sam pravi/uništava original. Adapter: **menja interfejs** (Cilj <- Adaptirani). |
| **Dekorater / Strategija** | Dekorater menja "kožu" (osnovni objekat je iza), Strategija "utrobu" (osnovni objekat je napred i delegira). Strategija može imati drugačiji interfejs, dekorater ne sme (slajd str. 83). |
| **Strategija / Šablonska metoda** | Obe varijaciju algoritma. Strategija kompozicijom (menja se u hodu), Šablonska metoda nasleđivanjem (fiksiran skelet, podklase menjaju korake). |
| **Strategija / State** (State nije u materijalu) | Isto strukturno; Strategiju bira klijent, State menja sam objekat po događajima. |
| **Komanda / Podsetnik** | Komanda = zahtev kao objekat (akcija, undo preko inverza ili snimka). Podsetnik = snimak stanja radi vraćanja. Na vežbama (z11) zajedno: `SaveCommand` pravi Podsetnik. |
| **Komanda / Strategija** | Komanda ima primaoca i parametre, može se čuvati/poništiti/grupisati. Strategija je zamenjiv algoritam. |
| **Komanda / Posmatrač** | Komanda: jedan zahtev, jedan primalac. Posmatrač: promena stanja se šalje svim prijavljenima. |
| **Fabrička metoda / Apstraktna fabrika / Prototip / Graditelj** | FM: jedna metoda, podklasa bira klasu (klasni). AF: više proizvoda jedne porodice, zamena fabrike menja porodicu. Prototip: pravi kopiranjem, bez podklasa fabrike. Graditelj: gradi **jedan** složen objekat korak po korak. |
| **Unikat / Multiton / Muva** | Unikat: jedna instanca. Multiton: po jedna instanca po imenu/ključu. Muva: deljeni objekti radi **štednje memorije** uz razdvajanje unutrašnjeg i spoljašnjeg stanja. |
| **Sastav / Dekorater** | Oba rekurzivna. Sastav ima više dece i agregira, Dekorater jedno dete i dodaje ponašanje. |
| **Fasada / Adapter** | Fasada pravi **novi** jednostavan interfejs za grupu klasa. Adapter prilagođava **postojeći** interfejs jedne klase traženom. (Na vežbama `HAL` je oba.) |
| **Zastupnik / Muva** | Zastupnik odlaže pravljenje jednog objekta; Muva vraća isti objekat za isti ključ. |

## 4. Nazivi uloga: vežbe vs slajdovi (GoF)

Na kolokvijumu u `z1.txt` piši nazive **sa vežbi**, a GoF naziv u zagradi.

| Uzorak | Vežbe | Slajdovi / GoF |
|---|---|---|
| Dekorater | Komponenta, **Subjekat**, **Dopuna**, Konkretna dopuna | Component, ConcreteComponent, Decorator, ConcreteDecorator |
| Zastupnik | Klijent, Subjekat, **Original**, Zastupnik | Client, Subject, RealSubject, Proxy |
| Adapter | Klijent, **Cilj**, Adapter, **Adaptirani** | Client, Target, Adapter, Adaptee |
| Komanda | **Pokretač**, Komanda, Konkretna komanda, **Primalac** | Invoker, Command, ConcreteCommand, Receiver (+ Client) |
| Posmatrač | Konkretan subjekat, Posmatrač, Konkretan posmatrač (Subjekat izostavljen u push varijanti) | Subject, Observer, ConcreteSubject, ConcreteObserver |
| Strategija | Kontekst, Strategija, Konkretna strategija | Context, Strategy, ConcreteStrategy |
| Šablonska metoda | Apstraktna klasa, Konkretna klasa | AbstractClass, ConcreteClass |
| Fabrička metoda | **Fabrika**, Konkretna fabrika, Proizvod, Konkretan proizvod | Creator, ConcreteCreator, Product, ConcreteProduct |
| Apstraktna fabrika | Apstraktna fabrika, Konkretna fabrika, Apstraktan proizvod, Konkretan proizvod | AbstractFactory... |
| Prototip | Klijent, Prototip, Konkretan prototip | Client, Prototype, ConcretePrototype |
| Sastav | Klijent, Element, **Sklop** (u z10 "Sastav"), List | Client, Component, Composite, Leaf |
| Muva | **Fabrika muva**, Muva, Konkretna muva | FlyweightFactory, Flyweight, ConcreteFlyweight |
| Podsetnik | **Subjekat**, Podsetnik, **Čuvar** | Originator, Memento, Caretaker |
| Fasada | Fasada, **Podsistem** | Facade, subsystem classes |
| Unikat | Unikat | Singleton |

Nazivi uzoraka: slajdovi "Šablonska metoda", "Fabrička metoda"; vežbe "Šablonski metod", "Fabrički metod". Isti uzorak.

## 5. Šta se očekuje u z1.txt / z2.txt (iz tekstova starih K1)

- z1.txt: nabroj klase i uloge (npr. `Komponenta: AudioStream; Subjekat: RawAudio; Dopuna: AudioEffect; Konkretna dopuna: Echo, VolumeBoost`) i, ako se traži, **vrstu** (zastupnika).
- z2.txt: po jedna do dve rečenice za **svaku** primenu uzorka ("Strategija: algoritam klađenja je izdvojen jer se način igre konfiguriše po igraču; Unikat: ...").
- Kod mora da se **kompajlira** i primer upotrebe (`main`) da radi gde se traži; početni kod zna da sadrži greške i neispravne delove (analiza u `zadaci/analiza-K1.md`).
