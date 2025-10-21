# Exercice 02 : Projections

## Vue d'ensemble

Cet exercice marque la **première création de foncteurs personnalisés**. L'objectif est d'implémenter les foncteurs `MakeFst` et `MakeSnd` qui extraient respectivement le premier et le second élément d'une paire, ainsi que leur signature commune `MAKEPROJECTION`.

## Concepts clés

### 1. Création de foncteurs

Un **foncteur** est une fonction au niveau des modules. Sa création suit cette syntaxe :

```ocaml
module MonFoncteur = functor (Param : SIGNATURE_PARAM) -> struct
  (* implémentation *)
end
```

### 2. Signatures de foncteurs

Une **signature de foncteur** définit le type d'un foncteur :

```ocaml
module type MA_SIGNATURE_FONCTEUR = functor (P : INPUT) -> OUTPUT
```

### 3. Projections

Les **projections** extraient des composantes d'une structure de données :

- **Première projection** : `fst (a, b) = a`
- **Seconde projection** : `snd (a, b) = b`

## Architecture de la solution

### Étape 1 : Analyse des types fournis

```ocaml
module type PAIR = sig val pair : (int * int) end
module type VAL = sig val x : int end
```

**Analyse :**

- `PAIR` : Module contenant une paire d'entiers
- `VAL` : Module contenant un entier nommé `x`
- **Relation** : Les foncteurs transforment `PAIR` en `VAL`

### Étape 2 : Déduction de MAKEPROJECTION

L'énoncé mentionne cette signature sans la définir. Par déduction logique :

```ocaml
module type MAKEPROJECTION = functor (P : PAIR) -> VAL
```

**Justification :**

- **Entrée** : Module respectant `PAIR`
- **Sortie** : Module respectant `VAL`
- **Cohérence** : Utilisé par `MakeFst` et `MakeSnd`

### Étape 3 : Implémentation des foncteurs

#### MakeFst - Première projection

```ocaml
module MakeFst : MAKEPROJECTION = functor (P : PAIR) -> struct
  let x = Stdlib.fst P.pair
end
```

**Analyse technique :**

- **Paramètre** : `P` respectant `PAIR`
- **Extraction** : `Stdlib.fst P.pair`
- **Résultat** : Module avec `x = premier_élément`

#### MakeSnd - Seconde projection

```ocaml
module MakeSnd : MAKEPROJECTION = functor (P : PAIR) -> struct
  let x = Stdlib.snd P.pair
end
```

**Analyse technique :**

- **Paramètre** : `P` respectant `PAIR`
- **Extraction** : `Stdlib.snd P.pair`
- **Résultat** : Module avec `x = second_élément`

## Comportement attendu

### Code de test

```ocaml
module Pair : PAIR = struct let pair = ( 21, 42 ) end
module Fst : VAL = MakeFst (Pair)
module Snd : VAL = MakeSnd (Pair)
```

### Exécution

```ocaml
Printf.printf "Fst.x = %d, Snd.x = %d\n" Fst.x Snd.x
```

### Sortie attendue

```
Fst.x = 21, Snd.x = 42
```

**Explication :**

- `Pair.pair = (21, 42)`
- `MakeFst(Pair)` produit un module avec `x = 21`
- `MakeSnd(Pair)` produit un module avec `x = 42`

## Contraintes et respect des règles

### 1. Fonctions autorisées

**Uniquement** : `Stdlib.fst` et `Stdlib.snd`

**Implémentation conforme :**

```ocaml
let x = Stdlib.fst P.pair  (* ✓ Autorisé *)
let x = Stdlib.snd P.pair  (* ✓ Autorisé *)
```

**Alternatives interdites :**

```ocaml
let x = match P.pair with (a, _) -> a  (* ✗ Pattern matching interdit *)
let x = let (a, _) = P.pair in a       (* ✗ Destructuring interdit *)
```

### 2. Signatures exactes

Les signatures doivent permettre au code fourni de compiler sans modification.

### 3. Noms imposés

- `MakeFst` et `MakeSnd` : noms des foncteurs
- `MAKEPROJECTION` : signature commune
- `Fst.x` et `Snd.x` : utilisation dans le test

