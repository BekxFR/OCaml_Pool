# Guide Pédagogique - Day 21: Chimie et Programmation Orientée Objet

## Vue d'ensemble

Le **Day 21** explore la modélisation de concepts chimiques à travers la programmation orientée objet en OCaml. Ce jour met l'accent sur :

- Les **classes virtuelles** et l'héritage
- La modélisation de domaines complexes (chimie)
- Les **contraintes fonctionnelles strictes** (pas de style impératif)
- L'implémentation d'algorithmes chimiques (notation de Hill, équilibrage stœchiométrique)

## Objectifs pédagogiques

1. Maîtriser les **classes virtuelles** et l'héritage en OCaml
2. Comprendre la **notation de Hill** pour les formules chimiques
3. Implémenter des calculs chimiques (formules moléculaires, stœchiométrie)
4. Respecter le **paradigme fonctionnel** (éviter mutable/impératif)
5. Modéliser des systèmes complexes par composition d'objets

## Progression des exercices

### Exercice 00: Atoms (Fondations)

**Objectif**: Créer une hiérarchie de classes pour les atomes chimiques.

**Concepts clés**:

- **Classe virtuelle** `atom` avec méthodes virtuelles
- Implémentation concrète pour 6 atomes (H, C, O, N, S, Cl)
- Méthodes concrètes héritées par tous

**Structure**:

```ocaml
class virtual atom =
object
  method virtual name : string
  method virtual symbol : string
  method virtual atomic_number : int
  method to_string : string = (* implementation *)
  method equals (other : atom) : bool = (* implementation *)
end

class hydrogen = object
  inherit atom
  method name = "Hydrogen"
  method symbol = "H"
  method atomic_number = 1
end
```

**Points importants**:

- Les méthodes virtuelles DOIVENT être implémentées dans les classes concrètes
- `method virtual name : type` déclare une méthode abstraite
- `inherit parent_class` établit l'héritage

### Exercice 01: Molecules (Composition)

**Objectif**: Créer des molécules composées d'atomes avec notation de Hill.

**Concepts clés**:

- Héritage de `atom` via composition
- **Notation de Hill**: C d'abord, puis H, puis alphabétique
- Génération automatique de formules chimiques
- Traitement de listes fonctionnel

**Algorithme de Hill**:

1. Compter les occurrences de chaque symbole atomique
2. Trier selon les règles: C → H → autres (alphabétique)
3. Formater: symbole + nombre (omis si = 1)

**Exemple**:

```ocaml
class water =
object
  inherit molecule [
    new Atom.hydrogen;
    new Atom.hydrogen;
    new Atom.oxygen
  ]
  method name = "Water"
end
(* Formula: H2O *)
```

**Défis techniques**:

- Parser et compter les atomes d'une liste
- Trier selon des règles personnalisées
- Formatter proprement (omission du "1")

### Exercice 02: Alkanes (Formule paramétrique)

**Objectif**: Générer automatiquement des alcanes selon la formule CnH(2n+2).

**Concepts clés**:

- Héritage de `molecule`
- **Génération paramétrique** d'atomes
- Validation des contraintes (1 ≤ n ≤ 12)
- Nomenclature IUPAC (methane, ethane, propane...)

**Formule chimique**:

- **Alcane**: hydrocarbure saturé de formule CnH(2n+2)
- Exemples:
  - n=1: CH4 (méthane)
  - n=2: C2H6 (éthane)
  - n=8: C8H18 (octane)

**Implémentation**:

```ocaml
class alkane (n : int) =
  let () =
    if n < 1 || n > 12 then
      failwith "Alkane: n must be between 1 and 12"
  in
  let atoms_list =
    let carbons = List.init n (fun _ -> new Atom.carbon) in
    let hydrogens = List.init (2*n+2) (fun _ -> new Atom.hydrogen) in
    carbons @ hydrogens
  in
object
  inherit Molecule.molecule atoms_list
  method name = (* Lookup IUPAC name *)
end
```

**Points techniques**:

- Validation AVANT la construction de l'objet
- `List.init` pour génération fonctionnelle
- Nomenclature systématique des alcanes

### Exercice 03: Reactions (Conservation des atomes)

**Objectif**: Modéliser des réactions chimiques avec loi de Lavoisier.

**Concepts clés**:

