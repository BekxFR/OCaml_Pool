# Exercice 01 : The Hashtbl module and the Hashtbl.Make functor

## Vue d'ensemble

Cet exercice explore l'utilisation du **foncteur `Hashtbl.Make`** pour créer des tables de hachage personnalisées avec des clés string. L'accent est mis sur l'implémentation d'une **fonction de hachage efficace** et la compréhension du comportement non-déterministe des tables de hachage.

## Concepts clés

### 1. Foncteur Hashtbl.Make

Le module `Hashtbl` propose une interface fonctorielle pour créer des tables de hachage typées :

- **`HashedType`** : signature requise pour le paramètre
- **`S`** : signature du module résultant
- **`Make`** : le foncteur qui génère une table de hachage

### 2. Signature HashedType

```ocaml
module type HashedType = sig
  type t
  val equal : t -> t -> bool
  val hash : t -> int
end
```

**Contraintes importantes :**

- `equal x y = true` ⟹ `hash x = hash y` (cohérence)
- `hash` doit être déterministe
- Bonne distribution pour minimiser les collisions

### 3. Fonctions de hachage reconnues

L'énoncé exige une fonction "vraie et connue", excluant les implémentations triviales comme `String.length`.

#### Fonctions courantes :

1. **djb2** (Daniel J. Bernstein) - choisi ici
2. **FNV-1a** (Fowler-Noll-Vo)
3. **Jenkins hash**
4. **MurmurHash**

## Architecture de la solution

### Étape 1 : Implémentation de StringHashedType

```ocaml
module StringHashedType = struct
  type t = string
  let equal s1 s2 = (s1 = s2)
  let hash str = (* djb2 implementation *)
end
```

**Choix de djb2 :**

- **Algorithme** : `hash = hash * 33 + char_value`
- **Initialisation** : 5381
- **Optimisation** : `33 = (x << 5) + x`
- **Avantages** : Simple, rapide, bonne distribution

### Étape 2 : Implémentation de la fonction hash

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

**Analyse technique :**

- **Complexité** : O(n) où n = longueur de la chaîne
- **Contraintes respectées** : Utilise uniquement `String.get` et `String.length`
- **Récursion terminale** : Optimisation des appels récursifs

### Étape 3 : Génération du StringHashtbl

```ocaml
module StringHashtbl = Hashtbl.Make(StringHashedType)
```

**Résultat :** Module complet avec toutes les opérations :

- `create` : création O(1)
- `add` : insertion O(1) moyen, O(n) pire cas
- `find` : recherche O(1) moyen, O(n) pire cas
- `iter` : itération O(n)

## Comportement attendu

### Entrée

```ocaml
[ "Hello"; "world"; "42"; "Ocaml"; "H" ]
```

### Sortie (exemple avec djb2)

```
k = "Ocaml", v = 5
k = "Hello", v = 5
k = "42", v = 2
k = "H", v = 1
k = "world", v = 5
```

**Important :** L'ordre peut varier selon :

- La fonction de hachage utilisée
- La taille de la table
- La gestion des collisions

## Analyse des hash values (djb2)

Calculons les hash values avec notre implémentation :

```
"Hello"  : hash = 210676686969, hash % 5 = 4
"world"  : hash = 210732791149, hash % 5 = 4
"42"     : hash =    5861675, hash % 5 = 0
"Ocaml"  : hash = 210684904593, hash % 5 = 3
"H"      : hash =     177645, hash % 5 = 0
```

**Observations :**

- Les chaînes plus longues ont des hash values plus élevés
- "Hello" et "world" ont la même position modulo 5 (collision)
- "42" et "H" partagent également la position 0
- L'ordre final dépend de la résolution des collisions par chaînage

## Alternatives d'implémentation

### 1. FNV-1a Hash

```ocaml
let hash str =
  let len = String.length str in
  let rec hash_aux acc i =
    if i >= len then acc
    else
      let char_code = Char.code (String.get str i) in
      let new_acc = (acc lxor char_code) * 16777619 in
      hash_aux new_acc (i + 1)
  in
  hash_aux 2166136261 0
```

### 2. Polynomial Rolling Hash

```ocaml
let hash str =
  let len = String.length str in
  let base = 31 in
  let rec hash_aux acc i =
    if i >= len then acc
    else
      let char_code = Char.code (String.get str i) in
      let new_acc = acc * base + char_code in
      hash_aux new_acc (i + 1)
  in
  hash_aux 0 0
```

### 3. Jenkins One-at-a-Time Hash

```ocaml
let hash str =
  let len = String.length str in
  let rec hash_aux acc i =
    if i >= len then
      let h1 = acc + (acc lsl 3) in
      let h2 = h1 lxor (h1 lsr 11) in
      h2 + (h2 lsl 15)
    else
      let char_code = Char.code (String.get str i) in
      let h1 = acc + char_code in
      let h2 = h1 + (h1 lsl 10) in
      let h3 = h2 lxor (h2 lsr 6) in
      hash_aux h3 (i + 1)
  in
  hash_aux 0 0
```