## Alternatives d'implémentation

### 1. Foncteurs génériques

```ocaml
module type GENERIC_PAIR = sig
  type 'a pair_type = 'a * 'a
  val pair : int pair_type
end

module type MAKEPROJECTION_GENERIC =
  functor (P : GENERIC_PAIR) -> VAL
```

**Limitation :** Plus complexe que nécessaire pour cet exercice.

### 2. Foncteurs avec contraintes de type

```ocaml
module MakeFst (P : sig val pair : 'a * 'b end) : sig val x : 'a end = struct
  let x = Stdlib.fst P.pair
end
```

**Limitation :** Ne respecte pas les signatures imposées `PAIR` et `VAL`.

### 3. Signature avec paramètres de type

```ocaml
module type MAKEPROJECTION_POLY =
  functor (P : sig val pair : 'a * 'b end) -> sig val x : 'a end
```

**Limitation :** L'exercice cible spécifiquement `int * int`.

## Analyse approfondie des foncteurs

### 1. Mécanisme d'application

```ocaml
module Fst : VAL = MakeFst (Pair)
```

**Étapes :**

1. `MakeFst` : foncteur `PAIR → VAL`
2. `Pair` : module respectant `PAIR`
3. `MakeFst(Pair)` : application du foncteur
4. **Résultat** : module respectant `VAL`

### 2. Vérification de types

Le système de types OCaml vérifie :

- `Pair` respecte `PAIR` ✓
- `MakeFst` respecte `MAKEPROJECTION` ✓
- `MakeFst(Pair)` respecte `VAL` ✓

### 3. Évaluation différée

Les foncteurs ne sont évalués qu'à l'application :

```ocaml
(* Déclaration : pas d'évaluation *)
module MakeFst = functor (P : PAIR) -> struct ... end

(* Application : évaluation de Stdlib.fst P.pair *)
module Fst = MakeFst (Pair)
```

## Comparaison avec d'autres approches

### 1. Fonctions vs Foncteurs

**Avec fonctions :**

```ocaml
let extract_fst pair = Stdlib.fst pair
let extract_snd pair = Stdlib.snd pair
```

**Avantages des foncteurs :**

- **Encapsulation** : Création de modules complets
- **Namespace** : `Fst.x` au lieu de valeurs libres
- **Extensibilité** : Possibilité d'ajouter d'autres fonctions

### 2. Classes vs Modules

**Avec classes (non applicable ici) :**

```ocaml
class projection pair = object
  method fst = Stdlib.fst pair
  method snd = Stdlib.snd pair
end
```

**Pourquoi les modules ici :**

- **Simplicité** : Pas besoin d'instanciation
- **Performance** : Pas de surcoût d'objet
- **Conformité** : Respect de l'énoncé

## Tests et validation

### Tests de base

```ocaml
let test_projections () =
  let module TestPair = struct let pair = (10, 20) end in
  let module TestFst = MakeFst(TestPair) in
  let module TestSnd = MakeSnd(TestPair) in
  assert (TestFst.x = 10);
  assert (TestSnd.x = 20);
  print_endline "Tests réussis"
```

### Tests avec différentes paires

```ocaml
let test_multiple_pairs () =
  let pairs = [(1, 2); (100, 200); (-5, -10)] in
  List.iter (fun (a, b) ->
    let module P = struct let pair = (a, b) end in
    let module F = MakeFst(P) in
    let module S = MakeSnd(P) in
    assert (F.x = a);
    assert (S.x = b)
  ) pairs
```

### Résultats des tests complets

