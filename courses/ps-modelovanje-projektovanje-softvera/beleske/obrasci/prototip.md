# Prototype (Prototip)

Vrsta: kreacioni, nad objektima. Izvor: vežbe zadaci 5 i 8; stari K1 2021–2023 i probni testovi 2021 (teorija, sa wikija).

## Namena

Novi objekti se prave kopiranjem postojećeg objekta (prototipa) preko operacije `clone()`, a ne pozivom konstruktora konkretne klase.

## Problem koji rešava

Klijent treba da pravi objekte čiju konkretnu klasu ne zna (ili ne želi da zavisi od nje), ili je pravljenje skupo, ili se vrste proizvoda određuju tek u izvršavanju. Ako se prototip kopira, klijent poznaje samo apstraktni interfejs proizvoda.

## Struktura

Uloge na vežbama (slajd "Zadatak 5 – saradnja"): **Klijent**, **Prototip**, **Konkretan prototip**. To su tri tipa učesnika; na wikiju (probni testovi 2021, zadatak 9) je tačan odgovor na "koliko različitih tipova učesnika" tri. (GoF: Client, Prototype, ConcretePrototype.)

```
Klijent --koristi--> Prototip {clone()}
                        ^          ^
              Proizvod1A        Proizvod1B   (konkretni prototipi, svaki implementira clone)
```

U Javi: `clone()` je pisan ručno (vežbe prave `new Proizvod1A()` i kopiraju polja), ne preko `Cloneable`.

Važna razlika kopija: pliće (dele se referentni atributi) i duboko (kopiraju se i objekti na koje se pokazuje). Memorijski fragment sa vežbi (zadatak 8) kopira niz element po element, dakle duboka kopija.

## Kada se koristi

- Klase koje se instanciraju određuju se u izvršavanju (dinamičko učitavanje, registar prototipova).
- Izbegavaš paralelnu hijerarhiju fabrika.
- Objekti imaju malo različitih stanja, pa je jeftinije kopirati prilagođen prototip nego ručno ga graditi.
- Prototipi se mogu dodavati i brisati u izvršavanju (tvrdnja iz wiki testova).

## Primer: Apstraktna fabrika pomoću Prototipa (vežbe, zadatak 5)

```java
abstract class Proizvod1 { abstract Proizvod1 copy(); }
class Proizvod1A extends Proizvod1 {
    int a;
    Proizvod1A copy() { Proizvod1A c = new Proizvod1A(); c.a = a; return c; }
}
class Proizvod1B extends Proizvod1 {
    int b;
    Proizvod1B copy() { Proizvod1B c = new Proizvod1B(); c.b = b; return c; }
}

abstract class Proizvod2 { abstract Proizvod2 copy(); }
class Proizvod2A extends Proizvod2 { Proizvod2A copy() { return new Proizvod2A(); } }
class Proizvod2B extends Proizvod2 { Proizvod2B copy() { return new Proizvod2B(); } }

// jedna fabrika; porodica se bira prototipovima koje dobije
class Fabrika {
    private final Proizvod1 p1;
    private final Proizvod2 p2;
    Fabrika(Proizvod1 p1, Proizvod2 p2) { this.p1 = p1; this.p2 = p2; }
    Proizvod1 napraviProizvod1() { return p1.copy(); }
    Proizvod2 napraviProizvod2() { return p2.copy(); }
}

public class Main {
    public static void main(String[] args) {
        Fabrika a = new Fabrika(new Proizvod1A(), new Proizvod2A());
        Fabrika b = new Fabrika(new Proizvod1B(), new Proizvod2B());
        System.out.println(a.napraviProizvod1().getClass().getSimpleName());
        System.out.println(b.napraviProizvod2().getClass().getSimpleName());
        System.out.println(a.napraviProizvod1() != a.napraviProizvod1());
    }
}
```

Na vežbama su `KonkretnaFabrikaA/B` podklase apstraktne fabrike, koje samo prosleđuju prototipe konstruktoru. Gornja verzija je skraćena na jednu klasu, ali je ideja ista; ako na ispitu treba da prikažeš uloge, nacrtaj kao na slajdu.

Drugi primer sa vežbi (zadatak 8): `MemFragment.clone()` se koristi u `Process.fork()` da se napravi dete-proces; `Process` je Klijent, `MemFragment` Prototip, `MemFragmentImpl` i `MemFragmentProxy` Konkretni prototipi.

## Sa čim se meša

- **Abstract Factory**: Prototype je jedan od načina da se ona implementira (fabrika čuva prototipe i kopira ih umesto da zove konstruktore).
- **Factory Method**: Factory Method nasleđivanjem bira klasu, Prototype kopiranjem instance.
- **Memento**: Memento čuva stanje radi vraćanja, Prototype radi pravljenja novog nezavisnog objekta.
- **Composite/Decorator**: prototipovi se često kombinuju sa njima da se složeni objekti kopiraju.

## Pojavljivalo se na K1

- Samo kao teorija (višestruki izbor) na starim K1: 2021 (zadatak 8), 2022 (zadatak 8), 2023 (zadatak 8), probni testovi 2021 (zadatak 9, odgovor 3). Prema wiki sažetku teme su: metoda kopiranja i registar, klijent ne mora da zna konkretne prototipe, dodavanje u izvršavanju, kombinovanje sa Composite, "klasni ili objektni" uzorak (objektni).
- U kodnim kolokvijumima 2024/25 i 2025/26 nije bio tražen.
