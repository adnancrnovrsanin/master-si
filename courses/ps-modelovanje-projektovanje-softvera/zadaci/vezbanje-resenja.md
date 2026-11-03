# K1 vežbanje: rešenja

Svako rešenje je kompajlirano (Java 26, `--release 17`) i pokrenuto; izlaz ispod je stvaran izlaz programa. U kolokvijumu svaka klasa ide u svoj fajl (ovde su klase u jednom fajlu radi preglednosti, bez `public` osim `Main`). Rešenja su moja i nisu zvanična; to su jedna od mogućih raspodela uloga. Ako imaš drugačije rešenje, proveri da li je uzorak ispravan (uloge, ko koga drži, transparentnost), a ne da li se poklapa sa ovim.

Zadatke prvo pokušaj sam (`vezbanje.md`).

---

## Zadatak 1: Dekorater (senzor)

```text
z1.txt
Komponenta (Component): SensorStream
Subjekat (ConcreteComponent): RawSensor, osnovni tok sa originalnim merenjima
Dopuna (Decorator): SensorDecorator, apstraktna klasa koja je SensorStream i drži SensorStream
Konkretna dopuna (ConcreteDecorator): Offset, MovingAverage, Clamp
Klijent koristi samo SensorStream, pa ne zna da li je tok dekorisan.
```

Na vežbi 2 su isti nazivi (Komponenta, Subjekat, Dopuna, Konkretna dopuna). Svaka dekorisana operacija radi nad **kopijom** niza (`RawSensor.getReadings()` vraća `data.clone()`), pa početni niz nikad nije izmenjen: bez toga bi se dva uzastopna poziva razlikovala. Isto važi za K1 2024/25 gde je `Pixel` promenljiv: pravi nove `Pixel` objekte.

```java
import java.util.Random;

// Zadatak 1: Decorator nad tokom merenja senzora
interface SensorStream {
    double[] getReadings();
}

class RawSensor implements SensorStream {
    private final double[] data;

    RawSensor(double[] data) {
        this.data = data;
    }

    @Override
    public double[] getReadings() {
        return data.clone();
    }
}

abstract class SensorDecorator implements SensorStream {
    protected final SensorStream inner;

    protected SensorDecorator(SensorStream inner) {
        this.inner = inner;
    }
}

class Offset extends SensorDecorator {
    private final double delta;

    Offset(SensorStream inner, double delta) {
        super(inner);
        this.delta = delta;
    }

    @Override
    public double[] getReadings() {
        double[] r = inner.getReadings();
        for (int i = 0; i < r.length; i++) r[i] += delta;
        return r;
    }
}

class MovingAverage extends SensorDecorator {
    private final int window;

    MovingAverage(SensorStream inner, int window) {
        super(inner);
        this.window = window;
    }

    @Override
    public double[] getReadings() {
        double[] in = inner.getReadings();
        double[] out = new double[in.length];
        for (int i = 0; i < in.length; i++) {
            int from = Math.max(0, i - window + 1);
            double sum = 0;
            for (int j = from; j <= i; j++) sum += in[j];
            out[i] = sum / (i - from + 1);
        }
        return out;
    }
}

class Clamp extends SensorDecorator {
    private final double min, max;

    Clamp(SensorStream inner, double min, double max) {
        super(inner);
        this.min = min;
        this.max = max;
    }

    @Override
    public double[] getReadings() {
        double[] r = inner.getReadings();
        for (int i = 0; i < r.length; i++) r[i] = Math.max(min, Math.min(max, r[i]));
        return r;
    }
}

public class Main {
    public static void main(String[] args) {
        Random rnd = new Random(42);
        double[] raw = new double[8];
        for (int i = 0; i < raw.length; i++) raw[i] = Math.round(rnd.nextDouble() * 400) / 10.0; // 0..40
        SensorStream s = new Clamp(new MovingAverage(new Offset(new RawSensor(raw), -2.5), 3), 5.0, 30.0);
        System.out.println(java.util.Arrays.toString(raw));
        System.out.println(java.util.Arrays.toString(s.getReadings()));
        // bez dekoratora
        System.out.println(java.util.Arrays.toString(new RawSensor(raw).getReadings()));
    }
}
```

Izlaz:

```text
[29.1, 27.3, 12.3, 11.1, 26.6, 36.1, 14.8, 11.0]
[26.6, 25.700000000000003, 20.400000000000002, 14.4, 14.166666666666666, 22.100000000000005, 23.333333333333332, 18.133333333333336]
[29.1, 27.3, 12.3, 11.1, 26.6, 36.1, 14.8, 11.0]
```

---

## Zadatak 2: Sastav + Posmatrač (planiranje projekta)

```text
z1.txt
Sastav (Composite):
  Element: WorkItem
  List: SimpleTask
  Sklop: TaskGroup
  Klijent: kod koji koristi WorkItem (main)
Posmatrač (Observer):
  Konkretan subjekat: TaskGroup (u isto vreme Sklop; zasebna klasa Subjekat nije potrebna)
  Posmatrač: TaskObserver
  Konkretan posmatrač: ConsoleLogger
Konfiguracija je push: poruka se šalje kao parametar notify().
```

Poruke su kao u zadatku (uključujući mešanje `:` i `-` u tekstu). Obaveštenja se šalju samo iz grupe nad kojom je posmatrač prijavljen; promena u podgrupi `QA` ne stiže do posmatrača glavne grupe jer posmatrač nije prijavljen na `QA`. To je namerno pojednostavljenje (kao u K1P 2024/25 z1); ako zadatak traži propagaciju kroz stablo, grupa mora da prosleđuje događaje roditelju.

