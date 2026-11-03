# Regresija i klasterovanje (K3, ne K1)

Izvor: `vezbe/7_Linearna_i_logistička_regresija.pdf`, `vezbe/8_Nenadgledano_mašinsko_učenje.pdf`, `predavanja/IS_P12_K-means`. Jan 2024: linearna regresija analitički (10 p), k-means po koracima (teorija); Feb 2024: k-means zadatak; gradient descent i alfa (teorija). Brojevi provereni skriptom.

## Linearna regresija (vežbe 7)
- Hipoteza **h(x) = w₀ + w₁x₁ + … + wₙxₙ**. Greška: **J(w) = (1/2m) Σ (h(x⁽ⁱ⁾) − y⁽ⁱ⁾)²** (MSE sa 1/2).
- **Gradijentni spust**: wᵢ ← wᵢ − α·∂J/∂wᵢ. α (korak učenja) premali: sporo, moguće zaglavljivanje; preveliki: preskače minimum. Zaustavlja se kad je promena parametra ≈ 0. Za jednostruku regresiju ∂J/∂w₀ = (1/m)Σ(h−y), ∂J/∂w₁ = (1/m)Σ(h−y)·x.
- **Analitički (mali skup, jedna promenljiva):**
  w₁ = (nΣxy − ΣxΣy)/(nΣx² − (Σx)²), w₀ = (Σy − w₁Σx)/n.

**Primer (sl. "Zavisnost uspeha od učenja"):** x = 1..8 sati, y = 30, 45, 51, 57, 60, 65, 70, 71. Σx = 36, Σy = 449, Σxy = 2249, Σx² = 204, n = 8.
w₁ = (8·2249 − 36·449)/(8·204 − 36²) = (17992 − 16164)/(1632 − 1296) = 1828/336 = **5.4405**; w₀ = (449 − 5.4405·36)/8 = **31.643**. Za 4.5 sati: 31.643 + 5.4405·4.5 = **56.125** poena. MSE na trening skupu = 12.216 (J = 6.108 sa faktorom 1/2).

## Logistička regresija
- Klasifikacija: h(x) = 1/(1 + e^(−y)), y = w₀ + w₁x₁ + …, h(x) = P(klasa 1 | x). Više od 2 klase: softmax (multinomijalna).
- MSE nije konveksan za sigmoid → koristi se **cross-entropy / log-loss**: Cost = −y·ln h − (1−y)·ln(1−h) = −ln P(y|x). Nema analitičkog rešenja, ide gradijentni spust.
- logit(p) = ln(p/(1−p)) = y.
- **Poređenje dva modela (sl. "Ispit")**: za svaki podatak izračunaj verovatnoću p, "likelihood" = p ako je oznaka 1, inače 1 − p, pa sumu logaritama (log-likelihood). **Veći** log-likelihood = bolji model. Primer, 10 podataka (sati 1-5.5; oznake 0,0,0,0,1,0,1,1,1,1): y = 0.25x − 0.125 daje Σ ln L = −6.216; y = 0.125x + 0.25 daje −6.778. **Prvi model je bolji** (isto kao na slajdu).

## K-means (vežbe 8)
**Recept:**
1. Izaberi k i k početnih centroida (u zadatku su zadati).
2. **Dodela:** svaku tačku dodeli najbližem centroidu (Euklid).
3. **Ažuriranje:** centroid = srednja vrednost tačaka klastera.
4. Ponavljaj 2-3 dok se klasteri ne menjaju.
5. Greška **J = (1/m) Σ ‖x⁽ⁱ⁾ − t_c(i)‖²**.
Izbegavanje lokalnog minimuma: više pokretanja, bira se najmanje J. k iz domenskog znanja ili poređenjem J za različite k.

**Primer (Oblici):** tačke (1,3), (5,6), (5,3), (2,2), (6,4), (6,5), (2,4); početni centroidi (2.5, 6) i (3.5, 1). Iteracije: centroidi (4.33, 5) i (3.5, 3) → (5.67, 5) i (2.5, 3) → **(5.5, 4.5) i (1.67, 3)**, posle čega nema promene. Klaster 1: (5,6), (5,3), (6,4), (6,5); klaster 2: (1,3), (2,2), (2,4). **J = 1.238** (slajd: 1.23).

## Tipične greške
- Linearna regresija: pogrešno Σxy, Σx² (kvadrat sume ≠ suma kvadrata).
- Logistička: tvrdiš da se MSE koristi; ili poredak modela po manjem (umesto većem) log-likelihoodu.
- K-means: zaboraviš da nova dodela koristi **nove** centroide; greška bez kvadrata ili bez deljenja sa m.
