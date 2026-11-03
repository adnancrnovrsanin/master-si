# Adapter (Adapter)

Vrsta: strukturni, klasni i objektni. Izvor: slajdovi str. 69–77; vežbe zadaci 6 i 9.

## Namena

Pretvara interfejs postojeće klase u interfejs koji klijent očekuje, da bi sarađivale klase čiji se interfejsi ne poklapaju. Drugi naziv: **Omotač (Wrapper)** (slajd str. 72).

## Problem koji rešava

Postoji gotova klasa/biblioteka koju ne smeš ili ne možeš da menjaš (`TextView`, Apache HTTP, drajveri motora), a njen interfejs nije onaj koji klijent koristi (`Shape`, `HttpInterface`, `WithSpeed`).

## Struktura

Slajdovi (str. 73–74): **objektni Adapter** (kompozicija: drži `adaptee`) i **klasni Adapter** (višestruko nasleđivanje, u Javi se ne može direktno). Učesnici: Target, Client, Adaptee, Adapter (primer: Shape, DrawingEditor, TextView, TextShape).

Vežbe (slajd "Zadatak 6 – saradnja"): **Klijent** (`KlijentskaApp`), **Cilj** (`ZahtevaniInterfejs` = `WithSpeed`), **Adapter** (`SpeedAdapter`), **Adaptirani** (`HAL`); na dijagramu je naznačeno "Objektni Adapter".

```
Klijent --> Cilj {setSpeed(int)}
              ^
            Adapter ---drži---> Adaptirani {setSpeed(packet)}
   setSpeed(n): { int packet = convert(n); adaptirani.setSpeed(packet); }
```

## Kada se koristi

- Hoćeš postojeću klasu, a interfejs ne odgovara.
- Praviš ponovno upotrebljivu klasu koja treba da sarađuje sa nepoznatim/nekompatibilnim klasama.
- Objektna varijanta: radi sa više podklasa Adaptee-a odjednom.

Aspekti (str. 75–77): prilagođavaj što manji interfejs; "pluggable adapters" (prilagođavanje samo nekoliko operacija, npr. tree view); dvosmerni (two-way) adapter. Klasni: vezan za jednu klasu, može da redefiniše Adaptee; objektni: radi sa podklasama Adaptee-a, teže se redefiniše njegovo ponašanje.

## Primer (vežbe, zadatak 6, svojim rečima)

```java
interface WithSpeed { void setSpeed(int percent); }          // cilj

class Hal {                                                   // adaptirana klasa (ne sme se menjati)
    void setSpeed(byte[] packet) {
        System.out.println("hal got packet of " + packet.length + " bytes, value " + packet[0]);
    }
}

class SpeedAdapter implements WithSpeed {                    // objektni adapter
    private final Hal hal;
    SpeedAdapter(Hal hal) { this.hal = hal; }
    public void setSpeed(int percent) {
        hal.setSpeed(new byte[]{(byte) percent});            // konverzija formata
    }
}

public class Main {
    public static void main(String[] args) {
        WithSpeed motor = new SpeedAdapter(new Hal());
        motor.setSpeed(40);
        motor.setSpeed(0);                                    // gašenje, po zadatku
    }
}
```

Drugi primer sa vežbi (zadatak 9): `ApacheAdapter implements HttpInterface` obmotava biblioteku Apache HTTP (`HttpClients`, `HttpGet`, `HttpPost`); klijent adaptera je `SubjectProxy`. Slajd za zadatak 9 ima i grešku: `json.concat(...)` ne menja `String`, pa bi se telo zahteva uvek izgubilo.

## Sa čim se meša

- **Fasada**: Fasada pravi *novi, jednostavniji* interfejs prema podsistemu (više klasa), Adapter usklađuje *postojeći* interfejs jedne klase sa *traženim* interfejsom. Na vežbama je `HAL` istovremeno Fasada (za drajvere) i Adaptirani (za `SpeedAdapter`).
- **Dekorater**: ne menja interfejs, dodaje ponašanje.
- **Zastupnik**: isti interfejs kao original.
- **Bridge**: struktura slična, ali Bridge se projektuje unapred da razdvoji apstrakciju od implementacije, a Adapter se uvodi naknadno (Bridge nije u materijalu za K1, nepotvrđeno).

## Pojavljivalo se na K1

Nije bio eksplicitno tražen ni na jednom K1 u materijalu (kodni ili wiki). Pojavljuje se u vežbama 6 i 9. Realno se može očekivati kao pomoćni uzorak u zadatku 2 ("početni kod koristi drugu biblioteku").

## Razlika u notaciji (slajdovi / vežbe)

Slajdovi: Target, Client, Adaptee, Adapter. Vežbe: **Cilj**, Klijent, **Adaptirani**, Adapter (i napomena "Objektni adapter" na dijagramu).
