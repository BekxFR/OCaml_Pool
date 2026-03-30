# Module 21 — Programmation Orientee Objet en OCaml : Guide pour debutants

Ce guide explique pas a pas les concepts du module 21 de la piscine OCaml.
Le theme : modeliser la chimie avec des classes et de l'heritage.

---

## La POO en OCaml : les bases

OCaml est connu comme un langage fonctionnel, mais il supporte aussi la
programmation orientee objet. Voici les concepts utilises dans ce module :

### Classe virtuelle

Une classe qu'on ne peut pas instancier directement. Elle definit un "contrat" :
les sous-classes doivent implementer ses methodes virtuelles.

```ocaml
class virtual animal =
object (self)
  method virtual cri : string          (* pas d'implementation *)
  method presenter = "Je fais : " ^ self#cri   (* implementation concrete *)
end
```

On ne peut pas ecrire `new animal` — il faut creer une sous-classe.

### Heritage

Une classe concrete herite d'une classe virtuelle et implemente ses methodes :

```ocaml
class chien =
object
  inherit animal
  method cri = "Woof"
end

let rex = new chien     (* OK — rex#presenter retourne "Je fais : Woof" *)
```

### Coercion de type (`:>`)

OCaml n'a pas de sous-typage implicite. Pour mettre des objets de types differents
dans une meme liste, il faut les convertir explicitement vers le type parent :

```ocaml
let animaux : animal list = [
  (rex :> animal);
  (new chat :> animal);
]
```

### `self`

Le mot-cle `self` permet a un objet d'appeler ses propres methodes. C'est
l'equivalent du `this` en Java/C++.

---

## La chimie modelisee

Le module 21 construit progressivement un systeme de chimie :

```
Atome -> Molecule -> Alcane -> Reaction -> Combustion -> Combustion incomplete
ex00     ex01       ex02      ex03        ex04          ex05
```

Chaque exercice depend du precedent. On commence par les briques de base
(les atomes) et on monte vers des systemes de plus en plus complexes
(les reactions chimiques equilibrees).

---

## Exercice par exercice

---

### ex00 — Atoms (les atomes)

**Concept chimique** : Un atome est la plus petite unite d'un element chimique.
Il est defini par son nom, son symbole et son numero atomique (Z).

**Concept OCaml** : Classe virtuelle + heritage.

**Ce qu'on construit** :

```
atom (virtuel)
  |-- hydrogen   (H,  Z=1)
  |-- carbon     (C,  Z=6)
  |-- nitrogen   (N,  Z=7)
  |-- oxygen     (O,  Z=8)
  |-- sulfur     (S,  Z=16)
  |-- chlorine   (Cl, Z=17)
```

La classe `atom` est virtuelle : elle definit les methodes `name`, `symbol`,
`atomic_number` (virtuelles) et `to_string`, `equals` (concretes).

Chaque atome concret herite de `atom` et fixe les valeurs :

```ocaml
class hydrogen =
object
  inherit atom
  method name = "Hydrogen"
  method symbol = "H"
  method atomic_number = 1
end
```

**Methodes** :
- `to_string` : `"Hydrogen: [H, Z=1]"` — description textuelle
- `equals` : compare deux atomes par leur numero atomique

**Fichiers** : `ex00/atom.ml`, `ex00/main.ml`, `ex00/Makefile`

---

### ex01 — Molecules (les molecules)

**Concept chimique** : Une molecule est un assemblage d'atomes. Sa formule
chimique liste les symboles et les quantites de chaque atome.

**Concept OCaml** : Constructeur avec parametres + calcul dans les methodes.

**Ce qu'on construit** :

La classe virtuelle `molecule` prend une liste d'atomes en parametre du
constructeur. A partir de cette liste, elle calcule automatiquement la formule
chimique en **notation de Hill** :

> Notation de Hill : le carbone (C) vient en premier, puis l'hydrogene (H),
> puis tous les autres elements par ordre alphabetique. Si un element
> apparait une seule fois, on n'ecrit pas "1".