- Classe virtuelle `reaction`
- **Loi de Lavoisier**: conservation de la masse (atomes)
- Listes associatives (molécule, coefficient)
- Vérification d'équilibre

**Loi de Lavoisier**:
"Rien ne se perd, rien ne se crée, tout se transforme"
→ Le nombre d'atomes de chaque type doit être identique avant/après

**Structure**:

```ocaml
class virtual reaction =
object
  method virtual get_start : (Molecule.molecule * int) list
  method virtual get_result : (Molecule.molecule * int) list
  method is_balanced : bool = (* compare atom counts *)
  method virtual balance : unit
end
```

**Algorithme de vérification**:

1. Compter tous les atomes dans les réactifs (avec coefficients)
2. Compter tous les atomes dans les produits (avec coefficients)
3. Comparer les deux listes (doivent être identiques)

**Format des listes**:

- `(molecule, coefficient)` représente "coefficient × molecule"
- Exemple: `[(CH4, 1); (O2, 2)]` = "CH4 + 2 O2"

### Exercice 04: Alkane Combustion (Équilibrage automatique)

**Objectif**: Combustion complète des alcanes avec équilibrage stœchiométrique.

**Concepts clés**:

- **Combustion complète**: CnH(2n+2) + O2 → CO2 + H2O
- Calcul automatique des **coefficients stœchiométriques**
- Exception `UnbalancedReaction` si non équilibré
- Contrôle d'accès (get_start/get_result lancent exception avant balance)

**Équilibrage stœchiométrique**:
Pour un alcane CnH(2n+2):

```
2 CnH(2n+2) + (2n+3) O2 → 2n CO2 + 2(n+1) H2O
```

Exemples:

- Méthane (n=1): `2 CH4 + 5 O2 → 2 CO2 + 4 H2O`
- Éthane (n=2): `2 C2H6 + 7 O2 → 4 CO2 + 6 H2O`
- Octane (n=8): `2 C8H18 + 19 O2 → 16 CO2 + 18 H2O`

**Implémentation**:

```ocaml
class alkane_combustion (alkanes : Alkane.alkane list) =
  let coefficients = compute_coefficients alkanes in
  let start_list = build_start_list alkanes coefficients in
  let result_list = build_result_list alkanes coefficients in
object
  inherit Reaction.reaction
  val balanced_ref = ref false

  method get_start =
    if not !balanced_ref then raise UnbalancedReaction
    else start

  method balance = balanced_ref := true
end
```

**Points critiques**:

- Les coefficients sont calculés à la construction
- `balance` débloque l'accès aux listes
- Exception si accès avant équilibrage

---

## 📚 Annexe Technique : Calcul des Coefficients et Simplification

### 1. Calcul des Coefficients Stœchiométriques

#### Explication Simple

