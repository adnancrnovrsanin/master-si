# K1 vežbanje: zadaci po uzoru na stare kolokvijume

Rešenja su u `vezbanje-resenja.md` (nemoj da ih otvaraš pre nego što pokušaš). Zadaci su napisani kao na K1 2024/25 i 2025/26: `[10]` poena, Java, početni kod (ako ga ima, može da sadrži greške), `z1.txt` / `z2.txt` sa ulogama i obrazloženjima. Zadaci 1, 2, 8 i 10 su "zadatak 1" tipa (uzorak je imenovan), zadaci 3–7 i 9 su "zadatak 2" tipa (uzorak prepoznaješ sam, navodiš **sve** primene). Za vežbu K1 koji traje 90 min: dva zadatka sa liste u jednom sedenju, bez Interneta, sa slajdovima i vežbama pri ruci.

Svaki zadatak: napiši kod u zasebnim fajlovima, kompajliraj ga sa `javac`, napiši traženi tekst.

---

## Zadatak 1 [10] (uzorak je imenovan)

Posmatra se sistem za obradu merenja senzora. Merenja su niz realnih brojeva. Treba omogućiti da se na tok merenja primeni proizvoljan broj korekcija (ili nijedna), u proizvoljnom redosledu, pri čemu ostatak sistema ne treba da vidi razliku u odnosu na to da li su korekcije primenjene ili nisu. Korekcije koje trenutno postoje (kasnije mogu biti dodate nove):

- Offset: svako merenje se uvećava za zadatu konstantu (može biti negativna).
- MovingAverage: svako merenje se zamenjuje prosekom poslednjih `k` merenja zaključno sa tekućim (za početna merenja, gde ih nema `k`, prosek svih dostupnih).
- Clamp: merenja se ograničavaju na opseg `[min, max]`.

Klijent može da dohvati merenja; ako su primenjene korekcije, vraćaju se izmenjena merenja, a **početni niz merenja se ne menja**.

Koristeći projektni uzorak **Dekorater** implementirati opisani deo sistema i navesti raspodelu uloga iz uzorka klasama u rešenju (`z1.txt`). Napisati primer upotrebe: napraviti tok sa nasumičnim merenjima i korekcijama Offset, MovingAverage i Clamp (tim redom), pa ispisati merenja pre i posle.

Interfejs toka je dat:

```java
interface SensorStream {
    double[] getReadings();
}
```

---

## Zadatak 2 [10] (uzorci su imenovani)

Posmatra se deo sistema za planiranje projekata. Stavka posla ima ime, procenu trajanja u satima i može da se ispiše. **Zadatak** je stavka koja je uvek list, ima ime i broj sati, može biti označen kao završen; pri ispisu se ispisuje njegovo ime (dopisano `[done]` ako je završen). **Grupa zadataka** je stavka koja može da ima decu (zadatke ili druge grupe); njen broj sati je zbir sati dece; pri ispisu grupe ispisuje se njeno ime, a zatim u sukcesivnim redovima njena deca sa dodatnim tabom uvlačenja.

Moguće je prijavljivanje na praćenje promena u grupi. Svaki put kada se desi promena, svim prijavljenima se šalje poruka u obliku teksta za sledeće situacije:

- dodat je zadatak (ili grupa): `Task added: {name}`
- uklonjen je zadatak (ili grupa): `Task removed - {name}`
- zadatak je označen kao završen preko grupe: `Task done - {name}`

U sistemu za sada postoji jedan tip posmatrača (kasnije mogu biti dodati novi) - `ConsoleLogger`, koji svaku poruku ispisuje na standardni izlaz sa prefiksom `LOG: `.

Koristeći kombinaciju uzoraka **Sastav (Composite)** i **Posmatrač (Observer)** implementirati opisani deo sistema i navesti raspodelu uloga u `z1.txt`.

Napisati primer upotrebe: napraviti grupu `Sprint 1` sa dva zadatka i podgrupom `QA` koja ima jedan zadatak. Prijaviti jedan `ConsoleLogger` na praćenje glavne grupe. Ispisati grupu, zatim dodati novi zadatak i ukloniti neki od početna dva, označiti jedan preostali zadatak kao završen preko grupe, i ponovo ispisati grupu.

---

## Zadatak 3 [10] (prepoznati uzorke)

