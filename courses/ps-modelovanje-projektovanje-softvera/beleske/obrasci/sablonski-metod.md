# Template Method (Šablonski metod)

Vrsta: ponašanja, nad klasama. Izvor: vežbe zadaci 1, 7 i 13; stari K1 2021–2023 (teorija, sa wikija).

## Namena

Apstraktna klasa u jednom (finalnom) metodu fiksira redosled koraka algoritma, a korake koji se razlikuju prepušta podklasama. Kontrola je "obrnuta": podklasa ne poziva okvir, okvir poziva podklasu.

## Problem koji rešava

Više procesa ima isti skelet (isti koraci, isti redosled), a samo neki koraci se razlikuju. Bez uzorka se skelet kopira u svaku klasu ili se grana sa `if`/`switch`.

## Struktura

Nazivi uloga na vežbama (slajd "Zadatak 1 – saradnja"): **Apstraktna klasa**, **Konkretna klasa**. Isto kao u GoF (AbstractClass, ConcreteClass).

```
BeverageMaker (apstraktna klasa)
  + makeBeverage()            <- šablonski metod: boilWater(); brew(); pourInCup(); addCondiments();
  # boilWater(), pourInCup()   <- zajednički koraci (implementirani)
  # brew()      {abstract}     <- koraci koje podklase redefinišu
  # addCondiments() {abstract}
      ^                ^
  CoffeeMaker       TeaMaker      (konkretne klase redefinišu brew i addCondiments)
```

Varijanta: korak sa podrazumevanim ponašanjem koje podklasa sme da promeni ("zakačka", hook).

## Kada se koristi

- Koraci i njihov redosled su jasno definisani i isti za sve varijante, a pojedinačni koraci variraju.
- Želiš da zajednički deo kôda postoji na jednom mestu.
- Želiš da kontrolišeš gde se podklase mogu "uključiti" (samo preko definisanih koraka).

## Primer (vežbe, zadatak 1, svojim rečima)

```java
abstract class BeverageMaker {
    public final void makeBeverage() {      // šablonski metod
        boilWater();
        brew();
        pourInCup();
        addCondiments();
    }
    protected void boilWater() { System.out.println("Boiling water"); }
    protected void pourInCup() { System.out.println("Pouring into cup"); }
    protected abstract void brew();
    protected abstract void addCondiments();
}

class CoffeeMaker extends BeverageMaker {
    protected void brew() { System.out.println("Dripping coffee through filter"); }
    protected void addCondiments() { System.out.println("Adding sugar and milk"); }
}

class TeaMaker extends BeverageMaker {
    protected void brew() { System.out.println("Steeping the tea"); }
    protected void addCondiments() { System.out.println("Adding lemon"); }
}

public class Main {
    public static void main(String[] args) {
        new CoffeeMaker().makeBeverage();
        new TeaMaker().makeBeverage();
    }
}
```

## Sa čim se meša

- **Strategy**: obe menjaju deo algoritma. Template Method to radi nasleđivanjem (u vreme kompajliranja, po klasi), Strategy kompozicijom (objekat se menja u toku rada). Ako se algoritam menja "u hodu" ili se kombinuje, ide Strategy.
- **Factory Method**: fabrički metod je često jedan korak šablonskog metoda. Na vežbama (zadatak 7) je metod `getTexture` istovremeno šablonski metod (zna redosled: proveri keš, napravi, vrati) i fabrički metod (poziva `createTextureWater/Land` koje podklase redefinišu).
- **Builder** (vežbe, diskusija zadatka 1): kad bi kafa i čaj bili posebne klase sa sopstvenim ponašanjem, sistem bi se mogao rešiti i Builder-om.

## Slajdovi predavanja (PS_full_2026.pdf, str. 39–46)

- Motivacija i primer okvira `Application`/`Document` (str. 40–41): `openDocument` je šablonska metoda koja poziva `canOpenDocument`, `createDocument`, `addDocument`, `aboutToOpenDoc`, `doc->open()`, `doc->read()`.
- Namena i primenljivost (str. 42): nepromenljive delove algoritma napisati jednom; algoritamska generalizacija (refaktorisanje zajedničkih delova); kontrola proširenja preko "operacija kukica" (hook operations).
- Struktura (str. 43): `AbstractClass` (`templateMethod`, `primitiveOp1/2`) i `ConcreteClass`. Učesnici na slajdu: AbstractClass (Application), ConcreteClass (TxtDocument).
- Implementacija (str. 44): primitivne operacije su najčešće zaštićene, apstraktne ako se moraju redefinisati; šablonska metoda je najčešće nepolimorfna (`final`); težiti najmanjem skupu operacija koje se moraju redefinisati; konvencija imenovanja primitivnih operacija (`hRead`, `doRead`).
- Posledice (str. 45–46): "holivudski princip" (Don't call us, we'll call you). Bolje je da šablonska metoda poziva kukicu nego da se od podklase traži da pozove `BaseClass::op()` (lako se zaboravi). Četiri vrste operacija koje šablonska metoda poziva: konkretne koje se ne redefinišu, apstraktne, kukice, operacije drugih klasa.
- Str. 68: Command + Template Method. Slajd predlaže da se pokretanje komande izdvoji u šablonsku metodu `handle`, a `execute` bude kukica; `handle` lokalizuje proveru preduslova/postuslova, proveru prava pristupa, transakcioni mehanizam, hvatanje i obradu izuzetaka i logovanje. To je skoro doslovno zadatak 2 sa ispita feb 2026 (iz sećanja), videti `komanda.md`.

**Razlika u notaciji (slajdovi / vežbe):** isti nazivi uloga (AbstractClass/ConcreteClass = Apstraktna klasa/Konkretna klasa). Naziv uzorka: slajdovi "Šablonska metoda", vežbe "Šablonski metod". Slajdovi uzorak klasifikuju kao klasni/ponašanja.

## Pojavljivalo se na K1

- Teorijska pitanja sa wikija (višestruki izbor, nepotvrđeno koje su opcije tačne): K1 2021 (zadaci 6 i 7), K1 2022 (zadatak 7), K1 2023 (zadatak 7).
- Ispit januar/februar 2026 (iz sećanja studenata, vidi `zadaci/ispit-februar-2026-iz-secanja.md`): zadatak 2 traži Template Method + Command (komanda koja proverava prava, loguje i hvata greške). To nije K1 nego ispit, ali pokazuje kako se uzorak kombinuje.
- U novim kolokvijumima (2024/25, 2025/26) nije eksplicitno tražen; može da se pojavi kao deo "dorade" u zadatku 2.
