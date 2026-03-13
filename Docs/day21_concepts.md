# Day 21 - OOP Chemistry : Concepts

## Notions de chimie

### Atome (ex00)
Un **atome** est la plus petite unite d'un element chimique. Il est defini par :
- **Nom** : ex. "Hydrogen", "Carbon", "Oxygen"
- **Symbole** : notation courte (H, C, O, N, S, Cl...)
- **Numero atomique (Z)** : nombre de protons dans le noyau, identifie l'element de maniere unique

### Molecule (ex01)
Une **molecule** est un assemblage d'atomes lies entre eux. Elle est decrite par :
- **Nom** : ex. "Water", "Carbon dioxide"
- **Formule chimique** : liste des symboles atomiques avec leur quantite
- **Notation de Hill** : convention d'ecriture ou C vient en premier, puis H, puis les autres elements par ordre alphabetique (ex. C7H5N3O6 pour le TNT)

### Alcane (ex02)
Un **alcane** est un hydrocarbure (C + H uniquement) de formule **CnH(2n+2)** :
- n=1 : Methane (CH4), n=2 : Ethane (C2H6), ..., n=12 : Dodecane (C12H26)
- Famille de molecules simples, lineaires, saturees

### Reaction chimique (ex03)
Une **reaction** transforme des reactifs en produits, en respectant la **loi de Lavoisier** : le nombre d'atomes de chaque element est conserve entre les deux cotes de la reaction.
- **Coefficients stoechiometriques** : multiplicateurs devant chaque molecule pour equilibrer la reaction
- Ex. CH4 + **2** O2 -> CO2 + **2** H2O (1C, 4H, 4O de chaque cote)

### Combustion d'alcane (ex04)
Reaction specifique : un alcane + du dioxygene produit du dioxyde de carbone et de l'eau.

**Equation non equilibree :**
```
CnH(2n+2) + O2 -> CO2 + H2O
```

**Objectif :** trouver les coefficients (a, b, c, d) tels que :
```
a CnH(2n+2) + b O2 -> c CO2 + d H2O
```
avec le meme nombre de chaque atome des deux cotes.

#### Demonstration de l'equilibrage pas a pas

On pose a = 1 (un seul alcane) et on equilibre atome par atome :

1. **Carbone** : n carbones a gauche -> il faut n CO2 a droite -> **c = n**
2. **Hydrogene** : (2n+2) hydrogenes a gauche -> il faut (2n+2)/2 = (n+1) H2O -> **d = n+1**
3. **Oxygene** : a droite on a 2c + d = 2n + (n+1) = 3n+1 atomes d'O. Chaque O2 apporte 2 atomes -> **b = (3n+1)/2**

On obtient :
```
CnH(2n+2) + (3n+1)/2 O2 -> n CO2 + (n+1) H2O
```

**Probleme** : (3n+1)/2 n'est pas toujours entier (ex. n=2 donne 7/2 = 3.5).

#### Elimination de la fraction

On multiplie **tous** les coefficients par 2 :
```
2 CnH(2n+2) + (3n+1) O2 -> 2n CO2 + 2(n+1) H2O
```

Maintenant tous les coefficients sont entiers. Mais ils ne sont pas forcement les plus petits possibles.

#### Simplification par le PGCD

On calcule le PGCD des 4 coefficients (2, 3n+1, 2n, 2n+2) et on divise chacun par ce PGCD.

| n | Avant PGCD | PGCD | Apres PGCD | Reaction finale |
|---|-----------|------|-----------|-----------------|
| 1 (methane) | 2, 4, 2, 4 | 2 | **1, 2, 1, 2** | CH4 + 2 O2 -> CO2 + 2 H2O |
| 2 (ethane) | 2, 7, 4, 6 | 1 | **2, 7, 4, 6** | 2 C2H6 + 7 O2 -> 4 CO2 + 6 H2O |
| 3 (propane) | 2, 10, 6, 8 | 2 | **1, 5, 3, 4** | C3H8 + 5 O2 -> 3 CO2 + 4 H2O |
| 8 (octane) | 2, 25, 16, 18 | 1 | **2, 25, 16, 18** | 2 C8H18 + 25 O2 -> 16 CO2 + 18 H2O |

> Quand n est impair, le PGCD vaut 2 et on retrouve des coefficients simples.
> Quand n est pair, (3n+1) est impair donc le PGCD vaut 1 et on garde les coefficients x2.

#### Dans le code