```java
import java.util.ArrayList;
import java.util.List;

// Zadatak 2: Composite + Observer
interface TaskObserver {
    void notify(String message);
}

abstract class WorkItem {
    protected final String name;

    protected WorkItem(String name) {
        this.name = name;
    }

    String getName() {
        return name;
    }

    abstract int getHours();

    abstract void print(String indent);
}

class SimpleTask extends WorkItem {
    private final int hours;
    private boolean done;

    SimpleTask(String name, int hours) {
        super(name);
        this.hours = hours;
    }

    boolean isDone() {
        return done;
    }

    void setDone(boolean done) {
        this.done = done;
    }

    @Override
    int getHours() {
        return hours;
    }

    @Override
    void print(String indent) {
        System.out.println(indent + name + (done ? " [done]" : ""));
    }
}

class TaskGroup extends WorkItem {
    private final List<WorkItem> children = new ArrayList<>();
    private final List<TaskObserver> observers = new ArrayList<>();

    TaskGroup(String name) {
        super(name);
    }

    void subscribe(TaskObserver o) {
        observers.add(o);
    }

    void unsubscribe(TaskObserver o) {
        observers.remove(o);
    }

    private void fire(String msg) {
        for (TaskObserver o : observers) o.notify(msg);
    }

    void add(WorkItem item) {
        children.add(item);
        fire("Task added: " + item.getName());
    }

    void remove(WorkItem item) {
        if (children.remove(item)) fire("Task removed - " + item.getName());
    }

    void markDone(SimpleTask t) {
        if (!children.contains(t)) return;
        t.setDone(true);
        fire("Task done - " + t.getName());
    }

    @Override
    int getHours() {
        int sum = 0;
        for (WorkItem c : children) sum += c.getHours();
        return sum;
    }

    @Override
    void print(String indent) {
        System.out.println(indent + name);
        for (WorkItem c : children) c.print(indent + "\t");
    }
}

class ConsoleLogger implements TaskObserver {
    @Override
    public void notify(String message) {
        System.out.println("LOG: " + message);
    }
}

public class Main {
    public static void main(String[] args) {
        TaskGroup sprint = new TaskGroup("Sprint 1");
        SimpleTask a = new SimpleTask("Design", 5);
        SimpleTask b = new SimpleTask("Code", 12);
        TaskGroup qa = new TaskGroup("QA");
        qa.add(new SimpleTask("Unit tests", 4));
        sprint.add(a);
        sprint.add(b);
        sprint.add(qa);
        ConsoleLogger logger = new ConsoleLogger();
        sprint.subscribe(logger);
        sprint.print("");
        SimpleTask c = new SimpleTask("Deploy", 2);
        sprint.add(c);
        sprint.remove(a);
        sprint.markDone(b);
        sprint.print("");
        System.out.println("Hours: " + sprint.getHours());
    }
}
```

Izlaz:

```text
Sprint 1
	Design
	Code
	QA
		Unit tests
LOG: Task added: Deploy
LOG: Task removed - Design
LOG: Task done - Code
Sprint 1
	Code [done]
	QA
		Unit tests
	Deploy
Hours: 18
```

---

## Zadatak 3: Zaštitni zastupnik + Strategija (novčanik)

```text
z2.txt
Zaštitni zastupnik (WalletProxy): implementira Wallet i pre svakog poziva proverava prava, a stvarnu operaciju prepušta RealWallet, koji se nije menjao. Subjekat: Wallet, Original: RealWallet.
Strategija (AccessPolicy, RolePolicy, LimitPolicy): politika pristupa je izdvojena iz zastupnika jer je u datom trenutku aktivna samo jedna, nove se dodaju kasnije i menjaju se u toku rada (setPolicy). Kontekst: WalletProxy.
```

Ovo je isti sklop kao K1 2025/26 z2 (zaštitni zastupnik + politike kao strategije, slajd str. 32 kaže da je Strategija = Politika). Klijentski kod i dalje drži `Wallet`.

```java
// Zadatak 3: zaštitni Proxy + Strategy (polise)
enum Role { OWNER, CLERK, GUEST }

class User {
    private final String name;
    private final Role role;

    User(String name, Role role) {
        this.name = name;
        this.role = role;
    }

    String getName() {
        return name;
    }

    Role getRole() {
        return role;
    }
}

interface Wallet {
    double getBalance(User user);

    void pay(User user, double amount);
}

// postojeća implementacija: ne menja se
class RealWallet implements Wallet {
    private double balance;

    RealWallet(double balance) {
        this.balance = balance;
    }

    @Override
    public double getBalance(User user) {
        return balance;
    }

    @Override
    public void pay(User user, double amount) {
        if (amount > balance) throw new IllegalStateException("Insufficient funds");
        balance -= amount;
    }
}

// Strategija
interface AccessPolicy {
    boolean canRead(User user);

    boolean canPay(User user, double amount);
}

class RolePolicy implements AccessPolicy {
    @Override
    public boolean canRead(User user) {
        return user.getRole() != Role.GUEST;
    }

    @Override
    public boolean canPay(User user, double amount) {
        return user.getRole() == Role.OWNER;
    }
}

class LimitPolicy implements AccessPolicy {
    private final double limit;

    LimitPolicy(double limit) {
        this.limit = limit;
    }

    @Override
    public boolean canRead(User user) {
        return true;
    }

    @Override
    public boolean canPay(User user, double amount) {
        return amount <= limit;
    }
}

// zaštitni zastupnik
class WalletProxy implements Wallet {
    private final Wallet real;
    private AccessPolicy policy;

    WalletProxy(Wallet real, AccessPolicy policy) {
        this.real = real;
        this.policy = policy;
    }

    void setPolicy(AccessPolicy policy) {
        this.policy = policy;
    }

    @Override
    public double getBalance(User user) {
        if (!policy.canRead(user)) throw new SecurityException(user.getName() + " cannot read");
        return real.getBalance(user);
    }

    @Override
    public void pay(User user, double amount) {
        if (!policy.canPay(user, amount)) throw new SecurityException(user.getName() + " cannot pay " + amount);
        real.pay(user, amount);
    }
}

public class Main {
    public static void main(String[] args) {
        User owner = new User("ana", Role.OWNER);
        User clerk = new User("bob", Role.CLERK);
        User guest = new User("gus", Role.GUEST);
        WalletProxy w = new WalletProxy(new RealWallet(1000), new RolePolicy());
        System.out.println(w.getBalance(clerk));
        w.pay(owner, 100);
        System.out.println(w.getBalance(owner));
        try { w.pay(clerk, 10); } catch (SecurityException e) { System.out.println("denied: " + e.getMessage()); }
        try { w.getBalance(guest); } catch (SecurityException e) { System.out.println("denied: " + e.getMessage()); }
        w.setPolicy(new LimitPolicy(50));
        w.pay(clerk, 50);
        try { w.pay(clerk, 51); } catch (SecurityException e) { System.out.println("denied: " + e.getMessage()); }
        System.out.println(w.getBalance(guest));
    }
}
```

