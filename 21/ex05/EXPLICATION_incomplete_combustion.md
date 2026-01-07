# Exercice 05 - Combustion Incomplète des Alcanes

## 🔬 Principes de Chimie

### Combustion Complète vs Incomplète

#### Combustion Complète
Lorsqu'un alcane brûle avec **suffisamment d'oxygène**, tous les atomes de carbone se transforment en **CO₂** (dioxyde de carbone) :

```
CₙH₂ₙ₊₂ + (3n+1)/2 O₂ → n CO₂ + (n+1) H₂O
```

**Exemple avec le propane (C₃H₈) :**
```
C₃H₈ + 5 O₂ → 3 CO₂ + 4 H₂O
```
- ✅ Tout le carbone → CO₂
- ✅ Tout l'hydrogène → H₂O
- ✅ Combustion propre

#### Combustion Incomplète
Lorsqu'il y a **manque d'oxygène**, le carbone peut former :
- **CO₂** (dioxyde de carbone) - nécessite 2 atomes d'O par C
- **CO** (monoxyde de carbone) - nécessite 1 atome d'O par C  
- **C** (carbone pur/suie) - nécessite 0 atome d'O

**Exemples avec le propane (C₃H₈) :**

Avec **4 O₂** (au lieu de 5) :
```
C₃H₈ + 4 O₂ → 2 CO₂ + C + 4 H₂O  (ou autres combinaisons)
```
- 4 O₂ = 8 atomes d'O
- Eau : 4 H₂O consomme 4 O
- Reste : 8 - 4 = **4 O** pour 3 carbones
- Solutions possibles : 2 CO₂ + 1 C, ou CO₂ + 2 CO

Avec **3 O₂** :
```
C₃H₈ + 3 O₂ → CO₂ + 2 C + 4 H₂O  (ou autres combinaisons)
```
- 3 O₂ = 6 atomes d'O
- Eau : 4 H₂O consomme 4 O
- Reste : 6 - 4 = **2 O** pour 3 carbones
- Solutions possibles : 1 CO₂ + 2 C, ou 2 CO + 1 C

Avec **2 O₂** :
```
C₃H₈ + 2 O₂ → 3 C + 4 H₂O
```
- 2 O₂ = 4 atomes d'O
- Eau : 4 H₂O consomme 4 O
- Reste : 4 - 4 = **0 O** pour les carbones
- Solution : tout le carbone → C/suie pure

### Règles de Conservation

Pour toute combustion (complète ou incomplète), on doit respecter :

1. **Conservation du carbone** : Tous les C de l'alcane se retrouvent dans CO₂, CO ou C
2. **Conservation de l'hydrogène** : Tous les H forment H₂O (toujours prioritaire)
3. **Conservation de l'oxygène** : Total d'O dans O₂ = Total d'O dans les produits

### Calcul de l'Eau (H₂O)

L'eau se forme **toujours** en priorité car la réaction H + O → H₂O est très favorable :

```
Pour CₙH₂ₙ₊₂ : 
  Hydrogènes = 2n + 2
  H₂O formé = (2n + 2) / 2 = n + 1
  Oxygène consommé pour H₂O = n + 1
```

**Exemple propane (C₃H₈) :**
- 8 hydrogènes → **4 H₂O**
- Consomme **4 atomes d'O**
- Reste : O₂ disponible - 4 atomes d'O pour le carbone

---

## 💻 Explication du Code

### Structure de la Classe

```ocaml
class incomplete_combustion (alkanes : Alkane.alkane list) =
  inherit Alkane_combustion.alkane_combustion alkanes
```

La classe hérite de `alkane_combustion` (exercice 04), donc :
- ✅ La méthode `balance` fonctionne toujours (combustion complète)
- ➕ Ajoute `get_incomplete_results` pour les combustions incomplètes

### Nouvelles Molécules

```ocaml
class carbon =  (* Carbone pur / Suie *)
class carbon_monoxide =  (* CO - Monoxyde de carbone *)
```

### Algorithme Principal

#### Étape 1 : Calcul des Totaux
```ocaml
let total_carbons = ... (* Somme des carbones de tous les alcanes *)
let total_hydrogens = ... (* Somme des hydrogènes *)
```

**Exemple avec [propane; methane] :**
- Propane : C₃H₈ → 3 C, 8 H
- Méthane : CH₄ → 1 C, 4 H
- **Total : 4 C, 12 H**

#### Étape 2 : Génération des Scénarios

Pour chaque quantité d'O₂ (de 1 à max_o2-1) :

1. **Calculer l'oxygène disponible**
   ```ocaml
   available_oxygen = 2 * o2_amount
   ```

2. **Réserver l'oxygène pour l'eau**
   ```ocaml
   water_oxygen = total_hydrogens / 2
   remaining_oxygen = available_oxygen - water_oxygen
   ```

3. **Distribuer le reste entre CO₂, CO, C**
   ```ocaml
   generate_combos total_carbons remaining_oxygen []
   ```

#### Étape 3 : Algorithme Récursif

```ocaml
let rec generate_combos c_remaining o_remaining acc =
  if c_remaining = 0 && o_remaining = 0 then
    [acc]  (* Solution trouvée *)
  else
    (* Essayer d'ajouter CO₂, CO ou C *)
    with_co2 @ with_co @ with_c
```

**Arbre de décision pour chaque atome de carbone :**
```
         Carbone à placer
        /       |        \
    CO₂(-2O)  CO(-1O)   C(-0O)
```

### Exemple Concret : Propane avec 3 O₂

**Données :**
- Propane : C₃H₈
- O₂ : 3 molécules → 6 atomes d'O

