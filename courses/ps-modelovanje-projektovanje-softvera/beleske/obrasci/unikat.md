# Singleton (Unikat), Multiton

Vrsta: kreacioni, nad objektima. Izvor: vežbe zadatak 3 (a kroz zadatke 6, 11 i 12 se pojavljuje kao pomoćni uzorak); stari K1 2019, 2023, probni testovi 2021.

## Namena

Klasa ima tačno jednu instancu (ili kontrolisan broj instanci) i globalnu tačku pristupa do nje.

## Problem koji rešava

Resurs koji sme (ili treba) da postoji samo jednom: menadžer mreže, štampač, servis akcija, panel, log. Globalna promenljiva ne sprečava pravljenje drugih instanci, a klasa sa samo statičkim metodama se ne može nasleđivati niti menjati u toku rada.

## Struktura

Uloga na vežbama: **Unikat** (jedina uloga, slajd "Zadatak 6/11/12 – saradnja").

```
Singleton
  - instance : Singleton {static}
  - Singleton()                      <- privatan konstruktor
  + getInstance() : Singleton {static}
```

Tri koraka: privatan konstruktor, privatan statički atribut sa instancom, javna statička metoda koja je pravi pri prvom pozivu (lenjo) i vraća.

Varijante sa vežbi:
- **klasična** (lenja inicijalizacija, nije bezbedna za niti)
- **Multiton** (zadatak 3): više instanci, pristup po imenu: `Map<String, Multiton>`; `getInstance(name)` pravi instancu ako je nema
- **thread-safe**: u kodovima sa vežbi postoji `ThreadSafeSingleton` sa `volatile` poljem i double-checked locking-om u `synchronized` bloku

## Kada se koristi

- Mora postojati tačno jedna instanca i klijenti joj pristupaju sa jednog dobro poznatog mesta.
- Instanca treba da se može proširivati nasleđivanjem ili da broj instanci bude kasnije promenljiv (zato nije isto što i klasa sa statičkim metodama).

## Primer

```java
import java.util.HashMap;
import java.util.Map;

class Singleton {
    private static Singleton instance = null;
    private Singleton() {}
    static Singleton getInstance() {
        if (instance == null) instance = new Singleton();
        return instance;
    }
}

class Multiton {
    private static final Map<String, Multiton> instances = new HashMap<>();
    private final String name;
    private Multiton(String name) { this.name = name; }
    static Multiton getInstance(String name) {
        if (!instances.containsKey(name)) instances.put(name, new Multiton(name));
        return instances.get(name);
    }
    String getName() { return name; }
}

class ThreadSafeSingleton {
    private static volatile ThreadSafeSingleton instance;
    private ThreadSafeSingleton() {}
    static ThreadSafeSingleton getInstance() {
        if (instance == null) {
            synchronized (ThreadSafeSingleton.class) {
                if (instance == null) instance = new ThreadSafeSingleton();
            }
        }
        return instance;
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println(Singleton.getInstance() == Singleton.getInstance());
        System.out.println(Multiton.getInstance("a") == Multiton.getInstance("a"));
        System.out.println(Multiton.getInstance("a") == Multiton.getInstance("b"));
        System.out.println(ThreadSafeSingleton.getInstance() == ThreadSafeSingleton.getInstance());
    }
}
```

## Sa čim se meša

- **Utility klasa (samo statički metodi)**: nije isto. Unikat ima stanje objekta, može implementirati interfejs i nasleđivati; wiki teorija (2019, 2023) to pominje kao čestu zamku.
- **Globalna promenljiva**: Unikat sprečava drugu instancu i može da bude lenj.
- **Flyweight**: Flyweight fabrika vraća deljene objekte različitih ključeva (kao Multiton), ali deli nepromenljivo unutrašnje stanje radi štednje memorije.
- **Prototype**/**Abstract Factory**: fabrike često jesu Unikati (jedna fabrika po porodici), vidi `apstraktna-fabrika.md`.

## Slajdovi predavanja (PS_full_2026.pdf, str. 15–21)

- Motivacija (str. 16): `Scheduler` u jezgru OS, `DBManager`. Zahtev: instanca je propisno inicijalizovana i sigurno postoji pri prvom pristupu, ne može se napraviti više instanci, lako je dostupna. Globalni statički objekat ne daje garanciju inicijalizacije ni enkapsulacije.
- Namena (str. 17): objektni obrazac pravljenja; jedna instanca + globalna pristupna tačka; instanca treba da bude **proširiva nasleđivanjem** pa klijenti koriste izvedenu klasu bez izmena.
- Struktura (str. 18): atribut `_instance`, statička operacija `instance()`, **zaštićen** (`protected`) konstruktor; učesnik je samo Singleton (Scheduler).
- Implementacija (str. 19–20): Java verzija sa slajda je **eager** (`private static instance = new Scheduler;`, pristup `Scheduler.instance().put(...)`), C++ preporuka je lokalni statički objekat u `instance()` (inicijalizuje se pri prvom pristupu).
- Posledice (str. 21): kontrola pristupa (npr. parametri `instance()`), manje opterećenje globalnog prostora imena, može se nasleđivati i konfigurisati u izvršavanju, moguć je kontrolisan broj instanci (Multiton), fleksibilnije nego uslužna klasa sa statičkim operacijama (one ne mogu biti polimorfne).

**Razlika u notaciji (slajdovi / vežbe):** slajdovi `instance()`, zaštićen konstruktor, eager; vežbe `getInstance()`, privatan konstruktor, lenja inicijalizacija, plus Multiton i thread-safe varijanta. Obe varijante su "tačne"; ako se traži nasleđivanje instance, konstruktor mora biti `protected`. Slajdovi ne pominju Multiton ni double-checked locking (to je samo sa vežbi).

## Pojavljivalo se na K1

- Kao pomoćni uzorak u gotovo svakom zadatku sa vežbi (HAL = Fasada + Unikat + adaptirana klasa; Panel i PanelStateLog; StockService).
- K1 2024/25 z2 (poker, "krupije"): `Croupier` je Unikat, i početni kod ga ima pokvarenog (`getInstance()` uvek vraća `null`, instanca se nikad ne pravi). To je "ispravi" deo zadatka.
- K1P 2025/26 z2 (laboratorija): `LaboratoryNetworkManager` i `NetworkManager` su već Unikati u početnom kodu; Unikat tu nije nešto što treba dodati, nego primalac komande.
- Teorija sa wikija: K1 2019 (zadatak 1), K1 2023 (zadatak 6, uključuje trku niti), probni testovi 2021 (zadatak 8).