Posmatra se deo sistema za upravljanje novčanikom. Sistem koristi interfejs novčanika preko kog se čita stanje i obavljaju plaćanja; korisnik je identifikovan imenom i ulogom (`OWNER`, `CLERK`, `GUEST`). U prilogu je dat deo implementacije koji treba dorađivati tako da se uvedu prava pristupa. Politike kojima se određuju prava mogu biti:

- Politika uloga: stanje mogu da čitaju svi osim gostiju; plaćanja može da obavlja samo vlasnik.
- Politika limita: svako može da čita stanje, plaćanje je dozvoljeno ako je iznos najviše jednak zadatom limitu.

U datom trenutku primenjuje se samo jedna politika, a očekuje se da će se u budućnosti dodavati nove vrste politika. Politika se može zameniti u toku rada sistema.

Dorađivati dati sistem **bez menjanja postojeće implementacije novčanika** koristeći odgovarajuće projektne uzorke. Navesti sve primene projektnih uzoraka u sistemu sa kratkim obrazloženjem u `z2.txt` (jedna do dve rečenice).

```java
enum Role { OWNER, CLERK, GUEST }

class User {
    private final String name;
    private final Role role;
    User(String name, Role role) { this.name = name; this.role = role; }
    String getName() { return name; }
    Role getRole() { return role; }
}

interface Wallet {
    double getBalance(User user);
    void pay(User user, double amount);
}

class RealWallet implements Wallet {
    private double balance;
    RealWallet(double balance) { this.balance = balance; }
    public double getBalance(User user) { return balance; }
    public void pay(User user, double amount) {
        if (amount > balance) throw new IllegalStateException("Insufficient funds");
        balance -= amount;
    }
}
```

---

## Zadatak 4 [10] (prepoznati uzorke)

Posmatra se deo implementacije šahovske table za uređaj sa malim memorijskim kapacitetom. Figura može biti pešak, top, kraljica ili kralj. Figure istog tipa se uvek crtaju na isti način, bez obzira na to na kom se polju nalaze. Tabla se parametrizuje tako da koristi ili klasične ili moderne figure (klasične su manje i svetlije, moderne veće i tamnije), nakon čega se figure dodaju jedna po jedna, pri čemu se pri svakom dodavanju zadaje tip figure i polje (kolona, vrsta). Na uređaju se u svakom trenutku prikazuje samo jedna tabla, i obično na njoj ima mnogo figura. Tabla može da se resetuje, pri čemu se brišu sve figure koje su se nalazile na njoj, i tada može da se promeni parametrizacija (vrsta figura).

Dorađivati dati početni kod koristeći odgovarajuće projektne uzorke i navesti sve primene uzoraka u `z2.txt` (jedna do dve rečenice). Napisati kratak primer: tabla sa 8 pešaka i 3 ostale figure u klasičnoj postavci, ispisati koliko je objekata figura napravljeno, pa reset na moderne figure i dodavanje dve kraljice.

```java
enum PieceType { PAWN, ROOK, QUEEN, KING }

abstract class Piece {
    abstract void draw(int col, int row);
}

class ClassicPiece extends Piece {
    private final PieceType type;
    ClassicPiece(PieceType type) { this.type = type; }
    void draw(int col, int row) { System.out.println("classic " + type + " at " + col + "," + row); }
}

class ModernPiece extends Piece {
    private final PieceType type;
    ModernPiece(PieceType type) { this.type = type; }
    void draw(int col, int row) { System.out.println("modern " + type + " at " + col + "," + row); }
}

class Board {
    private static class Placed {
        final Piece piece; final int col, row;
        Placed(Piece piece, int col, int row) { this.piece = piece; this.col = col; this.row = row; }
    }
    private boolean modern;
    private final java.util.List<Placed> pieces = new java.util.ArrayList<>();

    Board(boolean modern) { this.modern = modern; }

    void add(PieceType type, int col, int row) {
        Piece p = modern ? new ModernPiece(type) : new ClassicPiece(type);
        pieces.add(new Placed(p, col, row));
    }
    void reset(boolean modern) { pieces.clear(); this.modern = modern; }
    void draw() { for (Placed p : pieces) p.piece.draw(p.col, p.row); }
}
```

---

## Zadatak 5 [10] (prepoznati uzorke)

