# Jour 30 — Monoïdes et Monades en OCaml

Document d'explication pour la défense. Conçu pour un lecteur qui ne connaît **ni OCaml, ni les modules, ni les notions algébriques utilisées**.

---

## 1. Vue d'ensemble

Le jour 30 est un saut conceptuel : on quitte les objets pour entrer dans la **programmation fonctionnelle structurelle**. L'objectif est de manipuler des **modules**, des **types de modules**, des **foncteurs**, et d'implémenter deux patrons fondamentaux : les **monoïdes** et les **monades**.

Règle forte du jour : *« your coding style MUST be functional (except for the side effects for input/output) »* — aucun `ref`, aucun `mutable`, pas de boucle impérative.

---

## 2. Notions OCaml employées

### 2.1 Module
Un **module** regroupe types, valeurs et fonctions. Chaque fichier `watchtower.ml` devient automatiquement le module `Watchtower`.

### 2.2 Signature (`sig ... end`)
Une signature décrit **ce qu'un module expose**, sans dire comment c'est fait :
```ocaml
module type MONOID = sig
  type element
  val zero1 : element
  val add : element -> element -> element
end
```

### 2.3 Structure (`struct ... end`)
Une structure est l'**implémentation** d'un module :
```ocaml
module INT : (MONOID with type element = int) = struct
  type element = int
  let zero1 = 0
  let add = ( + )
end
```
La syntaxe `:(MONOID with type element = int)` contraint le module à respecter la signature `MONOID` en fixant le type interne à `int`.

### 2.4 Foncteur
Un **foncteur** est une « fonction sur les modules » : il prend un module en entrée et renvoie un module en sortie.
```ocaml
module Calc = functor (M : MONOID) -> struct
  let add = M.add
  ...
end
```
On obtient une instance en appliquant le foncteur : `module Calc_int = Calc(INT)`.

### 2.5 Types algébriques
```ocaml
type 'a t = Success of 'a | Failure of exn
```
Un type **somme** : une valeur de type `'a t` est soit `Success v`, soit `Failure e`. Le `'a` est un paramètre : ce type fonctionne pour n'importe quelle donnée (`int t`, `string t`, …).

### 2.6 Pattern matching
```ocaml
match m with
| Success v -> ...
| Failure e -> ...
```
Analyse exhaustive des cas. Le compilateur vérifie qu'on traite toutes les possibilités.

### 2.7 Style fonctionnel pur
- Aucune variable modifiable.
- Les fonctions retournent une **nouvelle valeur** plutôt que muter.
- Les listes sont traitées par `List.map`, `List.filter`, `List.fold_left`, récursion — pas de boucle.

---

## 3. Notions algébriques

### 3.1 Monoïde
Un **monoïde** est une structure abstraite définie par :
- un type `T` ;
- un élément neutre `zero` de type `T` ;
- une opération binaire `combine : T × T → T` ;
- deux lois :
  - **associativité** : `combine (combine a b) c = combine a (combine b c)`
  - **élément neutre** : `combine zero a = a = combine a zero`

Exemples concrets : `(int, 0, +)`, `(int, 1, *)`, `(string, "", ^)`, `(list, [], @)`.

