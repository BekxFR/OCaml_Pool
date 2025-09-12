# Explication détaillée : Séquence de Gray (Code Gray)

## Qu'est-ce que la séquence de Gray ?

La séquence de Gray (ou code Gray) est une séquence binaire où deux valeurs consécutives ne diffèrent que par un seul bit. Cette propriété est cruciale pour éviter les états intermédiaires indésirables lors des transitions.

### Exemple du problème avec la séquence binaire classique :

```
Séquence binaire standard pour n=2 : 00 → 01 → 10 → 11
```

**Problème** : Pour passer de `01` à `10`, il faut changer 2 bits :

- Bit 0 : `1` → `0`
- Bit 1 : `0` → `1`

Cela peut créer un état intermédiaire `00` ou `11`, ce qui peut causer des erreurs dans les systèmes électroniques.

### Solution avec Gray :

```
Séquence de Gray pour n=2 : 00 → 01 → 11 → 10
```

Ici, chaque transition ne change qu'un seul bit :

- `00` → `01` : seul le bit 0 change
- `01` → `11` : seul le bit 1 change
- `11` → `10` : seul le bit 0 change
- `10` → `00` : seul le bit 1 change (retour au début)

## Algorithme mathématique

### Formule de conversion binaire → Gray

```
gray(i) = i XOR (i >> 1)
```

Où :

- `i` est l'index en binaire standard (0, 1, 2, 3, ...)
- `>>` est le décalage binaire à droite
- `XOR` est l'opération "ou exclusif"

### Démonstration étape par étape pour n=3

| i (décimal) | i (binaire) | i >> 1 | i XOR (i >> 1) | Gray (binaire) |
| ----------- | ----------- | ------ | -------------- | -------------- |
| 0           | 000         | 000    | 000 XOR 000    | 000            |
| 1           | 001         | 000    | 001 XOR 000    | 001            |
| 2           | 010         | 001    | 010 XOR 001    | 011            |
| 3           | 011         | 001    | 011 XOR 001    | 010            |
| 4           | 100         | 010    | 100 XOR 010    | 110            |
| 5           | 101         | 010    | 101 XOR 010    | 111            |
| 6           | 110         | 011    | 110 XOR 011    | 101            |
| 7           | 111         | 011    | 111 XOR 011    | 100            |

**Résultat** : `000 001 011 010 110 111 101 100`

### Vérification de la propriété "un seul bit change" :

- `000` → `001` : bit 0 change (0→1)
- `001` → `011` : bit 1 change (0→1)
- `011` → `010` : bit 0 change (1→0)
- `010` → `110` : bit 2 change (0→1)
- `110` → `111` : bit 0 change (0→1)
- `111` → `101` : bit 1 change (1→0)
- `101` → `100` : bit 0 change (1→0)

✅ Chaque transition ne change effectivement qu'un seul bit !

## Analyse du code OCaml

### 1. Fonction auxiliaire `pow2`

```ocaml
let pow2 k =
  let rec aux acc k =
    if k = 0 then acc
    else aux (acc * 2) (k - 1) in
  aux 1 k
```

**Rôle** : Calcule 2^k (le nombre total d'éléments dans la séquence)

- Pour n=1 : 2^1 = 2 éléments
- Pour n=2 : 2^2 = 4 éléments
- Pour n=3 : 2^3 = 8 éléments

### 2. Conversion binaire → Gray

```ocaml
let g = i lxor (i lsr 1) in
```

**Explication des opérateurs** :

- `lsr` : Logical Shift Right (décalage logique à droite)
- `lxor` : XOR logique
- `land` : AND logique

**Exemple détaillé pour i=5** :

```
i = 5 = 101 (binaire)
i lsr 1 = 101 >> 1 = 010 (binaire) = 2 (décimal)
g = 5 lxor 2 = 101 lxor 010 = 111 (binaire) = 7 (décimal)
```

### 3. Construction de la chaîne binaire

```ocaml
let rec build_str j acc =
  if j < 0 then acc
  else
    let bit =
      if (g lsr j) land 1 = 0 then "0"
      else "1"
    in
    build_str (j - 1) (acc ^ bit)
```

**Fonctionnement** : Pour chaque position de bit (de gauche à droite) :

**Exemple pour g=7 (111 en binaire) avec n=3** :

1. **j=2** : `(g lsr 2) land 1` = `(111 >> 2) land 1` = `001 land 1` = `1` → "1"
2. **j=1** : `(g lsr 1) land 1` = `(111 >> 1) land 1` = `011 land 1` = `1` → "1"
3. **j=0** : `(g lsr 0) land 1` = `(111 >> 0) land 1` = `111 land 1` = `1` → "1"

**Résultat** : "111"

### 4. Explication de `(g lsr j) land 1`

Cette expression extrait le bit à la position `j` :

**Exemple avec g=5 (101 en binaire)** :

- Position 2 : `(101 >> 2) land 1` = `001 land 1` = `1`
- Position 1 : `(101 >> 1) land 1` = `010 land 1` = `0`
- Position 0 : `(101 >> 0) land 1` = `101 land 1` = `1`

Résultat : "101"

## Exemples complets d'exécution

### Gray(1) :

```
i=0: 0 XOR (0>>1) = 0 XOR 0 = 0 → "0"
i=1: 1 XOR (1>>1) = 1 XOR 0 = 1 → "1"
```

**Sortie** : `0 1`

### Gray(2) :

```
i=0: 0 XOR (0>>1) = 0 XOR 0 = 0 → "00"
i=1: 1 XOR (1>>1) = 1 XOR 0 = 1 → "01"
i=2: 2 XOR (2>>1) = 2 XOR 1 = 3 → "11"
i=3: 3 XOR (3>>1) = 3 XOR 1 = 2 → "10"
```

**Sortie** : `00 01 11 10`

### Gray(3) :

```
i=0: 0 XOR 0 = 0 → "000"
i=1: 1 XOR 0 = 1 → "001"
i=2: 2 XOR 1 = 3 → "011"
i=3: 3 XOR 1 = 2 → "010"
i=4: 4 XOR 2 = 6 → "110"
i=5: 5 XOR 2 = 7 → "111"
i=6: 6 XOR 3 = 5 → "101"
i=7: 7 XOR 3 = 4 → "100"
```

**Sortie** : `000 001 011 010 110 111 101 100`

## Applications pratiques

1. **Encodeurs rotatifs** : Évite les erreurs de lecture lors des transitions
2. **Systèmes de navigation** : Réduction des erreurs dans les capteurs de position
3. **Circuits logiques** : Minimise les transitions simultanées multiples
4. **Systèmes embarqués** : Évite les états indéterminés

## Complexité

- **Temporelle** : O(n × 2^n) où n est le nombre de bits
- **Spatiale** : O(n) pour stocker la chaîne de bits

L'algorithme est très efficace car il utilise des opérations binaires natives du processeur.