**Exemple avec le TNT (C7H5N3O6)** :
1. On a 7 C, 5 H, 3 N, 6 O
2. Hill : C d'abord -> `C7`, H ensuite -> `H5`, puis alphabetique -> `N3O6`
3. Resultat : `C7H5N3O6`

**Molecules implementees** :

| Classe | Formule | Atomes |
|--------|---------|--------|
| `water` | H2O | 2 H + 1 O |
| `carbon_dioxide` | CO2 | 1 C + 2 O |
| `methane` | CH4 | 1 C + 4 H |
| `sulfuric_acid` | H2O4S | 2 H + 1 S + 4 O |
| `ammonia` | H3N | 3 H + 1 N |
| `dioxygen` | O2 | 2 O |
| `dihydrogen` | H2 | 2 H |

**Comment la formule est calculee** :
1. Compter les occurrences de chaque symbole dans la liste d'atomes
2. Trier selon Hill (C, H, puis alphabetique)
3. Formater : symbole + nombre (sauf si nombre = 1)

**Fichiers** : `ex01/molecule.ml`, `ex01/main.ml`, `ex01/Makefile`

---

### ex02 — Alkanes (les alcanes)

**Concept chimique** : Les alcanes sont une famille de molecules composees
uniquement de carbone et d'hydrogene, suivant la formule **CnH(2n+2)** :

| n | Nom | Formule |
|---|-----|---------|
| 1 | Methane | CH4 |
| 2 | Ethane | C2H6 |
| 3 | Propane | C3H8 |
| 4 | Butane | C4H10 |
| ... | ... | ... |
| 8 | Octane | C8H18 |
| ... | ... | ... |
| 12 | Dodecane | C12H26 |

**Concept OCaml** : Classe parametree + validation dans le constructeur +
heritage en chaine.

La classe `alkane` prend `n` en parametre. Le constructeur :
1. Verifie que `1 <= n <= 12`
2. Genere automatiquement la liste d'atomes (n carbones + 2n+2 hydrogenes)
3. Passe cette liste au constructeur de `molecule` via `inherit`

```ocaml
class alkane (n : int) =
  let () = if n < 1 || n > 12 then failwith "..." in
  let atoms_list = (* n carbones + 2n+2 hydrogenes *) in
object
  inherit Molecule.molecule atoms_list
  method name = match n with 1 -> "Methane" | 2 -> "Ethane" | ...
  method carbon_count = n
end
```

Les 12 alcanes sont aussi disponibles comme classes raccourcis :

```ocaml
class methane = object inherit alkane 1 end
class ethane  = object inherit alkane 2 end
class octane  = object inherit alkane 8 end
(* ... etc. *)
```

**Fichiers** : `ex02/alkane.ml`, `ex02/main.ml`, `ex02/Makefile`

---

### ex03 — Reactions (les reactions chimiques)

**Concept chimique** : Une reaction chimique transforme des reactifs en produits.
La **loi de Lavoisier** impose que le nombre d'atomes de chaque element soit
conserve entre les deux cotes de la reaction.

**Concept OCaml** : Classe virtuelle avec methodes concretes partagees +
parsing de formule chimique.

La classe `reaction` est virtuelle et definit :

| Methode | Type | Role |
|---------|------|------|
| `get_start` (virtuelle) | `(molecule * int) list` | Reactifs avec coefficients |
| `get_result` (virtuelle) | `(molecule * int) list` | Produits avec coefficients |
| `balance` (virtuelle) | `reaction` | Equilibrer la reaction |
| `is_balanced` (concrete) | `bool` | Verifier la conservation des atomes |
| `to_string` (concrete) | `string` | Affichage de la reaction |

**`is_balanced`** est le coeur du systeme : elle parse les formules chimiques
de toutes les molecules, multiplie par les coefficients stoechiometriques,
et compare les totaux cote reactifs vs cote produits.

**Exemple** : `CH4 + 2 O2 -> CO2 + 2 H2O`
- Reactifs : 1C + 4H + 4O = {C:1, H:4, O:4}
- Produits : 1C + 2H + 3O... non ! 1C + 2*2H + 1*2O + 2*1O = {C:1, H:4, O:4}
- Les deux cotes sont egaux -> equilibree.