Izlaz:

```text
1000.0
900.0
denied: bob cannot pay 10.0
denied: gus cannot read
denied: bob cannot pay 51.0
850.0
```

---

## Zadatak 4: Muva + Fabrički/Šablonski metod (šahovska tabla)

```text
z2.txt
Muva (PieceFactory, Piece): figure istog tipa se crtaju isto bez obzira na polje, pa se deli po jedan objekat figure po tipu (ClassicPiece/ModernPiece); polje (kolona, vrsta) je spoljašnje stanje i prosleđuje se pri draw().
Fabrički metod (create u PieceFactory) i Šablonski metod (get): get() zna kako se keš pregleda, a podklase ClassicPieceFactory i ModernPieceFactory odlučuju koju klasu figure prave.
Zamena fabrike u Board.reset(...) bira vrstu figura (klasične ili moderne) za celu tablu.
```

Ovo je isti sklop kao K1P 2024/25 z2 (Piano/Forte). Brojači `ClassicPiece.created` i `ModernPiece.created` su samo za proveru: 3 objekta umesto 11. Apstraktna fabrika u užem smislu bi postojala tek kad bi fabrika pravila više vrsta proizvoda (npr. i polja table); ovde je to jedan proizvod, pa je tačnije Fabrički metod.

```java
import java.util.ArrayList;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

// Zadatak 4: Muva + Fabrički metod + Šablonski metod
enum PieceType { PAWN, ROOK, QUEEN, KING }

abstract class Piece {                         // Muva
    private final PieceType type;

    protected Piece(PieceType type) {
        this.type = type;
    }

    PieceType getType() {
        return type;
    }

    // spoljašnje stanje (kolona, vrsta) dolazi kao parametar
    abstract void draw(int col, int row);
}

class ClassicPiece extends Piece {            // Konkretna muva
    static int created = 0;

    ClassicPiece(PieceType t) {
        super(t);
        created++;
    }

    @Override
    void draw(int col, int row) {
        System.out.println("classic " + getType() + " at " + col + "," + row);
    }
}

class ModernPiece extends Piece {              // Konkretna muva
    static int created = 0;

    ModernPiece(PieceType t) {
        super(t);
        created++;
    }

    @Override
    void draw(int col, int row) {
        System.out.println("modern " + getType() + " at " + col + "," + row);
    }
}

abstract class PieceFactory {                  // Fabrika muva
    private final Map<PieceType, Piece> pool = new EnumMap<>(PieceType.class);

    final Piece get(PieceType type) {          // šablonski metod koji poziva fabrički metod
        Piece p = pool.get(type);
        if (p == null) {
            p = create(type);
            pool.put(type, p);
        }
        return p;
    }

    protected abstract Piece create(PieceType type);   // fabrički metod
}

class ClassicPieceFactory extends PieceFactory {
    @Override
    protected Piece create(PieceType type) {
        return new ClassicPiece(type);
    }
}

class ModernPieceFactory extends PieceFactory {
    @Override
    protected Piece create(PieceType type) {
        return new ModernPiece(type);
    }
}

class Board {                                   // Klijent
    private static class Placed {
        final Piece piece;
        final int col, row;

        Placed(Piece piece, int col, int row) {
            this.piece = piece;
            this.col = col;
            this.row = row;
        }
    }

    private PieceFactory factory;
    private final List<Placed> pieces = new ArrayList<>();

    Board(PieceFactory factory) {
        this.factory = factory;
    }

    void add(PieceType type, int col, int row) {
        pieces.add(new Placed(factory.get(type), col, row));
    }

    void reset(PieceFactory newFactory) {
        pieces.clear();
        this.factory = newFactory;
    }

    void draw() {
        for (Placed p : pieces) p.piece.draw(p.col, p.row);
    }
}

public class Main {
    public static void main(String[] args) {
        Board b = new Board(new ClassicPieceFactory());
        for (int c = 0; c < 8; c++) b.add(PieceType.PAWN, c, 1);
        b.add(PieceType.ROOK, 0, 0);
        b.add(PieceType.ROOK, 7, 0);
        b.add(PieceType.KING, 4, 0);
        b.draw();
        System.out.println("created classic: " + ClassicPiece.created); // 3, a ne 11
        b.reset(new ModernPieceFactory());
        b.add(PieceType.QUEEN, 3, 0);
        b.add(PieceType.QUEEN, 3, 7);
        b.draw();
        System.out.println("created modern: " + ModernPiece.created);   // 1
    }
}
```

