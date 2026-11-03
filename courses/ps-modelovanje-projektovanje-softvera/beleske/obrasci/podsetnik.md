# Memento (Podsetnik)

Vrsta: ponašanja, objektni (klasifikacija po GoF-u). Izvor: vežbe zadatak 11. Nema ga na slajdovima PS_full_2026.pdf.

## Namena

Bez narušavanja enkapsulacije, spolja zabeleži unutrašnje stanje objekta tako da se objekat kasnije može vratiti u to stanje.

## Problem koji rešava

Treba "sačuvaj stanje" / "vrati poslednje sačuvano stanje" (undo), a stanje objekta je privatno. Ako bi `Panel` izlagao sva polja, narušila bi se enkapsulacija; ako stanje čuva spoljašnji kod, vezan je za implementaciju.

## Struktura

Uloge na vežbama (slajd "Zadatak 11 – saradnja"): **Subjekat** (`Panel`; GoF Originator), **Podsetnik** (`PanelState`; Memento), **Čuvar** (`PanelStateLog`; Caretaker). `Panel` i `PanelStateLog` su i **Unikati**, a pokretanje čuvanja i vraćanja su **Komande** (`SaveCommand`, `UndoCommand`, pokretač `Button`, primalac `Panel`).

```
Subjekat (Panel): getText()/setText()          <- stanje čijih kopija ima smisla
Podsetnik (PanelState): text                   <- snimak stanja (nepromenljiv)
Čuvar (PanelStateLog): Stack<PanelState> push(), pop()     <- čuva podsetnike, ne zna šta su
SaveCommand.execute():  log.push(new PanelState(panel.getText()))
UndoCommand.execute():  panel.setText(log.pop().getText())
```

Pravi GoF oblik: Originator sam pravi memento (`createMemento()`) i sam se vraća (`restore(m)`), a Caretaker ne sme da čita unutrašnjost. Na vežbama komande čitaju `getText()` iz `PanelState`, što je pojednostavljenje.

## Kada se koristi

- Treba vratiti prethodno stanje (undo, rollback, "checkpoint").
- Direktan pristup stanju bi razotkrio implementaciju.

## Primer (vežbe, zadatak 11, bliži GoF-u)

```java
import java.util.ArrayDeque;
import java.util.Deque;

class Panel {                                     // Subjekat
    private String text = "";
    void setText(String t) { text = t; }
    String getText() { return text; }

    PanelState save() { return new PanelState(text); }
    void restore(PanelState s) { text = s.text; }

    static class PanelState {                     // Podsetnik: vidljiv samo unutar Panela
        private final String text;
        private PanelState(String text) { this.text = text; }
    }
}

class PanelStateLog {                             // Čuvar
    private final Deque<Panel.PanelState> states = new ArrayDeque<>();
    void push(Panel.PanelState s) { states.push(s); }
    Panel.PanelState pop() { return states.pop(); }
    boolean isEmpty() { return states.isEmpty(); }
}

public class Main {
    public static void main(String[] args) {
        Panel p = new Panel();
        PanelStateLog log = new PanelStateLog();
        p.setText("one");
        log.push(p.save());
        p.setText("two");
        log.push(p.save());
        p.setText("three");
        p.restore(log.pop());
        System.out.println(p.getText());           // two
        p.restore(log.pop());
        System.out.println(p.getText());           // one
    }
}
```

## Diskusija sa vežbi (slajd "Zadatak 11 – diskusija")

- Čuvaju se samo eksplicitno sačuvana stanja. Za varijantu u kojoj se pamte sve izvršene komande: komande čuvaju istoriju i svaka ima `undo()` (Komanda).
- Efikasniji Podsetnik: ne čuvati kompletno stanje nego samo razliku (delta).

## Sa čim se meša

- **Komanda**: komanda poništava akciju (inverzna operacija ili snimak), Podsetnik samo čuva snimak. Često idu zajedno (vežbe).
- **Prototip**: Prototip pravi nov, nezavisan objekat; Podsetnik je snimak stanja vezan za originala.
- **Posmatrač**: ne.

## Pojavljivalo se na K1

Nije bio eksplicitno tražen ni na jednom K1 u materijalu. Vežbe: zadatak 11 (Komanda + Podsetnik + Unikat).

## Razlika u notaciji (slajdovi / vežbe)

Nema slajdova. Nazivi uloga: Subjekat, Podsetnik, Čuvar (na GoF-u: Originator, Memento, Caretaker). Pazi: "Subjekat" na vežbama znači Originator (ovde) ali i Component/RealSubject u drugim uzorcima.