**Reactions implementees** :
- `methane_combustion` : CH4 + 2 O2 -> CO2 + 2 H2O
- `water_synthesis` : 2 H2 + O2 -> 2 H2O

**Fichiers** : `ex03/reaction.ml`, `ex03/main.ml`, `ex03/Makefile`

---

### ex04 — Alkane Combustion (combustion complete)

**Concept chimique** : Bruler un alcane = alcane + dioxygene -> dioxyde de
carbone + eau. Il faut trouver les **coefficients stoechiometriques** pour
que la reaction soit equilibree.

**Concept OCaml** : Calcul dans le constructeur + heritage concret.

**La methode d'equilibrage pas a pas** :

Pour un alcane CnH(2n+2), la reaction est :
```
CnH(2n+2) + O2 -> CO2 + H2O
```

On equilibre atome par atome :
1. **Carbone** : n C a gauche -> n CO2 a droite
2. **Hydrogene** : (2n+2) H a gauche -> (n+1) H2O a droite
3. **Oxygene** : a droite on a 2n + (n+1) = 3n+1 atomes d'O -> (3n+1)/2 O2

Le probleme : (3n+1)/2 n'est pas toujours entier. On multiplie tout par 2 :
```
2 CnH(2n+2) + (3n+1) O2 -> 2n CO2 + 2(n+1) H2O
```

Puis on simplifie par le PGCD des 4 coefficients.

**Exemples** :

| Alcane | Avant PGCD | PGCD | Reaction finale |
|--------|-----------|------|-----------------|
| Methane (n=1) | 2, 4, 2, 4 | 2 | CH4 + 2 O2 -> CO2 + 2 H2O |
| Ethane (n=2) | 2, 7, 4, 6 | 1 | 2 C2H6 + 7 O2 -> 4 CO2 + 6 H2O |
| Propane (n=3) | 2, 10, 6, 8 | 2 | C3H8 + 5 O2 -> 3 CO2 + 4 H2O |
| Octane (n=8) | 2, 25, 16, 18 | 1 | 2 C8H18 + 25 O2 -> 16 CO2 + 18 H2O |

**Dans le code** : les coefficients sont calcules dans le constructeur (avant
`object`). La reaction est equilibree des sa creation — `balance` retourne
simplement `self`.

Le constructeur accepte une **liste** d'alcanes : pour plusieurs alcanes, il
calcule les coefficients de chacun et somme les O2, CO2, H2O.

**Fichiers** : `ex04/alkane_combustion.ml`, `ex04/main.ml`, `ex04/Makefile`

---

### ex05 — Incomplete Combustion (combustion incomplete)

**Concept chimique** : Quand il n'y a pas assez d'oxygene, la combustion
ne produit pas que CO2 et H2O. Elle peut aussi produire :
- **CO** (monoxyde de carbone) — combustion partielle
- **C** (suie/carbone pur) — combustion tres incomplete

**Concept OCaml** : Heritage de classe concrete + algorithme recursif de
backtracking.

