# Jour 21 — Programmation Orientée Objet en OCaml (thème: chimie)

Document d'explication pour la défense. Conçu pour un lecteur qui ne connaît **ni OCaml, ni les concepts objets, ni la chimie utilisée**.

---

## 1. Vue d'ensemble

Le but pédagogique du jour 21 est d'appliquer la **programmation orientée objet** (POO) en OCaml sur une chaîne de problèmes de chimie : modéliser des atomes, composer des molécules, spécialiser en alcanes, décrire des réactions, et enfin équilibrer automatiquement une combustion (complète puis incomplète).

Chaque exercice dépend du précédent — on construit une hiérarchie de classes.

```
atom  ←  molecule  ←  alkane
                  ↘
                   reaction  ←  alkane_combustion  ←  incomplete_combustion
```

---

## 2. Notions OCaml employées

OCaml est un langage **fonctionnel typé statiquement**. Pour ce jour on utilise sa partie objet.

### 2.1 Objet et classe
Une **classe** est un plan décrivant des objets. Un **objet** est une instance créée par `new`.
```ocaml
let h = new hydrogen        (* crée un objet de classe hydrogen *)
```

### 2.2 Méthode
Les champs d'un objet s'appellent des **méthodes** (`method`). On les appelle avec `#` :
```ocaml
h#symbol      (* équivalent de h.symbol() en Java/Python *)
```

### 2.3 Classe virtuelle (= abstraite)
`class virtual atom = ...` déclare une classe **qu'on ne peut pas instancier directement**. Elle peut contenir des méthodes `method virtual` (non implémentées). Les sous-classes concrètes doivent les implémenter.

### 2.4 Héritage
```ocaml
class hydrogen = object inherit atom ... end
```
`hydrogen` récupère tout de `atom` et peut compléter/redéfinir.

### 2.5 `val` — champ d'instance immuable
`val atoms = atom_list` stocke une valeur dans chaque objet. **Sans `mutable`, c'est immuable** — on ne peut pas la changer après construction. C'est le style fonctionnel exigé par le sujet : *« Any imperative class in your code means no points »*.

### 2.6 Coercition `:>` (upcast)
`(h :> atom)` convertit un `hydrogen` en `atom` (vue plus générale). Nécessaire pour mettre des objets de types différents dans une même liste :
```ocaml
let atoms : atom list = [ (h :> atom); (c :> atom) ]
```

### 2.7 Module = fichier
En OCaml chaque fichier `foo.ml` devient automatiquement un module `Foo`. Pour utiliser le contenu de `molecule.ml` depuis un autre fichier on écrit `Molecule.water`.

### 2.8 Listes immuables
`[1; 2; 3]` est une liste. Les listes sont **immuables** : toute opération (`List.map`, `List.filter`, `List.fold_left`) renvoie une nouvelle liste.

---

## 3. Notions de chimie

- **Atome** : brique élémentaire (nom, symbole, numéro atomique Z).
- **Molécule** : ensemble d'atomes liés.
- **Notation Hill** : convention d'écriture d'une formule brute — d'abord le carbone (C), puis l'hydrogène (H), puis les autres symboles **par ordre alphabétique**. Exemple : TNT = `C7H5N3O6`.
- **Alcane** : hydrocarbure saturé de formule `CnH(2n+2)` (méthane n=1, éthane n=2, propane n=3, …).
- **Réaction chimique** : transformation *réactifs → produits*. **Loi de Lavoisier** : conservation des atomes — même quantité de chaque élément des deux côtés.
- **Coefficient stœchiométrique** : nombre devant chaque molécule pour équilibrer. Exemple : `CH4 + 2 O2 → CO2 + 2 H2O`.
- **Combustion complète** : alcane + O₂ → CO₂ + H₂O (tout le carbone finit en CO₂).
- **Combustion incomplète** : manque d'O₂ → CO (monoxyde) et/ou C (suie) apparaissent.

---

## 4. Exercices

