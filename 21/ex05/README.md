# Exercise 05 - Incomplete Combustion

## Description

Cet exercice étend la classe `alkane_combustion` pour gérer les **combustions incomplètes**, qui se produisent lorsqu'il n'y a pas assez d'oxygène pour brûler complètement l'alcane.

## Concept chimique

### Combustion complète vs incomplète

**Combustion complète** (suffisamment d'O2):

```
2 C2H6 + 7 O2 → 4 CO2 + 6 H2O
```

Produit uniquement du dioxyde de carbone (CO2) et de l'eau (H2O).

**Combustion incomplète** (manque d'O2):

```
C2H6 + 2 O2 → CO + C + 3 H2O
C2H6 + 3 O2 → CO2 + CO + 3 H2O
```

Produit du monoxyde de carbone (CO) et/ou du carbone pur (C - suie) en plus de CO2 et H2O.

### Nouvelles molécules

- **Carbon (C)**: Carbone pur (suie noire)
- **Carbon monoxide (CO)**: Gaz toxique incolore

## Classe `incomplete_combustion`

### Héritage

```ocaml
class incomplete_combustion (alkanes : Alkane.alkane list) =
object
  inherit Alkane_combustion.alkane_combustion alkanes

  method get_incomplete_results : (int * (Molecule.molecule * int) list) list
end
```

Hérite de `alkane_combustion`, donc possède toutes ses méthodes (`balance`, `get_start`, `get_result`, etc.).

### Méthode `get_incomplete_results`

**Type**: `(int * (Molecule.molecule * int) list) list`

**Retour**: Liste de tuples où:

- Premier élément (`int`): Quantité d'O2 utilisée
- Deuxième élément (`(molecule * int) list`): Liste des produits avec leurs coefficients

**Exemple de retour**:

```ocaml
[
  (1, [(C, 1); (H2O, 2)]);           (* Avec 1 O2: C + 2 H2O *)
  (2, [(CO, 1); (C, 1); (H2O, 2)]);  (* Avec 2 O2: CO + C + 2 H2O *)
]
```

## Algorithme

### Étape 1: Calcul de l'oxygène disponible

Pour une quantité `n` de molécules O2:

- Oxygène total disponible: `2 * n` atomes
- Oxygène pour H2O (fixe): `total_hydrogens / 2` atomes
- Oxygène restant pour C: `2 * n - (total_hydrogens / 2)` atomes

### Étape 2: Génération des combinaisons

Pour chaque combinaison de CO2, CO, et C:

- **CO2** consomme 2 atomes d'oxygène par atome de carbone
- **CO** consomme 1 atome d'oxygène par atome de carbone
- **C** ne consomme pas d'oxygène

L'algorithme génère récursivement toutes les combinaisons qui:

1. Utilisent exactement `total_carbons` atomes de carbone
2. Utilisent exactement l'oxygène disponible

### Étape 3: Filtrage

On filtre pour ne garder que les combustions **incomplètes**:

- Doit contenir au moins du CO ou du C
- Exclut les combustions complètes (uniquement CO2)

## Exemples de résultats

### Méthane (CH4)

Avec 1 O2 seulement:

```
CH4 + O2 → C + 2 H2O
```

- 4 H nécessitent 2 O (pour 2 H2O) ✓
- 0 O restant → 1 C reste non brûlé ✓

### Éthane (C2H6)

Avec 2 O2:

```
C2H6 + 2 O2 → CO + C + 3 H2O
```

- 6 H nécessitent 3 O (pour 3 H2O)
- 4 O disponibles - 3 O pour H2O = 1 O restant
- 1 O peut former 1 CO, laissant 1 C ✓

Avec 3 O2:

```
C2H6 + 3 O2 → CO2 + CO + 3 H2O
C2H6 + 3 O2 → 2 CO + 3 H2O
```

- 6 O disponibles - 3 O pour H2O = 3 O restant
- 2 carbones à placer avec 3 O disponibles
- Solutions: (1 CO2 + 1 CO) ou (2 CO) ✓

### Propane (C3H8)

Plus de carbones = plus de combinaisons possibles!

Avec 3 O2:

```
C3H8 + 3 O2 → CO2 + 2 C + 4 H2O
C3H8 + 3 O2 → 2 CO + C + 4 H2O
C3H8 + 3 O2 → 3 CO + 4 H2O (complete! filtered out)
```

## Compilation et exécution

```bash
make        # Compiler
make run    # Compiler et exécuter
make clean  # Nettoyer
```

## Tests

Le fichier `main.ml` teste:

1. **Éthane**: Génération de toutes les combustions incomplètes
2. **Propane**: Plus de combinaisons possibles
3. **Méthane**: Cas simple avec peu de résultats
4. **Héritage**: Vérification que la combustion complète fonctionne toujours
5. **Statistiques**: Comptage des résultats par quantité d'O2

## Complexité

Le nombre de solutions croît **exponentiellement** avec:

- Le nombre d'atomes de carbone
- La quantité d'oxygène disponible

Pour un alcane CnH(2n+2):

- n=1 (méthane): ~1 solution incomplète
- n=2 (éthane): ~4 solutions incomplètes
- n=3 (propane): ~13 solutions incomplètes
- n=8 (octane): plusieurs centaines de solutions

## Observations

### Duplications

Certaines solutions peuvent apparaître plusieurs fois avec un **ordre différent** des produits:

```
CO + C + 3 H2O
C + CO + 3 H2O
```

C'est acceptable - l'énoncé demande toutes les combinaisons possibles.

### Conservation des atomes

Toutes les solutions respectent:

- **Conservation du carbone**: Somme des carbones dans les produits = carbones dans l'alcane
- **Conservation de l'hydrogène**: H dans H2O = H dans l'alcane
- **Conservation de l'oxygène**: O dans les produits = O dans O2

### Réalisme chimique

Dans la réalité, les combustions incomplètes dépendent de:

- La température
- La pression
- Le mélange air/carburant
- La structure moléculaire

Ici, on considère uniquement l'**équilibre stœchiométrique** (comptage d'atomes).

## Points clés

✅ Hérite de `alkane_combustion`  
✅ Génération exhaustive des combinaisons  
✅ Filtrage des combustions complètes  
✅ Conservation des atomes respectée  
✅ Style fonctionnel (récursion, pas de mutable)  
✅ Type de retour: `(int * (molecule * int) list) list`

## Ressources

- **Combustion incomplète**: https://fr.wikipedia.org/wiki/Combustion#Combustion_incomplète
- **Monoxyde de carbone**: https://fr.wikipedia.org/wiki/Monoxyde_de_carbone
- **Suie**: https://fr.wikipedia.org/wiki/Suie
