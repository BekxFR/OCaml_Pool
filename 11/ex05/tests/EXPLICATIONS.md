# Explications pour l'exercice eu_dist - Distance Euclidienne

## 1. Contexte général

Cet exercice est une introduction au **machine learning** (apprentissage automatique). Bien que le machine learning puisse sembler complexe, il repose sur des fondations mathématiques solides, dont la distance euclidienne est un élément fondamental.

## 2. Qu'est-ce que la distance euclidienne ?

### 2.1 Définition intuitive

La distance euclidienne est simplement la distance "en ligne droite" entre deux points dans l'espace. C'est la distance que l'on mesurerait avec une règle si on pouvait tracer une ligne directe entre deux points.

### 2.2 En 2D (deux dimensions)

Imaginez deux points sur une feuille de papier :

- Point A : (x₁, y₁) = (1, 2)
- Point B : (x₂, y₂) = (4, 6)

La distance euclidienne est calculée avec le **théorème de Pythagore** :

```
distance = √[(x₂ - x₁)² + (y₂ - y₁)²]
distance = √[(4 - 1)² + (6 - 2)²]
distance = √[9 + 16]
distance = √25 = 5
```

### 2.3 En n dimensions

La formule se généralise pour n'importe quel nombre de dimensions :

**Formule mathématique :**

```
eu_dist(a, b) = √[Σᵢ₌₁ⁿ (aᵢ - bᵢ)²]
```

Où :

- `a` et `b` sont deux points (vecteurs)
- `aᵢ` est la coordonnée du point `a` dans la dimension `i`
- `bᵢ` est la coordonnée du point `b` dans la dimension `i`
- `n` est le nombre de dimensions
- `Σ` signifie "somme" (on additionne tous les termes)

## 3. Concepts OCaml nécessaires

### 3.1 Tableaux (Arrays)

En OCaml, les tableaux sont des collections de taille fixe contenant des éléments du même type.

**Déclaration :**

```ocaml
let mon_array = [| 1.0; 2.0; 3.0 |]
```

**Accès aux éléments :**

```ocaml
let premier_element = mon_array.(0)  (* indices commencent à 0 *)
```

**Longueur d'un tableau :**

```ocaml
let longueur = Array.length mon_array
```

### 3.2 Type float