### Exercice 00 — Atoms

**Demandé.** Une classe virtuelle `atom` avec trois attributs (name, symbol, atomic_number) définis **comme méthodes**, plus `to_string` et `equals`. Trois atomes imposés (H, C, O) et trois au choix.

**Notions ciblées.** Classe virtuelle, héritage, méthodes.

**Réalisé.** `atom.ml` définit `atom` virtuel et 6 sous-classes concrètes : hydrogen, carbon, oxygen, nitrogen, sulfur, chlorine.

**Comment.** Chaque méthode virtuelle est redéfinie en constante dans la sous-classe :
```ocaml
class hydrogen = object
  inherit atom
  method name = "Hydrogen"
  method symbol = "H"
  method atomic_number = 1
end
```
`equals` compare via `atomic_number` (deux atomes avec même Z sont du même élément). `to_string` combine les trois méthodes.

### Exercice 01 — Molecules

**Demandé.** Classe virtuelle `molecule` construite à partir d'un nom et d'une liste d'atomes. Doit produire la **formule en notation Hill**, avec `to_string` et `equals`. Deux molécules imposées (eau, CO₂) + trois au choix.

**Notions ciblées.** Paramètres de constructeur, traitement de liste fonctionnel, tri.

**Réalisé.** `molecule.ml` définit `molecule name atom_list` + water, carbon_dioxide, methane, sulfuric_acid, ammonia, dioxygen, dihydrogen.

**Comment.** Calcul de la formule en 3 étapes purement fonctionnelles :
1. `count_atoms` parcourt la liste récursivement et construit une liste d'associations `(symbole, nombre)`.
2. `hill_sort` extrait C et H, trie le reste par `compare` (ordre alphabétique), recolle.
3. `format_element` écrit `symbol` si count = 1, sinon `symbol ^ string_of_int count`.

`equals` compare les formules.

### Exercice 02 — Alkanes

**Demandé.** Classe `alkane` prenant un entier `n` (1 ≤ n ≤ 12), produisant automatiquement la formule `CnH(2n+2)`. Trois alcanes imposés : méthane, éthane, octane.

**Notions ciblées.** Construction paramétrée, `List.init` (génération de liste), héritage de `molecule`.

**Réalisé.** `alkane.ml` : classe `alkane n` + 12 sous-classes (methane … dodecane).

**Comment.**
1. Validation : `if n < 1 || n > 12 then failwith ...`.
2. Génération de la liste d'atomes : `List.init n (fun _ -> new carbon)` et pareil pour `2n+2` hydrogènes.
3. Le nom est choisi par `match n with ...` puis **passé au constructeur parent** `Molecule.molecule alkane_name atoms_list`.
4. Méthode `carbon_count` expose `n` (utilisée plus tard par la combustion).

### Exercice 03 — Reactions

**Demandé.** Classe virtuelle `reaction` instanciée avec **deux collections de molécules** (début et fin), exposant `get_start`, `get_result`, `balance`, `is_balanced`.

**Notions ciblées.** Structure abstraite, constructeur à deux arguments, algorithme de comptage d'atomes sur une formule.

**Réalisé.** `reaction.ml` : `class virtual reaction start_list result_list` + deux exemples concrets (methane_combustion, water_synthesis) + une exception `UnbalancedReaction`.

**Comment.**
- `is_balanced` appelle `count_atoms` sur `get_start` et `get_result`, puis teste l'égalité après tri alphabétique.
- `count_atoms` parse la formule caractère par caractère : majuscule = début de symbole, minuscules suivantes = reste du symbole, chiffres suivants = quantité (ou 1). Le tout multiplié par le coefficient stœchiométrique et sommé.
- `balance` reste virtuel — chaque sous-classe le spécialise.
- `to_string` produit `"A + 2 B -> C + 2 D"`.

### Exercice 04 — Alkane Combustion

