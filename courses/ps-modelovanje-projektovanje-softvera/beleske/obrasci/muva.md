# Flyweight (Muva)

Vrsta: strukturni, objektni. Izvor: vežbe zadatak 7 (galerija tekstura); K1P 2024/25 z2. Nema ga na slajdovima predavanja osim pomena na str. 38 ("Flyweight DP": deljenje stateless strategija).

## Namena

Deljenje velikog broja sitnih objekata radi štednje memorije. Objekat se deli tako što se njegovo stanje razdvoji na **unutrašnje** (nezavisno od konteksta, deli se) i **spoljašnje** (zavisi od konteksta, prosleđuje se pri svakom pozivu).

## Problem koji rešava

Aplikacija ima ogroman broj objekata koji se razlikuju samo po malom delu stanja (note u partituri, polja mape, znakovi u dokumentu), a "isti" objekat se uvek crta na isti način. Pravljenje novog za svaku pojavu troši memoriju. Prepoznavanje u tekstu zadatka: "svaka konkretna tekstura se crta uvek na isti način, nezavisno od konteksta"; "ноте са истим вредностима се цртају на исти начин независно од тога где се налазе"; "uređaj sa malim memorijskim kapacitetom".

## Struktura

Uloge na vežbama (slajd "Zadatak 7 – saradnja"): **Fabrika muva** (`TextureGallery`), **Muva** (`Texture`), **Konkretna muva** (`TextureEarthWater`, `TextureEarthLand`, `TextureMarsWater`, `TextureMarsLand`). GoF: FlyweightFactory, Flyweight, ConcreteFlyweight (klijent nije prikazan).

```
FabrikaMuva: Map<Ključ, Muva> pool
   getTexture(ključ): ako nema u mapi -> napravi i stavi; vrati iz mape
Muva: operacija(spoljašnjeStanje)         <- pozicija, indeks... stižu kao parametar
```

Dva uslova: fabrika vraća **isti** objekat za isti ključ, i muva ne čuva spoljašnje stanje (ono dolazi kroz parametre metoda).

## Kada se koristi

- Aplikacija koristi veliki broj objekata, čime se troši mnogo memorije.
- Većinu stanja moguće je izdvojiti kao spoljašnje.
- Identitet objekta nije bitan.

## Primer (vežbe, zadatak 7, svojim rečima)

```java
import java.util.HashMap;
import java.util.Map;

abstract class Texture {
    abstract void draw(int x, int y);       // x, y su spoljašnje stanje
}
class WaterTexture extends Texture {
    static int created = 0;
    WaterTexture() { created++; }
    void draw(int x, int y) { System.out.println("water at " + x + "," + y); }
}
class LandTexture extends Texture {
    static int created = 0;
    LandTexture() { created++; }
    void draw(int x, int y) { System.out.println("land at " + x + "," + y); }
}

class TextureGallery {                      // fabrika muva
    enum FieldType { LAND, WATER }
    private final Map<FieldType, Texture> textures = new HashMap<>();

    Texture getTexture(FieldType type) {
        Texture t = textures.get(type);
        if (t == null) {
            t = (type == FieldType.LAND) ? new LandTexture() : new WaterTexture();
            textures.put(type, t);
        }
        return t;
    }
}

public class Main {
    public static void main(String[] args) {
        TextureGallery g = new TextureGallery();
        for (int i = 0; i < 6; i++) {            // i u praksi hiljade polja
            g.getTexture(i % 3 == 0 ? TextureGallery.FieldType.WATER : TextureGallery.FieldType.LAND).draw(i, i);
        }
        System.out.println(WaterTexture.created + " + " + LandTexture.created);   // 1 + 1
    }
}
```

Kombinacija sa vežbi: `TextureGallery` je istovremeno Apstraktna fabrika (zemaljska/marsovska galerija), Muva-fabrika (`getTexture` vraća keširanu instancu) i Šablonski/Fabrički metod (`getTexture` zove `createTextureWater/Land`). Vidi `apstraktna-fabrika.md`. Primer te kombinacije u kolokvijumskom obliku je zadatak 4 u `zadaci/vezbanje.md`.

## Sa čim se meša

- **Singleton/Multiton**: Multiton daje jedinstvenu instancu po imenu, ali ne razdvaja stanje na unutrašnje i spoljašnje i nije ciljno napravljen radi štednje memorije.
- **Prototype**: pravi *nove* objekte kopiranjem, Flyweight *vraća iste*.
- **Proxy**: zastupnik pravi/učitava pravi objekat kasnije, Flyweight deli objekte. Na vežbama (diskusija zadatka 7) se uz muvu kaže da polje ne mora da učitava teksturu dok nije u vidnom polju igrača: to je Zastupnik.
- **Strategy**: slajdovi (str. 38) kažu da se stateless strategije mogu deliti kao muve.

## Pojavljivalo se na K1

- K1P 2024/25 (1.12.2024.) z2: sistem notnog zapisa na uređaju sa malom memorijom. Početni kod ima `Piano`/`Forte` klase sa statičkim mapama tekstura po `NoteValue`, a `draw(index, sol)` prima spoljašnje stanje kao parametar. Uzorak nije imenovan u tekstu zadatka; Flyweight + fabrika (po vrsti nota Piano/Forte) je moje tumačenje, ne zvanično rešenje.
- Vežbe: zadatak 7.
