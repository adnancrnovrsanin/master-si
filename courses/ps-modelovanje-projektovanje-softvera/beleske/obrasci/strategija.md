# Strategy (Strategija)

Vrsta: ponašanja, nad objektima. Izvor: vežbe zadatak 4 (i diskusije zadataka 7 i 12); K1 2024/25 z2, K1 2025/26 z2.

## Namena

Familija zamenljivih algoritama iza zajedničkog interfejsa; klijent (kontekst) bira koji se koristi, i može ga menjati u toku rada.

## Problem koji rešava

Metoda sa `if`/`else` ili `switch` po "režimu rada" (`aggressive`, `showFirst`, `role == ADMIN`) postaje nepregledna, a svaki novi režim dodaje novu granu i menja postojeći kôd. Strategija izdvaja svaku granu u klasu.

## Struktura

Uloge na vežbama (slajd "Zadatak 4 – saradnja"): **Kontekst**, **Strategija**, **Konkretna strategija**. Isto kao GoF (Context, Strategy, ConcreteStrategy).

```
Chatbot (kontekst) --drži--> QuestionChooser (strategija) {getQuestion(len)}
                                 ^                ^
                  FirstQuestionChooser     RandomQuestionChooser
```

Kontekst dobija strategiju kroz konstruktor i/ili `setQuestionChooser(...)`; deo posla delegira (`questionChooser.getQuestion(questions.size())`).

## Kada se koristi

- Više srodnih klasa/ponašanja se razlikuje samo u algoritmu.
- Algoritam treba da se bira ili menja u toku rada, ili će se uvoditi novi ("predviđa se osmišljavanje novih načina igre").
- U kodu postoji uslovna logika po tipu ponašanja.
- U tekstu zadatka: "način se može konfigurisati za svaki X različito", "logika izbora se može menjati".

## Primer (vežbe, zadatak 4, svojim rečima)

```java
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

interface QuestionChooser { int pick(int size); }

class FirstChooser implements QuestionChooser {
    public int pick(int size) { return 0; }
}

class RandomChooser implements QuestionChooser {
    private final Random random = new Random();
    public int pick(int size) { return random.nextInt(size); }
}

class Chatbot {
    private final List<String> questions = new ArrayList<>(List.of("2+2?", "3*3?", "9/3?"));
    private QuestionChooser chooser;
    Chatbot(QuestionChooser chooser) { this.chooser = chooser; }
    void setChooser(QuestionChooser c) { this.chooser = c; }
    void displayQuestions() {
        while (!questions.isEmpty()) {
            int i = chooser.pick(questions.size());
            System.out.println(questions.remove(i));
        }
    }
}

public class Main {
    public static void main(String[] args) {
        new Chatbot(new FirstChooser()).displayQuestions();
        Chatbot bot = new Chatbot(new RandomChooser());
        bot.displayQuestions();
    }
}
```

Napomena sa vežbi: u originalu je lista pitanja prazna posle prvog poziva `displayQuestions` jer se pitanja brišu, pa isti `Chatbot` ne može da se pokaže dvaput.

## Sa čim se meša

- **State**: struktura gotovo ista. Razlika: u State-u se stanje menja samo (objekat prelazi iz stanja u stanje po događajima), a u Strategy-u klijent bira algoritam. State nije u materijalu za K1 (nepotvrđeno da ulazi).
- **Template Method**: isti cilj (varira korak algoritma), ali nasleđivanjem. Strategy je kompozicija i može da se menja u hodu.
- **Command**: Command enkapsulira zahtev sa primaocem i parametrima (može se čuvati, stavljati u red, poništiti), Strategy enkapsulira algoritam.
- **Policy / politika** u K1 2025/26: politika pristupa (korisnička, direktorijumska) je Strategija koju drži zastupnik; ne treba je mešati sa samim zastupnikom.

## Slajdovi predavanja (PS_full_2026.pdf, str. 28–38)

- Motivacija (str. 29–31): prelom teksta u redove (`Composition`/`Compositor` sa `SimpleCompositor`, `TeXCompositor`, `ArrayCompositor`); generatori slučajnih brojeva za TSS (`RndGenerator`, `UniformGenerator`, `NormalGenerator`).
- Namena (str. 32): familija algoritama, enkapsulirani i zamenjivi. **Drugi naziv: Politika (Policy)**. Primenljivost: klase se razlikuju samo po ponašanju; varijante istog zadatka (vreme/memorija); algoritam koristi podatke koji klijentu ne trebaju; klasa ima uslovno grananje (strategija izdvaja grane u potklase).
- Struktura (str. 33–34): `Context` (drži `strategy`), `Strategy` (`algorithm()`), `ConcreteStrategyA/B/C`. Konfiguracija spolja (injekcija zavisnosti).
- Implementacija (str. 37): dve varijante prenosa podataka: kontekst šalje sve kao parametre, ili šalje referencu na sebe (`this`) pa strategija zove njegov interfejs; strategija može biti opciona (podrazumevano ponašanje).
- Posledice (str. 38): eliminiše uslovna grananja; alternativa izvođenju klasa konteksta; više objekata, ali se stateless strategije mogu deliti (Flyweight).
- Str. 83: poređenje sa Dekoraterom ("utroba" vs "koža"), vidi `dekorater.md`.

**Razlika u notaciji (slajdovi / vežbe):** isti nazivi (Context/Strategy/ConcreteStrategy = Kontekst/Strategija/Konkretna strategija). Slajdovi dodaju naziv "Politika (Policy)", što direktno objašnjava zašto se u K1 2025/26 z2 "politike pristupa" rešavaju Strategijom.

## Pojavljivalo se na K1

- K1 2024/25 z2 (poker): `Player` ima `aggressive` zastavicu i `if/else` u `update()` (strategija klađenja), a `Croupier.defineWinner()` ima komentar da treba više taktika određivanja pobednika (druga strategija). Dakle dve strategije u istom zadatku. Uz Unikat i Posmatrač (tekst zadatka ne imenuje uzorke).
- K1 2025/26 z2 (repozitorijum fajlova): politika pristupa (korisnika / direktorijuma) se bira jedna u datom trenutku, nove se dodaju kasnije. Početni `Policy.java` je pseudokod sa `if`ovima. Strategija za politike + Proxy oko repozitorijuma (moje tumačenje, zvanično rešenje nije dostupno).
- Vežbe: zadatak 4, diskusije zadataka 7 (galerija kao strategija pravljenja tekstura) i 12 (logika kupovine/prodaje).