Posmatra se sistem za upravljanje pametnom kućom. Korisnik pokreće akcije ili pritiskom na dugme na ekranu ili izgovaranjem fraze preko glasovnog asistenta. Akcije od interesa su: paljenje svetla, gašenje svetla, postavljanje termostata na 22 stepena i postavljanje termostata na 18 stepeni. Pored pojedinačnih akcija, sistem treba da podrži i složene akcije koje se sastoje od više drugih akcija izvršenih redom (na primer, scena "Film" gasi svetlo i postavlja termostat na 22; scena "Laku noć" izvršava scenu "Film", a zatim postavlja termostat na 18). Dugme i asistent treba da mogu da pokreću i pojedinačne i složene akcije, a nove akcije se dodaju bez menjanja dugmeta i asistenta.

Dorađivati i ispraviti dati početni kod koristeći odgovarajuće projektne uzorke. Navesti sve primene u `z2.txt`. Napisati primer: dugme za scenu "Film", fraza "good night" za scenu "Laku noć", fraza "lights on" za paljenje svetla i izgovorena nepoznata fraza.

```java
import java.util.List;
import java.util.Map;

class LightController {
    private static LightController instance;
    private LightController() {}
    static LightController getInstance() {
        if (instance == null) instance = new LightController();
        return instance;
    }
    void on() { System.out.println("Lights ON"); }
    void off() { System.out.println("Lights OFF"); }
}

class ThermostatController {
    private static ThermostatController instance;
    private ThermostatController() {}
    static ThermostatController getInstance() {
        if (instance == null) instance = new ThermostatController();
        return instance;
    }
    void set(int celsius) { System.out.println("Thermostat set to " + celsius); }
}

enum Action { LIGHTS_ON, LIGHTS_OFF, THERMOSTAT_22, THERMOSTAT_18 }

class Button {
    private final String label;
    private final List<Action> actions;
    Button(String label, List<Action> actions) { this.label = label; this.actions = actions; }
    void press() {
        System.out.println("[button " + label + "]");
        for (Action a : actions) {
            switch (a) {
                case LIGHTS_ON: LightController.getInstance().on(); break;
                case LIGHTS_OFF: LightController.getInstance().off(); break;
                case THERMOSTAT_22: ThermostatController.getInstance().set(22); break;
                case THERMOSTAT_18: ThermostatController.getInstance().set(18); break;
            }
        }
    }
}

class VoiceAssistant {
    private final Map<String, List<Action>> phrases;
    VoiceAssistant(Map<String, List<Action>> phrases) { this.phrases = phrases; }
    void hear(String phrase) {
        for (Action a : phrases.get(phrase)) {
            switch (a) {
                case LIGHTS_ON: LightController.getInstance().on(); break;
                case LIGHTS_OFF: LightController.getInstance().off(); break;
                case THERMOSTAT_22: ThermostatController.getInstance().set(22); break;
                case THERMOSTAT_18: ThermostatController.getInstance().set(18); break;
            }
        }
    }
}
```

---

## Zadatak 6 [10] (prepoznati uzorke)

Posmatra se sistem aukcije jedne stvari. Pre početka aukcije, ponuđači mogu da se prijave aukcionaru za učestvovanje i mogu da se odjave. Aukcija se odvija u rundama. U svakoj rundi aukcionar objavi trenutnu cenu svim prijavljenim ponuđačima (broj ponuđača je mali, pa je prihvatljiva sinhrona komunikacija), a oni koji žele daju ponudu aukcionaru. Ponuđači među sobom ne komuniciraju. Neki ponuđači su agresivni (nude 1.5 puta trenutnu cenu, najviše koliko imaju na raspolaganju), a neki oprezni (nude 1.1 puta cenu ako imaju toliko novca, a u suprotnom ne nude ništa); način nuđenja može da se konfiguriše za svakog ponuđača različito, a predviđa se osmišljavanje novih načina. Na kraju runde aukcionar bira pobednika runde i nova cena postaje njegova ponuda. Logika izbora pobednika se može menjati (najviša ponuda; ili nasumično među ponuđačima koji su dali ponudu).

Dorađivati i ispraviti dati početni kod koristeći odgovarajuće projektne uzorke. Navesti sve primene u `z2.txt` sa obrazloženjem (jedna do dve rečenice). Napisati primer: dva ponuđača različitih strategija, tri runde, jedna odjava i jedna promena logike izbora pobednika.

