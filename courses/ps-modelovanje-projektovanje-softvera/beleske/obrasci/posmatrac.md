# Observer (Posmatrač)

Vrsta: ponašanja, objektni. Izvor: slajdovi str. 85–92; vežbe zadatak 12; K1 2024/25 z2, K1P 2024/25 z1.

## Namena

Zavisnost jedan prema više: kada subjekat promeni stanje, svi prijavljeni posmatrači se obaveštavaju i sami se ažuriraju. Drugi naziv: **Objava-pretplata (Publish-Subscribe)** (str. 87).

## Problem koji rešava

Više objekata treba da bude konzistentno sa stanjem jednog (tabela i histogram istih podataka; korisnici berzanskog servisa), a ne žele da budu čvrsto vezani niti da se unapred zna koliko ih je.

## Struktura

Slajdovi (str. 88–89): **Subject** (`subscribe`, `unsubscribe`, `notify`; drži `observers`), **Observer** (`update()`), **ConcreteSubject** (`getState/setState`), **ConcreteObserver** (drži `subject`, implementira `update`, u `update` pita subjekat za stanje).

Vežbe (slajd "Zadatak 12 – saradnja"): **Konkretan subjekat** (`StockService`), **Posmatrač** (`User`), **Konkretan posmatrač** (`IndividualUser`, `Company`). Napomena sa slajda: "Ne postoji klasa sa ulogom Subjekat. Predstavlja **push** konfiguraciju uzorka Posmatrač."

```
StockService (konkretan subjekat)  --drži 0..*-->  User {update(stock, delta)}  (posmatrač)
  registerUser(u), removeUser(u),                      ^                ^
  stockChange(stock, delta): za svakog u -> u.update(...)   IndividualUser   Company
```

## Kada se koristi (str. 87)

- Apstrakcija ima dva aspekta (model i prikaz) koje treba razdvojiti.
- Promena jednog objekta menja više drugih, ne zna se koliko.
- Objekat treba da obavesti druge ne znajući ko su.
- U tekstu zadatka: "korisnici se prijavljuju/odjavljuju", "svi prijavljeni se obaveštavaju", "pošalje se poruka svim pretplaćenima".

## Aspekti implementacije (str. 90–91)

- Ko poziva `notify`: operacije koje menjaju stanje (automatski) ili klijent (kad se grupišu promene).
- Subjekat mora biti u konzistentnom stanju pred `notify` (šablonska metoda pomaže).
- **Push** model: subjekat šalje podatke kao parametre `update` (K1 poker, vežbe zadatak 12). **Pull** model: `update()` bez podataka, posmatrač traži stanje od subjekta (opštije i manje spregnuto, ali može biti manje efikasno).
- Posmatrač može posmatrati više subjekata: `update` dobija subjekat kao parametar.
- Prijavljivanje na "temu" (topic); `ChangeManager` između subjekata i posmatrača (MVC).
- Posledice (str. 92): subjekti i posmatrači se menjaju nezavisno, broadcast komunikacija, posmatrači ne znaju cenu promene.

## Primer (vežbe, zadatak 12, svojim rečima, push)

```java
import java.util.ArrayList;
import java.util.List;

interface User { void update(String stock, double delta); }

class StockService {                                   // konkretan subjekat
    private final List<User> users = new ArrayList<>();
    void registerUser(User u) { users.add(u); }
    void removeUser(User u) { users.remove(u); }
    void stockChange(String stock, double delta) {
        for (User u : new ArrayList<>(users)) u.update(stock, delta);
    }
}

class IndividualUser implements User {                 // konkretan posmatrač
    private final String name;
    IndividualUser(String name) { this.name = name; }
    public void update(String stock, double delta) {
        if (delta < 0) System.out.println(name + " buys 2 of " + stock);
        else System.out.println(name + " sells " + stock);
    }
}

class Company implements User {
    private final double threshold;
    Company(double threshold) { this.threshold = threshold; }
    public void update(String stock, double delta) {
        if (delta < 0 && Math.abs(delta) > threshold) System.out.println("company buys 5 of " + stock);
    }
}

public class Main {
    public static void main(String[] args) {
        StockService s = new StockService();     // na vežbama je još i Unikat
        User a = new IndividualUser("ana");
        s.registerUser(a);
        s.registerUser(new Company(1.0));
        s.stockChange("ABC", -2.0);
        s.removeUser(a);
        s.stockChange("ABC", 0.5);                // nikog ne zanima
    }
}
```

U kodu sa slajda `stockChange` ima `users.update(...)` umesto `user.update(...)`, `Stock.getPrice()` vraća `String` i `stocks.set(...)` ne postoji na `HashMap`. Ne kopiraj slepo.

Diskusija sa vežbi: logika `update` kod `IndividualUser` i `Company` nije lako proširiva za nove načine kupovine/prodaje (ovde dolazi Strategija); pull konfiguracija bi imala `update()` bez podataka i posmatrač bi pitao subjekat šta se promenilo.

## Sa čim se meša

- **Komanda**: Komanda je jedan zahtev jednom primaocu, Posmatrač je broadcast promene stanja.
- **Mediator** (nije u materijalu): Mediator koordiniše kolege dvosmerno; Posmatrač je jednosmeran i subjekat ne zna ko su posmatrači. Slajd str. 368 kaže "objava-pretplata srodan Observer i Mediator". Tekst K1 2024/25 z2 naglašava da "igrači ne razgovaraju međusobno", pa Mediator nije potreban.
- **Strategija**: posmatrač menja ponašanje kao odgovor na događaj, strategija je algoritam koji klijent bira.
- **Singleton**: subjekt je često Unikat (StockService, Croupier).

## Pojavljivalo se na K1

- K1 2024/25 (27.10.2024.) z2: krupije (subjekat) obaveštava sve prijavljene igrače o otkrivenoj karti; igrači se prijavljuju i odjavljuju; "broj igrača mali, dovoljno za sinhronu komunikaciju" (push, sinhrono). U početnom kodu postoji `// TODO: Update players on new Cards on table.`.
- K1P 2024/25 (1.12.2024.) z1: `Directory` je subjekat, `ObserverLogger` posmatrač; tri vrste obaveštenja (dodat fajl, uklonjen fajl, promenjen sadržaj). Poruke su zadate u tekstu ("File added: ...", "File removed – ...", "File content changed – ..."); poštuj tačno formu iz zadatka (na wikiju ima neslaganje između teksta i rešenja).
- Vežbe: zadatak 12.

## Razlika u notaciji (slajdovi / vežbe)

Slajdovi: Subject, Observer, ConcreteSubject, ConcreteObserver; metode `subscribe/unsubscribe/notify/update`. Vežbe: Konkretan subjekat, Posmatrač, Konkretan posmatrač; metode `registerUser/removeUser/update`; uloga Subject je izostavljena (push konfiguracija). Za z1.txt na K1 navedi uloge po vežbama i dodaj GoF naziv u zagradi.