- Type pour les nombres à virgule flottante (décimaux)
- Exemples : `1.0`, `3.14`, `-2.5`
- Opérations : `+.`, `-.`, `*.`, `/.` (noter le point après l'opérateur)

### 3.3 Fonctions mathématiques

OCaml fournit des fonctions mathématiques dans le module par défaut :

**Puissance :**

```ocaml
let carre = x *. x  (* x² *)
(* ou *)
let carre = x ** 2.0  (* opérateur puissance *)
```

**Racine carrée :**

```ocaml
let racine = sqrt x  (* √x *)
```

### 3.4 Signature de fonction demandée

```ocaml
eu_dist : float array -> float array -> float
```

Cette signature signifie :

- La fonction prend **deux paramètres** : deux tableaux de float
- Elle **retourne** un float (la distance)

## 4. Algorithme à implémenter

### 4.1 Étapes de calcul

1. **Parcourir** les deux tableaux simultanément
2. Pour chaque paire de coordonnées (aᵢ, bᵢ) :
   - Calculer la différence : `aᵢ - bᵢ`
   - Élever au carré : `(aᵢ - bᵢ)²`
3. **Additionner** tous ces carrés
4. Prendre la **racine carrée** du résultat

### 4.2 Exemple concret

**Entrée :**

```ocaml
let point_a = [| 1.0; 2.0; 3.0 |]
let point_b = [| 4.0; 6.0; 3.0 |]
```

**Calcul :**

```
Dimension 1: (1.0 - 4.0)² = (-3.0)² = 9.0
Dimension 2: (2.0 - 6.0)² = (-4.0)² = 16.0
Dimension 3: (3.0 - 3.0)² = (0.0)² = 0.0

Somme = 9.0 + 16.0 + 0.0 = 25.0
Distance = √25.0 = 5.0
```

## 5. Outils OCaml utiles

### 5.1 Itération sur les indices

Pour parcourir un tableau par indices :

```ocaml
for i = 0 to Array.length arr - 1 do
  (* traiter arr.(i) *)
done
```

### 5.2 Fonctions d'ordre supérieur

OCaml propose des fonctions comme :

- `Array.map` : applique une fonction à chaque élément
- `Array.fold_left` : accumule une valeur en parcourant le tableau
- `Array.mapi` : comme map, mais avec accès à l'indice

### 5.3 Références mutables

Si on veut accumuler une somme :

```ocaml
let somme = ref 0.0 in
(* ... *)
somme := !somme +. valeur;
(* ... *)
!somme  (* déréférencement pour obtenir la valeur *)
```

## 6. Domaine mathématique

**eu_dist : ℝᴰ × ℝᴰ → ℝ⁺, D ∈ ℕ\***

Signification :

- **ℝᴰ** : espace réel à D dimensions (un point avec D coordonnées)
- **×** : produit cartésien (deux points en entrée)
- **→** : fonction qui mappe vers...
- **ℝ⁺** : nombres réels positifs ou nuls (une distance est toujours ≥ 0)
- **D ∈ ℕ\*** : D est un entier naturel strictement positif (au moins 1 dimension)

## 7. Propriétés de la distance euclidienne

### 7.1 Propriétés mathématiques

1. **Non-négativité** : d(a, b) ≥ 0
2. **Identité** : d(a, b) = 0 si et seulement si a = b
3. **Symétrie** : d(a, b) = d(b, a)
4. **Inégalité triangulaire** : d(a, c) ≤ d(a, b) + d(b, c)

### 7.2 Applications en machine learning

La distance euclidienne est utilisée dans :

- **K-Nearest Neighbors (KNN)** : trouver les k points les plus proches
- **K-Means clustering** : regrouper des points similaires
- **Analyse de similarité** : mesurer la ressemblance entre données
- **Détection d'anomalies** : identifier les points éloignés

## 8. Points d'attention pour l'implémentation

### 8.1 Hypothèses

- Les deux tableaux ont **la même longueur** (pas besoin de gérer le cas contraire)
- Les tableaux ne sont **pas vides**
- Tous les éléments sont des **float valides**

### 8.2 Cas particuliers à tester

```ocaml
(* Même point : distance = 0 *)
eu_dist [|1.0; 2.0|] [|1.0; 2.0|] = 0.0

(* 1D : simple différence absolue *)
eu_dist [|5.0|] [|2.0|] = 3.0

(* 2D : pythagore classique *)
eu_dist [|0.0; 0.0|] [|3.0; 4.0|] = 5.0

(* 3D et plus *)
eu_dist [|1.0; 2.0; 3.0|] [|4.0; 6.0; 3.0|] = 5.0
```

## 9. Concepts avancés (optionnels)

### 9.1 Autres distances en ML

- **Distance de Manhattan** : Σ|aᵢ - bᵢ|
- **Distance de Minkowski** : généralisation
- **Distance de Cosinus** : angle entre vecteurs

### 9.2 Optimisation

Pour éviter le calcul de la racine carrée (coûteux) quand on compare des distances :

- On peut comparer les **distances au carré** directement
- Si d₁² < d₂², alors d₁ < d₂

## 10. Résumé pour l'implémentation

**Ce qu'il faut faire :**

1. Prendre deux tableaux de float en paramètre
2. Calculer la somme des carrés des différences
3. Retourner la racine carrée de cette somme

**Structures de données :**

- Entrée : `float array` et `float array`
- Sortie : `float`

**Opérations clés :**

- Parcours d'indices : 0 à n-1
- Soustraction : `-.`
- Multiplication : `*.`
- Addition cumulative
- Racine carrée : `sqrt`