**L'idee** : Pour chaque quantite d'O2 insuffisante, on enumere toutes les
facons de repartir les carbones entre CO2 (coute 2 O), CO (coute 1 O), et
C (coute 0 O), sachant que l'eau consomme toujours le meme nombre d'oxygene
(determine par le nombre d'hydrogenes).

**Exemple avec l'ethane (C2H6)** :
- Combustion complete : C2H6 + 3.5 O2 -> 2 CO2 + 3 H2O (7 O2 apres x2, PGCD...)
- Avec 3 O2 (6 atomes d'O) : 3 pour H2O, 3 restants pour 2 C
  - 1 CO2 + 1 CO : 2+1 = 3 O -> `C2H6 + 3 O2 -> CO2 + CO + 3 H2O`
  - 0 CO2 + 2 CO : 0+2 = 2 O -> ne marche pas (3 != 2)
- Avec 2 O2 (4 atomes d'O) : 3 pour H2O, 1 restant
  - 0 CO2 + 1 CO + 1 C : 0+1 = 1 O -> `C2H6 + 2 O2 -> CO + C + 3 H2O`

**L'algorithme** :
1. Pour chaque quantite d'O2 de 1 a max_o2 - 1
2. Calculer l'oxygene restant apres formation de l'eau
3. Generer recursivement toutes les combinaisons de CO2/CO/C qui
   utilisent exactement le bon nombre de carbones et d'oxygene
4. Agreger, deduplicquer, filtrer les combustions completes
5. Convertir en molecules avec coefficients

**Type de retour** : `(int * (molecule * int) list) list` — chaque entree
associe une quantite d'O2 a une liste de produits avec coefficients.

**Heritage** : `incomplete_combustion` herite de `alkane_combustion`, donc
elle a aussi `get_start`, `get_result`, `is_balanced` pour la combustion
complete. La methode `get_incomplete_results` est ajoutee en plus.

**Fichiers** : `ex05/incomplete_combustion.ml`, `ex05/main.ml`, `ex05/Makefile`

---

## Progression pedagogique

```
ex00  Classe virtuelle     ->  Definir un contrat, l'implementer dans des sous-classes
ex01  Constructeur + calcul ->  Passer des parametres, calculer des proprietes
ex02  Heritage en chaine    ->  molecule <- alkane <- methane/ethane/...
ex03  Classe abstraite      ->  Methodes virtuelles + methodes concretes partagees
ex04  Calcul dans le        ->  Logique complexe avant object, equilibrage automatique
      constructeur
ex05  Heritage concret +    ->  Etendre une classe existante, backtracking recursif
      backtracking
```

Le fil rouge est **l'heritage progressif** :
- ex00-01 posent les briques de base (atome, molecule)
- ex02 montre comment specialiser une molecule (alcane = molecule parametree)
- ex03 introduit une abstraction pour les reactions chimiques
- ex04 implemente une reaction concrète avec equilibrage automatique
- ex05 etend la combustion pour gerer les cas incomplets

---

## Hierarchie des classes

```
atom (virtual)                          [ex00]
  |-- hydrogen, carbon, oxygen,
      nitrogen, sulfur, chlorine

molecule (virtual, param: atom list)    [ex01]
  |-- water, carbon_dioxide, methane,
      sulfuric_acid, ammonia,
      dioxygen, dihydrogen
  |-- alkane (param: n)                 [ex02]
  |     |-- methane, ethane, propane, butane,
  |         pentane, hexane, heptane, octane,
  |         nonane, decane, undecane, dodecane
  |-- carbon_monoxide                   [ex05]
  |-- carbon (soot)                     [ex05]

reaction (virtual)                      [ex03]
  |-- methane_combustion
  |-- water_synthesis
  |-- alkane_combustion (param: alkane list)     [ex04]
        |-- incomplete_combustion                [ex05]
            (ajoute get_incomplete_results)
```

---

## Structure des fichiers

```
21/
  ex00/  atom.ml                    main.ml   Makefile
  ex01/  molecule.ml                main.ml   Makefile
  ex02/  alkane.ml                  main.ml   Makefile
  ex03/  reaction.ml                main.ml   Makefile
  ex04/  alkane_combustion.ml       main.ml   Makefile
  ex05/  incomplete_combustion.ml   main.ml   Makefile
```

Chaque exercice depend des precedents. Compiler ex05 compile toute la chaine.
`make fclean && make && make test` dans n'importe quel exercice suffit.

---

## Notions de chimie utilisees

### Atomes (ex00)

| Symbole | Nom | Numero atomique |
|---------|-----|-----------------|
| H | Hydrogene | 1 |
| C | Carbone | 6 |
| N | Azote | 7 |
| O | Oxygene | 8 |
| S | Soufre | 16 |
| Cl | Chlore | 17 |

### Loi de Lavoisier (ex03)

> "Rien ne se perd, rien ne se cree, tout se transforme."

Dans une reaction chimique, le nombre d'atomes de chaque element est
identique des deux cotes de la fleche. C'est ce que verifie `is_balanced`.

### Coefficients stoechiometriques (ex04)

Les nombres places devant les molecules pour equilibrer la reaction.
Exemple : dans `CH4 + **2** O2 -> CO2 + **2** H2O`, les coefficients
sont 1, 2, 1, 2.