Quand on brûle un alcane (comme l'essence dans une voiture), on doit calculer combien d'oxygène (O₂) on a besoin et combien de CO₂ et H₂O on va produire. C'est comme une recette de cuisine : il faut les bonnes proportions !

**Exemple concret** : Pour le méthane (CH₄)
- On a : 1 atome de carbone (C) et 4 atomes d'hydrogène (H)
- Chaque C devient CO₂ (il faut 2 oxygènes)
- Chaque 2 H deviennent H₂O (il faut 1 oxygène)

**Le problème** : Les hydrogènes sont au nombre de 4, donc on va faire 2 molécules d'eau. Pour l'équilibrage, on va parfois obtenir des **fractions** !

#### Explication Avancée : Formule Mathématique

Pour un alcane de formule **CₙH₍₂ₙ₊₂₎**, la combustion complète suit cette équation :

```
CₙH₍₂ₙ₊₂₎ + O₂ → CO₂ + H₂O
```

**Calcul des coefficients bruts (avant simplification)** :

1. **Pour le CO₂** : Chaque carbone devient un CO₂
   - Coefficient CO₂ = **n**

2. **Pour le H₂O** : Chaque paire d'hydrogène devient une H₂O
   - Coefficient H₂O = **(2n + 2) / 2 = n + 1**

3. **Pour le O₂** : On compte les oxygènes nécessaires
   - Oxygènes pour CO₂ : 2n (car n × CO₂ et chaque CO₂ a 2 O)
   - Oxygènes pour H₂O : n + 1 (car (n+1) × H₂O et chaque H₂O a 1 O)
   - Total oxygènes : 2n + (n + 1) = **3n + 1**
   - Coefficient O₂ = **(3n + 1) / 2** ⚠️ **FRACTION !**

**Équation brute avec fraction** :
```
CₙH₍₂ₙ₊₂₎ + (3n+1)/2 O₂ → n CO₂ + (n+1) H₂O
```

---

### 2. Format Sans et Avec Multiplication pour la Simplification

#### Le Problème des Fractions

En chimie, on ne peut pas avoir "1.5 molécules" d'O₂ dans une équation chimique. Les coefficients doivent être des **nombres entiers**.

#### Solution : Multiplication par 2

Pour éliminer la fraction `(3n+1)/2`, on **multiplie toute l'équation par 2** :

**Avant multiplication** (avec fraction) :
```
1 CₙH₍₂ₙ₊₂₎ + (3n+1)/2 O₂ → n CO₂ + (n+1) H₂O
```

**Après multiplication par 2** (sans fraction) :
```
2 CₙH₍₂ₙ₊₂₎ + (3n+1) O₂ → 2n CO₂ + 2(n+1) H₂O
```

**Coefficients après multiplication** :
- Alcane : **2**
- O₂ : **3n + 1**
- CO₂ : **2n**
- H₂O : **2(n + 1) = 2n + 2**

#### Exemples Concrets

**Exemple 1 : Méthane (n = 1)**

Avant multiplication :
```
CH₄ + (3×1+1)/2 O₂ → 1 CO₂ + (1+1) H₂O
CH₄ + 2 O₂ → CO₂ + 2 H₂O   ✓ Pas de fraction !
```

Après multiplication par 2 (formule générale) :
```
2 CH₄ + (3×1+1) O₂ → 2×1 CO₂ + 2×(1+1) H₂O
2 CH₄ + 4 O₂ → 2 CO₂ + 4 H₂O
```

**Exemple 2 : Éthane (n = 2)**

Avant multiplication :
```
C₂H₆ + (3×2+1)/2 O₂ → 2 CO₂ + (2+1) H₂O
C₂H₆ + 3.5 O₂ → 2 CO₂ + 3 H₂O   ❌ Fraction !
```

Après multiplication par 2 :
```
2 C₂H₆ + (3×2+1) O₂ → 2×2 CO₂ + 2×(2+1) H₂O
2 C₂H₆ + 7 O₂ → 4 CO₂ + 6 H₂O   ✓ Pas de fraction !
```

**Exemple 3 : Propane (n = 3)**

Avant multiplication :
```
C₃H₈ + (3×3+1)/2 O₂ → 3 CO₂ + (3+1) H₂O
C₃H₈ + 5 O₂ → 3 CO₂ + 4 H₂O   ✓ Pas de fraction !
```

Après multiplication par 2 (formule générale) :
```
2 C₃H₈ + (3×3+1) O₂ → 2×3 CO₂ + 2×(3+1) H₂O
2 C₃H₈ + 10 O₂ → 6 CO₂ + 8 H₂O
```

**Observation importante** : Pour le propane, la multiplication par 2 n'était pas nécessaire car il n'y avait déjà pas de fraction. C'est là qu'intervient le **PGCD** pour simplifier !

---

### 3. Le Calcul du PGCD (Plus Grand Commun Diviseur)

#### Pourquoi le PGCD ?

Après avoir multiplié par 2 pour éliminer les fractions, les coefficients peuvent avoir un **diviseur commun**. On veut la forme la plus **simple** de l'équation.

**Exemple** : 
- `2 C₃H₈ + 10 O₂ → 6 CO₂ + 8 H₂O`
- Tous les coefficients sont divisibles par 2
- Forme simplifiée : `C₃H₈ + 5 O₂ → 3 CO₂ + 4 H₂O`

#### L'Algorithme d'Euclide (Simple)

Le PGCD de deux nombres se calcule ainsi :

```
pgcd(a, 0) = a
pgcd(a, b) = pgcd(b, a mod b)  où "mod" est le reste de la division
```

**En OCaml** :
```ocaml
let rec gcd a b = 
  if b = 0 then a 
  else gcd b (a mod b)
```

#### Exemples de Calcul du PGCD

**Exemple 1 : PGCD de 12 et 8**

```
gcd(12, 8)
= gcd(8, 12 mod 8)    → 12 mod 8 = 4
= gcd(8, 4)
= gcd(4, 8 mod 4)     → 8 mod 4 = 0
= gcd(4, 0)
= 4                   ✓ Résultat
```

**Exemple 2 : PGCD de 15 et 10**

```
gcd(15, 10)
= gcd(10, 15 mod 10)  → 15 mod 10 = 5
= gcd(10, 5)
= gcd(5, 10 mod 5)    → 10 mod 5 = 0
= gcd(5, 0)
= 5                   ✓ Résultat
```

**Exemple 3 : PGCD de 7 et 3**

```
gcd(7, 3)
= gcd(3, 7 mod 3)     → 7 mod 3 = 1
= gcd(3, 1)
= gcd(1, 3 mod 1)     → 3 mod 1 = 0
= gcd(1, 0)
= 1                   ✓ Résultat (nombres premiers entre eux)
```

#### PGCD de Plus de 2 Nombres

Pour trouver le PGCD de plusieurs nombres (tous les coefficients), on les combine deux par deux :

```ocaml
(* PGCD de 4 nombres : a, b, c, d *)
let pgcd_total = gcd (gcd (gcd a b) c) d
```

**Exemple concret : Méthane (n=1) après multiplication par 2**

Coefficients : `[2, 4, 2, 4]` (alcane, O₂, CO₂, H₂O)

```
Étape 1 : gcd(2, 4) = 2
Étape 2 : gcd(2, 2) = 2
Étape 3 : gcd(2, 4) = 2
PGCD final = 2
```

Division par le PGCD :
- 2 / 2 = 1 (alcane)
- 4 / 2 = 2 (O₂)
- 2 / 2 = 1 (CO₂)
- 4 / 2 = 2 (H₂O)

**Équation simplifiée** : `CH₄ + 2 O₂ → CO₂ + 2 H₂O` ✓

#### Application Complète : Propane (n = 3)

**Étape 1 : Calcul des coefficients bruts**
```
Alcane : 2
O₂ : 3×3 + 1 = 10
CO₂ : 2×3 = 6
H₂O : 2×(3+1) = 8
```

**Étape 2 : Calcul du PGCD**
```
gcd(2, 10) = gcd(10, 2) = gcd(2, 0) = 2
gcd(2, 6) = gcd(6, 2) = gcd(2, 0) = 2
gcd(2, 8) = gcd(8, 2) = gcd(2, 0) = 2
PGCD final = 2
```

**Étape 3 : Division par le PGCD**
```
Alcane : 2 / 2 = 1
O₂ : 10 / 2 = 5
CO₂ : 6 / 2 = 3
H₂O : 8 / 2 = 4
```

**Équation finale** : `C₃H₈ + 5 O₂ → 3 CO₂ + 4 H₂O` ✓

#### Code OCaml Complet

```ocaml
(* Calcul des coefficients pour un alcane de paramètre n *)
let compute_coefficients n =
  (* Coefficients après multiplication par 2 *)
  let coeff_alk = 2 in
  let coeff_o2 = 3 * n + 1 in
  let coeff_co2 = 2 * n in
  let coeff_h2o = 2 * (n + 1) in
  
  (* Fonction PGCD *)
  let rec gcd a b = if b = 0 then a else gcd b (a mod b) in
  
  (* Calcul du PGCD de tous les coefficients *)
  let pgcd = gcd (gcd (gcd coeff_alk coeff_o2) coeff_co2) coeff_h2o in
  
  (* Division par le PGCD pour simplifier *)
  (coeff_alk / pgcd, coeff_o2 / pgcd, coeff_co2 / pgcd, coeff_h2o / pgcd)
```

#### Tableau Récapitulatif des Alcanes

| n | Alcane | Avant simplification | PGCD | Après simplification |
|---|--------|---------------------|------|---------------------|
| 1 | CH₄ | 2 CH₄ + 4 O₂ → 2 CO₂ + 4 H₂O | 2 | CH₄ + 2 O₂ → CO₂ + 2 H₂O |
| 2 | C₂H₆ | 2 C₂H₆ + 7 O₂ → 4 CO₂ + 6 H₂O | 1 | 2 C₂H₆ + 7 O₂ → 4 CO₂ + 6 H₂O |
| 3 | C₃H₈ | 2 C₃H₈ + 10 O₂ → 6 CO₂ + 8 H₂O | 2 | C₃H₈ + 5 O₂ → 3 CO₂ + 4 H₂O |
| 4 | C₄H₁₀ | 2 C₄H₁₀ + 13 O₂ → 8 CO₂ + 10 H₂O | 1 | 2 C₄H₁₀ + 13 O₂ → 8 CO₂ + 10 H₂O |
| 5 | C₅H₁₂ | 2 C₅H₁₂ + 16 O₂ → 10 CO₂ + 12 H₂O | 2 | C₅H₁₂ + 8 O₂ → 5 CO₂ + 6 H₂O |
| 8 | C₈H₁₈ | 2 C₈H₁₈ + 25 O₂ → 16 CO₂ + 18 H₂O | 1 | 2 C₈H₁₈ + 25 O₂ → 16 CO₂ + 18 H₂O |

**Observation** : Le PGCD est toujours 1 ou 2 selon la parité de (3n + 1).

---

### Exercice 05: Incomplete Combustion (Combustion incomplète)

**Objectif**: Générer toutes les combustions incomplètes possibles avec quantités variables d'O2.

**Concepts clés**:

- **Combustion incomplète**: Manque d'oxygène → production de CO et/ou C
- Génération de **toutes les combinaisons** valides
- Algorithme récursif pour explorer les possibilités
- Filtrage des combustions complètes (qui ne contiennent que CO2)

**Combustion incomplète**:
Quand il n'y a pas assez d'oxygène pour une combustion complète:

```
CnH(2n+2) + O2 → CO2 + CO + C + H2O (diverses combinaisons)
```

Exemples pour l'éthane (C2H6):

- Avec 2 O2: `C2H6 + 2 O2 → CO + C + 3 H2O`
- Avec 3 O2: `C2H6 + 3 O2 → CO2 + CO + 3 H2O` ou `C2H6 + 3 O2 → 2 CO + 3 H2O`

Pour le propane (C3H8):

- Avec 2 O2: `C3H8 + 2 O2 → 3 C + 4 H2O`
- Avec 3 O2: `C3H8 + 3 O2 → CO2 + 2 C + 4 H2O` ou `C3H8 + 3 O2 → 2 CO + C + 4 H2O`
- Avec 4 O2: `C3H8 + 4 O2 → 2 CO2 + C + 4 H2O` etc.

**Type de retour**: `(int * (molecule * int) list) list`

- `int`: Quantité d'O2 utilisée
- `(molecule * int) list`: Liste des produits avec leurs coefficients

**Algorithme**:

```ocaml
(* Pour chaque quantité d'O2 de 1 à max_o2-1 *)
let generate_outcomes o2_amount =
  (* 1. Calculer l'oxygène disponible: 2 * o2_amount *)
  (* 2. Soustraire l'oxygène pour H2O (toujours fixe) *)
  (* 3. Générer toutes les combinaisons CO2/CO/C qui utilisent
        le reste d'oxygène et tous les carbones *)
  (* 4. Filtrer les combustions complètes *)
```

**Génération récursive**:

```ocaml
let rec generate_combos carbones_restants oxygene_restant acc =
  if carbones = 0 && oxygene = 0 then
    [acc]  (* Solution trouvée *)
  else
    (* Essayer d'ajouter CO2 (consomme 2 O), CO (consomme 1 O), ou C (consomme 0 O) *)
    with_co2 @ with_co @ with_c
```

**Nouvelles molécules**:

```ocaml
class carbon =  (* Carbone pur - suie *)
object
  inherit Molecule.molecule [new Atom.carbon]
  method name = "Carbon"
end

class carbon_monoxide =  (* CO *)
object
  inherit Molecule.molecule [new Atom.carbon; new Atom.oxygen]
  method name = "Carbon monoxide"
end
```

**Implémentation**:

```ocaml
class incomplete_combustion (alkanes : Alkane.alkane list) =
  (* Calculer total carbones et hydrogènes *)
  let total_carbons = ... in
  let total_hydrogens = ... in
  let max_o2 = ... in  (* Pour combustion complète *)
object
  inherit Alkane_combustion.alkane_combustion alkanes

  method get_incomplete_results : (int * (Molecule.molecule * int) list) list =
    (* Générer pour chaque quantité d'O2 de 1 à max_o2-1 *)
    generate_all_outcomes 1 []
end
```

**Défis techniques**:

1. **Génération exhaustive**: Explorer toutes les combinaisons CO2/CO/C
2. **Conservation**: Respecter le nombre total de carbones et d'oxygène disponible
3. **Eau fixe**: H2O toujours produit en quantité fixe (total_hydrogens/2)
4. **Filtrage**: Éliminer les combustions complètes (pas de CO ni C)
5. **Format de retour**: Aplatir la structure pour avoir une entrée par solution

**Points d'attention**:

- L'algorithme génère TOUTES les combinaisons possibles
- Certaines peuvent être des permutations (ordre différent des produits)
- Le nombre de solutions croît rapidement avec la taille de l'alcane
- La récursion doit gérer les cas limites (pas assez d'O2)

## Contraintes techniques

### Style fonctionnel strict

**Interdit**:

- `mutable` dans les classes (sauf pour le flag balanced - toléré via `ref`)
- Boucles `for`/`while`
- Structures impératives (Array avec mutation)

**Autorisé**:

- `List.map`, `List.fold_left`, `List.filter`
- Récursion
- `ref` pour état minimal (comme le flag balanced)

### Listes associatives

Format: `(key, value) list`

- DOIVENT être triées par ordre croissant de clé
- Utiliser `List.sort` avec fonction de comparaison

Exemple:

```ocaml
let counts = [("C", 2); ("H", 6); ("O", 1)]
let sorted = List.sort (fun (k1,_) (k2,_) -> compare k1 k2) counts
(* Résultat: [("C", 2); ("H", 6); ("O", 1)] - déjà trié *)
```

## Concepts chimiques

### Notation de Hill

Système standard pour écrire les formules chimiques:

1. **Carbon (C)** en premier (si présent)
2. **Hydrogen (H)** en second (si présent)
3. **Autres éléments** par ordre alphabétique

Exemples:

- Eau: H2O (pas de carbone, donc H d'abord)
- Méthane: CH4 (C puis H)
- Acide sulfurique: H2O4S (pas de carbone, H puis alphabétique)

### Stœchiométrie

Science des proportions dans les réactions chimiques:

- **Coefficients stœchiométriques**: nombres devant les formules
- **Loi de conservation**: mêmes atomes avant/après
- **Équilibrage**: trouver les bons coefficients

Exemple (combustion du méthane):

```
CH4 + O2 → CO2 + H2O    (non équilibré)
CH4 + 2 O2 → CO2 + 2 H2O  (équilibré)
```

Vérification:

- Avant: 1 C, 4 H, 4 O
- Après: 1 C, 4 H, 4 O ✓

## Difficultés courantes

### 1. Syntaxe des classes virtuelles

**Erreur**: `val _ = if condition then failwith`
**Solution**: Utiliser `let () = ...` avant l'objet

### 2. Parsing des formules chimiques

**Défi**: Extraire symboles et nombres de "C2H6O"
**Solution**: Parser caractère par caractère, détecter majuscules/minuscules/chiffres

### 3. Upcast pour equals

**Erreur**: Type incompatible dans `alkane#equals methane2`
**Solution**: `alkane#equals (methane2 :> Molecule.molecule)`

### 4. Gestion de l'état balanced

**Problème**: Comment gérer un flag sans `mutable`?
**Solution**: Utiliser `ref` (toléré car minimal)

### 5. Calcul des coefficients

**Défi**: Formule mathématique correcte
**Solution**: Pour CnH(2n+2), coefficient O2 = 2n+3 (pas 3n+1)

### 6. Génération exhaustive (Ex05)

**Défi**: Générer TOUTES les combinaisons possibles sans doublon logique
**Solution**: Récursion avec branchement CO2/CO/C, filtrage des combustions complètes

### 7. Explosion combinatoire (Ex05)

**Problème**: Nombre de solutions croît très rapidement
**Solution**: Acceptable - l'algorithme explore tout l'espace des possibilités

### 8. Conservation des atomes (Ex05)

**Défi**: S'assurer que carbones_utilisés = total_carbones ET oxygène_utilisé = disponible
**Solution**: Conditions de terminaison dans la récursion (c=0 ET o=0)

## Comparaison Day 20 vs Day 21

| Aspect          | Day 20 (Doctor Who)           | (Chimie)                                    |
| --------------- | ----------------------------- | ------------------------------------------- |
| **Domaine**     | Jeu/Fiction                   | Science/Chimie                              |
| **Style**       | Impératif toléré (game state) | Fonctionnel strict                          |
| **Mutable**     | Autorisé (hp, age)            | Interdit (sauf ref minimal)                 |
| **Complexité**  | Interactions objet            | Calculs algorithmiques                      |
| **Héritage**    | Simple (people → doctor)      | Multiple niveaux (atom → molecule → alkane) |
| **Algorithmes** | Logique de jeu                | Hill notation, stœchiométrie                |

## Commandes de compilation

Chaque exercice utilise un Makefile avec dépendances:

```makefile
# Ex05 dépend de ex00, ex01, ex02, ex03, ex04
OCAML_FLAGS = -I ../ex00 -I ../ex01 -I ../ex02 -I ../ex03 -I ../ex04

$(NAME): $(CMX)
	$(OCAMLOPT) $(OCAML_FLAGS) -o $(NAME) \
		../ex00/atom.cmx \
		../ex01/molecule.cmx \
		../ex02/alkane.cmx \
		../ex03/reaction.cmx \
		../ex04/alkane_combustion.cmx \
		$(CMX)
```

Commandes:

- `make`: Compiler
- `make run`: Compiler et exécuter
- `make clean`: Nettoyer fichiers temporaires
- `make fclean`: Nettoyage complet
- `make re`: Recompiler from scratch

## Tests et validation

Chaque exercice inclut un `main.ml` exhaustif testant:

1. **Création** d'instances
2. **Méthodes** de base (to_string, etc.)
3. **Propriétés** spécifiques (formula, equals)
4. **Cas limites** (bounds checking)
5. **Exceptions** (erreurs attendues)
6. **Polymorphisme** (listes hétérogènes)

Exemple de sortie attendue (ex04):

```
Methane (n=1): 2 Methane (CH4) + 5 Dioxygen (O2) -> 2 CO2 + 4 H2O
  Expected: 2 x C1H4 + 5 O2 -> 2 CO2 + 4 H2O
```

Exemple de sortie attendue (ex05):

```
=== Day 21 Ex05: Testing Incomplete Combustion ===

--- Test 1: Ethane incomplete combustion ---
Found 4 incomplete combustion scenarios

Sample outcomes:
With 2 O2: Carbon monoxide (CO) + Carbon (C) + 3 Water (H2O)
With 3 O2: Carbon dioxide (CO2) + Carbon monoxide (CO) + 3 Water (H2O)

--- Test 3: Methane incomplete combustion ---
Found 1 incomplete combustion scenarios

All outcomes:
With 1 O2: Carbon (C) + 2 Water (H2O)
```

## Points d'attention pour la correction

1. ✅ **Classes virtuelles** correctement déclarées
2. ✅ **Notation de Hill** strictement respectée (C, H, alphabétique)
3. ✅ **Style fonctionnel** (pas de for/while/mutable inapproprié)
4. ✅ **Listes associatives** triées en ordre croissant
5. ✅ **Équilibrage stœchiométrique** correct (vérifier formule)
6. ✅ **Exception UnbalancedReaction** lancée au bon moment
7. ✅ **Validation des contraintes** (n entre 1 et 12 pour alkanes)
8. ✅ **Compilation sans warnings**
9. ✅ **Combustion incomplète (Ex05)**: Génération exhaustive des combinaisons CO2/CO/C
10. ✅ **Filtrage correct (Ex05)**: Exclusion des combustions complètes

## Concepts OCaml avancés utilisés

- **Classes virtuelles**: `class virtual`, `method virtual`
- **Héritage**: `inherit parent_class`
- **Upcast**: `(obj :> parent_type)`
- **Références**: `ref`, `:=`, `!` (usage minimal)
- **List functions**: `map`, `fold_left`, `filter`, `init`, `sort`
- **Pattern matching**: sur listes et tuples
- **Exceptions**: `exception`, `raise`, `try...with`
- **Let binding avant objet**: validation pré-construction

## Conclusion

Le Day 21 démontre comment OCaml peut modéliser des domaines scientifiques complexes avec élégance. La combinaison de:

- **OOP** (classes, héritage, polymorphisme)
- **Programmation fonctionnelle** (immutabilité, récursion)
- **Algorithmique** (tri, parsing, calculs)

...permet de créer un système robuste et maintenable pour la chimie computationnelle.

Les contraintes strictes (pas de mutable, style fonctionnel) forcent à penser différemment et produisent du code plus prévisible et testable.