```ocaml
let compute_one_alkane alk =
  let n = alk#carbon_count in
  (* Coefficients x2 pour eviter les fractions *)
  let coeff_alk = 2 in              (* a = 2           *)
  let coeff_o2  = 3 * n + 1 in     (* b = 3n+1        *)
  let coeff_co2 = 2 * n in         (* c = 2n          *)
  let coeff_h2o = 2 * (n + 1) in   (* d = 2(n+1)      *)

  (* Simplification par le PGCD *)
  let rec gcd a b = if b = 0 then a else gcd b (a mod b) in
  let g = gcd (gcd (gcd coeff_alk coeff_o2) coeff_co2) coeff_h2o in
  (coeff_alk / g, coeff_o2 / g, coeff_co2 / g, coeff_h2o / g)
```

Ensuite, pour construire la reaction complete :
- **Reactifs** : chaque alcane avec son coefficient + la somme de tous les coefficients O2
- **Produits** : la somme de tous les CO2 + la somme de tous les H2O
- La reaction est **deja equilibree par construction**, donc `balance` retourne `self` et `is_balanced` (herite de `reaction`) confirme la conservation des atomes

### Combustion incomplete (ex05)
Quand il n'y a **pas assez d'O2**, la combustion produit aussi du **CO** (monoxyde de carbone) et du **C** (suie/carbone pur) en plus du CO2 et H2O.
- On enumere toutes les combinaisons possibles de CO2, CO et C pour chaque quantite d'O2 insuffisante
- Les doublons dans les resultats sont attendus (chaque atome de carbone est traite individuellement)

---

## Notions OCaml OOP

### Classe virtuelle (`class virtual`)
Une classe qui ne peut pas etre instanciee directement. Elle definit un "contrat" que les sous-classes doivent respecter.

```ocaml
(* ex00/atom.ml - Classe virtuelle avec methodes virtuelles *)
class virtual atom =
object (self)
  method virtual name : string          (* pas d'implementation *)
  method virtual symbol : string
  method virtual atomic_number : int

  method to_string : string =           (* implementation concrete *)
    self#name ^ ": [" ^ self#symbol ^ "]"
end
```
> `self` permet d'appeler les methodes de l'objet courant (comme `this` en Java/C++).

### Heritage (`inherit`)
Une classe concrete herite d'une classe virtuelle et implemente ses methodes virtuelles.

```ocaml
(* ex00/atom.ml - Classe concrete heritant de atom *)
class hydrogen =
object
  inherit atom
  method name = "Hydrogen"
  method symbol = "H"
  method atomic_number = 1
end
```

### Constructeur avec parametres
Une classe peut accepter des arguments a la construction. Le code avant `object` s'execute a l'instanciation.

```ocaml
(* ex01/molecule.ml - Constructeur acceptant une liste d'atomes *)
class virtual molecule (atom_list : Atom.atom list) =
  (* code execute a la construction *)
object (self)
  val atoms = atom_list     (* stockage interne *)
  method virtual name : string
  method formula : string = (* calcule a partir de atoms *)
    ...
end
```

### Validation dans le constructeur
On peut executer du code de validation avant `object`, et lever une exception si les arguments sont invalides.

```ocaml
(* ex02/alkane.ml - Validation de n dans [1, 12] *)
class alkane (n : int) =
  let () =
    if n < 1 || n > 12 then
      failwith "Alkane: n must be between 1 and 12"
  in
  let atoms_list = ... in   (* construction de la liste d'atomes *)
object (self)
  inherit Molecule.molecule atoms_list as super
  ...
end
```
> `as super` permet d'acceder aux methodes de la classe parente si besoin.

### Heritage en chaine et classes "raccourcis"
Des classes concretes heritent d'une sous-classe avec un parametre fixe.

```ocaml
(* ex02/alkane.ml - methane = alkane avec n=1 *)
class methane = object inherit alkane 1 end
class ethane  = object inherit alkane 2 end
class octane  = object inherit alkane 8 end
```

### Coercion de type (`:>`)
OCaml n'a pas de sous-typage implicite. Pour utiliser un objet d'une sous-classe la ou le type parent est attendu, on utilise l'operateur `:>`.

```ocaml
(* ex02/main.ml - Coercion alkane -> molecule *)
let molecules : Molecule.molecule list = [
  (propane :> Molecule.molecule);
  (butane  :> Molecule.molecule);
]
```

### Classe virtuelle avec methodes concretes partagees
`reaction` est virtuelle mais implemente `is_balanced`, `to_string` et `count_atoms` que toutes les reactions heritent.

