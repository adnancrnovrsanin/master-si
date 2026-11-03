# Builder (Graditelj)

Vrsta: kreacioni, objektni (klasifikacija po GoF-u). Izvor: vežbe zadatak 14 (i diskusija zadatka 1). Nema ga na slajdovima PS_full_2026.pdf.

## Namena

Odvaja pravljenje složenog objekta od njegove reprezentacije i omogućava da se objekat pravi korak po korak; u varijanti sa vežbi, to je način da se napravi objekat sa mnogo (obaveznih i neobaveznih) atributa bez konstruktora sa dugačkom listom parametara.

## Problem koji rešava (slajd "Zadatak 14")

Korisnik ima obavezne (ime, prezime) i neobavezne atribute (email, telefon, srednja imena...).
- Konstruktor sa mnogo parametara: lako se zameni redosled, ne vidi se koje je polje koje.
- Konstruktori za sve kombinacije: eksponencijalan broj.
- Setteri: nema načina da se proveri da li je objekat potpuno konstruisan pre upotrebe.

## Struktura sa vežbi

Odstupa od kanonskog uzorka (slajd kaže da "nije potrebno više različitih tipova graditelja niti upravljač, pa možemo odstupiti"):

- `Person.Builder` je statička **unutrašnja klasa**; `Person` ima **privatan konstruktor** koji kopira polja iz graditelja; polja `Person` su `final`.
- Metode graditelja postavljaju polje graditelja i **vraćaju `this`** (uvezivanje poziva).
- `build()` pravi `Person`.

Kanonski GoF (nije na vežbama, ovde samo radi poređenja): Director (upravljač), Builder (apstraktni graditelj), ConcreteBuilder, Product. Director poziva korake, ConcreteBuilder pravi različite reprezentacije proizvoda.

Varijante sa vežbi, redom:
1. **Osnovni graditelj** (str. 97–98 vežbi): `Person.builder().firstName("John").lastName("Doe").phone("555").build()`.
2. **Provera u `build()`**: baci izuzetak ako obavezno polje nije zadato (greška tek u izvršavanju).
3. **Obavezni parametri u konstruktoru graditelja**: `new Person.Builder("John", "Doe")`, ali se vraća problem nerazumljivih parametara.
4. **Uvezivanje interfejsa** (step builder): `FirstNameSetter -> LastNameSetter -> OptionalFieldsSetter`. `Person.builder()` vraća `FirstNameSetter`, pa kompajler zabranjuje pogrešan redosled: `Person.builder().phone("...")` se ne kompajlira.

## Kada se koristi

- Mnogo atributa, deo obavezan.
- Objekat treba da bude nepromenljiv (immutable) i uvek potpuno konstruisan.
- Poziv treba da bude čitljiv (imenovana polja).

## Primer (varijanta 4)

```java
import java.util.List;

class Person {
    private final String firstName, lastName, email, phone;
    private final List<String> middleNames;

    private Person(Builder b) {
        firstName = b.firstName;
        lastName = b.lastName;
        email = b.email;
        phone = b.phone;
        middleNames = b.middleNames;
    }

    interface FirstNameSetter { LastNameSetter firstName(String s); }
    interface LastNameSetter { OptionalFieldsSetter lastName(String s); }
    interface OptionalFieldsSetter {
        OptionalFieldsSetter email(String s);
        OptionalFieldsSetter phone(String s);
        Person build();
    }

    static FirstNameSetter builder() { return new Builder(); }

    private static class Builder implements FirstNameSetter, LastNameSetter, OptionalFieldsSetter {
        private String firstName, lastName, email = "", phone = "";
        private List<String> middleNames = List.of();

        public LastNameSetter firstName(String s) { firstName = s; return this; }
        public OptionalFieldsSetter lastName(String s) { lastName = s; return this; }
        public OptionalFieldsSetter email(String s) { email = s; return this; }
        public OptionalFieldsSetter phone(String s) { phone = s; return this; }
        public Person build() { return new Person(this); }
    }

    @Override public String toString() { return firstName + " " + lastName + " <" + email + "> " + phone; }
}

public class Main {
    public static void main(String[] args) {
        Person p = Person.builder().firstName("John").lastName("Doe").phone("555-5555").build();
        System.out.println(p);
        // Person.builder().phone("555");   // ne kompajlira se: FirstNameSetter nema phone()
    }
}
```

## Sa čim se meša

- **Apstraktna fabrika**: ona odmah vraća gotove proizvode više vrsta (porodice), Graditelj gradi *jedan* objekat postepeno.
- **Fabrički metod**: jedan korak pravljenja, bez koraka konfiguracije.
- **Šablonski metod** (vežbe, zadatak 1, diskusija): kad bi `Kafa` i `Caj` bile klase sa sopstvenim ponašanjem, sistem sa fiksnim koracima bi mogao da se reši Graditeljem.
- **Prototip**: kopira gotov objekat.

## Pojavljivalo se na K1

Nije bio na K1 u materijalu (kodni ili wiki). Vežbe: zadatak 14.

## Razlika u notaciji (slajdovi / vežbe)

Nema slajdova. Na vežbama se piše "Градитељ" (Graditelj); upravljač = Director. Zbog odstupanja od kanonskog uzorka na vežbama, ako se na kolokvijumu traži raspodela uloga, navedi Builder (graditelj) i Product (proizvod), a Director istakni kao izostavljen.