## Complexités et performances

### Complexités théoriques

| Opération | Moyen cas | Pire cas |
| --------- | --------- | -------- |
| `create`  | O(1)      | O(1)     |
| `add`     | O(1)      | O(n)     |
| `find`    | O(1)      | O(n)     |
| `mem`     | O(1)      | O(n)     |
| `iter`    | O(n)      | O(n)     |

### Facteurs de performance

1. **Qualité de la fonction de hachage**

   - Distribution uniforme
   - Faible nombre de collisions

2. **Facteur de charge** (α = n/m)

   - Idéal : α ≤ 0.75
   - Redimensionnement automatique

3. **Gestion des collisions**
   - Chaînage (utilisé par OCaml)
   - Adressage ouvert

## Comparaison des fonctions de hachage

### Critères d'évaluation

| Fonction   | Vitesse | Distribution | Simplicité | Collisions |
| ---------- | ------- | ------------ | ---------- | ---------- |
| djb2       | +++     | ++           | +++        | ++         |
| FNV-1a     | +++     | +++          | ++         | +++        |
| Jenkins    | ++      | +++          | +          | +++        |
| Polynomial | ++      | ++           | ++         | ++         |

### Recommandations

- **Usage général** : djb2 (bon compromis)
- **Performance critique** : FNV-1a
- **Sécurité** : Jenkins ou MurmurHash
- **Simplicité** : Polynomial rolling hash

## Tests et validation

### Tests de base

```ocaml
let test_stringhashtbl () =
  let ht = StringHashtbl.create 3 in
  StringHashtbl.add ht "test" 42;
  assert (StringHashtbl.find ht "test" = 42);
  assert (StringHashtbl.mem ht "test");
  assert (not (StringHashtbl.mem ht "absent"));

  (* Test des collisions *)
  StringHashtbl.add ht "a" 1;
  StringHashtbl.add ht "b" 2;
  StringHashtbl.add ht "c" 3;

  let count = ref 0 in
  StringHashtbl.iter (fun _ _ -> incr count) ht;
  assert (!count = 4)
```

### Tests de distribution

```ocaml
let test_distribution () =
  let ht = StringHashtbl.create 100 in
  let words = ["apple"; "banana"; "cherry"; "date"; "elderberry"] in
  List.iter (fun w -> StringHashtbl.add ht w (String.length w)) words;

  (* Vérifier que tous les éléments sont présents *)
  List.iter (fun w -> assert (StringHashtbl.mem ht w)) words
```

## Erreurs courantes à éviter

1. **Fonction de hachage triviale**

   ```ocaml
   (* MAUVAIS *)
   let hash s = String.length s
   ```

2. **Non-cohérence equal/hash**

   ```ocaml
   (* MAUVAIS : equal cohérent mais hash non déterministe *)
   let hash s = Random.int 1000
   ```

3. **Débordement d'entiers**

   ```ocaml
   (* Attention aux débordements sur de grandes chaînes *)
   let hash str = (* implémenter avec modulo si nécessaire *)
   ```

4. **Oubli de la récursion terminale**
   ```ocaml
   (* MAUVAIS : risque de stack overflow *)
   let rec hash_aux acc i =
     if i >= len then acc
     else acc + (hash_aux (acc * 33) (i + 1))
   ```

## Bonnes pratiques

### 1. Encapsulation propre

```ocaml
module StringHashtbl = Hashtbl.Make(struct
  type t = string
  let equal = String.equal
  let hash = (* implémentation djb2 *)
end)
```

### 2. Interface étendue

```ocaml
module type STRING_HASHTBL = sig
  include Hashtbl.S with type key = string
  val of_list : (string * 'a) list -> 'a t
  val to_list : 'a t -> (string * 'a) list
end
```

### 3. Tests de performance

```ocaml
let benchmark_hash () =
  let words = (* grande liste de mots *) in
  let start = Sys.time () in
  let ht = StringHashtbl.create (List.length words) in
  List.iter (fun w -> StringHashtbl.add ht w (String.length w)) words;
  let elapsed = Sys.time () -. start in
  Printf.printf "Temps d'insertion : %.4f s\n" elapsed
```

## Conclusion

Cet exercice illustre parfaitement :

- **L'importance du choix de la fonction de hachage**
- **La puissance des foncteurs pour la généricité type-safe**
- **Les compromis performance vs simplicité**
- **La nature non-déterministe des structures de hachage**

L'implémentation avec djb2 offre un excellent équilibre entre performance, simplicité et qualité de distribution, tout en respectant strictement les contraintes de la piscine OCaml.
