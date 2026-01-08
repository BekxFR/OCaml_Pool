# Guide Complet de la Piscine OCaml
## De Zéro à la Programmation Fonctionnelle Avancée

> **Public cible** : Développeurs connaissant C, C++ ou JavaScript/TypeScript mais découvrant OCaml et la programmation fonctionnelle.

---

## Table des matières

1. [Introduction à OCaml et à la programmation fonctionnelle](#1-introduction)
2. [Les bases d'OCaml (Jours 00-01)](#2-les-bases-docaml)
3. [Types algébriques et pattern matching (Jour 02)](#3-types-algébriques)
4. [Modules et types abstraits (Jour 10)](#4-modules-et-types-abstraits)
5. [Foncteurs : Modules paramétriques (Jour 12)](#5-foncteurs)
6. [Monades et types paramétriques (Jour 11)](#6-monades)
7. [Programmation orientée objet en OCaml (Jour 21)](#7-programmation-orientée-objet)
8. [Concepts avancés de programmation fonctionnelle](#8-concepts-avancés)
9. [Récapitulatif et analogies avec C/C++/JavaScript](#9-récapitulatif)

---

## 1. Introduction à OCaml et à la programmation fonctionnelle {#1-introduction}

### Qu'est-ce qu'OCaml ?

**OCaml** (Objective Caml) est un langage de programmation :
- **Multi-paradigme** : fonctionnel, impératif et orienté objet
- **Fortement typé** : le compilateur vérifie tous les types à la compilation
- **Avec inférence de types** : vous n'avez généralement pas besoin d'annoter les types
- **Compilé et performant** : proche des performances du C

### Comparaison avec vos langages familiers

| Concept | C/C++ | JavaScript/TypeScript | OCaml |
|---------|-------|----------------------|-------|
| **Typage** | Statique (C++), Manuel | Dynamique / Statique (TS) | Statique avec inférence |
| **Mutabilité** | Par défaut | Par défaut | Immutabilité par défaut |
| **Gestion mémoire** | Manuelle (C) / RAII (C++) | Garbage Collector | Garbage Collector |
| **Paradigme dominant** | Impératif / OOP | Multi-paradigme | Fonctionnel |
| **NULL** | Pointeurs NULL | null/undefined | Option type (pas de NULL!) |

### La philosophie fonctionnelle

En programmation fonctionnelle :

1. **Les fonctions sont des valeurs** (comme en JavaScript)
2. **L'immutabilité est la norme** (contrairement à C/C++)
3. **Pas d'effets de bord** (idéalement)
4. **Pattern matching** plutôt que if/switch
5. **Composition de fonctions** plutôt que séquences d'instructions

**Analogie** : Pensez à une fonction mathématique f(x) = x². Elle ne modifie jamais x, elle retourne toujours le même résultat pour la même entrée. C'est ça, la programmation fonctionnelle !

---

## 2. Les bases d'OCaml (Jours 00-01) {#2-les-bases-docaml}

### 2.1 Syntaxe de base

#### Variables et fonctions

```ocaml
(* Ceci est un commentaire *)

(* Déclaration d'une variable (en fait une constante!) *)
let x = 42

(* Fonction simple *)
let add a b = a + b

(* Équivalent en C : *)
// int add(int a, int b) { return a + b; }

(* Fonction avec type annoté *)
let multiply (a: int) (b: int) : int = a * b

(* Fonction récursive (DOIT utiliser 'rec') *)
let rec factorial n =
  if n <= 1 then 1
  else n * factorial (n - 1)
```

**🔑 Point clé** : En OCaml, `let` crée une **liaison** (binding), pas une variable mutable. Par défaut, tout est immutable !

#### Types de base

```ocaml
let entier = 42              (* int *)
let flottant = 3.14          (* float *)
let caractere = 'a'          (* char *)
let chaine = "Hello"         (* string *)
let booleen = true           (* bool *)
let unite = ()               (* unit - comme void en C *)
```

**⚠️ Attention** : Les opérateurs arithmétiques diffèrent entre int et float !

```ocaml
(* Pour les entiers *)
let a = 10 + 5    (* addition *)
let b = 10 - 5    (* soustraction *)
let c = 10 * 5    (* multiplication *)
let d = 10 / 5    (* division entière *)

(* Pour les flottants - notez le point ! *)
let x = 10.0 +. 5.0
let y = 10.0 -. 5.0
let z = 10.0 *. 5.0
let w = 10.0 /. 5.0
```

### 2.2 Fonctions d'ordre supérieur

**Définition** : Une fonction d'ordre supérieur est une fonction qui :
- Prend une ou plusieurs fonctions en paramètres, ET/OU
- Retourne une fonction

**Exemple de référence** : `iter` (Jour 01, ex06)

```ocaml
(* iter : ('a -> 'a) -> 'a -> int -> 'a
   Applique une fonction n fois à une valeur *)
let rec iter f x n =
  if n <= 0 then x
  else iter f (f x) (n - 1)

(* Utilisation *)
let double x = x * 2
let result = iter double 1 5  (* 1 * 2 * 2 * 2 * 2 * 2 = 32 *)
```

**Analogie JavaScript** :

```javascript
// Équivalent en JavaScript
function iter(f, x, n) {
  if (n <= 0) return x;
  return iter(f, f(x), n - 1);
}

const double = x => x * 2;
const result = iter(double, 1, 5); // 32
```

**Comparaison C++** :

```cpp
// En C++ (avec templates et fonctions)
template<typename T, typename Func>
T iter(Func f, T x, int n) {
    while (n > 0) {
        x = f(x);
        n--;
    }
    return x;
}

auto double_val = [](int x) { return x * 2; };
int result = iter(double_val, 1, 5); // 32
```

### 2.3 Récursivité

En programmation fonctionnelle, **la récursivité remplace les boucles**.

**Exemple** : Countdown (Jour 00, ex01)

```ocaml
(* Version récursive OCaml *)
let rec ft_countdown n =
  if n < 0 then ()
  else begin
    print_int n;
    print_char '\n';
    ft_countdown (n - 1)
  end

(* Équivalent en C avec boucle *)
void ft_countdown(int n) {
    for (int i = n; i >= 0; i--) {
        printf("%d\n", i);
    }
}
```

**🔑 Récursivité terminale** : Optimisation importante en OCaml

```ocaml
(* NON optimisée - accumule les appels *)
let rec sum n =
  if n = 0 then 0
  else n + sum (n - 1)

(* Optimisée (tail recursive) - utilise un accumulateur *)
let sum n =
  let rec aux acc n =
    if n = 0 then acc
    else aux (acc + n) (n - 1)
  in
  aux 0 n
```

La version optimisée ne consomme pas de pile d'appels !

### 2.4 Listes

Les listes sont **immutables** et **chaînées** (comme une linked list en C).

```ocaml
(* Création de listes *)
let vide = []
let nombres = [1; 2; 3; 4; 5]  (* Note: point-virgule, pas virgule! *)
let cons = 0 :: nombres         (* Ajoute en tête: [0; 1; 2; 3; 4; 5] *)
let concat = [1; 2] @ [3; 4]   (* Concaténation: [1; 2; 3; 4] *)

(* Pattern matching sur les listes *)
let rec length = function
  | [] -> 0
  | _ :: tail -> 1 + length tail

(* Équivalent en C avec structures *)
struct Node {
    int value;
    struct Node* next;
};

int length(struct Node* list) {
    if (list == NULL) return 0;
    return 1 + length(list->next);
}
```

**Fonctions classiques sur les listes** :

```ocaml
(* Map: transforme chaque élément *)
let rec map f = function
  | [] -> []
  | x :: xs -> f x :: map f xs

(* map (fun x -> x * 2) [1; 2; 3] = [2; 4; 6] *)

(* Filter: garde les éléments qui satisfont un prédicat *)
let rec filter p = function
  | [] -> []
  | x :: xs -> 
      if p x then x :: filter p xs
      else filter p xs

(* Fold: accumule une valeur *)
let rec fold_left f acc = function
  | [] -> acc
  | x :: xs -> fold_left f (f acc x) xs

(* fold_left (+) 0 [1; 2; 3; 4] = 10 *)
```

**Analogie JavaScript** :

```javascript
// Ces concepts existent en JavaScript!
[1, 2, 3].map(x => x * 2);           // [2, 4, 6]
[1, 2, 3].filter(x => x > 1);        // [2, 3]
[1, 2, 3].reduce((acc, x) => acc + x, 0); // 6
```

---

## 3. Types algébriques et pattern matching (Jour 02) {#3-types-algébriques}

### 3.1 Types somme (Sum types / Variants)

Les types somme n'existent pas en C (mais ressemblent aux enum en C++11 ou aux unions discriminées en TypeScript).

**Définition** : Un type qui peut être **une valeur parmi plusieurs alternatives**.

```ocaml
(* Définition d'un type somme *)
type nucleobase = A | T | C | G

(* Fonction utilisant le pattern matching *)
let complementary = function
  | A -> T
  | T -> A
  | C -> G
  | G -> C

(* Appel *)
let comp = complementary A  (* retourne T *)
```

**Analogie TypeScript** :

```typescript
// Union discriminée en TypeScript
type Nucleobase = 'A' | 'T' | 'C' | 'G';

function complementary(base: Nucleobase): Nucleobase {
  switch (base) {
    case 'A': return 'T';
    case 'T': return 'A';
    case 'C': return 'G';
    case 'G': return 'C';
  }
}
```

**Analogie C++17** :

```cpp
// Enum class en C++
enum class Nucleobase { A, T, C, G };

Nucleobase complementary(Nucleobase base) {
    switch (base) {
        case Nucleobase::A: return Nucleobase::T;
        case Nucleobase::T: return Nucleobase::A;
        case Nucleobase::C: return Nucleobase::G;
        case Nucleobase::G: return Nucleobase::C;
    }
}
```

### 3.2 Types avec données (Constructeurs paramétriques)

Les constructeurs peuvent **porter des données** !

```ocaml
(* Type Option - remplace NULL/nullptr *)
type 'a option =
  | None              (* Pas de valeur *)
  | Some of 'a        (* Une valeur de type 'a *)

(* Fonction qui peut échouer *)
let safe_divide a b =
  if b = 0 then None
  else Some (a / b)

(* Utilisation *)
let result = safe_divide 10 2  (* Some 5 *)
let error = safe_divide 10 0   (* None *)

(* Pattern matching sur Option *)
let print_result = function
  | None -> print_endline "Division impossible"
  | Some x -> Printf.printf "Résultat: %d\n" x
```

**🔑 Point clé** : Plus de `NULL` ! Le type `option` force à gérer explicitement l'absence de valeur.

**Analogie C++** :

```cpp
// std::optional en C++17
#include <optional>

std::optional<int> safe_divide(int a, int b) {
    if (b == 0) return std::nullopt;
    return a / b;
}

auto result = safe_divide(10, 2);  // has_value() = true, value() = 5
auto error = safe_divide(10, 0);   // has_value() = false
```

### 3.3 Types récursifs

Les types peuvent se référencer eux-mêmes !

```ocaml
(* Arbre binaire *)
type 'a tree =
  | Empty
  | Node of 'a * 'a tree * 'a tree

(* Création d'un arbre *)
let my_tree =
  Node(10,
    Node(5, Empty, Empty),
    Node(15, Empty, Empty)
  )
(*     10
      /  \
     5    15  *)

(* Parcours *)
let rec sum_tree = function
  | Empty -> 0
  | Node(value, left, right) ->
      value + sum_tree left + sum_tree right
```

**Analogie C** :

```c
// Structure récursive en C
struct TreeNode {
    int value;
    struct TreeNode* left;
    struct TreeNode* right;
};

int sum_tree(struct TreeNode* node) {
    if (node == NULL) return 0;
    return node->value + sum_tree(node->left) + sum_tree(node->right);
}
```

### 3.4 Exemple complet : Encodage run-length (Jour 02, ex00)

**Problème** : Compresser `[1; 1; 1; 2; 2; 3]` en `[(3, 1); (2, 2); (1, 3)]`

```ocaml
let encode lst =
  let rec aux current count acc = function
    | [] -> 
        if count > 0 then acc @ [(count, current)]
        else acc
    | x :: xs ->
        if x = current then
          aux current (count + 1) acc xs
        else
          aux x 1 (acc @ [(count, current)]) xs
  in
  match lst with
  | [] -> []
  | x :: xs -> aux x 1 [] xs

(* Utilisation *)
let encoded = encode [1; 1; 1; 2; 2; 3]
(* Résultat: [(3, 1); (2, 2); (1, 3)] *)
```

**Analogie C++** :

```cpp
#include <vector>
#include <utility>

std::vector<std::pair<int, int>> encode(const std::vector<int>& lst) {
    if (lst.empty()) return {};
    
    std::vector<std::pair<int, int>> result;
    int current = lst[0];
    int count = 1;
    
    for (size_t i = 1; i < lst.size(); i++) {
        if (lst[i] == current) {
            count++;
        } else {
            result.push_back({count, current});
            current = lst[i];
            count = 1;
        }
    }
    result.push_back({count, current});
    return result;
}
```

---

## 4. Modules et types abstraits (Jour 10) {#4-modules-et-types-abstraits}

### 4.1 Qu'est-ce qu'un module ?

Un **module** est un regroupement de :
- Types
- Valeurs
- Fonctions
- Sous-modules

**Analogie** :
- **C** : Un fichier .h + .c
- **C++** : Une classe ou un namespace
- **JavaScript** : Un module ES6

```ocaml
(* Définition d'un module *)
module Color = struct
  type t = Spade | Heart | Diamond | Club
  
  let all = [Spade; Heart; Diamond; Club]
  
  let toString = function
    | Spade -> "S"
    | Heart -> "H"
    | Diamond -> "D"
    | Club -> "C"
end

(* Utilisation *)
let colors = Color.all
let spade_str = Color.toString Color.Spade  (* "S" *)
```

**Référence** : Voir [Color.ml](10/ex00/Color.ml) et [Value.ml](10/ex01/Value.ml)

### 4.2 Signatures de modules (Interfaces)

Une **signature** définit l'interface publique d'un module (comme un fichier .h en C).

```ocaml
(* Signature (interface) *)
module type CARD = sig
  type t
  val newCard : Value.t -> Color.t -> t
  val getValue : t -> Value.t
  val getColor : t -> Color.t
  val toString : t -> string
  val toStringVerbose : t -> string
end

(* Implémentation *)
module Card : CARD = struct
  type t = Value.t * Color.t
  
  let newCard value color = (value, color)
  let getValue (v, _) = v
  let getColor (_, c) = c
  let toString (v, c) = Value.toString v ^ Color.toString c
  let toStringVerbose (v, c) = 
    Value.toStringVerbose v ^ " of " ^ Color.toStringVerbose c
end
```

**🔑 Point clé** : La signature cache les détails d'implémentation (encapsulation).

**Analogie C++** :

```cpp
// Fichier Card.h (interface)
class Card {
public:
    Card(Value value, Color color);
    Value getValue() const;
    Color getColor() const;
    std::string toString() const;
    
private:
    Value value_;  // Détails cachés
    Color color_;
};

// Fichier Card.cpp (implémentation)
Card::Card(Value value, Color color) 
    : value_(value), color_(color) {}
// ...
```

### 4.3 Types abstraits

Un **type abstrait** est un type dont la représentation interne est cachée.

```ocaml
(* Signature avec type abstrait *)
module type DECK = sig
  type t         (* Type abstrait - on ne sait pas comment il est représenté *)
  
  val newDeck : unit -> t
  val shuffle : t -> t
  val draw : t -> (Card.t * t) option
  val size : t -> int
end

(* Implémentation *)
module Deck : DECK = struct
  type t = Card.t list  (* Révélé seulement dans l'implémentation *)
  
  let newDeck () = (* ... *)
  let shuffle deck = (* ... *)
  let draw = function
    | [] -> None
    | card :: rest -> Some (card, rest)
  let size deck = List.length deck
end
```

**Avantage** : Les utilisateurs du module ne peuvent pas dépendre de la représentation interne. Vous pouvez la changer sans casser le code client !

**Analogie C++** :

```cpp
// Interface (deck.h)
class Deck {
public:
    Deck();
    void shuffle();
    std::optional<Card> draw();
    int size() const;
    
private:
    std::vector<Card> cards_;  // Détail d'implémentation caché
};
```

---

## 5. Foncteurs : Modules paramétriques (Jour 12) {#5-foncteurs}

### 5.1 Qu'est-ce qu'un foncteur ?

Un **foncteur** est une **fonction au niveau des modules** :
- Il prend un ou plusieurs modules en paramètres
- Il retourne un nouveau module
- Il est évalué à la compilation

**Analogie** :
- **Fonction normale** : `int -> int` (prend une valeur, retourne une valeur)
- **Foncteur** : `Module -> Module` (prend un module, retourne un module)
- **C++ Templates** : Similaire aux templates de classe paramétriques

### 5.2 Exemple : Set.Make

Le foncteur `Set.Make` crée un module de gestion d'ensembles pour n'importe quel type **ordonnable**.

```ocaml
(* Signature attendue en paramètre *)
module type OrderedType = sig
  type t
  val compare : t -> t -> int
end

(* Créer un module String ordonnable *)
module StringOrderedType = struct
  type t = string
  let compare = String.compare  (* Fonction de la stdlib *)
end

(* Application du foncteur *)
module StringSet = Set.Make(StringOrderedType)

(* Utilisation *)
let s = StringSet.empty
let s = StringSet.add "hello" s
let s = StringSet.add "world" s
let has_hello = StringSet.mem "hello" s  (* true *)
```

**Référence** : Voir le [guide pédagogique jour 12](12/GUIDE_PEDAGOGIQUE_DAY12.md)

**Analogie C++ Templates** :

```cpp
// Template de classe (proche concept)
template<typename T, typename Compare = std::less<T>>
class Set {
private:
    std::set<T, Compare> data_;
public:
    void add(const T& value) { data_.insert(value); }
    bool contains(const T& value) const { 
        return data_.find(value) != data_.end(); 
    }
};

// Utilisation
Set<std::string> string_set;
string_set.add("hello");
```

### 5.3 Exemple : Hashtbl.Make

Le foncteur `Hashtbl.Make` crée une table de hachage pour un type **hachable**.

```ocaml
(* Signature attendue *)
module type HashedType = sig
  type t
  val equal : t -> t -> bool
  val hash : t -> int
end

(* Implémentation pour string avec djb2 *)
module StringHashedType = struct
  type t = string
  
  let equal s1 s2 = (s1 = s2)
  
  (* Fonction de hachage djb2 *)
  let hash str =
    let rec aux hash i =
      if i >= String.length str then hash
      else
        let c = Char.code (String.get str i) in
        aux (hash * 33 + c) (i + 1)
    in
    aux 5381 0
end

(* Création du module *)
module StringHashtbl = Hashtbl.Make(StringHashedType)

(* Utilisation *)
let table = StringHashtbl.create 10
let () = StringHashtbl.add table "key" 42
let value = StringHashtbl.find table "key"  (* 42 *)
```

**Référence** : Voir [ex01.ml](12/ex01/ex01.ml)

**Analogie C++** :

```cpp
// std::unordered_map nécessite hash et égalité
struct StringHash {
    size_t operator()(const std::string& s) const {
        size_t hash = 5381;
        for (char c : s) {
            hash = hash * 33 + c;
        }
        return hash;
    }
};

std::unordered_map<std::string, int, StringHash> table;
table["key"] = 42;
```

### 5.4 Créer vos propres foncteurs

**Exemple** : Foncteur de projection (Jour 12, ex02)

```ocaml
(* Signatures *)
module type PAIR = sig 
  val pair : (int * int) 
end

module type VAL = sig 
  val x : int 
end

(* Signature du foncteur *)
module type MAKEPROJECTION = functor (P : PAIR) -> VAL

(* Implémentation du foncteur *)
module MakeFst : MAKEPROJECTION = functor (P : PAIR) -> struct
  let x = fst P.pair
end

module MakeSnd : MAKEPROJECTION = functor (P : PAIR) -> struct
  let x = snd P.pair
end

(* Utilisation *)
module MyPair = struct
  let pair = (10, 20)
end

module First = MakeFst(MyPair)   (* First.x = 10 *)
module Second = MakeSnd(MyPair)  (* Second.x = 20 *)
```

**Référence** : Voir [ex02.ml](12/ex02/ex02.ml)

### 5.5 Pourquoi les foncteurs ?

**Avantages** :
1. **Réutilisabilité** : Écrire du code générique une seule fois
2. **Sécurité des types** : Vérifications à la compilation
3. **Abstraction** : Séparer interface et implémentation
4. **Performance** : Pas de coût à l'exécution (monomorphisation)

**Cas d'usage** :
- Collections génériques (Set, Map, Hashtbl)
- Algorithmes paramétriques
- Structures de données abstraites
- Code hautement configurable

---

## 6. Monades et types paramétriques (Jour 11) {#6-monades}

### 6.1 Qu'est-ce qu'une monade ?

Une **monade** est un design pattern de programmation fonctionnelle. C'est :
- Un type paramétrique `'a m` (container)
- Avec deux opérations :
  - **return** (ou **unit**) : `'a -> 'a m` (met une valeur dans le contexte)
  - **bind** : `'a m -> ('a -> 'b m) -> 'b m` (compose des opérations)

**Analogie simple** : Une monade est comme une **boîte** qui :
1. Peut contenir une valeur
2. Permet d'appliquer des fonctions à la valeur sans l'extraire
3. Peut représenter un contexte (calcul qui peut échouer, état, IO, etc.)

**Règles (lois des monades)** :
1. **Identité gauche** : `bind (return x) f = f x`
2. **Identité droite** : `bind m return = m`
3. **Associativité** : `bind (bind m f) g = bind m (fun x -> bind (f x) g)`

### 6.2 Exemple : La monade Option

```ocaml
(* Type Option (déjà défini dans la stdlib) *)
type 'a option = None | Some of 'a

(* return : 'a -> 'a option *)
let return x = Some x

(* bind : 'a option -> ('a -> 'b option) -> 'b option *)
let bind opt f =
  match opt with
  | None -> None
  | Some x -> f x

(* Exemple d'utilisation *)
let safe_sqrt x =
  if x < 0.0 then None
  else Some (sqrt x)

let safe_divide a b =
  if b = 0.0 then None
  else Some (a /. b)

(* Composition avec bind *)
let compute x y =
  bind (safe_divide x y) (fun ratio ->
    bind (safe_sqrt ratio) (fun root ->
      return (root *. 2.0)
    )
  )

(* compute 8.0 2.0 = Some 4.0 
   compute 8.0 0.0 = None (division par zéro)
   compute (-8.0) 2.0 = None (racine négative) *)
```

**Syntaxe alternative** : OCaml a des opérateurs pour rendre ça plus lisible :

```ocaml
let ( >>= ) = bind  (* Opérateur infixe pour bind *)

let compute x y =
  safe_divide x y >>= fun ratio ->
  safe_sqrt ratio >>= fun root ->
  return (root *. 2.0)
```

**Analogie JavaScript** : Les Promises sont des monades !

```javascript
// Promise est une monade
// return = Promise.resolve
// bind = .then

Promise.resolve(8)
  .then(x => safeDivide(x, 2))
  .then(ratio => safeSqrt(ratio))
  .then(root => root * 2.0)
// Résultat: Promise<4.0>
```

### 6.3 Exemple : La monade Ref (Jour 11, ex01)

Une monade pour simuler des références mutables de manière "fonctionnelle".

```ocaml
(* Type ft_ref *)
type 'a ft_ref = { mutable contents : 'a }

(* return : 'a -> 'a ft_ref *)
let return a = { contents = a }

(* get : 'a ft_ref -> 'a *)
let get ref = ref.contents

(* set : 'a ft_ref -> 'a -> unit *)
let set ref value = ref.contents <- value

(* bind : 'a ft_ref -> ('a -> 'b ft_ref) -> 'b ft_ref *)
let bind ref f = f (get ref)

(* Utilisation *)
let counter = return 0
let () = set counter 10
let doubled = bind counter (fun x -> return (x * 2))
(* get doubled = 20 *)
```

**Référence** : Voir [ft_ref.ml](11/ex01/ft_ref.ml)

**Analogie C++** :

```cpp
// std::reference_wrapper proche concept
#include <functional>

template<typename T>
class Ref {
    T value_;
public:
    Ref(T val) : value_(val) {}
    
    T get() const { return value_; }
    void set(T val) { value_ = val; }
    
    template<typename F>
    auto bind(F f) { return f(value_); }
};

Ref<int> counter(0);
counter.set(10);
auto doubled = counter.bind([](int x) { return Ref(x * 2); });
```

### 6.4 Autres monades courantes

#### La monade List

```ocaml
(* return : 'a -> 'a list *)
let return x = [x]

(* bind : 'a list -> ('a -> 'b list) -> 'b list *)
let bind lst f = List.concat (List.map f lst)

(* Exemple *)
let pairs =
  bind [1; 2; 3] (fun x ->
    bind ['a'; 'b'] (fun y ->
      return (x, y)
    )
  )
(* Résultat: [(1, 'a'); (1, 'b'); (2, 'a'); (2, 'b'); (3, 'a'); (3, 'b')] *)
```

Cette monade représente le **non-déterminisme** : plusieurs résultats possibles.

**Analogie JavaScript** : Array.flatMap est exactement bind pour les listes !

```javascript
const pairs = [1, 2, 3].flatMap(x =>
  ['a', 'b'].flatMap(y =>
    [[x, y]]
  )
);
```

#### Pourquoi les monades sont utiles ?

1. **Gestion d'erreurs élégante** (Option, Result)
2. **Gestion d'état** (State monad)
3. **Effets de bord contrôlés** (IO monad)
4. **Séquençage d'opérations** asynchrones (Promise en JS)
5. **Code plus composable et modulaire**

---

## 7. Programmation orientée objet en OCaml (Jour 21) {#7-programmation-orientée-objet}

OCaml supporte la POO, mais avec une approche fonctionnelle.

### 7.1 Classes et objets

```ocaml
(* Définition d'une classe *)
class point x_init y_init =
object
  val mutable x = x_init  (* Attribut mutable *)
  val mutable y = y_init
  
  method get_x = x
  method get_y = y
  
  method move dx dy =
    x <- x + dx;
    y <- y + dy
  
  method to_string =
    Printf.sprintf "(%d, %d)" x y
end

(* Création d'un objet *)
let p = new point 10 20
let () = p#move 5 3
let s = p#to_string  (* "(15, 23)" *)
```

**Analogie C++** :

```cpp
class Point {
    int x, y;
public:
    Point(int x_init, int y_init) : x(x_init), y(y_init) {}
    
    int get_x() const { return x; }
    int get_y() const { return y; }
    
    void move(int dx, int dy) {
        x += dx;
        y += dy;
    }
    
    std::string to_string() const {
        return "(" + std::to_string(x) + ", " + std::to_string(y) + ")";
    }
};
```

### 7.2 Héritage et classes virtuelles

```ocaml
(* Classe virtuelle (abstraite) *)
class virtual animal =
object
  method virtual name : string       (* Méthode abstraite *)
  method virtual sound : string
  
  method speak =  (* Méthode concrète *)
    Printf.printf "%s says %s\n" self#name self#sound
end

(* Classe concrète héritant de animal *)
class dog dog_name =
object
  inherit animal
  method name = dog_name
  method sound = "Woof!"
end

class cat cat_name =
object
  inherit animal
  method name = cat_name
  method sound = "Meow!"
end

(* Utilisation *)
let d = new dog "Rex"
let c = new cat "Whiskers"
let () = d#speak  (* "Rex says Woof!" *)
let () = c#speak  (* "Whiskers says Meow!" *)
```

**Référence** : Voir le [guide jour 21](21/GUIDE_PEDAGOGIQUE_DAY21.md) pour des exemples chimiques complexes.

**Analogie C++** :

```cpp
// Classe abstraite
class Animal {
public:
    virtual std::string name() const = 0;
    virtual std::string sound() const = 0;
    
    void speak() const {
        std::cout << name() << " says " << sound() << std::endl;
    }
};

class Dog : public Animal {
    std::string dog_name_;
public:
    Dog(std::string name) : dog_name_(name) {}
    std::string name() const override { return dog_name_; }
    std::string sound() const override { return "Woof!"; }
};
```

### 7.3 OCaml OOP vs Fonctionnel

En OCaml, **le style fonctionnel est généralement préféré** :

| Aspect | OOP | Fonctionnel |
|--------|-----|-------------|
| **État** | Encapsulé (mutable) | Immutable |
| **Extensibilité** | Nouvelle classe | Nouvelle fonction |
| **Composition** | Héritage | Composition de fonctions |
| **Typage** | Sous-typage | Types algébriques |

**Quand utiliser OOP en OCaml ?** 
- Modélisation de domaines avec hiérarchies naturelles
- Interface avec du code impératif
- Systèmes avec état mutable complexe

---

## 8. Concepts avancés de programmation fonctionnelle {#8-concepts-avancés}

### 8.1 Foncteurs (au sens catégorique)

⚠️ **Ne pas confondre** avec les foncteurs OCaml (modules paramétriques) !

Un **foncteur** (au sens mathématique) est un type `'a f` avec une fonction :
- **map** (ou **fmap**) : `('a -> 'b) -> 'a f -> 'b f`

**Loi** : `map id = id` et `map (f ∘ g) = map f ∘ map g`

**Exemples** :

```ocaml
(* Option est un foncteur *)
let map_option f = function
  | None -> None
  | Some x -> Some (f x)

(* List est un foncteur *)
let map_list = List.map

(* Utilisation *)
let doubled = map_option (fun x -> x * 2) (Some 5)  (* Some 10 *)
let lengths = map_list String.length ["hi"; "hello"]  (* [2; 5] *)
```

**Intuition** : Un foncteur est un **container** qu'on peut mapper.

**Analogie JavaScript** :

```javascript
// Array est un foncteur
[1, 2, 3].map(x => x * 2);  // [2, 4, 6]

// Promise est un foncteur
Promise.resolve(5).then(x => x * 2);  // Promise<10>
```

### 8.2 Applicative Functors

Un **applicative functor** étend un foncteur avec :
- **pure** : `'a -> 'a f` (comme return des monades)
- **apply** : `('a -> 'b) f -> 'a f -> 'b f`

**Exemple avec Option** :

```ocaml
let pure x = Some x

let apply f_opt x_opt =
  match f_opt, x_opt with
  | Some f, Some x -> Some (f x)
  | _ -> None

(* Utilisation : appliquer une fonction dans un contexte *)
let add x y = x + y
let result = apply (apply (pure add) (Some 3)) (Some 5)  (* Some 8 *)
```

**Syntaxe avec opérateurs** :

```ocaml
let ( <*> ) = apply
let ( <$> ) f x = map_option f x  (* infix map *)

let result = pure add <$> Some 3 <*> Some 5  (* Some 8 *)
```

### 8.3 Monoïdes

Un **monoïde** est un type `t` avec :
- Un élément neutre **mempty** : `t`
- Une opération binaire associative **mappend** : `t -> t -> t`

**Lois** :
1. **Identité** : `mappend mempty x = x` et `mappend x mempty = x`
2. **Associativité** : `mappend (mappend a b) c = mappend a (mappend b c)`

**Exemples** :

```ocaml
(* Entiers avec addition *)
module IntAdd = struct
  type t = int
  let mempty = 0
  let mappend = (+)
end
(* 0 + x = x, et + est associatif *)

(* Listes avec concaténation *)
module ListMonoid = struct
  type 'a t = 'a list
  let mempty = []
  let mappend = (@)  (* concat *)
end
(* [] @ xs = xs, et @ est associatif *)

(* Strings avec concaténation *)
module StringMonoid = struct
  type t = string
  let mempty = ""
  let mappend = (^)
end

(* Utilisation *)
let sum = List.fold_left IntAdd.mappend IntAdd.mempty [1; 2; 3; 4]
(* 0 + 1 + 2 + 3 + 4 = 10 *)

let concat = List.fold_left StringMonoid.mappend StringMonoid.mempty 
  ["Hello"; " "; "World"]
(* "" ^ "Hello" ^ " " ^ "World" = "Hello World" *)
```

**Pourquoi c'est utile ?** Les monoïdes permettent :
- Réductions parallèles efficaces
- Accumulation de résultats
- Composition de transformations

### 8.4 Fold : Le pattern universel

**fold** (ou **reduce**) est l'opération la plus fondamentale sur les structures de données.

```ocaml
(* Fold left : accumule de gauche à droite *)
let rec fold_left f acc = function
  | [] -> acc
  | x :: xs -> fold_left f (f acc x) xs

(* Fold right : accumule de droite à gauche *)
let rec fold_right f lst acc =
  match lst with
  | [] -> acc
  | x :: xs -> f x (fold_right f xs acc)

(* Exemples *)
let sum = fold_left (+) 0 [1; 2; 3; 4]  (* 10 *)
let product = fold_left ( * ) 1 [1; 2; 3; 4]  (* 24 *)
let reversed = fold_left (fun acc x -> x :: acc) [] [1; 2; 3]  (* [3; 2; 1] *)

(* Map en termes de fold *)
let map f lst = 
  fold_right (fun x acc -> f x :: acc) lst []

(* Filter en termes de fold *)
let filter p lst =
  fold_right (fun x acc -> if p x then x :: acc else acc) lst []
```

**🔑 Point clé** : Presque toutes les opérations sur listes peuvent s'exprimer avec fold !

**Analogie JavaScript** :

```javascript
// Array.reduce est fold_left
[1, 2, 3, 4].reduce((acc, x) => acc + x, 0);  // 10

// Map via reduce
[1, 2, 3].reduce((acc, x) => [...acc, x * 2], []);  // [2, 4, 6]
```

### 8.5 Curryfication et application partielle

**Curryfication** : Transformer une fonction multi-arguments en suite de fonctions à un argument.

```ocaml
(* Ces deux formes sont équivalentes en OCaml *)
let add x y = x + y
let add = fun x -> fun y -> x + y

(* Application partielle *)
let add5 = add 5  (* add5 : int -> int *)
let result = add5 10  (* 15 *)

(* Pourquoi c'est utile ? *)
let numbers = [1; 2; 3; 4; 5]
let incremented = List.map (add 1) numbers  (* [2; 3; 4; 5; 6] *)
let doubled = List.map (( * ) 2) numbers    (* [2; 4; 6; 8; 10] *)
```

**Analogie JavaScript** :

```javascript
// Curryfication manuelle en JS
const add = x => y => x + y;
const add5 = add(5);
add5(10);  // 15

// Application partielle avec bind
function add(x, y) { return x + y; }
const add5 = add.bind(null, 5);
```

### 8.6 Composition de fonctions

```ocaml
(* Opérateur de composition *)
let ( >> ) f g x = g (f x)  (* f puis g *)
let ( << ) f g x = f (g x)  (* g puis f *)

(* Exemple *)
let double x = x * 2
let increment x = x + 1

let double_then_increment = double >> increment
let increment_then_double = double << increment

let r1 = double_then_increment 5  (* (5 * 2) + 1 = 11 *)
let r2 = increment_then_double 5  (* (5 + 1) * 2 = 12 *)

(* Pipeline d'opérations *)
let process =
  String.trim
  >> String.lowercase_ascii
  >> String.split_on_char ' '
  >> List.filter (fun s -> String.length s > 3)
  >> List.length

let count = process "  Hello World From OCaml  "  (* 2 *)
```

**Analogie JavaScript** :

```javascript
// Composition manuelle
const compose = (f, g) => x => g(f(x));

const double = x => x * 2;
const increment = x => x + 1;

const doubleThenIncrement = compose(double, increment);
doubleThenIncrement(5);  // 11
```

---

## 9. Récapitulatif et analogies avec C/C++/JavaScript {#9-récapitulatif}

### 9.1 Tableau de correspondance

| Concept OCaml | C/C++ | JavaScript/TypeScript | Exemple OCaml |
|---------------|-------|----------------------|---------------|
| `let x = 5` | `const int x = 5;` | `const x = 5;` | Constante |
| `let rec f x` | Fonction récursive | `function f(x) { ... return f(...); }` | Récursion |
| `type t = A \| B` | `enum class` | Type union | Type somme |
| `type 'a option` | `std::optional<T>` | `T \| undefined` | Optionalité |
| `List.map f lst` | `std::transform` | `arr.map(f)` | Map |
| `List.fold_left` | `std::accumulate` | `arr.reduce` | Fold |
| `module M = struct` | `namespace M { }` | `export module M` | Module |
| `module M : SIG` | Interface `.h` | `interface` (TS) | Signature |
| `module F(X)` | Template | Génériques | Foncteur |
| `class c` | `class C` | `class C` | Classe OOP |
| `method virtual` | `virtual f() = 0` | `abstract f()` | Méthode abstraite |

### 9.2 Patterns de conversion

#### De C à OCaml

```c
// C: Boucle for
for (int i = 0; i < n; i++) {
    printf("%d\n", i);
}

// OCaml: Récursion
let rec loop i n =
  if i < n then begin
    Printf.printf "%d\n" i;
    loop (i + 1) n
  end
in loop 0 n
```

```c
// C: Pointeur NULL
int* ptr = NULL;
if (ptr != NULL) {
    printf("%d\n", *ptr);
}

// OCaml: Option
let opt = None in
match opt with
| Some value -> Printf.printf "%d\n" value
| None -> ()
```

#### De JavaScript à OCaml

```javascript
// JavaScript: Array methods
const doubled = [1, 2, 3].map(x => x * 2);
const sum = [1, 2, 3].reduce((a, b) => a + b, 0);

// OCaml: List functions
let doubled = List.map (fun x -> x * 2) [1; 2; 3]
let sum = List.fold_left (+) 0 [1; 2; 3]
```

```javascript
// JavaScript: Promise chaining
fetch(url)
  .then(response => response.json())
  .then(data => process(data))
  .catch(error => handle(error))

// OCaml: Result monad
let open Result in
fetch url >>= fun response ->
parse_json response >>= fun data ->
process data
```

#### De C++ à OCaml

```cpp
// C++: Template
template<typename T>
T max(T a, T b) {
    return (a > b) ? a : b;
}

// OCaml: Polymorphisme paramétrique
let max a b = if a > b then a else b
(* Inféré automatiquement comme: 'a -> 'a -> 'a *)
```

```cpp
// C++: Classe abstraite
class Shape {
public:
    virtual double area() const = 0;
};

class Circle : public Shape {
    double radius;
public:
    Circle(double r) : radius(r) {}
    double area() const override {
        return 3.14159 * radius * radius;
    }
};

// OCaml: Classe virtuelle
class virtual shape =
object
  method virtual area : float
end

class circle radius_val =
object
  inherit shape
  val radius = radius_val
  method area = 3.14159 *. radius *. radius
end
```

### 9.3 Concepts clés à retenir

#### 1. Immutabilité par défaut
- **C/C++** : Variables mutables par défaut
- **OCaml** : Tout est immutable sauf `mutable` explicite
- **Avantage** : Pas de bugs liés aux modifications inattendues

#### 2. Typage fort avec inférence
- Pas besoin d'annoter les types (comme JavaScript)
- Mais vérification stricte à la compilation (comme C++)
- Meilleur des deux mondes !

#### 3. Pattern matching > if/switch
- Plus expressif et sûr
- Le compilateur vérifie l'exhaustivité
- Extraction de données intégrée

#### 4. Fonctions de première classe
- Comme JavaScript
- Mais typées statiquement
- Curryfication automatique

#### 5. Pas de NULL
- `option` type force à gérer l'absence
- Plus de segfaults !

#### 6. Système de modules puissant
- Plus riche que les namespaces C++
- Types abstraits natifs
- Foncteurs pour la généricité

### 9.4 Progression dans la piscine

```
Jour 00-01: Bases OCaml
    ↓ Syntaxe, fonctions, récursivité
    
Jour 02: Types algébriques
    ↓ Pattern matching, types somme
    
Jour 10: Modules
    ↓ Encapsulation, types abstraits
    
Jour 11: Monades (concepts avancés)
    ↓ Abstraction, composition
    
Jour 12: Foncteurs
    ↓ Généricité, réutilisabilité
    
Jour 21: OOP en OCaml
    ↓ Classes, héritage, polymorphisme
    
Jour 30: Projets complexes
    ↓ Intégration de tous les concepts
```

### 9.5 Ressources et références

**Dans cette piscine** :
- [Guide foncteurs (Jour 12)](12/GUIDE_PEDAGOGIQUE_DAY12.md)
- [Guide OOP (Jour 21)](21/GUIDE_PEDAGOGIQUE_DAY21.md)
- Exercices progressifs dans chaque dossier

**Concepts par exercice** :
- **Récursivité** : [00/ex01/ft_countdown.ml](00/ex01/ft_countdown.ml)
- **Fold/Iter** : [01/ex06/iter.ml](01/ex06/iter.ml)
- **Types somme** : Jour 02 (nucleotides, gray code)
- **Modules** : [10/ex00/Color.ml](10/ex00/Color.ml)
- **Foncteurs** : [12/ex01/ex01.ml](12/ex01/ex01.ml)
- **Monades** : [11/ex01/ft_ref.ml](11/ex01/ft_ref.ml)
- **OOP** : Jour 21 (chimie)

**Documentation officielle** :
- OCaml Manual: https://ocaml.org/manual/
- Real World OCaml: https://dev.realworldocaml.org/
- OCaml.org Tutorials: https://ocaml.org/learn/

---

## Conclusion

La piscine OCaml vous a fait découvrir :

1. **Programmation fonctionnelle** : Immutabilité, fonctions pures, composition
2. **Typage avancé** : Types algébriques, polymorphisme, inférence
3. **Abstractions puissantes** : Modules, foncteurs, monades
4. **Sûreté** : Pas de NULL, pattern matching exhaustif, types abstraits
5. **Performance** : Compilé, optimisations fonctionnelles

**Ces concepts sont transférables** à d'autres langages :
- **Rust** : Ownership similaire à l'immutabilité, pattern matching
- **Haskell** : Programmation fonctionnelle pure
- **F#** : OCaml sur .NET
- **TypeScript** : Types somme, fonctionnels
- **C++** : Templates, concepts fonctionnels modernes

Vous avez acquis une nouvelle façon de penser la programmation, qui vous rendra meilleur développeur dans **n'importe quel langage** !

---

**Félicitations d'avoir complété cette piscine ! 🎉**