Izlaz:

```text
classic PAWN at 0,1
classic PAWN at 1,1
classic PAWN at 2,1
classic PAWN at 3,1
classic PAWN at 4,1
classic PAWN at 5,1
classic PAWN at 6,1
classic PAWN at 7,1
classic ROOK at 0,0
classic ROOK at 7,0
classic KING at 4,0
created classic: 3
modern QUEEN at 3,0
modern QUEEN at 3,7
created modern: 1
```

---

## Zadatak 5: Komanda + Sastav (pametna kuća)

```text
z2.txt
Komanda (Command): akcija je objekat; Button i VoiceAssistant (pokretači) ne znaju koja se akcija izvršava. Konkretne komande: LightsOn, LightsOff, SetThermostat. Primaoci: LightController, ThermostatController.
Sastav (MacroCommand): složena akcija sadrži listu komandi (i druge makrokomande), pa dugme i asistent isto rukuju pojedinačnom i složenom akcijom (Makrokomanda).
Unikat (LightController, ThermostatController): jedan kontroler uređaja; bio je u početnom kodu.
```

Kao K1P 2025/26 z2. Ispravljen je i NPE iz početnog koda (`phrases.get(phrase)` za nepoznatu frazu). Stari `enum Action` i dupli `switch` nestaju; nova akcija znači novu klasu.

```java
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// Zadatak 5: Command + Composite (makrokomanda) + Singleton (primaoci)
class LightController {                          // Primalac (Unikat)
    private static LightController instance;

    private LightController() {}

    static LightController getInstance() {
        if (instance == null) instance = new LightController();
        return instance;
    }

    void on() { System.out.println("Lights ON"); }
    void off() { System.out.println("Lights OFF"); }
}

class ThermostatController {                      // Primalac (Unikat)
    private static ThermostatController instance;

    private ThermostatController() {}

    static ThermostatController getInstance() {
        if (instance == null) instance = new ThermostatController();
        return instance;
    }

    void set(int celsius) { System.out.println("Thermostat set to " + celsius); }
}

abstract class Command {
    abstract void execute();
}

class LightsOn extends Command {
    void execute() { LightController.getInstance().on(); }
}

class LightsOff extends Command {
    void execute() { LightController.getInstance().off(); }
}

class SetThermostat extends Command {
    private final int celsius;

    SetThermostat(int celsius) { this.celsius = celsius; }

    void execute() { ThermostatController.getInstance().set(celsius); }
}

class MacroCommand extends Command {              // Sastav (Sklop)
    private final List<Command> commands = new ArrayList<>();

    MacroCommand add(Command c) {
        commands.add(c);
        return this;
    }

    void execute() {
        for (Command c : commands) c.execute();
    }
}

class Button {                                    // Pokretač
    private final String label;
    private Command command;

    Button(String label, Command command) {
        this.label = label;
        this.command = command;
    }

    void setCommand(Command command) { this.command = command; }

    void press() {
        System.out.println("[button " + label + "]");
        command.execute();
    }
}

class VoiceAssistant {                            // Pokretač
    private final Map<String, Command> phrases = new HashMap<>();

    void bind(String phrase, Command c) { phrases.put(phrase, c); }

    void hear(String phrase) {
        Command c = phrases.get(phrase);
        if (c == null) {
            System.out.println("Unknown phrase: " + phrase);
            return;
        }
        System.out.println("[voice \"" + phrase + "\"]");
        c.execute();
    }
}

public class Main {
    public static void main(String[] args) {
        Command movie = new MacroCommand().add(new LightsOff()).add(new SetThermostat(22));
        Command goodNight = new MacroCommand().add(movie).add(new SetThermostat(18));
        Button b = new Button("Movie", movie);
        b.press();
        VoiceAssistant v = new VoiceAssistant();
        v.bind("good night", goodNight);
        v.bind("lights on", new LightsOn());
        v.hear("good night");
        v.hear("lights on");
        v.hear("dance");
    }
}
```

Izlaz:

```text
[button Movie]
Lights OFF
Thermostat set to 22
[voice "good night"]
Lights OFF
Thermostat set to 22
Thermostat set to 18
[voice "lights on"]
Lights ON
Unknown phrase: dance
```

---

## Zadatak 6: Unikat + Posmatrač + Strategija (aukcija)

```text
z2.txt
Unikat (Auctioneer): jedan aukcionar sa globalnom tačkom pristupa; ispravljen getInstance() koji je vraćao null.
Posmatrač (Auctioneer - PriceListener - Bidder): ponuđači se prijavljuju/odjavljuju i sinhrono se obaveštavaju o objavljenoj ceni (push).
Strategija (BiddingStrategy: AggressiveStrategy, CautiousStrategy): način nuđenja se konfiguriše po ponuđaču umesto zastavice aggressive.
Strategija (WinnerSelector: HighestOfferWins, LotteryAmongOffers): logika izbora pobednika se menja nezavisno od aukcionara.
```

Isti sklop kao K1 2024/25 z2 (poker). Ponuđači ne komuniciraju međusobno, pa Mediator nije potreban. `placeBid` je povratni poziv iz posmatrača ka subjektu (pull deo); `onPriceAnnounced` dobija cenu kao parametar (push). Izlaz treće runde zavisi od `Random(1)`, ali je za dati seed deterministički.

