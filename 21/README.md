#- Chimie et Programmation Orientée Objet

## Description

Ce jour explore la modélisation de concepts chimiques en OCaml avec un focus sur les **classes virtuelles**, l'**héritage**, et le **paradigme fonctionnel strict**.

## Thème: Chimie et Molécules

Les exercices construisent progressivement un système de modélisation chimique:

1. **Atomes** (éléments de base)
2. **Molécules** (assemblages d'atomes)
3. **Alcanes** (famille d'hydrocarbures)
4. **Réactions chimiques** (transformations avec conservation)
5. **Combustion** (réactions spécifiques équilibrées)

## Contraintes

- ❌ **Pas de style impératif**: Interdiction de `mutable`, `for`, `while`, `Array` avec mutation
- ✅ **Style fonctionnel uniquement**: Utilisation de `List.map`, `List.fold_left`, récursion
- ✅ **Listes associatives triées**: Par ordre croissant d'index
- ✅ **Exception pour déséquilibre**: `UnbalancedReaction`

## Exercices

### Ex00: Atoms (Atomes)

**Fichiers**: `atom.ml`, `main.ml`, `Makefile`

Classe virtuelle `atom` avec 3 méthodes virtuelles:

- `name`: Nom complet de l'atome
- `symbol`: Symbole chimique
- `atomic_number`: Numéro atomique

Implémentations concrètes: Hydrogen, Carbon, Oxygen, Nitrogen, Sulfur, Chlorine

**Compilation**: `make`  
**Exécution**: `./ex00`

### Ex01: Molecules (Molécules)

**Fichiers**: `molecule.ml`, `main.ml`, `Makefile`

Classe virtuelle `molecule` qui:

- Hérite conceptuellement de `atom` via composition
- Génère automatiquement la **formule chimique** en notation de Hill
- Implémente `to_string` et `equals`

**Notation de Hill**: C d'abord, puis H, puis ordre alphabétique

Molécules implémentées: Water, Carbon dioxide, Methane, Sulfuric acid, Ammonia

**Compilation**: `make`  
**Exécution**: `./ex01`

### Ex02: Alkanes (Alcanes)

**Fichiers**: `alkane.ml`, `main.ml`, `Makefile`

Classe `alkane` héritant de `molecule` avec génération automatique selon la formule:

```
CnH(2n+2) où 1 ≤ n ≤ 12
```

Génère automatiquement les atomes de carbone et d'hydrogène selon `n`.

Alcanes disponibles:

- n=1: Methane (CH4)
- n=2: Ethane (C2H6)
- n=3: Propane (C3H8)
- ...
- n=12: Dodecane (C12H26)

**Compilation**: `make`  
**Exécution**: `./ex02`

### Ex03: Reactions (Réactions chimiques)

**Fichiers**: `reaction.ml`, `main.ml`, `Makefile`

Classe virtuelle `reaction` modélisant les réactions chimiques avec:

- `get_start`: Liste des réactifs (molécule, coefficient)
- `get_result`: Liste des produits (molécule, coefficient)
- `is_balanced`: Vérifie la loi de Lavoisier (conservation des atomes)
- `balance`: Méthode virtuelle pour équilibrer

**Loi de Lavoisier**: Le nombre d'atomes de chaque type doit être identique avant et après la réaction.

Réactions exemples: Combustion du méthane, Synthèse de l'eau

**Compilation**: `make`  
**Exécution**: `./ex03`

### Ex04: Alkane Combustion (Combustion des alcanes)

**Fichiers**: `alkane_combustion.ml`, `main.ml`, `Makefile`

Classe `alkane_combustion` héritant de `reaction` qui:

- Prend une liste d'alcanes en entrée
- Calcule automatiquement les coefficients stœchiométriques
- Lance `UnbalancedReaction` si `get_start`/`get_result` appelés avant `balance`

**Formule de combustion**:

```
2 CnH(2n+2) + (2n+3) O2 → 2n CO2 + 2(n+1) H2O
```

Exemples:

- Méthane: `2 CH4 + 5 O2 → 2 CO2 + 4 H2O`
- Octane: `2 C8H18 + 19 O2 → 16 CO2 + 18 H2O`

> 📚 **Documentation détaillée** : Voir [GUIDE_PEDAGOGIQUE_DAY21.md](GUIDE_PEDAGOGIQUE_DAY21.md) - Section "Annexe Technique" pour :
> - Le calcul détaillé des coefficients stœchiométriques
> - L'explication de la multiplication par 2 pour éviter les fractions
> - Le calcul du PGCD avec exemples pas-à-pas
> - Un tableau récapitulatif pour tous les alcanes

**Compilation**: `make`  
**Exécution**: `./ex04`

### Ex05: Incomplete Combustion (Combustion incomplète)

**Fichiers**: `incomplete_combustion.ml`, `main.ml`, `Makefile`

Classe `incomplete_combustion` héritant de `alkane_combustion` qui:

- Génère toutes les combustions incomplètes possibles
- Méthode `get_incomplete_results` retournant `(int * (molecule * int) list) list`
- Calcule les résultats avec CO2, CO, C (carbone pur) et H2O
- Varie la quantité d'O2 de 1 jusqu'à la combustion complète - 1

**Combustion incomplète**: Quand il n'y a pas assez d'oxygène, on obtient du monoxyde de carbone (CO) ou du carbone pur (C - suie).

Exemples pour l'éthane (C2H6):

- Avec 2 O2: `C2H6 + 2 O2 → CO + C + 3 H2O`
- Avec 3 O2: `C2H6 + 3 O2 → CO2 + CO + 3 H2O`

**Format de retour**: Liste de tuples `(quantité_O2, liste_produits)`

**Compilation**: `make`  
**Exécution**: `./ex05`

## Structure des fichiers

```
21/
├── GUIDE_PEDAGOGIQUE_DAY21.md       # Guide complet avec explications détaillées
├── CALCUL_COEFFICIENTS_EXEMPLES.md  # 🔥 Exemples pas-à-pas du calcul des coefficients
├── README.md                         # Ce fichier
├── ex00/
│   ├── atom.ml                       # Classe virtuelle atom + implémentations
│   ├── main.ml                       # Tests
│   └── Makefile
├── ex01/
│   ├── molecule.ml                   # Classe virtuelle molecule + implémentations
│   ├── main.ml                       # Tests
│   └── Makefile
├── ex02/
│   ├── alkane.ml                     # Classe alkane (CnH2n+2)
│   ├── main.ml                       # Tests
│   └── Makefile
├── ex03/
│   ├── reaction.ml                   # Classe virtuelle reaction
│   ├── main.ml                       # Tests
│   └── Makefile
├── ex04/
│   ├── alkane_combustion.ml          # Combustion avec équilibrage
│   ├── main.ml                       # Tests
│   └── Makefile
└── ex05/
    ├── incomplete_combustion.ml      # Combustion incomplète
    ├── main.ml                       # Tests
    └── Makefile
```

## 📚 Documentation

- **[README.md](README.md)** : Vue d'ensemble et guide de démarrage rapide
- **[GUIDE_PEDAGOGIQUE_DAY21.md](GUIDE_PEDAGOGIQUE_DAY21.md)** : Guide complet avec :
  - Explications détaillées de chaque exercice
  - Concepts chimiques et OCaml
  - Section "Annexe Technique" sur les coefficients stœchiométriques
  - Calcul du PGCD avec exemples
  - Difficultés courantes et solutions
  
- **[CALCUL_COEFFICIENTS_EXEMPLES.md](CALCUL_COEFFICIENTS_EXEMPLES.md)** : 🔥 **Nouveau !**
  - Exemples pas-à-pas pour le méthane, éthane, propane, butane
  - Explications visuelles du calcul des coefficients
  - Tableaux récapitulatifs pour tous les alcanes
  - Code OCaml commenté

## Dépendances entre exercices

```
ex00 (atom)
  ↓
ex01 (molecule) ← dépend de ex00
  ↓
ex02 (alkane) ← dépend de ex00, ex01
  ↓
ex03 (reaction) ← dépend de ex00, ex01, ex02
  ↓
ex04 (alkane_combustion) ← dépend de ex00, ex01, ex02, ex03
  ↓
ex05 (incomplete_combustion) ← dépend de ex00, ex01, ex02, ex03, ex04
```

Les Makefiles gèrent automatiquement ces dépendances avec les flags `-I`.

## Compilation globale

Depuis la racine du Day 21:

```bash
# Compiler tous les exercices
for i in ex00 ex01 ex02 ex03 ex04 ex05; do
  cd $i && make && cd ..
done

# Exécuter tous les tests
for i in ex00 ex01 ex02 ex03 ex04 ex05; do
  echo "=== Testing $i ===" && ./$i/$i
done
```

## Concepts OCaml utilisés

- **Classes virtuelles**: `class virtual`, `method virtual`
- **Héritage**: `inherit parent_class`
- **Composition**: Objets contenant d'autres objets
- **Upcast**: `(obj :> parent_type)` pour polymorphisme
- **Exceptions**: `exception`, `raise`, `try...with`
- **List functions**: `map`, `fold_left`, `filter`, `init`, `sort`
- **Références**: `ref` (usage minimal pour état balanced)

## Notation de Hill - Rappel

Système standardisé pour écrire les formules chimiques:

1. **C** (carbone) en premier si présent
2. **H** (hydrogène) en second si présent
3. **Autres éléments** par ordre alphabétique

Exemples:

- H2O (pas de C, donc H en premier)
- CH4 (C puis H)
- C2H6 (C puis H avec leurs nombres)
- H2O4S (pas de C, donc H puis ordre alpha: O, S)

## Stœchiométrie - Rappel

**Équilibrage d'une réaction**: Trouver les coefficients qui conservent le nombre d'atomes.

Exemple - Combustion du méthane:

```
CH4 + O2 → CO2 + H2O     (non équilibré)
CH4 + 2O2 → CO2 + 2H2O   (équilibré)
```

Vérification:

- Réactifs: 1 C, 4 H, 4 O
- Produits: 1 C, 4 H, 4 O ✓

## Résultats attendus

### Ex00 - Atomes

```
=== Ex00: Testing Atoms ===
--- Test 2: Atom descriptions ---
Hydrogen (H, Z=1)
Carbon (C, Z=6)
Oxygen (O, Z=8)
...
```

### Ex01 - Molécules

```
=== Ex01: Testing Molecules ===
--- Test 2: Molecule descriptions ---
Water (H2O)
Carbon dioxide (CO2)
Methane (CH4)
...
```

### Ex02 - Alcanes

```
=== Ex02: Testing Alkanes ===
--- Test 4: All alkanes (n=1 to 12) ---
n= 1: Methane (CH4)
n= 2: Ethane (C2H6)
n= 3: Propane (C3H8)
...
```

### Ex03 - Réactions

```
=== Ex03: Testing Reactions ===
--- Test 2: Displaying reactions ---
Methane combustion: Methane (CH4) + 2 O2 -> CO2 + 2 H2O
...
```

### Ex04 - Combustion

```
=== Ex04: Testing Alkane Combustion ===
--- Test 1: Methane combustion ---
Reaction: 2 Methane (CH4) + 5 Dioxygen (O2) -> 2 CO2 + 4 H2O
...
```

## Points d'attention

1. ✅ Toutes les classes doivent être **fonctionnelles** (pas de mutable inapproprié)
2. ✅ Les formules doivent respecter la **notation de Hill**
3. ✅ Les réactions doivent être **équilibrées** (conservation des atomes)
4. ✅ L'exception `UnbalancedReaction` doit être levée au bon moment
5. ✅ Les coefficients stœchiométriques doivent être **corrects**

## Ressources

- **Guide pédagogique**: Voir `GUIDE_PEDAGOGIQUE_DAY21.md` pour explications détaillées
- **OCaml Manual**: https://ocaml.org/manual/
- **Notation de Hill**: https://en.wikipedia.org/wiki/Chemical_formula#Hill_system
- **Stœchiométrie**: https://fr.wikipedia.org/wiki/Stœchiométrie
