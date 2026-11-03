# Composite (Sastav)

Vrsta: strukturni, objektni (klasifikacija po GoF-u; na slajdovima predavanja uzorak nije obrađen). Izvor: vežbe zadaci 10 i 13; K1P 2024/25 z1, K1P 2025/26 z2; stari K1 2019–2023 (teorija, wiki). Slajdovi PS_full_2026.pdf ga pominju samo usput (str. 67: komande se grupišu u kompozitne makro komande, "Composite DP").

## Namena

Objekti se slažu u stablo "deo-celina", a klijent jednako tretira pojedinačne objekte (listove) i njihove sastave.

## Problem koji rešava

Struktura je hijerarhijska (fajl/direktorijum, stvar/torba, grafički element/crtež, efekat/čarolija) i klijentski kod ne treba da razlikuje list od sklopa niti da piše `if (x instanceof ...)`.

## Struktura

Uloge na vežbama (slajdovi "Zadatak 10 i 13 – saradnja"): **Element** (`MagicniEfekat`, `Stvar`), **List** (`DodavanjeZivota`, `Teleportovanje`; `Oruzje`, `Nakit`), **Sastav / Sklop** (`Carolija`; `Torba`), **Klijent** (`MagicnaPecurka`; `Junak`).

Napomena o nazivima: u zadatku 10 je uloga složenog objekta nazvana "Sastav" (isto kao naziv uzorka), u zadatku 13 "Sklop". Na wikiju (probni testovi 2021, zadatak 10, grafički editor) uloge su List, Sklop, Element, Klijent. GoF: Component, Leaf, Composite, Client. U z1.txt piši "Sklop (Composite)".

```
Element {operacija(); dodaj(Element)/izbaci(Element) - podrazumevano prazno}
  ^                ^
List            Sklop ---(agregira 0..*)--> Element
                operacija() { za svako dete: dete.operacija(); }
                dodaj(e), izbaci(e)
```

Pitanje dizajna: gde stoje `dodaj/izbaci`. Na vežbama (zadatak 10, 13) su deklarisani u `Element` sa praznim telom (transparentnost: klijent ne razlikuje liste od sklopova, ali list "ima" nesmislene operacije). Alternativa je samo u Sklopu (bezbednost, ali klijent mora da zna tip). Obe se prihvataju ako obrazložiš.

## Kada se koristi

- Hijerarhije deo-celina.
- Klijent treba da ignoriše razliku između pojedinačnih objekata i sastava.
- Sklop sme da sadrži sklopove (rekurzija), pa je stablo m-arno (ne binarno, wiki 2023).

## Primer (vežbe, zadatak 13, ispravljeno)

```java
import java.util.ArrayList;
import java.util.List;

abstract class Stvar {
    abstract int snaga();
    abstract int vrednost();
    void dodajStvar(Stvar s) { }              // listovi ne rade ništa
}

class Nakit extends Stvar {
    int snaga() { return 0; }
    int vrednost() { return 1000; }
}

class Oruzje extends Stvar {
    int snaga() { return 5000; }
    int vrednost() { return 50; }
}

class Torba extends Stvar {                   // sklop
    private final List<Stvar> stvari = new ArrayList<>();
    int snaga() {
        int s = 0;
        for (Stvar x : stvari) s += x.snaga();
        return s;
    }
    int vrednost() {
        int v = 0;
        for (Stvar x : stvari) v += x.vrednost();
        return v;
    }
    @Override void dodajStvar(Stvar s) { stvari.add(s); }
}

public class Main {
    public static void main(String[] args) {
        Torba mala = new Torba();
        mala.dodajStvar(new Nakit());
        Torba velika = new Torba();
        velika.dodajStvar(new Oruzje());
        velika.dodajStvar(mala);              // sklop u sklopu
        System.out.println(velika.snaga() + " " + velika.vrednost());   // 5000 1050
    }
}
```

U kodu sa slajda `Torba.vrednost()` je pogrešno sabirala u `snaga`, `Nakit.vrednost` je imao `abstract` sa telom i vraćao 2000 (tekst zadatka kaže 1000).

## Kombinacije koje se pojavljuju

- **Composite + Command = makrokomanda** (zadatak 10, slajd "Zadatak 10 – saradnja": "česta kolaboracija uzorka Komanda i uzorka Sastav koja se naziva Makrokomanda"). `MagicniEfekat` je Komanda i Element, `Carolija` je Sastav. K1P 2025/26 z2 ("složene akcije koje se sastoje od više akcija") je upravo to.
- **Composite + Observer**: K1P 2024/25 z1 (stablo fajl sistema, direktorijum je subjekat).
- **Composite + Factory Method**: zadatak 13 (`Dzin` pravi `Torba` sa pet nasumičnih stvari).

## Sa čim se meša

- **Dekorater**: obe pokazuju na komponentu istog tipa. Dekorater ima jedno dete i dodaje ponašanje; Sastav ima više dece i agregira njihove rezultate.
- **Iterator/Visitor** (nisu u materijalu): obilazak sastava.
- **Flyweight**: listovi sastava se često dele kao muve.

## Pojavljivalo se na K1

- K1P 2024/25 (1.12.2024.) z1: fajl sistem kao stablo + Observer (`FileSystemNode` interfejs sa metodom `write()` je dat, treba da dodaš `File`, `Directory`, `ObserverLogger`).
- K1P 2025/26 (11.1.2026.) z2: makro komanda za laboratorijske akcije (Command + Composite, početni kod nije koristio nijedan od dva uzorka).
- Teorija sa wikija: K1 2019 (zadatak 2: za sistem fajlova i foldera izabrati uzorak među Unikat/Sastav/Prototip; zadatak 5: multiplikativnosti agregacije u uzorku Sastav), K1 2021 (zadaci 6 i 9: klasifikacija i valjani objektni dijagrami), K1 2022 (zadatak 9), K1 2023 (zadatak 9), probni testovi 2021 (zadatak 10: pridruživanje klasa Linija, Pravougaonik, Kružnica, Crtez, Grafik, Editor ulogama List, Sklop, Element, Klijent). Tačni odgovori na wikiju nisu vidljivi u tekstualnom izvozu.

## Razlika u notaciji (slajdovi / vežbe)

Nema slajdova za Composite. Nazivi sa vežbi: Element, List, Sastav/Sklop, Klijent.