```java
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

// Zadatak 6: Unikat + Posmatrač + Strategija (x2)
interface BiddingStrategy {                       // Strategija
    double nextBid(double currentPrice, double budget);
}

class AggressiveStrategy implements BiddingStrategy {
    public double nextBid(double currentPrice, double budget) {
        return Math.min(currentPrice * 1.5, budget);
    }
}

class CautiousStrategy implements BiddingStrategy {
    public double nextBid(double currentPrice, double budget) {
        double bid = currentPrice * 1.1;
        return bid <= budget ? bid : 0;
    }
}

interface WinnerSelector {                        // Strategija
    Bidder select(List<Offer> offers);
}

class Offer {
    final Bidder bidder;
    final double amount;

    Offer(Bidder bidder, double amount) {
        this.bidder = bidder;
        this.amount = amount;
    }
}

class HighestOfferWins implements WinnerSelector {
    public Bidder select(List<Offer> offers) {
        Offer best = null;
        for (Offer o : offers) if (best == null || o.amount > best.amount) best = o;
        return best == null ? null : best.bidder;
    }
}

class LotteryAmongOffers implements WinnerSelector {
    private final Random rnd;

    LotteryAmongOffers(long seed) {
        rnd = new Random(seed);
    }

    public Bidder select(List<Offer> offers) {
        return offers.isEmpty() ? null : offers.get(rnd.nextInt(offers.size())).bidder;
    }
}

interface PriceListener {                         // Posmatrač
    void onPriceAnnounced(double price);
}

class Bidder implements PriceListener {           // Konkretan posmatrač + Kontekst strategije
    private final String name;
    private double budget;
    private BiddingStrategy strategy;

    Bidder(String name, double budget, BiddingStrategy strategy) {
        this.name = name;
        this.budget = budget;
        this.strategy = strategy;
    }

    String getName() { return name; }

    void setStrategy(BiddingStrategy s) { this.strategy = s; }

    public void onPriceAnnounced(double price) {
        double bid = strategy.nextBid(price, budget);
        if (bid > 0) Auctioneer.getInstance().placeBid(this, bid);
    }
}

class Auctioneer {                                // Konkretan subjekat + Unikat
    private static Auctioneer instance;

    private final List<PriceListener> listeners = new ArrayList<>();
    private final List<Offer> offers = new ArrayList<>();
    private WinnerSelector selector = new HighestOfferWins();
    private double price = 100;

    private Auctioneer() {}

    static Auctioneer getInstance() {
        if (instance == null) instance = new Auctioneer();
        return instance;
    }

    void register(PriceListener l) { listeners.add(l); }

    void unregister(PriceListener l) { listeners.remove(l); }

    void setSelector(WinnerSelector s) { this.selector = s; }

    void placeBid(Bidder b, double amount) { offers.add(new Offer(b, amount)); }

    Bidder runRound() {
        offers.clear();
        for (PriceListener l : new ArrayList<>(listeners)) l.onPriceAnnounced(price);
        Bidder w = selector.select(offers);
        if (w != null) price = offers.stream().filter(o -> o.bidder == w).findFirst().get().amount;
        return w;
    }
}

public class Main {
    public static void main(String[] args) {
        Auctioneer a = Auctioneer.getInstance();
        Bidder x = new Bidder("Aggro", 500, new AggressiveStrategy());
        Bidder y = new Bidder("Careful", 200, new CautiousStrategy());
        a.register(x);
        a.register(y);
        System.out.println(a.runRound().getName());   // Aggro
        a.unregister(x);
        System.out.println(a.runRound().getName());   // Careful
        a.register(x);
        a.setSelector(new LotteryAmongOffers(1));
        Bidder w = a.runRound();
        System.out.println(w == null ? "nobody" : w.getName());
        System.out.println(Auctioneer.getInstance() == a);
    }
}
```

Izlaz:

```text
Aggro
Careful
Aggro
true
```

---

## Zadatak 7: Šablonska metoda + Komanda + Unikat (operacije nad datotekama)

```text
z2.txt
Komanda (SecureCommand i konkretne DeleteFile, ReadFile): operacija je objekat sa jedinstvenim interfejsom execute().
Šablonska metoda (SecureCommand.execute): fiksira redosled "proveri prava, izvrši, zabeleži" i hvata sve greške na jednom mestu; podklase redefinišu requiredRole(), doExecute(), name(), a handleError() je kukica.
Unikat (Session): trenutni korisnik je dostupan sa jedne globalne tačke.
```

Ovo je (iz sećanja) zadatak 2 sa ispita feb 2026 i slajd str. 68 (`handle` = šablonska metoda, `execute` = kukica). Redosled `catch` blokova je bitan: `AccessDeniedException` je podklasa `RuntimeException`, pa mora prvi.

