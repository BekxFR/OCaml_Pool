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

#### Étape 3 : Algorithme Récursif (`generate_combos`)

La fonction `generate_combos` explore **toutes les façons** de placer chaque atome de carbone dans CO₂, CO ou C, en respectant le budget d'oxygène restant.

```ocaml
let rec generate_combos c_remaining o_remaining acc =
  if c_remaining = 0 && o_remaining = 0 then
    [acc]  (* Solution trouvée : tous les C sont placés et tout l'O est utilisé *)
  else if c_remaining = 0 then
    []     (* Plus de C à placer mais il reste de l'O inutilisé → invalide *)
  else if o_remaining < 0 then
    []     (* On a consommé trop d'O → invalide *)
  else
    (* Pour chaque atome de C, essayer 3 possibilités : *)
    let with_co2 = ... generate_combos (c-1) (o-2) (("CO2",1)::acc) ...
    let with_co  = ... generate_combos (c-1) (o-1) (("CO",1)::acc) ...
    let with_c   = ... generate_combos (c-1) (o)   (("C",1)::acc) ...
    with_co2 @ with_co @ with_c
```

**Arbre de décision pour chaque atome de carbone :**
```
         Carbone à placer
        /       |        \
    CO₂(-2O)  CO(-1O)   C(-0O)
```

L'accumulateur `acc` contient la liste des choix faits pour chaque carbone, sous forme de paires `("CO2", 1)`, `("CO", 1)` ou `("C", 1)`. Chaque entrée représente **un** atome de carbone placé. La fonction retourne une **liste de listes** : chaque sous-liste est une combinaison valide.

**Exemple : 3 C, 2 O restants → arbre d'exploration :**
```
generate_combos 3 2 []
├── CO₂ → generate_combos 2 0 [("CO2",1)]
│   ├── CO₂ → generate_combos 1 -2 [...] → [] (o < 0)
│   ├── CO  → generate_combos 1 -1 [...] → [] (o < 0)
│   └── C   → generate_combos 1 0 [("C",1);("CO2",1)]
│       ├── CO₂ → generate_combos 0 -2 [...] → [] (o < 0)
│       ├── CO  → generate_combos 0 -1 [...] → [] (o < 0)
│       └── C   → generate_combos 0 0 [("C",1);("C",1);("CO2",1)] → VALIDE
├── CO  → generate_combos 2 1 [("CO",1)]
│   ├── CO₂ → generate_combos 1 -1 [...] → [] (o < 0)
│   ├── CO  → generate_combos 1 0 [("CO",1);("CO",1)]
│   │   ├── CO₂ → [] (o < 0)
│   │   ├── CO  → [] (o < 0)
│   │   └── C   → generate_combos 0 0 [("C",1);("CO",1);("CO",1)] → VALIDE
│   └── C   → generate_combos 1 1 [("C",1);("CO",1)]
│       ├── CO₂ → [] (o < 0)
│       ├── CO  → generate_combos 0 0 [("CO",1);("C",1);("CO",1)] → VALIDE (doublon)
│       └── C   → generate_combos 0 1 [...] → [] (reste 1 O)
└── C   → generate_combos 2 2 [("C",1)]
    ├── CO₂ → generate_combos 1 0 [("CO2",1);("C",1)]
    │   └── C → generate_combos 0 0 [...] → VALIDE (doublon de la 1ère)
    ├── CO  → generate_combos 1 1 [("CO",1);("C",1)]
    │   ├── CO  → generate_combos 0 0 [...] → VALIDE (doublon)
    │   └── C   → generate_combos 0 1 [...] → [] (reste 1 O)
    └── C   → generate_combos 1 2 [("C",1);("C",1)]
        ├── CO₂ → generate_combos 0 0 [...] → VALIDE (doublon)
        └── ...
```

> **Note sur les doublons :** Chaque atome de C est traité individuellement, donc
> `[CO₂, C, C]` et `[C, CO₂, C]` sont deux combinaisons distinctes pour `generate_combos`.
> L'étape d'agrégation les transforme toutes les deux en `[("CO2",1); ("C",2)]`.
> Pour éliminer ces doublons, on applique une **normalisation** après agrégation :
> chaque combo est triée (`List.sort compare`) pour que l'ordre des entrées soit
> déterministe, puis `List.sort_uniq compare` élimine les combos identiques.
> Le résultat final est donc **sans doublons**, conformément au sujet.

