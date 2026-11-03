# Proxy (Zastupnik)

Vrsta: strukturni, objektni. Izvor: slajdovi str. 93–99; vežbe zadaci 8 i 9 (i diskusija zadatka 7); K1 2025/26 z2, K1P 2025/26 z1.

## Namena

Surogat koji ima isti interfejs kao pravi objekat i kontroliše pristup do njega. Klijent ne primećuje razliku.

## Problem koji rešava

Pravi objekat je skup za pravljenje/učitavanje, nalazi se na drugom računaru, ili mu pristup treba ograničiti. Zastupnik preuzima te brige, a ostatak programa se ne menja.

## Vrste zastupnika (slajd str. 96)

| Vrsta | Šta radi | Prepoznavanje u zadatku |
|---|---|---|
| **virtuelni** (virtual proxy) | odlaže skupo pravljenje/učitavanje do trenutka kada zaista zatreba | "lazy loading", "učitavaju se tek kada su potrebne", "u vidnom polju" |
| **zaštitni** (protection proxy) | kontroliše pristup, različiti klijenti imaju različita prava | "prava pristupa", "korisnik / admin / gost", "polise" |
| **udaljeni** (remote proxy) | lokalni predstavnik objekta u drugom adresnom prostoru | "objekat na serveru, klijentu transparentno" |
| **pametna referenca** (smart reference) | dodatne radnje pri pristupu: brojanje referenci, učitavanje perzistentnog objekta pri prvom pristupu, zaključavanje | "broji reference", "copy on write" |

## Struktura

Slajdovi (str. 97): `Client`, `Subject` (`request()`), `RealSubject`, `Proxy` (drži `subject` 0..1, `request()` prosleđuje `subject->request()`). Proxy održava referencu na pravi subjekat, ima isti interfejs, kontroliše pristup i **zadužen je za pravljenje i uništavanje** pravog subjekta.

Vežbe (slajdovi "Zadatak 8/9 – saradnja"): **Klijent** (`Process`, `SubjectRegistry`), **Subjekat** (`MemFragment`, `Subject`), **Original** (`MemFragmentImpl`, `SubjectImpl`), **Zastupnik** (`MemFragmentProxy`, `SubjectProxy`). Zadatak 8 je označen "zaštitni zastupnik sa dodatno implementiranim copy on write mehanizmom", zadatak 9 "udaljeni zastupnik".

Slajdovi (str. 94–95) daju primer virtuelnog zastupnika: `ImageProxy` čuva `fileName` i `extent` (dimenzije), pa `getExtent()` odgovara bez učitavanja slike; `draw()` učitava sliku (`image = load(fileName)`) pri prvom pozivu i prosleđuje. To je upravo oblik rešenja K1P 2025/26 z1 (zastupnik mora da pamti položaj i dimenzije, jer preglednik pita `Viewport.isInViewport(element)` pre nego što pozove `show()`).

## Kada se koristi

Vidi tabelu gore. Uslov: klijent mora da radi sa objektom kroz zajednički interfejs/apstraktnu klasu, inače zastupnik ne može da ga "zameni".

## Primer: virtuelni i zaštitni zastupnik

```java
interface Graphic {
    int width();
    void draw();
}

class Image implements Graphic {                 // original (skup za pravljenje)
    private final String file;
    private final int w;
    Image(String file, int w) {
        this.file = file;
        this.w = w;
        System.out.println("loading " + file);
    }
    public int width() { return w; }
    public void draw() { System.out.println("drawing " + file); }
}

class ImageProxy implements Graphic {            // virtuelni zastupnik
    private final String file;
    private final int w;                         // znamo dimenziju bez učitavanja
    private Image image;                         // 0..1
    ImageProxy(String file, int w) { this.file = file; this.w = w; }
    public int width() { return w; }
    public void draw() {
        if (image == null) image = new Image(file, w);   // lenjo
        image.draw();
    }
}

class ProtectedGraphic implements Graphic {      // zaštitni zastupnik
    private final Graphic real;
    private final boolean canDraw;
    ProtectedGraphic(Graphic real, boolean canDraw) { this.real = real; this.canDraw = canDraw; }
    public int width() { return real.width(); }
    public void draw() {
        if (!canDraw) throw new SecurityException("draw not permitted");
        real.draw();
    }
}

public class Main {
    public static void main(String[] args) {
        Graphic g = new ImageProxy("a.png", 100);
        System.out.println(g.width());            // bez "loading"
        g.draw();                                 // loading + drawing
        g.draw();                                 // samo drawing
        try { new ProtectedGraphic(g, false).draw(); } catch (SecurityException e) { System.out.println(e.getMessage()); }
    }
}
```

## Posebni slučajevi sa vežbi

- **Copy on write** (zadatak 8, slajd str. 99 takođe pominje): `MemFragmentProxy.clone()` ne kopira podatke nego deli `impl` između roditelja i deteta (`connection`), a pri prvom upisu `unbind()` pravi stvarnu kopiju. Isti zastupnik proverava `rwx` bite (zaštitni deo). Napomena sa vežbi: `OS.createProcess()` je morao da se promeni da pravi zastupnike, i veza se deli samo sa jednim detetom.
- **Udaljeni zastupnik + Adapter** (zadatak 9): `SubjectProxy` pretvara pozive u HTTP zahteve (`get` za void metode, `post` za metode sa povratnom vrednošću), a `ApacheAdapter` prilagođava `HttpInterface` biblioteci Apache HTTP (Adapter, Klijent = `SubjectProxy`). `SubjectRegistry` vraća `SubjectImpl` ili `SubjectProxy`, pa je klijentu transparentno.

## Sa čim se meša

- **Dekorater**: ista struktura. Dekorater dodaje ponašanje i slaže se u lance proizvoljne dužine, Zastupnik kontroliše pristup jednom pravom objektu i sam odlučuje kada ga pravi.
- **Adapter**: menja interfejs, Zastupnik ga čuva.
- **Fasada**: Fasada pojednostavljuje pristup grupi objekata, Zastupnik zamenjuje jedan objekat istog interfejsa.
- **Flyweight**: deli objekte, Zastupnik odlaže pravljenje.
- **Strategija** (K1 2025/26 z2): zaštitni zastupnik često drži politiku pristupa kao Strategiju.

## Pojavljivalo se na K1

- K1P 2025/26 (11.1.2026.) z1: lenjo učitavanje slika u veb pregledaču. Tekst traži "расподелу улога" i **врсту заступника** (virtuelni). Početni kod: `ImageElement` učitava bitmapu u konstruktoru; napomena: mock učitavanje pravi `new byte[path.hashCode()]`, pa može da baci `NegativeArraySizeException` ili zauzme stotine MB, zato u testu koristi kratke putanje (provereno: `"a".hashCode()` je 97, `"hello".hashCode()` je 99162322).
- K1 2025/26 (3.12.2025.) z2: zaštitni zastupnik oko `FileRepository` (korisnik: admin/obični/gost) uz Strategiju za polise. Zvanično rešenje nije dostupno; ovo je moje tumačenje.
- Vežbe: zadaci 8 i 9.

## Razlika u notaciji (slajdovi / vežbe)

Slajdovi: Client, Subject, RealSubject, Proxy. Vežbe: Klijent, Subjekat, **Original** (= RealSubject), Zastupnik. Nazivi vrsta (udaljeni, virtuelni, zaštitni, pametna referenca) su iz slajdova i vežbi isti.