```ocaml
(* ex03/reaction.ml *)
class virtual reaction =
object (self)
  method virtual get_start  : (Molecule.molecule * int) list
  method virtual get_result : (Molecule.molecule * int) list
  method virtual balance    : reaction

  method is_balanced : bool = ...   (* utilise get_start/get_result *)
  method to_string : string = ...   (* formate la reaction *)
end
```
> Les methodes concretes appellent les methodes virtuelles via `self#` : le comportement depend de l'implementation dans la sous-classe (polymorphisme).

### Heritage multi-niveaux avec calculs dans le constructeur
`alkane_combustion` herite de `reaction` et calcule les coefficients stoechiometriques avant `object`.

```ocaml
(* ex04/alkane_combustion.ml *)
class alkane_combustion (alkanes : Alkane.alkane list) =
  let coefficients = compute_coefficients alkanes in
  let start_list = build_start_list alkanes coefficients in
  let result_list = build_result_list alkanes coefficients in
object (self)
  inherit Reaction.reaction
  val start = start_list
  val result = result_list
  method get_start = start
  method get_result = result
  method balance : Reaction.reaction = (self :> Reaction.reaction)
end
```

### Heritage de classe concrete + extension
`incomplete_combustion` herite de `alkane_combustion` (classe concrete) et ajoute une nouvelle methode.

```ocaml
(* ex05/incomplete_combustion.ml *)
class incomplete_combustion (alkanes : Alkane.alkane list) =
  ...
object (self)
  inherit Alkane_combustion.alkane_combustion alkanes  (* herite tout *)
  method get_incomplete_results = ...                  (* nouvelle methode *)
end
```

---

## Resume de la hierarchie

```
atom (virtual)
  |-- hydrogen, carbon, oxygen, nitrogen, sulfur, chlorine

molecule (virtual, param: atom list)
  |-- water, carbon_dioxide, dioxygen, dihydrogen, ...
  |-- alkane (param: n) -> molecule avec CnH(2n+2) atomes
        |-- methane, ethane, ..., dodecane

reaction (virtual)
  |-- methane_combustion, water_synthesis
  |-- alkane_combustion (param: alkane list)
        |-- incomplete_combustion (ajoute get_incomplete_results)
```

---

## Elements et molecules utilises dans les exercices

### Atomes (ex00)

| Symbole | Nom (EN) | Nom (FR) | Numero atomique (Z) |
|---------|----------|----------|---------------------|
| H | Hydrogen | Hydrogene | 1 |
| C | Carbon | Carbone | 6 |
| N | Nitrogen | Azote | 7 |
| O | Oxygen | Oxygene | 8 |
| S | Sulfur | Soufre | 16 |
| Cl | Chlorine | Chlore | 17 |

### Molecules (ex01)

| Formule | Nom (EN) | Nom (FR) |
|---------|----------|----------|
| H2 | Dihydrogen | Dihydrogene |
| O2 | Dioxygen | Dioxygene |
| H2O | Water | Eau |
| CO2 | Carbon Dioxide | Dioxyde de carbone |
| CH4 | Methane | Methane |
| NH3 | Ammonia | Ammoniac |
| H2SO4 | Sulfuric Acid | Acide sulfurique |

### Alcanes (ex02) - CnH(2n+2)

| Formule | Nom (EN) | Nom (FR) | n |
|---------|----------|----------|---|
| CH4 | Methane | Methane | 1 |
| C2H6 | Ethane | Ethane | 2 |
| C3H8 | Propane | Propane | 3 |
| C4H10 | Butane | Butane | 4 |
| C5H12 | Pentane | Pentane | 5 |
| C6H14 | Hexane | Hexane | 6 |
| C7H16 | Heptane | Heptane | 7 |
| C8H18 | Octane | Octane | 8 |
| C9H20 | Nonane | Nonane | 9 |
| C10H22 | Decane | Decane | 10 |
| C11H24 | Undecane | Undecane | 11 |
| C12H26 | Dodecane | Dodecane | 12 |

### Molecules additionnelles (ex04-ex05)

| Formule | Nom (EN) | Nom (FR) | Contexte |
|---------|----------|----------|----------|
| O2 | Dioxygen | Dioxygene | Reactif de combustion (ex04) |
| CO2 | Carbon Dioxide | Dioxyde de carbone | Produit de combustion complete (ex04) |
| H2O | Water | Eau | Produit de combustion complete (ex04) |
| CO | Carbon Monoxide | Monoxyde de carbone | Produit de combustion incomplete (ex05) |
| C | Carbon (Soot) | Carbone (Suie) | Produit de combustion incomplete (ex05) |