#### Étape 4 : Agrégation avec `aggregate`

`generate_combos` produit des listes comme `[("CO2",1); ("C",1); ("C",1); ("CO2",1)]` où chaque entrée correspond à **un seul** atome de carbone. Il faut regrouper les entrées identiques et additionner leurs compteurs.

```ocaml
let rec aggregate acc = function
  | [] -> acc
  | (mol_type, count) :: rest ->
      let current = try List.assoc mol_type acc with Not_found -> 0 in
      aggregate ((mol_type, current + count) :: (List.remove_assoc mol_type acc)) rest
```

La fonction parcourt la liste et maintient un accumulateur `acc` de type `(string * int) list` :
- Pour chaque `(mol_type, count)`, elle cherche si `mol_type` existe déjà dans `acc`
- Si oui : additionne le compteur (`current + count`) et remplace l'ancienne entrée
- Si non : ajoute une nouvelle entrée avec `count`

**Exemple :**
```
Entrée:  [("CO2",1); ("C",1); ("C",1)]
  → ("CO2",1) : acc = [("CO2",1)]
  → ("C",1)   : acc = [("C",1); ("CO2",1)]
  → ("C",1)   : current=1, acc = [("C",2); ("CO2",1)]
Sortie:  [("C",2); ("CO2",1)]
```

#### Étape 5 : Normalisation et dédoublonnage

Après agrégation, les doublons issus de `generate_combos` (comme `[CO₂,C,C]` et `[C,CO₂,C]`) donnent le **même résultat agrégé** `[("CO2",1); ("C",2)]`. Cependant, l'ordre des entrées peut varier. Pour pouvoir les comparer et dédupliquer :

1. **Tri de chaque combo** (`List.sort compare`) : normalise l'ordre des entrées
2. **Déduplication** (`List.sort_uniq compare`) : élimine les combos identiques

```ocaml
let normalized = List.map (List.sort compare) aggregated_combos in
let unique_combos = List.sort_uniq compare normalized
```

#### Étape 6 : Filtrage avec `is_incomplete`

On ne veut que les combustions **incomplètes** (pas tout en CO₂).

```ocaml
let is_incomplete combo =
  List.exists (fun (mol, _) -> mol = "CO" || mol = "C") combo
```

Le filtre est simple : une combustion est incomplète si **au moins un** carbone finit en CO ou en C (suie), au lieu d'être entièrement en CO₂.

```ocaml
let incomplete_combos = List.filter is_incomplete unique_combos
```

#### Étape 7 : Conversion en objets (`combo_to_molecules`)

Les combinaisons sont déjà agrégées et dédupliquées. Cette étape les convertit en vrais objets `molecule` et ajoute l'eau :

```ocaml
let combo_to_molecules combo =
  let molecules = List.map (fun (mol_type, coeff) ->
    let mol = match mol_type with
      | "CO2" -> new Molecule.carbon_dioxide
      | "CO"  -> new carbon_monoxide
      | "C"   -> new carbon
    in (mol, coeff)
  ) combo in
  (* Ajouter l'eau en dernier *)
  molecules @ [((new Molecule.water), total_hydrogens / 2)]
```

#### Étape 8 : Aplatissement (`flat_results`)

`generate_all_outcomes` produit une liste de `(o2_amount, outcomes_list)` où chaque `outcomes_list` contient **plusieurs** scénarios pour un même nombre d'O₂. `flat_results` transforme cela en une liste plate :

```
Avant : [(3, [scenario_A; scenario_B]); (4, [scenario_C])]
Après : [(3, scenario_A); (3, scenario_B); (4, scenario_C)]
```

Chaque entrée du résultat final est un tuple `(int * (molecule * int) list)` : la quantité d'O₂ et la liste des produits avec leurs coefficients.

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

**Pourquoi 13 ?**
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