**Demandé.** Classe `alkane_combustion` héritant de `reaction`, prenant une liste d'alcanes. `balance` doit renvoyer une **nouvelle** instance avec les coefficients les **plus petits possibles**, en **supprimant les doublons** éventuels.

**Notions ciblées.** Algorithme d'équilibrage, calcul de PGCD (plus grand commun diviseur), génération d'objet immuable.

**Réalisé.** `alkane_combustion.ml` : fonctions pures `dedup_alkanes`, `gcd`, `list_gcd`, `compute_balanced`, puis la classe qui inherit `Reaction.reaction`.

**Comment.**

1. **Déduplication.** Deux alcanes avec le même `carbon_count` sont le même produit. `dedup_alkanes` garde le premier vu.

2. **Équilibrage.** Pour chaque alcane CₙH(2n+2), on part de la relation :
   ```
   2 CnH(2n+2) + (3n+1) O2 → 2n CO2 + (2n+2) H2O
   ```
   Le facteur 2 évite les fractions : un alcane contient (2n+2) H, donc consomme (n+1) O₂ pour produire l'eau, et nC consomme n O₂ pour produire CO₂ ; soit `(3n+1)/2` O₂ — on multiplie tout par 2.

3. **Sommation globale.** Quand plusieurs alcanes distincts sont présents, on additionne séparément les coefficients O₂, CO₂, H₂O.

4. **Réduction.** On calcule le PGCD de **tous** les coefficients (y compris les `2` des alcanes) avec `list_gcd`, puis on divise tout par ce PGCD — ce qui garantit les plus petits coefficients entiers. Exemple : méthane seul donne `(2, 4, 2, 4)`, PGCD = 2, résultat final `CH4 + 2 O2 → CO2 + 2 H2O`.

5. **Nouvelle instance.** `balance` fait `new alkane_combustion unique_alkanes` pour respecter *« returns a new alkane_combustion »*.

### Exercice 05 — Incomplete Combustion

**Demandé.** Ajouter `get_incomplete_results` qui énumère toutes les façons d'incomplètement brûler les alcanes en jouant sur la quantité d'O₂. Chaque scénario peut contenir CO₂, CO, C (suie) et H₂O. Type de retour : `(int * (molecule * int) list) list`.

**Notions ciblées.** Énumération combinatoire, récursion avec accumulateur, normalisation et déduplication.

**Réalisé.** `incomplete_combustion.ml` — classes `carbon`, `carbon_monoxide`, et classe `incomplete_combustion` héritant d'`alkane_combustion`.

**Comment.**

1. **Budget atomique.** On somme le nombre total de carbones et d'hydrogènes. L'H₂O consomme toujours `total_hydrogens / 2` oxygènes.

2. **Génération.** Pour une quantité donnée d'O₂ (donc `2 × o2` atomes d'O), on calcule l'oxygène **restant après** formation de l'eau. Puis `generate_combos` essaie récursivement, pour chaque atome de C à placer :
   - le mettre en CO₂ (2 O consommés),
   - le mettre en CO (1 O),
   - le laisser en C (0 O).

3. **Agrégation.** `[("CO",1); ("C",1); ("C",1)]` devient `[("CO",1); ("C",2)]`.

4. **Normalisation.** Tri puis `List.sort_uniq` supprime les permutations équivalentes.

5. **Filtre.** Seuls les scénarios contenant `CO` ou `C` sont gardés (sinon c'est une combustion complète, hors sujet).

6. **Assemblage final.** Chaque scénario est converti en `(molecule * int) list`, eau ajoutée à la fin, puis on renvoie les paires `(o2_amount, products)`.

---

## 5. Règles respectées (rappel)

- Aucun `open`, `for`, `while`, `;;`.
- Toutes les classes fonctionnelles (aucun champ `mutable`, aucun `ref`).
- Makefile par exercice, compilation avec `ocamlopt`.
- Notation Hill partout où une formule est produite.
- Alcanes bornés 1 ≤ n ≤ 12.
- Chaque exercice réutilise les précédents (dépendances de module via `-I ../exXX`).
