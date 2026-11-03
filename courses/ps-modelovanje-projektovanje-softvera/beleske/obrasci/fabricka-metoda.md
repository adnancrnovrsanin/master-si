# Factory Method (Fabrička metoda / Fabrički metod)

Vrsta: kreacioni, klasni. Izvor: slajdovi str. 47–53; vežbe zadaci 7 (usput) i 13.

## Namena

Definiše operaciju za pravljenje objekta, a podklase odlučuju koju klasu instanciraju. Klasa koja "zna kada" da napravi objekat prepušta podklasi "šta" da napravi.

## Problem koji rešava

Opšti deo (okvir, apstraktna klasa) mora da pravi objekte u tačno određenom trenutku, ali ne zna konkretnu klasu. Primer sa slajdova: `Application.openDocument()` mora da napravi `Document`, a tek `TxtProcApp` zna da je to `TxtDocument`.

## Struktura

Slajdovi (str. 50): `Creator` (`operation()` poziva `factoryMethod()`), `Product`, `ConcreteCreator` (redefiniše `factoryMethod` i vraća `new ConcreteProduct`), `ConcreteProduct`. Drugo ime: **Virtuelni konstruktor**.

Vežbe (slajd "Zadatak 13 – saradnja"): **Fabrika** (`Neprijatelj`), **Konkretna fabrika** (`Vilenjak`, `Patuljak`, `Dzin`), **Proizvod** (`Stvar`), **Konkretan proizvod** (`Nakit`, `Oruzje`, `Torba`).

```
Neprijatelj {interaguj(Junak) {... Stvar s = napraviNagradu(); junak.dodajNagradu(s);}
             # napraviNagradu() : Stvar {abstract}}     <- fabrički metod
   ^        ^        ^
Vilenjak  Patuljak  Dzin      (svaki vraća svoju konkretnu stvar: Nakit / Oruzje / Torba)
```

## Kada se koristi

- Klasa ne može da predvidi klasu objekata koje pravi.
- Klasa želi da podklase biraju vrstu proizvoda.
- Želiš da lokalizuješ odluku o tome koja se podklasa instancira.

Varijante (str. 51): `Creator` apstraktan (nema podrazumevanu implementaciju) ili sa podrazumevanom implementacijom; fabrički metod može imati parametar koji bira tip; za podklase koje se razlikuju samo po tipu proizvoda može se koristiti šablonska klasa (C++).

Posledice (str. 52–53): opšti deo ne zavisi od konkretnih tipova; nedostatak je što se moraju praviti podklase samo zbog pravljenja objekta (ne smeta ako se `Creator` ionako specijalizuje); moguće paralelne hijerarhije `ConcreteCreator` i `ConcreteProduct` (primer: `Figure.createManipulator()` pravi `LineManipulator`/`TextManipulator`).

## Primer (vežbe, zadatak 13, svojim rečima)

```java
abstract class Stvar { abstract int snaga(); }
class Nakit extends Stvar { int snaga() { return 0; } }
class Oruzje extends Stvar { int snaga() { return 5000; } }

abstract class Neprijatelj {
    protected final int snaga;
    Neprijatelj(int snaga) { this.snaga = snaga; }

    // šablonski metod koji poziva fabrički metod
    Stvar interaguj(int snagaJunaka) {
        return snagaJunaka > snaga ? napraviNagradu() : null;
    }

    protected abstract Stvar napraviNagradu();    // fabrički metod
}

class Vilenjak extends Neprijatelj {
    Vilenjak(int s) { super(s); }
    protected Stvar napraviNagradu() { return new Nakit(); }
}

class Patuljak extends Neprijatelj {
    Patuljak(int s) { super(s); }
    protected Stvar napraviNagradu() { return new Oruzje(); }
}

public class Main {
    public static void main(String[] args) {
        Neprijatelj[] n = { new Vilenjak(10), new Patuljak(10) };
        for (Neprijatelj e : n) {
            Stvar s = e.interaguj(50);
            System.out.println(s.getClass().getSimpleName() + " " + s.snaga());
        }
        System.out.println(n[0].interaguj(5));   // null: junak je slabiji
    }
}
```

## Sa čim se meša

- **Template Method**: metod `interaguj` je na vežbama šablonski metod koji poziva fabrički metod; fabrički metod je skoro uvek korak neke šablonske metode ("Metod dohvatiTeksturu je šablonski metod, a napraviTeksturuVoda i napraviTeksturuKopno su koraci koji se redefinišu. Ovo je istovremeno i Fabrički metod", slajd "Zadatak 7 – saradnja").
- **Abstract Factory**: skup fabričkih metoda koji zajedno pravi porodicu proizvoda.
- **Prototype**: isti cilj bez podklasa Creatora (slajdovi str. 55–56 pokazuju upravo zašto: previše podklasa `GraphicTool`).
- **Builder/Singleton**: nisu isto; Fabrički metod ne gradi korak po korak i ne ograničava broj instanci.

## Razlika u notaciji (slajdovi / vežbe)

Naziv: slajdovi "Fabrička metoda", vežbe "Fabrički metod". Uloge: Creator/ConcreteCreator/Product/ConcreteProduct = Fabrika/Konkretna fabrika/Proizvod/Konkretan proizvod. Slajdovi ga klasifikuju kao klasni obrazac pravljenja.

## Pojavljivalo se na K1

Nije bio eksplicitno tražen ni na jednom K1 u materijalu. Pojavljuje se kao pomoćni uzorak uz Šablonski metod i Apstraktnu fabriku u zadacima 7 i 13 sa vežbi; moguće ga je navesti u z2.txt kod zadataka sa Flyweight fabrikom (K1P 2024/25 z2).

Napomena o kodu sa vežbi: u zadatku 13 `Torba.vrednost()` sabira u promenljivu `snaga` umesto `vrednost`, `Nakit.vrednost()` je deklarisan kao `abstract` sa telom i vraća 2000 umesto 1000 iz teksta zadatka. Kod sa slajda ne kompajlira bez ispravke.