```java
import java.util.ArrayList;
import java.util.List;

class Bidder {
    private final String name;
    private double budget;
    private boolean aggressive = true;
    Bidder(String name, double budget, boolean aggressive) {
        this.name = name;
        this.budget = budget;
        this.aggressive = aggressive;
    }
    String getName() { return name; }
    // TODO: dobiti trenutnu cenu od aukcionara
    double bid() {
        double price = 0;
        if (aggressive) {
            return Math.min(price * 1.5, budget);
        } else {
            double b = price * 1.1;
            return b <= budget ? b : 0;
        }
    }
}

class Auctioneer {
    private static Auctioneer instance = null;
    private final List<Bidder> bidders = new ArrayList<>();
    private double price = 100;

    private Auctioneer() {}
    static Auctioneer getInstance() { return instance; }

    Bidder runRound() {
        // TODO: obavestiti ponuđače o ceni i izabrati pobednika (trenutno nasumično)
        return bidders.isEmpty() ? null : bidders.get(new java.util.Random().nextInt(bidders.size()));
    }
}
```

---

## Zadatak 7 [10] (prepoznati uzorke)

Posmatra se deo sistema za rad sa datotekama. Postoji nekoliko operacija nad datotekama (čitanje, brisanje), a sistem je zamišljen tako da svaka operacija može da se pokrene preko jedinstvenog interfejsa bez znanja o tome koja je operacija u pitanju. Korisnici imaju uloge `ADMIN`, `USER`, `GUEST`, a aktuelni korisnik sesije je dostupan sa jedne, globalne tačke. Svaka operacija zahteva određenu minimalnu ulogu (čitanje: `USER`, brisanje: `ADMIN`). Pre izvršavanja svake operacije potrebno je proveriti prava pristupa trenutnog korisnika i, ako ona nisu dovoljna, ne izvršavati operaciju. Posle izvršavanja svake operacije beleži se u log rezultat (uspeh, odbijeno, greška). Sve greške koje nastanu u konkretnoj operaciji moraju biti uhvaćene i obrađene na jednom mestu, bez dupliranja koda po operacijama. Dodavanje nove operacije treba da zahteva samo jednu novu klasu.

Dorađivati dati početni kod koristeći odgovarajuće projektne uzorke i navesti sve primene u `z2.txt`.

```java
enum Role { ADMIN, USER, GUEST }

class ReadFile {
    private final String path;
    ReadFile(String path) { this.path = path; }
    void run(Role current) {
        if (current.ordinal() > Role.USER.ordinal()) { System.out.println("denied"); return; }
        try {
            System.out.println("reading " + path);
            System.out.println("LOG: read ok");
        } catch (RuntimeException e) {
            System.out.println("LOG: read failed " + e.getMessage());
        }
    }
}

class DeleteFile {
    private final String path;
    DeleteFile(String path) { this.path = path; }
    void run(Role current) {
        if (current.ordinal() > Role.ADMIN.ordinal()) { System.out.println("denied"); return; }
        try {
            if (path.isEmpty()) throw new IllegalArgumentException("empty path");
            System.out.println("deleting " + path);
            System.out.println("LOG: delete ok");
        } catch (RuntimeException e) {
            System.out.println("LOG: delete failed " + e.getMessage());
        }
    }
}
```

---

## Zadatak 8 [10] (uzorci su imenovani)

Posmatra se sistem za slanje obaveštenja. Ostatak sistema koristi interfejs `Notifier` sa metodom `send(String phone, String text)`. Za slanje SMS poruka koristi se gotova biblioteka (data klasa `SmsModem` i pomoćna `SmsEncoder`) koja se ne sme menjati. Da bi se poruka poslala, modem se mora otvoriti, poruka poslati sirovim bajtovima (broj bez znaka `+`, kodiran tekst), pa se modem mora zatvoriti. Klijentski kod ne sme da zna za ove korake ni za format biblioteke. Pošto se u sistemu koristi samo jedan modem, treba obezbediti da postoji tačno jedna tačka pristupa njemu.

Koristeći projektne uzorke **Adapter**, **Fasada** i **Unikat** implementirati sistem i navesti raspodelu uloga (`z1.txt`). Napisati primer slanja poruke.

```java
interface Notifier {
    void send(String phone, String text);
}

class SmsModem {
    void open() { System.out.println("modem open"); }
    void close() { System.out.println("modem close"); }
    void sendRaw(byte[] number, byte[] payload) {
        System.out.println("raw sms to " + new String(number, java.nio.charset.StandardCharsets.US_ASCII)
                + ": " + new String(payload, java.nio.charset.StandardCharsets.UTF_8));
    }
}

class SmsEncoder {
    byte[] encode(String text) { return text.toUpperCase().getBytes(java.nio.charset.StandardCharsets.UTF_8); }
}
```

