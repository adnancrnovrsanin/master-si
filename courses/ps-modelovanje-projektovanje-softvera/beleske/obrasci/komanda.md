# Command (Komanda)

Vrsta: ponašanja, objektni. Izvor: slajdovi str. 61–68; vežbe zadaci 10 i 11; K1P 2025/26 z2; ispit feb 2026 (iz sećanja).

## Namena

Zahtev (poziv operacije nad nekim objektom) postaje objekat. Time klijent može da se parametrizuje zahtevima, da ih stavlja u red, loguje, odlaže, poništava i grupiše. Drugi nazivi: **Akcija (Action)**, **Transakcija (Transaction)** (slajd str. 64).

## Problem koji rešava

Onaj ko pokreće akciju (dugme, stavka menija, prečica) ne sme da zna ko i kako je izvršava. Bez Komande svaki pokretač ima `switch` po vrsti akcije (kao `Button.executeAction()` i `ShortcutManager.onShortcutActivated()` u K1P 2025/26 z2, gde je isti `switch` napisan dvaput).

## Struktura

Slajdovi (str. 65): **Invoker** (`MenuItem`), **Command** (`execute()`), **ConcreteCommand** (`PasteCmd`, `MacroCmd`; drži `rec` i stanje), **Receiver** (`Document`; `action()`), **Client** (Application; pravi komandu i povezuje je sa primaocem).

Vežbe (slajdovi "Zadatak 10/11 – saradnja"): **Pokretač** (= Invoker; `Button`, `MagicnaPecurka`), **Komanda**, **Konkretna komanda** (`SaveCommand`, `UndoCommand`; `DodavanjeZivota`...), **Primalac** (= Receiver; `Panel`, `Carobnjak`). Klijent nije prikazan.

```
Pokretač (Button) --drži--> Komanda {execute()}
                              ^                ^
                       SaveCommand      UndoCommand        ---poziva--> Primalac (Panel)
                       MacroCommand ---drži 0..*---> Komanda      (makrokomanda = + Sastav)
```

## Kada se koristi (str. 64)

- Parametrizacija objekata akcijama (OO alternativa za callback).
- Odloženo/asinhrono izvršavanje, redovi čekanja, prenos u drugi adresni prostor.
- Logovanje izvršenih zahteva.
- **Undo/redo** i istorija (komanda čuva prethodno stanje ili radi inverznu operaciju; str. 66).
- **Makrokomande/transakcije** (str. 67: Composite DP).

## Primer (vežbe, zadatak 10 i 11, svojim rečima)

```java
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.List;

class Panel {                                          // primalac
    private String text = "";
    String getText() { return text; }
    void setText(String t) { text = t; }
}

abstract class Command { abstract void execute(); }

class AppendCommand extends Command {
    private final Panel panel; private final String s;
    AppendCommand(Panel p, String s) { this.panel = p; this.s = s; }
    void execute() { panel.setText(panel.getText() + s); }
}

class SaveCommand extends Command {                   // snima stanje (vidi Podsetnik)
    private final Panel panel; private final Deque<String> log;
    SaveCommand(Panel p, Deque<String> log) { this.panel = p; this.log = log; }
    void execute() { log.push(panel.getText()); }
}

class UndoCommand extends Command {
    private final Panel panel; private final Deque<String> log;
    UndoCommand(Panel p, Deque<String> log) { this.panel = p; this.log = log; }
    void execute() { if (!log.isEmpty()) panel.setText(log.pop()); }
}

class MacroCommand extends Command {                  // Komanda + Sastav
    private final List<Command> parts = new ArrayList<>();
    MacroCommand add(Command c) { parts.add(c); return this; }
    void execute() { for (Command c : parts) c.execute(); }
}

class Button {                                        // pokretač
    private Command command;
    void setCommand(Command c) { command = c; }
    void click() { command.execute(); }
}

public class Main {
    public static void main(String[] args) {
        Panel p = new Panel();
        Deque<String> log = new ArrayDeque<>();
        Button b = new Button();
        b.setCommand(new MacroCommand().add(new SaveCommand(p, log)).add(new AppendCommand(p, "ab")));
        b.click(); b.click();
        System.out.println(p.getText());              // abab
        b.setCommand(new UndoCommand(p, log));
        b.click();
        System.out.println(p.getText());              // ab
    }
}
```

## Komanda + Šablonski metod (str. 68)

Slajd predlaže da pokretanje komande bude šablonska metoda (`handle`) a `execute` kukica: u šablonskoj metodi se lokalizuju provera preduslova/postuslova, provera prava pristupa, transakcioni mehanizam, jedinstveno hvatanje izuzetaka i logovanje. Zadatak 2 sa ispita feb 2026 (iz sećanja) traži upravo to. Rešenje u kodu: `zadaci/vezbanje-resenja.md`, zadatak 7.

## Komanda + Podsetnik (zadatak 11)

Komanda `SaveCommand` pravi Podsetnik (`PanelState`) i stavlja ga u Čuvara (`PanelStateLog`), `UndoCommand` ga vraća. Vidi `podsetnik.md`.

## Sa čim se meša

- **Strategija**: strategija je algoritam, komanda je zahtev sa primaocem i parametrima, može da se čuva i poništava.
- **Podsetnik**: čuva stanje za vraćanje; komanda čuva *akciju*. Undo se često ostvaruje kombinacijom.
- **Posmatrač**: oba su "povratni pozivi", ali posmatrač reaguje na promenu stanja više primalaca, komanda je jedan zahtev.
- **Sastav**: makrokomanda.
- **Prototip**: komanda koja čuva stanje pravi se kopiranjem prototipa (str. 66).

## Pojavljivalo se na K1

- K1P 2025/26 (11.1.2026.) z2: akcije laboratorije (start/stop, otkaz linka, povratak linka, stanje mreže) pokreću se i dugmićima (`Button`) i prečicama (`ShortcutManager`) preko duplog `switch`; traže se i složene akcije. Dakle Komanda (pokretači `Button` i `ShortcutManager`, primaoci `LaboratoryNetworkManager` i `NetworkManager`, već Unikati) + Sastav (makrokomanda).
- Ispit feb 2026 (iz sećanja): Template Method + Command.
- Vežbe: zadaci 10 i 11.

## Razlika u notaciji (slajdovi / vežbe)

Slajdovi: Invoker, Command, ConcreteCommand, Receiver, Client. Vežbe: **Pokretač**, Komanda, Konkretna komanda, **Primalac** (Klijent nije nacrtan). U zadatku 10 je `MagicniEfekat` istovremeno Komanda i Element (Sastav).
