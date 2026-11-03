# Facade (Fasada)

Vrsta: strukturni, objektni. Izvor: slajdovi str. 22–27; vežbe zadatak 6.

## Namena

Jedinstven, jednostavan interfejs višeg nivoa prema skupu interfejsa nekog podsistema.

## Problem koji rešava

Podsistem je složen (više klasa, redosled poziva, detalji); klijenti treba samo nekoliko tipičnih usluga. Bez fasade svaki klijent zavisi od mnogo klasa podsistema.

## Struktura

Slajdovi (str. 25): **Fasada** (zna koje klase podsistema rade posao, delegira zahteve) i **ostale klase podsistema** (rade posao, ne znaju za fasadu i ne zavise od nje). Vežbe (slajd "Zadatak 6 – saradnja"): **Fasada** (`HAL`) i **Podsistem** (paket `motor`: `DriverCounter`, `DriverDCDrive`, `DriverMotor`).

```
Klijent --> HAL.setSpeed(sp) { driverDCDrive.write(sp); driverCounter.reset(); driverMotor.turnOn(); }
            (fasada)  ---> DriverDCDrive, DriverCounter, DriverMotor   (podsistem)
```

## Kada se koristi (str. 24)

- Treba jednostavan interfejs složenog podsistema, a napredni klijenti i dalje mogu da pristupe delovima iza fasade.
- Postoji složena zavisnost između klijenata i klasa koje realizuju usluge.
- Treba organizovati podsisteme u slojeve; fasada je ulazna tačka u sloj.

Aspekti (str. 26): fasada može biti uslužna klasa ili Singleton, apstraktna klasa sa različitim verzijama podsistema, javni interfejs paketa dok su ostale klase privatne. Posledice (str. 27): manje objekata sa kojima klijent interaguje, slaba sprega, ne zabranjuje direktan pristup podsistemu.

## Primer (vežbe, zadatak 6, svojim rečima)

```java
class DriverCounter { void reset() { System.out.println("counter reset"); } }
class DriverDCDrive { void write(int v) { System.out.println("dc drive <- " + v); } }
class DriverMotor { void turnOn() { System.out.println("motor on"); } }

class Hal {                                          // fasada, ujedno Unikat
    private static Hal instance;
    private final DriverCounter counter = new DriverCounter();
    private final DriverDCDrive dc = new DriverDCDrive();
    private final DriverMotor motor = new DriverMotor();
    private Hal() {}
    static Hal getInstance() {
        if (instance == null) instance = new Hal();
        return instance;
    }
    void setSpeed(int sp) {                          // jedna operacija umesto tri
        dc.write(sp);
        counter.reset();
        motor.turnOn();
    }
}

public class Main {
    public static void main(String[] args) {
        Hal.getInstance().setSpeed(30);
    }
}
```

## Sa čim se meša

- **Adapter**: vidi `adapter.md`. Fasada pojednostavljuje, Adapter prilagođava postojeći interfejs jednoj klasi.
- **Mediator** (nije u materijalu): Mediator posreduje između kolega koji se međusobno znaju i može da se menja dvosmerno, Fasada je jednosmerna.
- **Singleton**: fasada je često Unikat (slajd str. 23, 26).

## Pojavljivalo se na K1

Nije bila eksplicitno tražena ni na jednom K1 u materijalu. Vežbe: zadatak 6.

## Razlika u notaciji (slajdovi / vežbe)

Isti učesnici, samo je na vežbama drugi učesnik nazvan **Podsistem** (prikazan kao paket), a na slajdovima "ostale klase podsistema".
