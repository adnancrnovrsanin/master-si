# Master SI — Adnan Crnovršanin

Lični repozitorijum za master studije: Elektrotehnika i računarstvo, modul Softversko inženjerstvo (ETF Beograd).

## Pregled

- [KOLOKVIJUMI.md](KOLOKVIJUMI.md): datumi, status gradiva i plan spremanja za prve kolokvijume (25–28.11.2026.)
- [resources/sajtovi.md](resources/sajtovi.md): svi sajtovi predmeta i SI Wiki na jednom mestu

## Predmeti

| Folder | Predmet | Sajt |
|---|---|---|
| [pp1-programski-prevodioci-1](courses/pp1-programski-prevodioci-1/README.md) | Programski prevodioci 1 (13E114PP1) | http://ir4pp1.etf.bg.ac.rs/ |
| [ps-modelovanje-projektovanje-softvera](courses/ps-modelovanje-projektovanje-softvera/README.md) | Modelovanje i projektovanje softvera (13M114PS) | https://ps.etf.bg.ac.rs/ |
| [is-inteligentni-servisi-sistemi](courses/is-inteligentni-servisi-sistemi/README.md) | Inteligentni servisi i sistemi (13M114IS) | http://ri4es.etf.rs/ |
| [pki-programiranje-korisnickih-interfejsa](courses/pki-programiranje-korisnickih-interfejsa/README.md) | Programiranje korisničkih interfejsa (13M111PKI) | http://ms1pki.etf.rs/ |
| [fp-funkcionalno-programiranje](courses/fp-funkcionalno-programiranje/README.md) | Funkcionalno programiranje | https://rti.etf.bg.ac.rs/rti/ms1fp/ |
| [opj-obrada-prirodnih-jezika](courses/opj-obrada-prirodnih-jezika/README.md) | Obrada prirodnih jezika (13M111OPJ) | https://rti.etf.bg.ac.rs/rti/ms1opj/ |

## Struktura svakog predmeta

```
courses/<predmet>/
  README.md      info o predmetu, bodovanje, linkovi, status gradiva
  links.txt      URL-ovi materijala za preuzimanje (samo PP1, PS, IS)
  materijali/    sirovi PDF-ovi sa sajta (ne ulaze u git)
  beleske/       moje beleške, rezimei, cheat sheet-ovi (ulaze u git)
  zadaci/        rešeni zadaci, stari kolokvijumi, vežbanje (ulaze u git)
```

## Preuzimanje materijala

```bash
scripts/fetch.sh is            # sve za Inteligentne sisteme
scripts/fetch.sh ps k1         # samo folder k1 za Projektovanje softvera
```
