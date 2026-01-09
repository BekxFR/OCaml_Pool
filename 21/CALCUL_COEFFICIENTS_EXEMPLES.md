# 🔥 Calcul des Coefficients Stœchiométriques - Exemples Détaillés

Ce document présente des exemples pas-à-pas pour comprendre le calcul des coefficients dans les réactions de combustion d'alcanes.

---

## 📖 Table des Matières

1. [Formule Générale](#formule-générale)
2. [Exemple 1 : Méthane (CH₄)](#exemple-1--méthane-ch₄)
3. [Exemple 2 : Éthane (C₂H₆)](#exemple-2--éthane-c₂h₆)
4. [Exemple 3 : Propane (C₃H₈)](#exemple-3--propane-c₃h₈)
5. [Exemple 4 : Butane (C₄H₁₀)](#exemple-4--butane-c₄h₁₀)
6. [Algorithme Complet](#algorithme-complet)

---

## Formule Générale

Pour un alcane **CₙH₍₂ₙ₊₂₎**, la combustion complète suit cette équation :

### Avant Simplification (avec fraction)
```
CₙH₍₂ₙ₊₂₎ + (3n+1)/2 O₂ → n CO₂ + (n+1) H₂O
```

### Après Multiplication par 2 (sans fraction)
```
2 CₙH₍₂ₙ₊₂₎ + (3n+1) O₂ → 2n CO₂ + 2(n+1) H₂O
```

### Formule des Coefficients

| Molécule | Coefficient avant simplification | Coefficient après ×2 |
|----------|----------------------------------|----------------------|
| Alcane   | 1                                | 2                    |
| O₂       | (3n+1)/2                        | 3n+1                 |
| CO₂      | n                                | 2n                   |
| H₂O      | n+1                              | 2(n+1) = 2n+2       |

---

## Exemple 1 : Méthane (CH₄)

**Paramètre** : n = 1

### Étape 1 : Calcul des coefficients bruts

```
Alcane : 1
O₂ : (3×1 + 1) / 2 = 4/2 = 2  ← Pas de fraction !
CO₂ : 1
H₂O : 1 + 1 = 2
```

### Équation brute
```
CH₄ + 2 O₂ → CO₂ + 2 H₂O  ✓ Déjà sans fraction
```

### Étape 2 : Application de la formule générale (×2)

```
Alcane : 2
O₂ : 3×1 + 1 = 4
CO₂ : 2×1 = 2
H₂O : 2×(1+1) = 4
```

### Équation après ×2
```
2 CH₄ + 4 O₂ → 2 CO₂ + 4 H₂O
```

### Étape 3 : Calcul du PGCD

Coefficients : [2, 4, 2, 4]

```
gcd(2, 4) = 2
gcd(2, 2) = 2
gcd(2, 4) = 2
PGCD = 2
```

### Étape 4 : Division par le PGCD

```
Alcane : 2 ÷ 2 = 1
O₂ : 4 ÷ 2 = 2
CO₂ : 2 ÷ 2 = 1
H₂O : 4 ÷ 2 = 2
```

### ✅ Équation Finale Simplifiée
```
CH₄ + 2 O₂ → CO₂ + 2 H₂O
```

---

## Exemple 2 : Éthane (C₂H₆)

**Paramètre** : n = 2

### Étape 1 : Calcul des coefficients bruts

```
Alcane : 1
O₂ : (3×2 + 1) / 2 = 7/2 = 3.5  ⚠️ FRACTION !
CO₂ : 2
H₂O : 2 + 1 = 3
```

### Équation brute (avec fraction)
```
C₂H₆ + 3.5 O₂ → 2 CO₂ + 3 H₂O  ❌ Fraction interdite
```

### Étape 2 : Multiplication par 2

```
Alcane : 2
O₂ : 3×2 + 1 = 7
CO₂ : 2×2 = 4
H₂O : 2×(2+1) = 6
```

### Équation après ×2
```
2 C₂H₆ + 7 O₂ → 4 CO₂ + 6 H₂O
```

### Étape 3 : Calcul du PGCD

Coefficients : [2, 7, 4, 6]

```
gcd(2, 7) :
  gcd(7, 2) → gcd(2, 1) → gcd(1, 0) = 1

gcd(1, 4) = 1
gcd(1, 6) = 1
PGCD = 1
```

### Étape 4 : Division par le PGCD

```
Alcane : 2 ÷ 1 = 2
O₂ : 7 ÷ 1 = 7
CO₂ : 4 ÷ 1 = 4
H₂O : 6 ÷ 1 = 6
```

### ✅ Équation Finale Simplifiée
```
2 C₂H₆ + 7 O₂ → 4 CO₂ + 6 H₂O
```

> 💡 **Note** : Le PGCD = 1 signifie que l'équation est déjà dans sa forme la plus simple.

---

## Exemple 3 : Propane (C₃H₈)

**Paramètre** : n = 3

### Étape 1 : Calcul des coefficients bruts

```
Alcane : 1
O₂ : (3×3 + 1) / 2 = 10/2 = 5  ← Pas de fraction !
CO₂ : 3
H₂O : 3 + 1 = 4
```

### Équation brute
```
C₃H₈ + 5 O₂ → 3 CO₂ + 4 H₂O  ✓ Déjà sans fraction
```

### Étape 2 : Application de la formule générale (×2)

```
Alcane : 2
O₂ : 3×3 + 1 = 10
CO₂ : 2×3 = 6
H₂O : 2×(3+1) = 8
```

### Équation après ×2
```
2 C₃H₈ + 10 O₂ → 6 CO₂ + 8 H₂O
```

### Étape 3 : Calcul du PGCD

Coefficients : [2, 10, 6, 8]

```
gcd(2, 10) :
  gcd(10, 2) → gcd(2, 0) = 2

gcd(2, 6) :
  gcd(6, 2) → gcd(2, 0) = 2

gcd(2, 8) :
  gcd(8, 2) → gcd(2, 0) = 2

PGCD = 2
```

### Étape 4 : Division par le PGCD

```
Alcane : 2 ÷ 2 = 1
O₂ : 10 ÷ 2 = 5
CO₂ : 6 ÷ 2 = 3
H₂O : 8 ÷ 2 = 4
```

### ✅ Équation Finale Simplifiée
```
C₃H₈ + 5 O₂ → 3 CO₂ + 4 H₂O
```

---

## Exemple 4 : Butane (C₄H₁₀)

**Paramètre** : n = 4

### Étape 1 : Calcul des coefficients bruts

```
Alcane : 1
O₂ : (3×4 + 1) / 2 = 13/2 = 6.5  ⚠️ FRACTION !
CO₂ : 4
H₂O : 4 + 1 = 5
```

### Équation brute (avec fraction)
```
C₄H₁₀ + 6.5 O₂ → 4 CO₂ + 5 H₂O  ❌ Fraction interdite
```

### Étape 2 : Multiplication par 2

```
Alcane : 2
O₂ : 3×4 + 1 = 13
CO₂ : 2×4 = 8
H₂O : 2×(4+1) = 10
```

### Équation après ×2
```
2 C₄H₁₀ + 13 O₂ → 8 CO₂ + 10 H₂O
```

### Étape 3 : Calcul du PGCD

Coefficients : [2, 13, 8, 10]

```
gcd(2, 13) :
  gcd(13, 2) → gcd(2, 1) → gcd(1, 0) = 1

gcd(1, 8) = 1
gcd(1, 10) = 1
PGCD = 1
```

### Étape 4 : Division par le PGCD

```
Alcane : 2 ÷ 1 = 2
O₂ : 13 ÷ 1 = 13
CO₂ : 8 ÷ 1 = 8
H₂O : 10 ÷ 1 = 10
```

### ✅ Équation Finale Simplifiée
```
2 C₄H₁₀ + 13 O₂ → 8 CO₂ + 10 H₂O
```

---

## Algorithme Complet

Voici l'algorithme en pseudo-code :

```
FONCTION calcul_coefficients(n):
    # Étape 1 : Multiplication par 2 pour éviter fractions
    coeff_alcane = 2
    coeff_o2 = 3 × n + 1
    coeff_co2 = 2 × n
    coeff_h2o = 2 × (n + 1)
    
    # Étape 2 : Calcul du PGCD
    pgcd = gcd(gcd(gcd(coeff_alcane, coeff_o2), coeff_co2), coeff_h2o)
    
    # Étape 3 : Simplification
    coeff_alcane_final = coeff_alcane ÷ pgcd
    coeff_o2_final = coeff_o2 ÷ pgcd
    coeff_co2_final = coeff_co2 ÷ pgcd
    coeff_h2o_final = coeff_h2o ÷ pgcd
    
    RETOURNER (coeff_alcane_final, coeff_o2_final, coeff_co2_final, coeff_h2o_final)

FONCTION gcd(a, b):
    SI b = 0 ALORS
        RETOURNER a
    SINON
        RETOURNER gcd(b, a modulo b)
```

### Code OCaml

```ocaml
(* Fonction PGCD par l'algorithme d'Euclide *)
let rec gcd a b = 
  if b = 0 then a 
  else gcd b (a mod b)

(* Calcul des coefficients pour un alcane CnH(2n+2) *)
let compute_coefficients n =
  (* Coefficients après multiplication par 2 *)
  let coeff_alk = 2 in
  let coeff_o2 = 3 * n + 1 in
  let coeff_co2 = 2 * n in
  let coeff_h2o = 2 * (n + 1) in
  
  (* Calcul du PGCD de tous les coefficients *)
  let pgcd = gcd (gcd (gcd coeff_alk coeff_o2) coeff_co2) coeff_h2o in
  
  (* Division par le PGCD pour simplifier *)
  (coeff_alk / pgcd, coeff_o2 / pgcd, coeff_co2 / pgcd, coeff_h2o / pgcd)
```

---

## 📊 Tableau Récapitulatif

| n | Alcane | Formule | Avant ×2 | Après ×2 | PGCD | **Équation Simplifiée** |
|---|--------|---------|----------|----------|------|------------------------|
| 1 | Méthane | CH₄ | CH₄ + 2 O₂ → CO₂ + 2 H₂O | 2 CH₄ + 4 O₂ → 2 CO₂ + 4 H₂O | 2 | **CH₄ + 2 O₂ → CO₂ + 2 H₂O** |
| 2 | Éthane | C₂H₆ | C₂H₆ + 3.5 O₂ → 2 CO₂ + 3 H₂O | 2 C₂H₆ + 7 O₂ → 4 CO₂ + 6 H₂O | 1 | **2 C₂H₆ + 7 O₂ → 4 CO₂ + 6 H₂O** |
| 3 | Propane | C₃H₈ | C₃H₈ + 5 O₂ → 3 CO₂ + 4 H₂O | 2 C₃H₈ + 10 O₂ → 6 CO₂ + 8 H₂O | 2 | **C₃H₈ + 5 O₂ → 3 CO₂ + 4 H₂O** |
| 4 | Butane | C₄H₁₀ | C₄H₁₀ + 6.5 O₂ → 4 CO₂ + 5 H₂O | 2 C₄H₁₀ + 13 O₂ → 8 CO₂ + 10 H₂O | 1 | **2 C₄H₁₀ + 13 O₂ → 8 CO₂ + 10 H₂O** |
| 5 | Pentane | C₅H₁₂ | C₅H₁₂ + 8 O₂ → 5 CO₂ + 6 H₂O | 2 C₅H₁₂ + 16 O₂ → 10 CO₂ + 12 H₂O | 2 | **C₅H₁₂ + 8 O₂ → 5 CO₂ + 6 H₂O** |
| 6 | Hexane | C₆H₁₄ | C₆H₁₄ + 9.5 O₂ → 6 CO₂ + 7 H₂O | 2 C₆H₁₄ + 19 O₂ → 12 CO₂ + 14 H₂O | 1 | **2 C₆H₁₄ + 19 O₂ → 12 CO₂ + 14 H₂O** |
| 7 | Heptane | C₇H₁₆ | C₇H₁₆ + 11 O₂ → 7 CO₂ + 8 H₂O | 2 C₇H₁₆ + 22 O₂ → 14 CO₂ + 16 H₂O | 2 | **C₇H₁₆ + 11 O₂ → 7 CO₂ + 8 H₂O** |
| 8 | Octane | C₈H₁₈ | C₈H₁₈ + 12.5 O₂ → 8 CO₂ + 9 H₂O | 2 C₈H₁₈ + 25 O₂ → 16 CO₂ + 18 H₂O | 1 | **2 C₈H₁₈ + 25 O₂ → 16 CO₂ + 18 H₂O** |

---

## 💡 Observations

### Quand le PGCD = 2 ?

Le PGCD vaut 2 lorsque **tous les coefficients sont pairs**. Cela se produit quand :
- `3n + 1` est pair
- Ce qui se produit quand `n` est impair

**Alcanes avec PGCD = 2** : n = 1, 3, 5, 7, 9, 11 (impairs)

### Quand le PGCD = 1 ?

Le PGCD vaut 1 lorsque **au moins un coefficient est impair**. Cela se produit quand :
- `3n + 1` est impair
- Ce qui se produit quand `n` est pair

**Alcanes avec PGCD = 1** : n = 2, 4, 6, 8, 10, 12 (pairs)

### Formule du PGCD

```
Si n est impair  → PGCD = 2
Si n est pair    → PGCD = 1
```

Autrement dit :
```ocaml
let pgcd_alcane n = if n mod 2 = 1 then 2 else 1
```

---

## ✅ Vérification de l'Équilibre

Pour vérifier qu'une équation est équilibrée, on compte les atomes de chaque type :

### Exemple : Propane
```
C₃H₈ + 5 O₂ → 3 CO₂ + 4 H₂O
```

**Réactifs (gauche)** :
- C : 3 (dans C₃H₈)
- H : 8 (dans C₃H₈)
- O : 5 × 2 = 10 (dans 5 O₂)

**Produits (droite)** :
- C : 3 × 1 = 3 (dans 3 CO₂)
- H : 4 × 2 = 8 (dans 4 H₂O)
- O : (3 × 2) + (4 × 1) = 6 + 4 = 10 (dans CO₂ et H₂O)

**Bilan** : C=C ✓, H=H ✓, O=O ✓ → **Équation équilibrée !**

---

## 🎓 Pour aller plus loin

Consultez le [GUIDE_PEDAGOGIQUE_DAY21.md](GUIDE_PEDAGOGIQUE_DAY21.md) pour :
- Les détails de l'implémentation OCaml
- Les explications sur les classes virtuelles
- La gestion des exceptions
- Les combustions incomplètes (ex05)
