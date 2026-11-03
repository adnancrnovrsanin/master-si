# Decorator (Dekorater)

Vrsta: strukturni, nad objektima. Izvor: vežbe zadatak 2; K1 2024/25 i K1 2025/26 zadatak 1.

## Namena

Dinamički dodaje objektu odgovornosti (ili menja njegovo ponašanje) umotavanjem u objekat istog interfejsa. Klijent ne vidi da li je objekat dekorisan.

## Problem koji rešava

Podklasa za svaku kombinaciju dodataka (BlendWithMilk, BlendWithMilkAndSugar...) daje eksploziju broja klasa i ne dozvoljava isti dodatak dva puta. Dekorater: po jedna klasa za svaki dodatak, a kombinacije se prave u izvršavanju, u proizvoljnom broju i redosledu.

## Struktura

Nazivi uloga na vežbama (slajd "Zadatak 2 – saradnja") **razlikuju se od GoF**:

| Vežbe | GoF | Primer sa vežbi |
|---|---|---|
| Komponenta | Component | `Coffee` |
| Subjekat | ConcreteComponent | `BlendCoffee`, `SingleOriginCoffee` |
| Dopuna | Decorator | `CoffeeAddition` (apstraktna, drži `Coffee`) |
| Konkretna dopuna | ConcreteDecorator | `MilkCoffeeAddition`, `SugarCoffeeAddition`, `ChocolateCoffeeAddition` |

Na kolokvijumu u z1.txt koristi nazive sa vežbi (Komponenta, Subjekat, Dopuna, Konkretna dopuna), a u zagradi možeš navesti GoF naziv.

```
Coffee {abstract: price(), description()}
  ^                      ^
BlendCoffee         CoffeeAddition  ---(drži)--> Coffee
SingleOriginCoffee      ^
                MilkCoffeeAddition, SugarCoffeeAddition, ...
```

Dekorater nasleđuje komponentu i istovremeno ima referencu na komponentu (kompozicija). Poziv prosleđuje unutrašnjem objektu, pa dodaje svoje ponašanje pre/posle.

## Kada se koristi

- Dodaješ funkcionalnost pojedinačnim objektima, ne celoj klasi.
- Dodaci se kombinuju, ponavljaju, redosled je proizvoljan.
- Klijent mora da ostane nezavisan od toga da li je dodataka bilo (transparentnost). To je skoro doslovna formulacija iz K1 2024/25 i 2025/26 z1: "proizvoljan broj, proizvoljan redosled, ostatku sistema transparentno".

## Primer (vežbe, zadatak 2, svojim rečima)

```java
abstract class Coffee {
    abstract int price();
    abstract String description();
}

class BlendCoffee extends Coffee {
    int price() { return 150; }
    String description() { return "Blend Coffee"; }
}

abstract class CoffeeAddition extends Coffee {
    protected final Coffee coffee;
    CoffeeAddition(Coffee coffee) { this.coffee = coffee; }
    int price() { return coffee.price(); }
    String description() { return coffee.description(); }
}

class MilkAddition extends CoffeeAddition {
    MilkAddition(Coffee c) { super(c); }
    int price() { return super.price() + 100; }
    String description() { return super.description() + " with Milk"; }
}

class SugarAddition extends CoffeeAddition {
    SugarAddition(Coffee c) { super(c); }
    String description() { return super.description() + " with Sugar"; }
}

public class Main {
    public static void main(String[] args) {
        Coffee c = new MilkAddition(new MilkAddition(new SugarAddition(new BlendCoffee())));
        System.out.println(c.price() + " / " + c.description());
    }
}
```

Napomena: u slajdu su klase `BlendCoffee` i `SingleOriginCoffee` imale pogrešno ime konstante (`BLENDCOFFEE_PRICE` vs `BLEND_COFFEE_PRICE`), pa kod sa slajda ne kompajlira bez ispravke.

Kolokvijumski oblik (K1 2025/26 z1): `AudioStream { double[] getSamples(); }` je Komponenta, treba napraviti osnovni audio zapis (Subjekat), apstraktnu `AudioEffect` (Dopuna), `Echo` i `VolumeBoost` (Konkretne dopune), plus primer korišćenja u `main`.

## Sa čim se meša

- **Proxy**: ista struktura (isti interfejs, drži objekat). Razlika je namera: Dekorater dodaje ponašanje i lančano se slaže u više slojeva, Proxy kontroliše pristup jednom objektu (lenjost, prava, udaljenost) i obično sam pravi/pronalazi pravi objekat.
- **Adapter**: menja interfejs, Dekorater ga čuva.
- **Composite**: dekorater je degenerisan sastav sa jednim detetom, ali ne agregira nego proširuje.
- **Strategy**: Strategy menja "utrobu" objekta, Dekorater menja "kožu" (obmotava spolja).
- **Template Method**: wiki sažetak za K1 2024 navodi da može da pomogne u baznoj klasi filtera; nije potvrđeno u zvaničnom rešenju.

## Slajdovi predavanja (PS_full_2026.pdf, str. 78–84)

- Motivacija (str. 79–80): grafički elementi (`VisualComponent`, `TextView`) ukrašeni ramom (`BorderDecorator`) i klizačem (`ScrollDecorator`) u proizvoljnim kombinacijama; dekorater zadovoljava isti interfejs pa je transparentan klijentu.
- Namena (str. 81): "pridodati odgovornosti objektu dinamički; fleksibilna alternativa izvođenju klasa". Drugi naziv: **Omotač (Wrapper)**. Primenljivo i kad se odgovornosti moraju moći izbaciti i kad je klasa nedostupna za izvođenje.
- Struktura (str. 82): Component, ConcreteComponent, Decorator, ConcreteDecorator (primer: VisualComponent, TextView, Decorator, BorderDecorator/ScrollDecorator).
- Implementacija (str. 83): obe klase moraju imati istu osnovnu klasu; apstraktni `Decorator` može da se izostavi ako postoji samo jedan konkretni dekorater; interfejs komponente držati što užim. **Dekorater menja "kožu", Strategija "utrobu"**: kod Strategije osnovni objekat je napred i delegira strategiji iza sebe, kod Dekoratera je osnovni objekat iza i maskiran; strategija može imati sasvim drugačiji interfejs, dekorater ne sme da menja interfejs; klijenti ne znaju za strategiju, ali ni klijent ni osnovni objekat ne znaju za dekoratere.
- Posledice (str. 84): veća fleksibilnost od izvođenja; ista odgovornost se može dodati više puta; odgovornosti se grade inkrementalno; mnogo malih objekata.

**Razlika u notaciji (slajdovi / vežbe):** slajdovi koriste GoF nazive (Component, ConcreteComponent, Decorator, ConcreteDecorator); vežbe Komponenta, **Subjekat** (= ConcreteComponent), **Dopuna** (= Decorator), Konkretna dopuna (= ConcreteDecorator). Za z1.txt na kolokvijumu je bezbedno napisati oba naziva (npr. "Subjekat (ConcreteComponent)").

## Pojavljivalo se na K1

- K1 2024/25 (27.10.2024.) z1: filteri slike (Greyscale, Invert) nad nizom `Pixel`.
- K1 2025/26 (3.12.2025.) z1: efekti audio zapisa (Echo, VolumeBoost).
- Teorija sa wikija: K1 2021 (zadaci 6 i 10), K1 2023 (zadatak 10).
- Ispit feb 2026 (iz sećanja): zadatak 1, prepoznati Dekorater iz opisa razloga za korišćenje.