```
╔══════════════════════════════════════════════════════════════════╗
║                    Tests complets - Exercice 02                  ║
║                         Projections                              ║
╚══════════════════════════════════════════════════════════════════╝

=== Test du cas original ===
Fst.x = 21, Snd.x = 42
✓ Test original réussi

=== Test avec différentes paires ===
Test petits entiers : (1, 2) -> Fst=1, Snd=2
Test entiers moyens : (100, 200) -> Fst=100, Snd=200
Test entiers négatifs : (-5, -10) -> Fst=-5, Snd=-10
Test avec zéro : (0, 42) -> Fst=0, Snd=42
Test valeurs différentes : (999, 1) -> Fst=999, Snd=1
✓ Tous les tests de paires réussis

=== Test de vérification des types ===
TestPair.pair = (123, 456)
TestFst.x = 123
TestSnd.x = 456
✓ Vérification des types réussie

=== Test d'utilisation de Stdlib ===
Direct Stdlib.fst = 789, MakeFst = 789
Direct Stdlib.snd = 101112, MakeSnd = 101112
✓ Utilisation correcte de Stdlib confirmée

╔══════════════════════════════════════════════════════════════════╗
║                       Tous les tests réussis !                   ║
║              MakeFst et MakeSnd fonctionnent correctement         ║
╚══════════════════════════════════════════════════════════════════╝
```

### Tests de compilation

```bash
# Vérification que le code compile sans erreur
ocamlopt ex02.ml -o ex02

# Vérification de la sortie
./ex02 | grep "Fst.x = 21, Snd.x = 42"

# Tests complets
ocamlopt tests.ml -o tests && ./tests
```

## Erreurs courantes à éviter

### 1. Signature incorrecte

```ocaml
(* MAUVAIS *)
module type MAKEPROJECTION = PAIR -> VAL  (* Pas un foncteur *)

(* CORRECT *)
module type MAKEPROJECTION = functor (P : PAIR) -> VAL
```

### 2. Utilisation de fonctions interdites

```ocaml
(* MAUVAIS *)
let x = match P.pair with (a, _) -> a

(* CORRECT *)
let x = Stdlib.fst P.pair
```

### 3. Noms de variables incorrects

```ocaml
(* MAUVAIS *)
module MakeFst = functor (P : PAIR) -> struct
  let value = Stdlib.fst P.pair  (* 'value' au lieu de 'x' *)
end

(* CORRECT *)
let x = Stdlib.fst P.pair
```

### 4. Signature de retour oubliée

```ocaml
(* MOINS PRÉCIS *)
module MakeFst = functor (P : PAIR) -> struct ... end

(* PLUS PRÉCIS *)
module MakeFst : MAKEPROJECTION = functor (P : PAIR) -> struct ... end
```

## Bonnes pratiques

### 1. Documentation des foncteurs

```ocaml
(**
 * MakeFst : Foncteur d'extraction du premier élément
 * @param P Module contenant une paire d'entiers
 * @return Module contenant le premier élément dans x
 *)
module MakeFst : MAKEPROJECTION = ...
```

### 2. Tests exhaustifs

```ocaml
let () =
  test_projections ();
  test_multiple_pairs ();
  print_endline "Tous les tests passent"
```

### 3. Signatures explicites

Toujours annoter les foncteurs avec leur signature pour clarifier l'interface.

## Applications pratiques

### 1. Extraction de coordonnées

```ocaml
module type POINT = sig val point : (int * int) end
module GetX = MakeFst
module GetY = MakeSnd

let module Origin = struct let pair = (0, 0) end in
let module X = GetX(Origin) in
let module Y = GetY(Origin) in
Printf.printf "Origine : (%d, %d)\n" X.x Y.x
```

### 2. Parsing de tuples

```ocaml
module type PARSED_PAIR = sig val pair : (int * int) end

let parse_pair_to_modules pair_str =
  (* parsing de "21,42" vers (21, 42) *)
  let module ParsedPair = struct let pair = parsed_result end in
  let module First = MakeFst(ParsedPair) in
  let module Second = MakeSnd(ParsedPair) in
  (First.x, Second.x)
```

## Conclusion

Cet exercice illustre parfaitement :

- **La création de foncteurs personnalisés**
- **L'importance des signatures dans l'écosystème des modules**
- **L'utilisation contrainte des fonctions de la bibliothèque standard**
- **Les mécanismes de projection en programmation fonctionnelle**

L'implémentation respecte scrupuleusement toutes les contraintes tout en démontrant la puissance du système de modules d'OCaml pour créer des abstractions réutilisables et type-safe.
