# Abstract Factory (Apstraktna fabrika)

Vrsta: kreacioni, nad objektima. Izvor: vežbe zadaci 5 i 7.

## Namena

Interfejs za pravljenje porodica srodnih (međusobno zavisnih) objekata bez navođenja njihovih konkretnih klasa. Promena fabrike menja celu porodicu odjednom.

## Problem koji rešava

Sistem treba da radi sa više "varijanti" proizvoda koji moraju da se koriste zajedno (zemaljska i marsovska voda i kopno; Windows i Mac dugmad i prozori), i ne sme da se desi da se pomešaju (zemaljska voda uz marsovsko kopno).

## Struktura

Uloge na vežbama (slajd "Zadatak 7 – saradnja"): **Apstraktna fabrika**, **Konkretna fabrika**, **Apstraktan proizvod**, **Konkretan proizvod**. Isto kao GoF. Klijent nije posebno prikazan.

```
TextureGallery (apstraktna fabrika)             TextureWater, TextureLand (apstraktni proizvodi)
  createTextureWater(), createTextureLand()
     ^                      ^
TextureGalleryEarth   TextureGalleryMars        TextureWaterEarth, TextureWaterMars,
 (konkretne fabrike)                            TextureLandEarth, TextureLandMars (konkretni proizvodi)
```

Svaka konkretna fabrika pravi sve proizvode jedne porodice. Dodavanje nove porodice: nova konkretna fabrika (plus konkretni proizvodi). Dodavanje nove vrste proizvoda: menja se apstraktna fabrika i sve konkretne (slabost uzorka).

## Kada se koristi

- Sistem treba da bude nezavisan od načina pravljenja proizvoda.
- Postoji više familija proizvoda i u datom trenutku se koristi samo jedna ("u jednom trenutku sve teksture u galeriji su ili zemaljske ili marsovske").
- Proizvodi jedne familije moraju da se koriste zajedno.

## Primer (vežbe, zadatak 7, svojim rečima, bez Flyweight dela)

```java
abstract class TextureWater { abstract String name(); }
abstract class TextureLand { abstract String name(); }

class WaterEarth extends TextureWater { String name() { return "water-earth"; } }
class WaterMars extends TextureWater { String name() { return "water-mars"; } }
class LandEarth extends TextureLand { String name() { return "land-earth"; } }
class LandMars extends TextureLand { String name() { return "land-mars"; } }

abstract class TextureGallery {
    abstract TextureWater createWater();
    abstract TextureLand createLand();
}

class GalleryEarth extends TextureGallery {
    TextureWater createWater() { return new WaterEarth(); }
    TextureLand createLand() { return new LandEarth(); }
}

class GalleryMars extends TextureGallery {
    TextureWater createWater() { return new WaterMars(); }
    TextureLand createLand() { return new LandMars(); }
}

public class Main {
    public static void main(String[] args) {
        for (TextureGallery g : new TextureGallery[]{new GalleryEarth(), new GalleryMars()})
            System.out.println(g.createWater().name() + " + " + g.createLand().name());
    }
}
```

## Sa čim se meša

- **Factory Method**: Factory Method je jedna metoda koja pravi jedan proizvod i podklasa bira klasu. Apstraktna fabrika je skup više fabričkih metoda koji zajedno pravi porodicu. Metode apstraktne fabrike se često implementiraju kao fabrički metodi (kao gore).
- **Prototype**: način da se Apstraktna fabrika implementira bez podklasa fabrike (vežbe, zadatak 5): fabrika drži po jedan prototip svakog proizvoda i kopira ga.
- **Singleton**: konkretne fabrike su često Unikati.
- **Flyweight**: na vežbama se spaja sa fabrikom (galerija vraća već napravljenu teksturu), vidi `muva.md`.
- **Strategy**: na vežbama (diskusija zadatka 7) se galerija može posmatrati kao strategija pravljenja tekstura za nivo.
- **Builder**: Builder gradi jedan složen objekat korak po korak, Apstraktna fabrika vraća odmah gotove proizvode više vrsta.

## Pojavljivalo se na K1

- Nije bilo eksplicitno traženo ni na jednom K1 u materijalu. Na K1P 2024/25 z2 (note Piano/Forte, "parametrizuje se da koristi ili Piano ili Forte") fabrika po vrsti nota je prirodna uz Flyweight, ali zvanično rešenje nije dostupno (nepotvrđeno).
- Vežbe: zadaci 5 i 7.