```java
import java.util.ArrayList;
import java.util.List;

// Zadatak 7: Šablonski metod + Komanda (provera prava, logovanje, obrada grešaka)
enum Role { ADMIN, USER, GUEST }

class AccessDeniedException extends RuntimeException {
    AccessDeniedException(String msg) { super(msg); }
}

class Session {                                  // Unikat
    private static Session instance;
    private Role currentRole = Role.GUEST;

    private Session() {}

    static Session getInstance() {
        if (instance == null) instance = new Session();
        return instance;
    }

    Role getCurrentRole() { return currentRole; }

    void login(Role r) { currentRole = r; }
}

class Log {
    static final List<String> entries = new ArrayList<>();

    static void write(String s) {
        entries.add(s);
        System.out.println("LOG: " + s);
    }
}

abstract class SecureCommand {                   // Apstraktna klasa + Komanda
    // šablonski metod
    public final void execute() {
        try {
            checkAccess();
            doExecute();
            Log.write(name() + " OK");
        } catch (AccessDeniedException e) {
            Log.write(name() + " DENIED: " + e.getMessage());
        } catch (RuntimeException e) {
            handleError(e);
        }
    }

    private void checkAccess() {
        Role r = Session.getInstance().getCurrentRole();
        if (r.ordinal() > requiredRole().ordinal())
            throw new AccessDeniedException(r + " < " + requiredRole());
    }

    protected void handleError(RuntimeException e) {       // zakačka sa podrazumevanim ponašanjem
        Log.write(name() + " FAILED: " + e.getMessage());
    }

    protected abstract Role requiredRole();               // koraci koje podklase redefinišu
    protected abstract void doExecute();
    protected abstract String name();
}

class DeleteFile extends SecureCommand {          // Konkretna komanda
    private final String path;

    DeleteFile(String path) { this.path = path; }

    protected Role requiredRole() { return Role.ADMIN; }

    protected void doExecute() {
        if (path.isEmpty()) throw new IllegalArgumentException("empty path");
        System.out.println("deleting " + path);
    }

    protected String name() { return "DeleteFile(" + path + ")"; }
}

class ReadFile extends SecureCommand {
    private final String path;

    ReadFile(String path) { this.path = path; }

    protected Role requiredRole() { return Role.USER; }

    protected void doExecute() { System.out.println("reading " + path); }

    protected String name() { return "ReadFile(" + path + ")"; }
}

public class Main {
    public static void main(String[] args) {
        SecureCommand del = new DeleteFile("a.txt");
        SecureCommand read = new ReadFile("a.txt");
        read.execute();                          // GUEST -> odbijeno
        Session.getInstance().login(Role.USER);
        read.execute();
        del.execute();                           // USER -> odbijeno
        Session.getInstance().login(Role.ADMIN);
        del.execute();
        new DeleteFile("").execute();            // greška sa nižeg nivoa, obrađena u šablonskom metodu
    }
}
```

Izlaz:

```text
LOG: ReadFile(a.txt) DENIED: GUEST < USER
reading a.txt
LOG: ReadFile(a.txt) OK
LOG: DeleteFile(a.txt) DENIED: USER < ADMIN
deleting a.txt
LOG: DeleteFile(a.txt) OK
LOG: DeleteFile() FAILED: empty path
```

---

## Zadatak 8: Adapter + Fasada + Unikat (SMS obaveštenja)

```text
z1.txt
Adapter: Klijent = ostatak sistema (koristi Notifier), Cilj = Notifier, Adapter = SmsNotifierAdapter, Adaptirani = SmsGateway.
Fasada: Fasada = SmsGateway, Podsistem = SmsModem, SmsEncoder (otvori, kodiraj i pošalji, zatvori sakriveno iza jedne operacije).
Unikat: SmsGateway (jedna tačka pristupa jedinom modemu).
```

Isti sklop kao zadatak 6 sa vežbi (HAL je Fasada + Unikat + Adaptirani). Adapter ovde prilagođava format poziva (`String` broj sa `+` u bajtove bez `+`).

```java
import java.nio.charset.StandardCharsets;

// Zadatak 8: Adapter + Fasada + Unikat
interface Notifier {                               // Cilj
    void send(String phone, String text);
}

// biblioteka koja se ne menja (podsistem)
class SmsModem {
    void open() { System.out.println("modem open"); }
    void close() { System.out.println("modem close"); }
    void sendRaw(byte[] number, byte[] payload) {
        System.out.println("raw sms to " + new String(number, StandardCharsets.US_ASCII)
                + ": " + new String(payload, StandardCharsets.UTF_8));
    }
}

class SmsEncoder {
    byte[] encode(String text) { return text.toUpperCase().getBytes(StandardCharsets.UTF_8); }
}

class SmsGateway {                                  // Fasada + Unikat
    private static SmsGateway instance;
    private final SmsModem modem = new SmsModem();
    private final SmsEncoder encoder = new SmsEncoder();

    private SmsGateway() {}

    static SmsGateway getInstance() {
        if (instance == null) instance = new SmsGateway();
        return instance;
    }

    void sendSms(byte[] number, String text) {
        modem.open();
        modem.sendRaw(number, encoder.encode(text));
        modem.close();
    }
}

class SmsNotifierAdapter implements Notifier {      // Adapter
    private final SmsGateway gateway = SmsGateway.getInstance();

    public void send(String phone, String text) {
        gateway.sendSms(phone.replace("+", "").getBytes(StandardCharsets.US_ASCII), text);
    }
}

public class Main {
    public static void main(String[] args) {
        Notifier n = new SmsNotifierAdapter();
        n.send("+38160123456", "hello");
    }
}
```

Izlaz:

```text
modem open
raw sms to 38160123456: HELLO
modem close
```

---

## Zadatak 9: Podsetnik + Komanda + Unikat (crtanje)

```text
z2.txt
Podsetnik (Canvas = Subjekat, CanvasState = Podsetnik, History = Čuvar): snimak stanja table je kopija liste oblika, pa kasnije izmene ne menjaju sačuvano stanje; History ne zna ništa o sadržaju snimka.
Komanda (Command, SaveCommand, RestoreCommand, AddShapeCommand; Canvas je primalac): meni i dugmići pokreću akcije kroz execute(), nove akcije su nove klase.
Unikat (History): jedna istorija stanja sa globalnim pristupom.
```

