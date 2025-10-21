# Exercice 04 : Evalexpr is so easy it hurts

## 📋 Description générale

Cet exercice démontre la puissance des **functors OCaml** pour créer des évaluateurs d'expressions génériques. L'objectif est d'implémenter un functor capable de générer des évaluateurs d'expressions selon un module arithmétique donné.

## 🎯 Objectifs pédagogiques

### Concepts fondamentaux

- **Functors avancés** avec contraintes de partage multiples
- **Signatures modulaires** (VAL, EVALEXPR, MAKEEVALEXPR)
- **Substitution destructive** (`:=` vs `=`)
- **Évaluation d'expressions** avec pattern matching récursif
- **Abstraction de types** pour la réutilisabilité

### Compétences techniques

- Diagnostic et résolution d'erreurs de signature
- Architecture modulaire extensible
- Contraintes de partage de types (type sharing)

## 🔧 Architecture technique

### 1. Signature VAL - Interface arithmétique

```ocaml
module type VAL = sig
  type t                    (* Type des valeurs *)
  val add : t -> t -> t     (* Opération d'addition *)
  val mul : t -> t -> t     (* Opération de multiplication *)
end
```

**Rôle** : Définit les opérations arithmétiques de base que tout module arithmétique doit implémenter.

### 2. Signature EVALEXPR - Interface d'évaluateur

```ocaml
module type EVALEXPR = sig
  type t                              (* Type abstrait des valeurs *)
  type expr = Value of t              (* Constructeurs d'expressions *)
            | Add of expr * expr
            | Mul of expr * expr
  val eval : expr -> t                (* Fonction d'évaluation *)
end
```

**Points clés** :

- Type `t` abstrait pour permettre les contraintes
- Type `expr` concret pour exposer les constructeurs
- Fonction `eval` récursive pour l'évaluation

### 3. Functor MakeEvalExpr - Générateur d'évaluateurs

```ocaml
module MakeEvalExpr : MAKEEVALEXPR =
  functor (V : VAL) -> struct
    type t = V.t                      (* Partage de type explicite *)
    type expr = Value of t | Add of expr * expr | Mul of expr * expr

    let rec eval = function           (* Pattern matching récursif *)
      | Value v -> v
      | Add (e1, e2) -> V.add (eval e1) (eval e2)
      | Mul (e1, e2) -> V.mul (eval e1) (eval e2)
  end
```

## ⚡ Contraintes de partage - Analyse détaillée

### Problème initial

Le code fourni dans l'énoncé **échoue intentionnellement** à la compilation pour enseigner les contraintes de partage.

### Les 7 contraintes identifiées

1. **Modules VAL** (3 contraintes)

   ```ocaml
   module IntVal : VAL with type t = int = struct ... end
   module FloatVal : VAL with type t = float = struct ... end
   module StringVal : VAL with type t = string = struct ... end
   ```

2. **Signature functor** (1 contrainte)

   ```ocaml
   module type MAKEEVALEXPR =
     functor (V : VAL) -> EVALEXPR with type t = V.t
   ```

3. **Modules finaux** (3 contraintes avec substitution destructive)
   ```ocaml
   module IntEvalExpr : EVALEXPR with type t := int = MakeEvalExpr (IntVal)
   module FloatEvalExpr : EVALEXPR with type t := float = MakeEvalExpr (FloatVal)
   module StringEvalExpr : EVALEXPR with type t := string = MakeEvalExpr (StringVal)
   ```

### Substitution destructive (`:=`)

- **`with type t = int`** : Crée un alias, `t` reste accessible
- **`with type t := int`** : Substitution complète, `t` disparaît de la signature

## 🧪 Tests et validation

### Expressions de test

```ocaml
let ie = IntEvalExpr.Add (IntEvalExpr.Value 40, IntEvalExpr.Value 2)
let fe = FloatEvalExpr.Add (FloatEvalExpr.Value 41.5, FloatEvalExpr.Value 0.92)
let se = StringEvalExpr.Mul (StringEvalExpr.Value "very ",
                           (StringEvalExpr.Add (StringEvalExpr.Value "very long",
                                              StringEvalExpr.Value "short")))
```

### Résultats attendus

```
Res = 42
Res = 42.420000
Res = very very long
```

### Logique des calculs

- **Int** : `40 + 2 = 42`
- **Float** : `41.5 + 0.92 = 42.42`
- **String** : `"very " ^ max("very long", "short") = "very very long"`

## 🔍 Analyse des erreurs courantes

### 1. `Unbound constructor`

**Cause** : Type `expr` non exposé dans la signature
**Solution** : Définir `expr` explicitement dans `EVALEXPR`

### 2. `Type mismatch: expected int, found IntVal.t`

**Cause** : Absence de contrainte sur les modules VAL  
**Solution** : Ajouter `with type t = int` aux modules VAL

### 3. `Signature mismatch on type t`

**Cause** : Pas de contrainte sur le functor
**Solution** : Ajouter `with type t = V.t` à `MAKEEVALEXPR`

## 🚀 Extensions possibles

### 1. Opérations supplémentaires

```ocaml
module type EXTENDED_VAL = sig
  include VAL
  val sub : t -> t -> t    (* Soustraction *)
  val div : t -> t -> t    (* Division *)
  val zero : t             (* Élément neutre *)
end
```

### 2. Expressions conditionnelles

```ocaml
type 'a expr =
  | Value of 'a
  | Add of 'a expr * 'a expr
  | Mul of 'a expr * 'a expr
  | If of ('a -> bool) * 'a expr * 'a expr
```

### 3. Variables et environnements

```ocaml
type 'a expr =
  | Var of string
  | Value of 'a
  | Let of string * 'a expr * 'a expr

val eval_with_env : (string * 'a) list -> 'a expr -> 'a
```

## 📚 Concepts théoriques

### Functors vs Fonctions

- **Fonctions** : Transforment des valeurs
- **Functors** : Transforment des modules
- **Avantage** : Type safety au niveau module

### Pattern du Functor Factory

Ce pattern permet de créer des familles de modules liés avec garanties de type au moment de la compilation.

### Abstraction de types

L'utilisation de types abstraits (`type t`) permet la réutilisabilité tout en gardant la sécurité de types.

## 🎓 Conclusion

Cet exercice illustre parfaitement la puissance des functors OCaml pour créer des architectures modulaires et extensibles. La maîtrise des contraintes de partage est essentielle pour exploiter pleinement le système de modules d'OCaml.

**Compétences acquises** :

- Diagnostic d'erreurs de signature complexes
- Architecture fonctorielle avancée
- Substitution destructive et partage de types
- Design patterns modulaires OCaml