**Calcul :**
1. Eau : 8 H → 4 H₂O consomme **4 O**
2. Reste pour le carbone : 6 - 4 = **2 O**
3. Distribuer 2 O entre 3 C :

| CO₂ | CO | C | Oxygène utilisé | Valide ? |
|-----|----|----|----------------|----------|
| 1   | 0  | 2  | 1×2 + 0×1 = 2  | ✅       |
| 0   | 2  | 1  | 0×2 + 2×1 = 2  | ✅       |
| 0   | 1  | 2  | 0×2 + 1×1 = 1  | ❌ (reste 1 O) |
| 1   | 1  | 1  | 1×2 + 1×1 = 3  | ❌ (trop d'O) |

**Résultats valides :**
```
With 3 O2: CO₂ + 2 C + 4 H₂O
With 3 O2: 2 CO + C + 4 H₂O
```

---

## 📊 Interprétation des Résultats du Main

### Test 2 : Propane (un seul alcane)

```
Found 40 incomplete combustion scenarios
```

**Pourquoi 40 ?**
- Pour chaque quantité d'O₂ de 1 à 4 (combustion complète = 5 O₂)
- Chaque quantité génère plusieurs combinaisons de CO₂/CO/C
- Total : plusieurs dizaines de scénarios possibles

**Exemples affichés :**
```
With 2 O2: 3 C + 4 H2O
```
- 2 O₂ → 4 atomes d'O
- Eau consomme 4 O (pour 4 H₂O)
- Reste **0 O** pour 3 C
- Solution : tout devient suie (3 C) ✓

```
With 3 O2: CO₂ + 2 C + 4 H₂O
```
- 3 O₂ → 6 atomes d'O
- Eau : 4 O
- Reste : 2 O pour 3 C
- Une combinaison : 1 CO₂ (utilise 2 O) + 2 C ✓

```
With 4 O2: 2 CO₂ + C + 4 H₂O
```
- 4 O₂ → 8 atomes d'O
- Eau : 4 O
- Reste : 4 O pour 3 C
- Une combinaison : 2 CO₂ (utilisent 4 O) + 1 C ✓

### Test 6 : Propane + Méthane

```
Found 40 incomplete combustion scenarios

With 3 O2: 4 Carbon (C) + 6 Water (H2O)
```

**Différence avec l'énoncé :**
- Énoncé : 1 propane (C₃H₈)
- Test 6 : **1 propane + 1 méthane** (C₃H₈ + CH₄)

**Calcul :**
- Total : 4 carbones, 12 hydrogènes
- Avec 3 O₂ = 6 atomes d'O
- Eau : 12 H → 6 H₂O consomme **6 O**
- Reste : 6 - 6 = **0 O** pour 4 C
- **Solution : 4 C (suie pure)**

**Note :** Les résultats réels montrent "With 3 O2: 4 Carbon (C) + 6 Water (H2O)" ce qui confirme le calcul ✓

### Test 5 : Statistiques

```
Number of incomplete outcomes per O2 amount:
  3 O2: X different outcomes
  4 O2: Y different outcomes
```

Montre la **richesse combinatoire** : plus d'O₂ disponible = plus de façons différentes de distribuer entre CO₂/CO/C.

---

## 🎯 Validation du Code

### Critères de Correction

1. **Conservation de la matière** ✓
   - Chaque scénario respecte C_total, H_total, O_total

2. **Pas de combustion complète** ✓
   - Filtre `is_incomplete` élimine les cas où tout est CO₂

3. **Couverture complète** ✓
   - Teste toutes les quantités d'O₂ de 1 à max-1

4. **Format de sortie** ✓
   - `(int * (molecule * int) list) list`
   - Exemple : `(4, [(CO2, 1); (C, 2); (H2O, 4)])`

### Comment Vérifier un Résultat

**Exemple : Propane avec 3 O₂ → CO₂ + 2 C + 4 H₂O**

| Élément | Réactifs | Produits | ✓ |
|---------|----------|----------|---|
| C | 3 (propane) | 1 (CO₂) + 2 (C) = 3 | ✅ |
| H | 8 (propane) | 4×2 (H₂O) = 8 | ✅ |
| O | 3×2 = 6 | 2 (CO₂) + 4 (H₂O) = 6 | ✅ |

**Est-ce une combustion incomplète ?** OUI → présence de C (suie) ✅

---

## 📚 Glossaire

- **Alcane** : Hydrocarbure de formule CₙH₂ₙ₊₂
- **Combustion complète** : Tout le carbone → CO₂
- **Combustion incomplète** : Carbone → CO₂ + CO + C
- **Suie** : Carbone pur (C) résultant d'une combustion incomplète
- **Monoxyde de carbone (CO)** : Gaz toxique produit par combustion incomplète
- **Stœchiométrie** : Science des proportions dans les réactions chimiques
- **Conservation de la matière** : Les atomes ne se créent ni ne se détruisent

---

## 🔍 Pour Aller Plus Loin

**Question :** Pourquoi l'eau se forme-t-elle toujours en priorité ?

**Réponse :** La liaison H-O dans H₂O est extrêmement stable (énergie de liaison élevée). Thermodynamiquement, la formation d'eau est favorisée avant la formation de CO₂ ou CO. C'est pourquoi dans notre algorithme, on calcule d'abord l'eau, puis on distribue l'oxygène restant.

**Question :** Pourquoi certaines quantités d'O₂ ne produisent aucun résultat ?

**Réponse :** Si `available_oxygen < water_oxygen`, il n'y a même pas assez d'O₂ pour former toute l'eau nécessaire. La combustion ne peut pas avoir lieu (ou serait extrêmement partielle, en dehors du scope de l'exercice).