Ograničenje istorije na tri se ostvaruje u Čuvaru. U primeru se prvo stanje (prazna tabla) odbacuje pa poslednje vraćanje ne menja ništa (`nothing to restore`). Diskusija sa vežbi (slajd 'Zadatak 11 - diskusija'): umesto celog stanja može se čuvati samo razlika.

```java
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.List;

// Zadatak 9: Podsetnik (Memento) + Komanda, ograničena istorija
class Canvas {                                      // Subjekat (Originator)
    private List<String> shapes = new ArrayList<>();

    void add(String shape) { shapes.add(shape); }

    List<String> getShapes() { return shapes; }

    CanvasState save() { return new CanvasState(shapes); }

    void restore(CanvasState s) { shapes = s.copyOfShapes(); }
}

class CanvasState {                                 // Podsetnik
    private final List<String> shapes;

    CanvasState(List<String> shapes) { this.shapes = new ArrayList<>(shapes); }

    List<String> copyOfShapes() { return new ArrayList<>(shapes); }
}

class History {                                     // Čuvar (Unikat)
    private static History instance;
    private static final int MAX = 3;
    private final Deque<CanvasState> states = new ArrayDeque<>();

    private History() {}

    static History getInstance() {
        if (instance == null) instance = new History();
        return instance;
    }

    void push(CanvasState s) {
        if (states.size() == MAX) states.removeFirst();   // najstarije se odbacuje
        states.addLast(s);
    }

    CanvasState pop() {
        return states.isEmpty() ? null : states.removeLast();
    }
}

abstract class Command { abstract void execute(); }

class SaveCommand extends Command {                  // Konkretna komanda
    private final Canvas canvas;
    SaveCommand(Canvas c) { canvas = c; }
    void execute() { History.getInstance().push(canvas.save()); }
}

class RestoreCommand extends Command {
    private final Canvas canvas;
    RestoreCommand(Canvas c) { canvas = c; }
    void execute() {
        CanvasState s = History.getInstance().pop();
        if (s != null) canvas.restore(s);
        else System.out.println("nothing to restore");
    }
}

class AddShapeCommand extends Command {
    private final Canvas canvas;
    private final String shape;
    AddShapeCommand(Canvas c, String shape) { canvas = c; this.shape = shape; }
    void execute() { canvas.add(shape); }
}

public class Main {
    public static void main(String[] args) {
        Canvas c = new Canvas();
        Command save = new SaveCommand(c), restore = new RestoreCommand(c);
        String[] names = {"circle", "square", "line", "star"};
        for (String n : names) {
            save.execute();
            new AddShapeCommand(c, n).execute();
        }
        System.out.println(c.getShapes());     // [circle, square, line, star]
        restore.execute();
        System.out.println(c.getShapes());     // [circle, square, line]
        restore.execute();
        System.out.println(c.getShapes());     // [circle, square]
        restore.execute();
        System.out.println(c.getShapes());     // [circle]
        restore.execute();                     // prvo stanje (prazno) je odbačeno zbog ograničenja 3
        System.out.println(c.getShapes());
    }
}
```

Izlaz:

```text
[circle, square, line, star]
[circle, square, line]
[circle, square]
[circle]
nothing to restore
[circle]
```

---

## Zadatak 10: Graditelj; Apstraktna fabrika pomoću Prototipa

```text
z1.txt
10a Graditelj: proizvod = HttpRequest, graditelj = HttpRequest.Builder; interfejsi UrlStep -> MethodStep -> OptionalStep nameću redosled obaveznih podataka; nema upravljača ni više graditelja (kao na vežbama, zadatak 14).
10b Apstraktna fabrika pomoću Prototipa: Apstraktni proizvod = Button, Checkbox; Konkretan prototip = LightButton, DarkButton, LightCheckbox, DarkCheckbox; fabrika/klijent prototipa = ThemeFactory koja kopira prototipove.
```

`HttpRequest.builder().method("GET")` se ne kompajlira (`UrlStep` nema `method`), provereno. Zadatak 10b je skraćena verzija zadatka 5 sa vežbi: jedna klasa `ThemeFactory` umesto apstraktne fabrike sa dve konkretne podklase; ako se traži striktna raspodela uloga, izdvoji `abstract class ThemeFactory` i dve konkretne klase koje drže prototipove, kao na vežbama.

