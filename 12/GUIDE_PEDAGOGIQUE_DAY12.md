# Guide Pédagogique - Day 12 : Foncteurs OCaml

## Table des matières

1. [Vue d'ensemble du Day 12](#vue-densemble)
2. [Exercice 00 : Set.Make et les foncteurs de base](#ex00)
3. [Exercice 01 : Hashtbl.Make et les fonctions de hachage](#ex01)
4. [Exercice 02 : Création de foncteurs personnalisés](#ex02)
5. [Exercice 03 : Nombres à virgule fixe paramétriques](#ex03)
6. [Exercice 04 : Évaluateur d'expressions fonctoriel](#ex04)
7. [Analyse critique et progression pédagogique](#analyse)

---

## 1. Vue d'ensemble du Day 12 {#vue-densemble}

### Objectif global

Le Day 12 constitue une **progression pédagogique structurée** vers la maîtrise des **foncteurs OCaml**, l'un des concepts les plus puissants du système de modules d'OCaml. Un foncteur est essentiellement une **fonction au niveau des modules** : il prend un ou plusieurs modules en paramètres et retourne un nouveau module.

### Pourquoi les foncteurs ?

**Problème résolu** : Comment créer du code générique et réutilisable sans perdre la sécurité des types d'OCaml ?

**Analogie** : Si les fonctions permettent de paramétrer du code par des valeurs, les foncteurs permettent de paramétrer du code par des **structures entières** (types + fonctions + valeurs).

### Progression pédagogique du Day 12

```
ex00 → Utiliser un foncteur existant (Set.Make)
ex01 → Utiliser un autre foncteur existant (Hashtbl.Make)
ex02 → Créer ses propres foncteurs simples
ex03 → Créer un foncteur paramétrique avancé
ex04 → Maîtriser les contraintes de partage de types
```

Cette progression suit le principe **"apprendre en faisant"** :

1. Observer comment fonctionnent les foncteurs standards
2. Comprendre leurs interfaces
3. Créer ses propres foncteurs
4. Résoudre des problèmes complexes de typage

---

## 2. Exercice 00 : Set.Make et les foncteurs de base {#ex00}

### Contexte et objectif

**Mission** : Créer un `StringSet`, un module permettant de manipuler des ensembles de chaînes de caractères ordonnées.

### Qu'est-ce qu'un foncteur ?

Un **foncteur** est une fonction qui :

- Prend un module en paramètre
- Retourne un nouveau module
- Est évalué au moment de la compilation

**Syntaxe** :

```ocaml
module MonModule = MonFoncteur(ParametreModule)
```

### Anatomie de Set.Make

Le foncteur `Set.Make` de la bibliothèque standard :

**Signature attendue en entrée** :

```ocaml
module type OrderedType = sig
  type t
  val compare : t -> t -> int
end
```

**Signature retournée** :

```ocaml
module type S = sig
  type elt  (* type des éléments *)
  type t    (* type de l'ensemble *)
  val empty : t
  val add : elt -> t -> t
  val mem : elt -> t -> bool
  val iter : (elt -> unit) -> t -> unit
  val fold : (elt -> 'a -> 'a) -> t -> 'a -> 'a
  (* ... et bien d'autres *)
end
```

### Analyse du code de l'ex00

```ocaml
module StringOrderedType = struct
  type t = string
  let compare = String.compare
end
```

**Question critique** : Pourquoi cette simplicité ?

- `String.compare` respecte déjà la sémantique requise (retourne <0, 0, >0)
- Pas besoin de réinventer la roue
- Principe de réutilisation du code

```ocaml
module StringSet = Set.Make(StringOrderedType)
```

**Ce qui se passe ici** :

1. `Set.Make` reçoit `StringOrderedType` en paramètre
2. Il génère un nouveau module avec toutes les opérations sur les ensembles
3. Les types sont instantiés : `elt = string`, `t = ensemble de strings`

### Pourquoi l'ordre est-il lexicographique ?

```ocaml
let set = List.fold_right StringSet.add
  [ "foo"; "bar"; "baz"; "qux" ] StringSet.empty
```

**Résultat** : `bar`, `baz`, `foo`, `qux`

**Explication** :

- `String.compare` utilise l'ordre lexicographique ASCII
- `Set.Make` crée un **arbre binaire de recherche équilibré**
- L'itération parcourt l'arbre en ordre croissant
- Ordre garanti : `'b' < 'f' < 'q'`

### Concepts clés appris

1. **Foncteur = générateur de modules**
2. **OrderedType = contrat d'interface**
3. **Ordre total requis** : la fonction `compare` doit être cohérente
4. **Réutilisabilité** : un seul foncteur pour tous les types ordonnables

---

## 3. Exercice 01 : Hashtbl.Make et les fonctions de hachage {#ex01}

### Différence conceptuelle avec Set

| Aspect                   | Set.Make        | Hashtbl.Make         |
| ------------------------ | --------------- | -------------------- |
| **Structure**            | Arbre équilibré | Table de hachage     |
| **Ordre**                | Oui (garanti)   | Non (hash-dépendant) |
| **Complexité recherche** | O(log n)        | O(1) moyen           |
| **Signature requise**    | OrderedType     | HashedType           |

### La signature HashedType

```ocaml
module type HashedType = sig
  type t
  val equal : t -> t -> bool
  val hash : t -> int
end
```

**Différence cruciale** : `hash` au lieu de `compare`

### Qu'est-ce qu'une fonction de hachage ?

Une fonction de hachage transforme une donnée arbitraire en un entier :

- **Déterministe** : même entrée → même sortie
- **Uniforme** : distribution équitable des valeurs
- **Rapide** : calcul en temps constant ou linéaire

### L'algorithme djb2

```ocaml
let hash str =
  let len = String.length str in
  let rec hash_aux acc i =
    if i >= len then acc
    else
      let char_code = Char.code (String.get str i) in
      let new_acc = ((acc lsl 5) + acc) + char_code in
      hash_aux new_acc (i + 1)
  in
  hash_aux 5381 0
```

**Décomposition** :

- `acc lsl 5` = `acc * 32` (décalage de 5 bits)
- `(acc lsl 5) + acc` = `acc * 33`
- Formule : `hash(i) = hash(i-1) * 33 + char[i]`

**Pourquoi 33 ?** Choix empirique de Daniel J. Bernstein :

- Nombre premier proche d'une puissance de 2
- Bon compromis entre vitesse et distribution
- Performance prouvée sur millions de chaînes

**Pourquoi 5381 ?** Valeur d'initialisation qui améliore la distribution statistique.

### Analyse critique : pourquoi djb2 et pas autre chose ?

**Contrainte de l'énoncé** : "fonction de hachage vraie et connue"

**Alternatives écartées** :

- `String.length` : trop de collisions (tous les mots de même longueur)
- `Hashtbl.hash` : pas "vraie" au sens algorithmique
- CRC32, MD5 : trop lents pour ce cas d'usage

**djb2 est optimal ici** :

- Rapide (une seule passe)
- Bien documenté
- Distribution acceptable
- Utilise uniquement `String.get` et `String.length`

### Ordre non déterministe

```ocaml
StringHashtbl.iter (fun k v ->
  Printf.printf "k = \"%s\", v = %d\n" k v) ht
```

**Résultat possible** : ordre imprévisible

**Pourquoi ?**

- Position dans la table = `hash(key) mod taille_table`
- L'ordre d'itération suit l'ordre interne du tableau
- Changez la fonction de hachage → changez l'ordre

### Concepts clés appris

1. **Différence Set vs Hashtbl** : ordre vs performance
2. **Fonction de hachage** : algorithme, distribution, performance
3. **Ordre non déterministe** : conséquence du hachage
4. **Choix algorithmiques** : pourquoi djb2 est adapté

---

## 4. Exercice 02 : Création de foncteurs personnalisés {#ex02}

### Objectif : créer ses propres foncteurs

**Mission** : Implémenter `MakeFst` et `MakeSnd`, deux foncteurs qui extraient respectivement le premier et le second élément d'une paire.

### Anatomie d'un foncteur personnalisé

**Signature du foncteur** :

```ocaml
module type MAKEPROJECTION = functor (P : PAIR) -> VAL
```

**Décomposition** :

- `functor` : mot-clé déclarant un foncteur
- `(P : PAIR)` : paramètre de type `PAIR`
- `-> VAL` : type du module retourné

### Implémentation

```ocaml
module MakeFst : MAKEPROJECTION = functor (P : PAIR) -> struct
  let x = Stdlib.fst P.pair
end
```

**Ce qui se passe** :

1. Réception d'un module `P` contenant `pair : (int * int)`
2. Extraction du premier élément avec `fst`
3. Création d'un nouveau module avec `x : int`

### Pourquoi cette abstraction ?

**Question provocante** : Pourquoi ne pas simplement écrire `fst (21, 42)` ?

**Réponses** :

1. **Modularité** : le foncteur est réutilisable pour n'importe quelle paire
2. **Encapsulation** : la paire peut provenir d'un contexte complexe
3. **Composition** : on peut chaîner des foncteurs
4. **Pédagogie** : comprendre la mécanique des foncteurs simples avant les complexes

### Analyse critique : un exercice simpliste ?

**Apparence** : trop simple, presque trivial

**Réalité pédagogique** :

- Comprendre la **syntaxe des foncteurs** sans complexité métier
- Différencier **signature de foncteur** vs **implémentation**
- Préparer aux foncteurs plus complexes (ex03, ex04)

**Analogie** : apprendre à faire des crêpes avant de faire un mille-feuille

### Concepts clés appris

1. **Créer un foncteur** : syntaxe `functor (Param : SIG) -> struct ... end`
2. **Signature de foncteur** : `module type NAME = functor (...) -> ...`
3. **Accès aux membres** : `P.pair` pour accéder au contenu du paramètre
4. **Simplicité intentionnelle** : fondations avant complexité

---

## 5. Exercice 03 : Nombres à virgule fixe paramétriques {#ex03}

### Contexte : pourquoi les nombres à virgule fixe ?

**Problème des flottants** :

- Imprécision : `0.1 + 0.2 ≠ 0.3`
- Performance variable selon le CPU
- Non déterministes dans certains cas

**Solution : fixed-point arithmetic**

- Représentation entière avec "décalage" implicite
- Précision fixe et prévisible
- Performance constante

### Format Q notation

**Q m.n** : m bits entiers, n bits fractionnaires

**Exemple Fixed4 (Q28.4)** :

- 4 bits fractionnaires
- 28 bits entiers (sur système 32 bits)
- Résolution = 1 / 2^4 = 1/16 = 0.0625

**Exemple Fixed8 (Q24.8)** :

- 8 bits fractionnaires
- 24 bits entiers
- Résolution = 1 / 2^8 = 1/256 ≈ 0.00390625

### Différence Fixed4 vs Fixed8 : analyse rigoureuse

| Aspect                  | Fixed4        | Fixed8            |
| ----------------------- | ------------- | ----------------- |
| **Bits fractionnaires** | 4             | 8                 |
| **Résolution**          | 0.0625        | 0.00390625        |
| **Précision**           | ±0.03125      | ±0.001953125      |
| **Plage entière**       | ±2^27         | ±2^23             |
| **Trade-off**           | Plus de range | Plus de précision |

**Choix d'usage** :

- **Fixed4** : compteurs, coordonnées de jeu, pas besoin de haute précision
- **Fixed8** : calculs scientifiques légers, graphismes, audio

### Représentation interne

**Conversion float → fixed** :

```ocaml
let of_float f = int_of_float (f *. scale_factor_float +. 0.5)
```

**Exemple avec Fixed4** (scale_factor = 16) :

- `1.5` → `1.5 * 16 + 0.5` → `24.5` → `24`
- En binaire : `24 = 0b11000 = 1.1000 en Q28.4`
- Lecture : 1 + 1\*2^(-1) = 1.5 ✓

**Le +0.5** : arrondi au plus proche (au lieu de troncature)

### Pourquoi itérer sur Fixed4 donne 17 itérations (pas 16) ?

**Code** :

```ocaml
Fixed4.foreach (Fixed4.zero) (Fixed4.one) (fun f -> ...)
```

**Calcul** :

- `zero` = 0 (représentation interne)
- `one` = 16 (représentation interne avec Fixed4)
- `succ` incrémente de 1
- Boucle : 0, 1, 2, ..., 15, 16
- **Total : 17 valeurs** (0 à 16 inclus)

**En valeurs réelles** :

```
0.0, 0.0625, 0.125, 0.1875, 0.25, 0.3125, 0.375, 0.4375,
0.5, 0.5625, 0.625, 0.6875, 0.75, 0.8125, 0.875, 0.9375, 1.0
```

**Analyse critique de la question** :

- Vous disiez "16 itérations" → **erreur courante**
- La réalité : **17 itérations** (boucle inclusive sur les bornes)
- Confusion classique : compter les intervalles vs compter les points

### Arithmétique : pourquoi les décalages ?

**Addition** : directe

```ocaml
let add x y = x + y
```

Justification : `(a * 2^n) + (b * 2^n) = (a+b) * 2^n` ✓

**Multiplication** : renormalisation nécessaire

```ocaml
let mul x y = (x * y) asr FB.bits
```

Justification : `(a * 2^n) * (b * 2^n) = (a*b) * 2^(2n)` → diviser par `2^n`

**Division** : pré-scaling nécessaire

```ocaml
let div x y = (x lsl FB.bits) / y
```

Justification : `(a * 2^n) / (b * 2^n) = a/b` → multiplier numérateur par `2^n`

### Concepts clés appris

1. **Fixed-point** : alternative aux flottants pour précision contrôlée
2. **Paramétrage par foncteur** : `Make(struct let bits = 4 end)`
3. **Trade-off précision/range** : Fixed4 vs Fixed8
4. **Itération inclusive** : 17 valeurs de 0.0 à 1.0 (pas 16)
5. **Arithmétique avec shifts** : optimisation et correction d'échelle

---

## 6. Exercice 04 : Évaluateur d'expressions fonctoriel {#ex04}

### Objectif : généricité maximale

**Mission** : Créer un évaluateur d'expressions qui fonctionne pour **n'importe quel type** disposant d'opérations `add` et `mul`.

### Architecture du système

```
VAL (signature d'arithmétique)
  ↓
MakeEvalExpr (foncteur)
  ↓
EVALEXPR (signature d'évaluateur)
```

**Instanciations** :

- `IntEvalExpr` = `MakeEvalExpr(IntVal)`
- `FloatEvalExpr` = `MakeEvalExpr(FloatVal)`
- `StringEvalExpr` = `MakeEvalExpr(StringVal)`

### Le problème des contraintes de partage de types

**Problème initial** :

```ocaml
module IntEvalExpr : EVALEXPR = MakeEvalExpr (IntVal)
```

**Erreur de compilation** : les constructeurs `Value`, `Add`, `Mul` ne sont pas accessibles !

**Pourquoi ?** Le type `expr` est **abstrait** dans la signature `EVALEXPR`.

### Solution 1 : exposer le type expr dans la signature

```ocaml
module type EVALEXPR = sig
  type t
  type expr =
    | Value of t
    | Add of expr * expr
    | Mul of expr * expr
  val eval : expr -> t
end
```

**Impact** : les constructeurs deviennent visibles de l'extérieur.

### Solution 2 : substitution destructive

```ocaml
module IntEvalExpr : EVALEXPR with type t := int =
  MakeEvalExpr (IntVal)
```

**Opérateur `:=`** : remplace le type abstrait `t` par `int` **et supprime `t` de la signature**.

**Différence avec `=`** :

- `with type t = int` : ajoute une égalité de type (t reste présent)
- `with type t := int` : **remplace et efface** t (substitution destructive)

### Les 7 contraintes de partage

**Énoncé** : "6-7 contraintes de partage requises"

**Inventaire** :

1. `IntVal : VAL with type t = int`
2. `FloatVal : VAL with type t = float`
3. `StringVal : VAL with type t = string`
4. `MAKEEVALEXPR : functor (V : VAL) -> EVALEXPR with type t = V.t`
5. `IntEvalExpr : EVALEXPR with type t := int`
6. `FloatEvalExpr : EVALEXPR with type t := float`
7. `StringEvalExpr : EVALEXPR with type t := string`

**Total : 7 contraintes** ✓

### StringVal : arithmétique sur chaînes

```ocaml
module StringVal : VAL with type t = string = struct
  type t = string
  let add s1 s2 = if (String.length s1) > (String.length s2) then s1 else s2
  let mul = ( ^ )
end
```

**Sémantique** :

- `add` = maximum par longueur (sélection)
- `mul` = concaténation

**Résultat du test** :

```ocaml
StringEvalExpr.Mul (
  Value "very ",
  Add (Value "very long", Value "short")
)
```

= `"very " ^ max_by_length("very long", "short")`
= `"very " ^ "very long"`
= `"very very long"`

### Analyse critique : pourquoi cette complexité ?

**Question provocante** : Pourquoi ne pas simplement utiliser des fonctions polymorphes ?

**Réponse** :

1. **Type safety** : le système de types garantit la cohérence
2. **Extensibilité** : ajouter un nouveau type arithmétique = créer un module `VAL`
3. **Séparation des préoccupations** : logique d'évaluation ≠ logique arithmétique
4. **Réutilisabilité** : `MakeEvalExpr` fonctionne pour tout `VAL` actuel et futur

**Cas d'usage réel** : calculatrice symbolique, DSL (Domain Specific Languages), compilateurs

### Concepts clés appris

1. **Foncteur générique** : un seul code pour tous les types
2. **Contraintes de partage** : `with type t = ...` pour exposer les types
3. **Substitution destructive** : `with type t := ...` pour remplacer
4. **Composition de foncteurs** : plusieurs instanciations d'un même foncteur
5. **Architecture extensible** : ajouter de nouveaux types sans modifier `MakeEvalExpr`

---

## 7. Analyse critique et progression pédagogique {#analyse}

### Critique de la progression

**Forces** :

1. **Gradualité** : de l'utilisation à la création
2. **Concret avant abstrait** : Set/Hashtbl avant foncteurs custom
3. **Difficulté croissante** : ex02 simple, ex04 complexe
4. **Diversité** : structures de données, arithmétique, évaluateur

**Faiblesses potentielles** :

1. **Gap ex02 → ex03** : le saut de complexité est brutal
2. **Manque d'intermédiaire** : pourquoi pas un foncteur avec 2 paramètres ?
3. **Ex02 trop simple** : risque de sous-estimation de la difficulté suivante

### Questions non résolues (volontairement ?)

1. **Pourquoi pas de foncteurs à plusieurs paramètres ?**

   - `functor (A : SIG1) (B : SIG2) -> ...` existe en OCaml
   - Absent du Day 12 : choix pédagogique ou limitation du temps ?

2. **Applicative functors** : non abordés

   - `module F = Make(A)(B)` vs `module F = Make(struct include A include B end)`

3. **First-class modules** : non abordés
   - Passage de modules comme valeurs

### Compétences acquises après le Day 12

**Niveau débutant → intermédiaire** :

- ✅ Comprendre ce qu'est un foncteur
- ✅ Utiliser des foncteurs standards
- ✅ Créer des foncteurs simples
- ✅ Gérer les contraintes de partage de types

**Compétences manquantes pour niveau avancé** :

- ❌ Foncteurs à plusieurs paramètres
- ❌ Foncteurs applicatifs
- ❌ First-class modules
- ❌ Pack/unpack de modules

### Mise en perspective : utilité réelle des foncteurs

**Cas d'usage en production** :

1. **Bibliothèques génériques** : Core, Jane Street Belt
2. **Structures de données paramétriques** : Map, Set, Hashtbl personnalisés
3. **DSL (Domain Specific Languages)** : parsers, évaluateurs
4. **Systèmes de types avancés** : GADTs avec foncteurs

**Écosystème OCaml** :

- 70% des bibliothèques utilisent des foncteurs
- Pattern fondamental du langage
- Différenciateur face à d'autres langages fonctionnels

### Erreurs courantes à éviter

1. **Confondre foncteur et fonction**

   - Foncteur = niveau module (compile-time)
   - Fonction = niveau valeur (run-time)

2. **Oublier les contraintes de partage**

   - Résultat : types abstraits inutilisables

3. **Sur-utiliser les foncteurs**

   - Parfois une simple fonction polymorphe suffit
   - Règle : foncteur si on a besoin de plusieurs fonctions cohérentes

4. **Négliger la documentation des signatures**
   - Une signature mal documentée rend le foncteur inutilisable

### Recommandations pour aller plus loin

**Lecture** :

- "Real World OCaml" - Chapter 9 (Functors)
- "OCaml from the Very Beginning" - Advanced Modules
- Documentation officielle OCaml sur les modules

**Exercices complémentaires** :

1. Créer un `OrderedHashtbl` combinant ordre et hachage
2. Implémenter un foncteur `MakePriorityQueue(Ord : OrderedType)`
3. Créer un système de plugins avec foncteurs

**Projets** :

- Mini-compilateur avec évaluateur fonctoriel
- Bibliothèque de structures de données génériques
- DSL pour un domaine spécifique (finance, graphiques, etc.)

---

## Conclusion

Le **Day 12** est un pivot dans l'apprentissage d'OCaml : il marque le passage de la programmation fonctionnelle simple à l'**ingénierie logicielle modulaire avancée**.

Les foncteurs ne sont pas qu'un exercice académique : ils sont le **fondement de l'architecture des grandes bases de code OCaml**. Maîtriser les foncteurs, c'est maîtriser la capacité à créer du code **générique, type-safe, et maintenable**.

**Question finale pour réflexion** : Les foncteurs sont-ils vraiment nécessaires, ou sont-ils juste une complication académique d'OCaml ?

**Réponse courte** : Ils sont nécessaires dès que votre codebase dépasse 1000 lignes et nécessite de la réutilisabilité sans sacrifier la sécurité des types.

**Réponse longue** : Les langages sans système de modules aussi puissant (Haskell avec typeclasses, Rust avec traits) ont développé leurs propres mécanismes. Les foncteurs d'OCaml sont une solution élégante à un problème universel en génie logiciel : **comment abstraire sans perdre la garantie de cohérence ?**