---

## Zadatak 9 [10] (prepoznati uzorke)

Posmatra se deo sistema za crtanje. Tabla (`Canvas`) sadrži listu oblika (nazivi), a oblici se dodaju jedan po jedan. U svakom trenutku korisnik izborom odgovarajuće stavke u meniju može da sačuva stanje table (lista oblika), a izborom druge stavke da vrati poslednje sačuvano stanje, onoliko puta koliko je urađeno čuvanje. Istorija se ograničava na poslednja **tri** sačuvana stanja (ako se sačuva četvrto, najstarije se odbacuje). Pokretanje akcija (dodavanje oblika, čuvanje, vraćanje) mora da bude jedinstveno za menije i dugmiće, a nove akcije se dodaju bez menjanja tih elemenata. Stanje table se čuva tako da kasnije izmene table ne utiču na sačuvana stanja, a da se ne razotkriva njena unutrašnja struktura više nego što je neophodno.

Implementirati sistem koristeći odgovarajuće projektne uzorke i navesti sve primene u `z2.txt`. Napisati primer sa četiri dodavanja oblika, svako pre čuvanja stanja, a zatim vraćanja do kraja istorije.

---

## Zadatak 10 [10] (uzorci su imenovani)

**a)** Zahtev za HTTP poziv ima obavezne podatke (URL i metod) i neobavezne (telo, vreme čekanja u milisekundama; podrazumevano prazno telo i 30000 ms). Zahtev je nepromenljiv nakon pravljenja. Obezbediti pravljenje zahteva tako da se ne može napraviti zahtev bez URL-a i metoda, da se obavezni podaci zadaju tim redom (prvo URL, pa metod), a da se neobavezni zadaju proizvoljnim redosledom, i da kompajler odbije pogrešan redosled. Koristiti odgovarajući projektni uzorak.

**b)** Sistem za izgradnju korisničkog interfejsa ima dugmad (`Button`) i polja za potvrdu (`Checkbox`) u svetloj i tamnoj varijanti, pri čemu se u jednom trenutku koristi samo jedna varijanta. Koristiti **Apstraktnu fabriku** implementiranu pomoću uzorka **Prototip**: fabrika pravi proizvode kopiranjem prototipova, bez podklasa fabrike. Prikazati raspodelu uloga u `z1.txt` i primer koji pravi po jedan proizvod svake vrste za obe varijante.

---

## Kratka pitanja (po uzoru na K1 2019–2023, 20-minutni testovi sa wikija)

1. Koliko različitih tipova učesnika ima uzorak Prototip? Navedi ih.
2. Tačno / netačno: (a) Konstruktor Unikata mora da bude privatan. (b) Klasa sa samo statičkim metodama je ekvivalentna Unikatu. (c) Unikat može da se nasleđuje. (d) Lenja inicijalizacija je bezbedna u višenitnom okruženju bez dodatnih mera.
3. U uzorku Šablonska metoda ko poziva koga? Šta je "operacija kukica"?
4. Pridruži ulogama iz Dekoratera klase: `Coffee`, `BlendCoffee`, `CoffeeAddition`, `MilkCoffeeAddition` (uloge sa vežbi: Komponenta, Subjekat, Dopuna, Konkretna dopuna).
5. Sastav: u kojoj klasi stoje operacije `dodaj`/`izbaci` na vežbama i koja je alternativa? Da li stablo mora biti binarno?
6. Klasifikuj: Fabrička metoda, Prototip, Dekorater, Šablonska metoda, Posmatrač po nameni (kreacioni, strukturni, ponašanja) i po opsegu (klasni, objektni).
7. Šta je razlika između push i pull modela u Posmatraču? Koji je u zadatku sa berzom na vežbama?
8. Za svaki opis odaberi uzorak: (a) slike se učitavaju tek kad uđu u vidno polje; (b) akcija koja se pokreće i dugmetom i prečicom, sa mogućnošću poništavanja; (c) jedna fabrika pravi dve vrste proizvoda zemaljske ili marsovske varijante; (d) mnogo atributa, deo obavezan; (e) postojeća biblioteka ima drugačiji interfejs od onog koji sistem očekuje.
9. Navedi tri razlike između Dekoratera i Zastupnika.
10. Čemu u Apstraktnoj fabrici služi više metoda, a čemu je dovoljna jedna kod Fabričke metode? Šta se menja kada se doda nova porodica, a šta kada se doda nova vrsta proizvoda?