```java
// Zadatak 10a: Graditelj sa uslovom da se prvo zadaju obavezni parametri (lanac interfejsa)
// Zadatak 10b: Apstraktna fabrika implementirana pomoću Prototipa
class HttpRequest {
    private final String url;
    private final String method;
    private final String body;
    private final int timeoutMs;

    private HttpRequest(Builder b) {
        this.url = b.url;
        this.method = b.method;
        this.body = b.body;
        this.timeoutMs = b.timeoutMs;
    }

    interface UrlStep { MethodStep url(String url); }
    interface MethodStep { OptionalStep method(String method); }
    interface OptionalStep {
        OptionalStep body(String body);
        OptionalStep timeoutMs(int ms);
        HttpRequest build();
    }

    static UrlStep builder() { return new Builder(); }

    private static class Builder implements UrlStep, MethodStep, OptionalStep {
        private String url, method, body = "";
        private int timeoutMs = 30000;

        public MethodStep url(String url) { this.url = url; return this; }
        public OptionalStep method(String method) { this.method = method; return this; }
        public OptionalStep body(String body) { this.body = body; return this; }
        public OptionalStep timeoutMs(int ms) { this.timeoutMs = ms; return this; }
        public HttpRequest build() { return new HttpRequest(this); }
    }

    @Override
    public String toString() { return method + " " + url + " body=" + body + " timeout=" + timeoutMs; }
}

// 10b
abstract class Button { abstract Button copy(); abstract String render(); }
abstract class Checkbox { abstract Checkbox copy(); abstract String render(); }

class LightButton extends Button {
    Button copy() { return new LightButton(); }
    String render() { return "[light button]"; }
}
class DarkButton extends Button {
    Button copy() { return new DarkButton(); }
    String render() { return "[dark button]"; }
}
class LightCheckbox extends Checkbox {
    Checkbox copy() { return new LightCheckbox(); }
    String render() { return "(light checkbox)"; }
}
class DarkCheckbox extends Checkbox {
    Checkbox copy() { return new DarkCheckbox(); }
    String render() { return "(dark checkbox)"; }
}

class ThemeFactory {                                  // jedna generička fabrika, familija zavisi od prototipova
    private final Button buttonProto;
    private final Checkbox checkboxProto;

    ThemeFactory(Button b, Checkbox c) {
        buttonProto = b;
        checkboxProto = c;
    }

    Button createButton() { return buttonProto.copy(); }
    Checkbox createCheckbox() { return checkboxProto.copy(); }
}

public class Main {
    public static void main(String[] args) {
        HttpRequest r = HttpRequest.builder().url("http://x.io/a").method("POST").body("{}").timeoutMs(500).build();
        System.out.println(r);
        System.out.println(HttpRequest.builder().url("http://x.io").method("GET").build());
        // HttpRequest.builder().method("GET");  // ne kompajlira se: UrlStep nema method()
        ThemeFactory light = new ThemeFactory(new LightButton(), new LightCheckbox());
        ThemeFactory dark = new ThemeFactory(new DarkButton(), new DarkCheckbox());
        for (ThemeFactory f : new ThemeFactory[]{light, dark})
            System.out.println(f.createButton().render() + " " + f.createCheckbox().render());
        System.out.println(light.createButton() != light.createButton());
    }
}
```

Izlaz:

```text
POST http://x.io/a body={} timeout=500
GET http://x.io body= timeout=30000
[light button] (light checkbox)
[dark button] (dark checkbox)
true
```

---

## Kratka pitanja: odgovori

1. **Tri** tipa učesnika: Klijent, Prototip (interfejs `clone()`), Konkretan prototip (probni testovi 2021, zadatak 9).
2. (a) Netačno kako je napisano: konstruktor mora biti nedostupan klijentima. Na vežbama je privatan, na slajdovima (str. 18) zaštićen da bi instanca mogla biti izvedene klase. (b) Netačno: statičke operacije nisu polimorfne i ne može se imati više specijalizovanih instanci (slajd str. 21). (c) Tačno (str. 17, 21). (d) Netačno: bez sinhronizacije (ili eager inicijalizacije, ili double-checked locking-a sa `volatile`) dve niti mogu da naprave dve instance.
3. Apstraktna klasa u šablonskoj metodi poziva primitivne operacije koje podklase (re)definišu ("holivudski princip", str. 45). Operacija kukica je operacija sa podrazumevanim (često praznim) ponašanjem koju podklasa sme, ali ne mora da redefiniše.
4. `Coffee` = Komponenta, `BlendCoffee` = Subjekat, `CoffeeAddition` = Dopuna, `MilkCoffeeAddition` = Konkretna dopuna.
5. Na vežbama u apstraktnoj klasi Elementa (`MagicniEfekat`, `Stvar`), sa praznim telom za listove, a pravi se samo u Sklopu (transparentnost nasuprot bezbednosti). Alternativa: deklarisati ih samo u Sklopu. Stablo je m-arno, ne binarno (wiki K1 2023).
6. Fabrička metoda: kreacioni, klasni. Prototip: kreacioni, objektni. Dekorater: strukturni, objektni. Šablonska metoda: ponašanja, klasni. Posmatrač: ponašanja, objektni (slajdovi, "Namena" svakog uzorka).
7. Push: subjekat šalje podatke o promeni kao parametre `update`. Pull: `update()` bez podataka, posmatrač pita subjekat za stanje (opštije, manje spregnuto, može biti manje efikasno; str. 91). Na vežbama, zadatak 12, je **push** (`update(Stock, double delta)`).
8. (a) Zastupnik (virtuelni). (b) Komanda (undo uz Podsetnik). (c) Apstraktna fabrika. (d) Graditelj. (e) Adapter.
9. (1) Namena: Dekorater dodaje ponašanje, Zastupnik kontroliše pristup (pravljenje, prava, daljina). (2) Original: Dekorater ga dobija spolja i slaže se u proizvoljan broj slojeva (ista odgovornost više puta); Zastupnik obično sam pravi i uništava original i obično je jedan sloj. (3) Dekorater je za klijenta "isti objekat sa više mogućnosti", Zastupnik "isti objekat na drugom mestu / kad zatreba". Oba čuvaju interfejs (za razliku od Adaptera).
10. Apstraktna fabrika ima po jednu metodu za svaku vrstu proizvoda porodice; Fabrička metoda ima jednu metodu za jedan proizvod. Nova porodica u Apstraktnoj fabrici: samo nova konkretna fabrika (+ proizvodi), bez menjanja postojećih. Nova vrsta proizvoda: menja se apstraktna fabrika i sve konkretne (slabost). Kod Fabričke metode nova vrsta proizvoda = nova podklasa kreatora + nov konkretan proizvod.