### 3.2 Monade
Une **monade** est un type paramétré `'a t` muni de :
- `return : 'a -> 'a t` (encapsulation d'une valeur) ;
- `bind : 'a t -> ('a -> 'b t) -> 'b t` (enchaînement de calculs).

Une monade capture une notion de **calcul enrichi** : peut échouer (Try), peut produire plusieurs résultats (Set), peut faire des effets, etc. Les monades respectent trois lois (identité à gauche/droite, associativité).

### 3.3 Horloge 12 heures
Arithmétique modulo 12. L'élément neutre n'est pas 0 mais 12 (dans une lecture où l'horloge affiche `1..12`, pas `0..11`).

---

## 4. Exercices

### Exercice 00 — Watchtower (monoïde horloge 12 h)

**Demandé.** Un module `Watchtower` avec signature imposée :
```
type hour = int, val zero, val add, val sub
```
`add` et `sub` respectent l'arithmétique cyclique 12 h.

**Notions ciblées.** Module basique, convention d'horloge 12 h.

**Réalisé.** `watchtower.ml` — 4 définitions (`type hour`, `zero`, `add`, `sub`). Le nom du module est automatique (depuis le nom de fichier).

**Comment.**
- `zero = 12` — sur une horloge 12 h, c'est l'élément neutre (ajouter 12 ne change pas l'heure affichée).
- `add h1 h2` : `((h1 mod 12) + (h2 mod 12) + 24) mod 12`, avec conversion du résultat `0` en `12` pour rester sur `1..12`. Le `+24` protège contre les valeurs négatives en entrée.
- `sub` applique la même logique sur la soustraction.

### Exercice 01 — App (monoïde projet)

**Demandé.** Module `App` avec signature :
```
type project = string * string * int, val zero, val combine, val fail, val success
```
- `combine` concatène les chaînes et moyenne les notes.
- `fail` met note à 0, statut `"failed"`.
- `success` met note à 80, statut `"succeed"`.

**Notions ciblées.** Type produit (tuple), déstructuration, monoïde non numérique.

**Réalisé.** `app.ml` — 5 définitions couvrant la signature + `main.ml` avec un `print_proj` de type `App.project -> unit`.

**Comment.**
- `type project = string * string * int` — triplet.
- `zero = ("", "", 0)` — élément neutre.
- `combine` : moyenne arithmétique des notes, statut `"succeed"` si `grade >= 80`. Le choix `>=` (plutôt que `>`) est **délibéré** : `success` fixe grade = 80 avec statut `"succeed"`, donc un projet `success` recombiné avec lui-même (moyenne = 80) doit rester `"succeed"`.
- `fail` / `success` écrasent la note et le statut en conservant le nom.

### Exercice 02 — Monoid functor Calc

**Demandé.** Deux modules `INT` et `FLOAT` respectant `module type MONOID` (zero1, zero2, add, sub, mul, div). Puis un foncteur `Calc` qui, à partir d'un `MONOID`, produit un module calculatrice incluant `power` (n entier positif) et `fact` (factorielle).

**Notions ciblées.** `module type` avec contrainte `with type`, foncteur, polymorphisme abstrait.

**Réalisé.** `monoid.ml` — `MONOID`, `INT`, `FLOAT`, `Calc`, plus deux instanciations `Calc_int = Calc(INT)`, `Calc_float = Calc(FLOAT)`.

**Comment.**
- `INT` et `FLOAT` exposent `zero1 = 0 / 0.0` (neutre additif), `zero2 = 1 / 1.0` (neutre multiplicatif), et les 4 opérations standard.
- Dans `Calc(M)` :
  - `add`, `sub`, `mul` sont des alias de `M.add`, `M.sub`, `M.mul`.
  - `div x y` contrôle `y = M.zero1` et lève `failwith` sinon.
  - `power x n` est récursive : `x^0 = zero2`, `x^1 = x`, sinon `x * x^(n-1)`.
  - `fact x` : récursion sur l'élément lui-même, arrêt quand `x = zero1`.

### Exercice 03 — Monade Try

**Demandé.** Monade `Try` avec constructeurs `Success of 'a | Failure of exn` et les fonctions : `return`, `bind`, `recover`, `filter`, `flatten`.

**Notions ciblées.** Type somme paramétrique, monade d'exceptions, gestion fonctionnelle des erreurs.

**Réalisé.** `try_monad.ml` — type `'a t`, exception custom `Filter_failed`, puis les 5 fonctions.

**Comment.**
- `return x = Success x` — encapsule une valeur.
- `bind m f` applique `f` **seulement** si `m` est `Success` ; si `f` lève une exception, on la capture dans `Failure`. C'est ce qui permet d'écrire une chaîne de calculs sans `try/with` à chaque étape.
- `recover m f` fait l'inverse : ne réagit qu'aux `Failure`, en laissant `f` proposer une valeur de repli.
- `filter m predicate` garde le `Success` si le prédicat passe, sinon renvoie `Failure (Filter_failed ...)`.
- `flatten (Success (Success v)) = Success v`, `flatten (Success (Failure e)) = Failure e`. La règle *« Success of Failure is treated as a Failure »* est traitée explicitement.

### Exercice 04 — Monade Set

**Demandé.** Monade `Set` représentant un ensemble mathématique (sans doublons), avec `return`, `bind`, `union`, `inter`, `diff`, `filter`, `foreach`, `for_all`, `exists`.

**Notions ciblées.** Monade de collection, propagation des opérations ensemblistes, pureté totale.

**Réalisé.** `set_monad.ml` — représentation `type 'a t = 'a list` + 9 fonctions. `remove_duplicates` sert d'utilitaire interne pour préserver l'invariant « pas de doublon ».

**Comment.**
- Représentation : liste avec déduplication via `List.mem`. Simple et suffisant pour le sujet.
- `return x = [x]` — singleton.
- `bind m f` applique `f` à chaque élément puis aplatit avec `List.concat` et déduplique.
- `union` concatène + dédup.
- `inter` filtre `m1` par appartenance à `m2`.
- `diff` filtre par **non-appartenance** à `m2`.
- `filter`, `foreach`, `for_all`, `exists` délèguent à `List.filter`, `List.iter`, `List.for_all`, `List.exists`.

Les lois monadiques (identité gauche, identité droite) sont vérifiées dans le `main.ml`.

---

## 5. Règles respectées (rappel)

- Aucun `open`, `for`, `while`, `;;`.
- Pas de `ref`, pas de `mutable`, pas de `:=` dans le code source — style fonctionnel strict.
- Makefile par exercice, compilation avec `ocamlopt`.
- Signatures de modules imposées respectées (types, constructeurs, noms de fonctions).
- Tests exhaustifs dans chaque `main.ml` (cas nominaux, cas limites, cas d'erreur).
