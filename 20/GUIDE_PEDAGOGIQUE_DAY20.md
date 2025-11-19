# Guide Pédagogique - Day 20 : Programmation Orientée Objet en OCaml

## 📋 Table des matières

1. [But du Day 20](#but-du-day-20)
2. [Concepts fondamentaux](#concepts-fondamentaux)
3. [Progression pédagogique des exercices](#progression-pédagogique)
4. [Exercice 00 : Classe simple](#exercice-00)
5. [Exercice 01 : Composition d'objets](#exercice-01)
6. [Exercice 02 : Interactions entre objets](#exercice-02)
7. [Exercice 03 : Classes paramétrées](#exercice-03)
8. [Exercice 04 : Système complexe](#exercice-04)
9. [Points importants et bonnes pratiques](#points-importants)
10. [Synthèse comparative](#synthèse-comparative)

---

## 🎯 But du Day 20

### Objectif principal

Maîtriser la **Programmation Orientée Objet (POO)** en OCaml, un paradigme différent du style fonctionnel pur vu précédemment. OCaml est un langage **multi-paradigmes** qui permet de combiner programmation fonctionnelle et orientée objet.

### Compétences développées

1. **Définition de classes** avec attributs et méthodes
2. **Encapsulation** des données et du comportement
3. **Composition d'objets** (objets contenant d'autres objets)
4. **Polymorphisme paramétrique** avec classes génériques
5. **Architecture logicielle** pour systèmes complexes
6. **Gestion d'état mutable** dans un contexte objet

### Contexte thématique : Doctor Who

Tous les exercices utilisent l'univers de Doctor Who pour rendre l'apprentissage plus engageant :

- **People** : humains/compagnons
- **Doctor** : Time Lords avec capacités spéciales
- **Dalek** : ennemis avec technologie avancée
- **Army/Galifrey** : structures organisationnelles

---

## 🧠 Concepts fondamentaux

### Syntaxe de base en OCaml

```ocaml
(* Classe simple *)
class nom_classe (parametre : type) =
object (self)
  (* Attributs *)
  val attribut : type = valeur
  val mutable attribut_mutable : type = valeur

  (* Initializer - exécuté à la création *)
  initializer
    (* code d'initialisation *)

  (* Méthodes publiques *)
  method nom_methode : type_retour =
    (* implémentation *)

  (* Méthodes privées *)
  method private nom_prive : type_retour =
    (* implémentation *)
end
```

### Différences avec la programmation fonctionnelle

| Aspect            | Fonctionnel                  | Orienté Objet                     |
| ----------------- | ---------------------------- | --------------------------------- |
| **Organisation**  | Fonctions + données séparées | Données + comportements regroupés |
| **État**          | Immutable par défaut         | Peut être mutable (val mutable)   |
| **Réutilisation** | Composition de fonctions     | Héritage et composition d'objets  |
| **Polymorphisme** | Types paramétrés             | Classes paramétrées + héritage    |

### Utilisation des objets

```ocaml
(* Création *)
let mon_objet = new MaClasse "param" in

(* Appel de méthode *)
mon_objet#ma_methode;

(* Accès à l'attribut via getter *)
mon_objet#get_attribut
```

---

## 📚 Progression pédagogique

Les exercices suivent une progression logique :

```
Ex00: Classe simple
  ↓
Ex01: Composition d'objets (Doctor contient People)
  ↓
Ex02: Interactions (Dalek interagit avec People)
  ↓
Ex03: Généricité (Army<'a> contient n'importe quel type)
  ↓
Ex04: Système complet (Galifrey orchestre tout)
```

---

## 📝 Exercice 00 : Classe simple

### Objectif

Créer une première classe OCaml avec les concepts de base.

### Ce qui est enseigné

- Définition d'une classe avec constructeur
- Attributs immutables (`val`)
- Méthodes publiques
- Initializer
- Convention de nommage des modules

### Implémentation : `class people`

```ocaml
class people (initial_name : string) =
object (self)
  val name : string = initial_name
  val hp : int = 100

  initializer
    print_endline ("New person created: " ^ name)

  method to_string : string =
    "Name: " ^ name ^ ", HP: " ^ string_of_int hp

  method talk : unit =
    print_endline ("I'm " ^ name ^ "!")

  method die : unit =
    print_endline "Aaaarghh!"
end
```

### Points clés

1. **Constructeur** : `(initial_name : string)` - paramètre obligatoire
2. **Attributs immutables** : `val name` ne peut pas changer après création
3. **Initializer** : Code exécuté automatiquement à `new people`
4. **Typage des méthodes** : `method talk : unit` (retourne rien)
5. **Convention module** : Fichier `people.ml` → module `People` (majuscule)

### Utilisation dans main.ml

```ocaml
(* Important : notation Module.classe *)
let rose = new People.people "Rose Tyler" in
rose#talk;
rose#die
```

**⚠️ Erreur courante** : Écrire `new people` au lieu de `new People.people` provoque "Unbound class people".

### Fichiers produits

- `people.ml` : Définition de la classe
- `main.ml` : Tests de toutes les méthodes
- `Makefile` : Compilation avec `ocamlopt`

---

## 📝 Exercice 01 : Composition d'objets

### Objectif

Comprendre qu'un objet peut **contenir** d'autres objets comme attributs.

### Ce qui est enseigné

- Composition d'objets (relation "has-a")
- Attributs mutables (`val mutable`)
- Méthodes privées
- Manipulation du temps (travel_in_time)

### Implémentation : `class doctor`

```ocaml
class doctor (initial_name : string)
             (initial_age : int)
             (initial_sidekick : People.people) =
object (self)
  val name : string = initial_name
  val mutable age : int = initial_age
  val sidekick : People.people = initial_sidekick  (* COMPOSITION *)
  val mutable hp : int = 100

  method travel_in_time (start : int) (arrival : int) : unit =
    let time_diff = arrival - start in
    age <- age + time_diff  (* Modification d'attribut mutable *)

  method private regenerate : unit =
    hp <- 100  (* Méthode privée, non accessible de l'extérieur *)
end
```

### Modifications par rapport à l'Ex00

| Aspect               | Ex00 (people)  | Ex01 (doctor)               | Justification         |
| -------------------- | -------------- | --------------------------- | --------------------- |
| **Attributs**        | 2 (name, hp)   | 4 (name, age, sidekick, hp) | Plus complexe         |
| **Composition**      | Aucune         | Contient un `People.people` | Relation "has-a"      |
| **Mutabilité**       | Tout immutable | `age` et `hp` mutables      | Changement d'état     |
| **Méthodes privées** | Non            | Oui (`regenerate`)          | Encapsulation         |
| **Constructeur**     | 1 paramètre    | 3 paramètres                | Plus de configuration |

### Points clés

1. **Composition** : `sidekick : People.people` - le Doctor "a un" compagnon
2. **Attributs mutables** : `val mutable age` peut changer via `age <- nouvelle_valeur`
3. **Méthode privée** : `method private regenerate` - inaccessible depuis `main.ml`
4. **Modification d'état** : `travel_in_time` modifie l'âge (paradigme objet, pas fonctionnel pur)

### Utilisation

```ocaml
(* D'abord créer un sidekick *)
let rose = new People.people "Rose Tyler" in

(* Puis créer le Doctor avec ce sidekick *)
let tenth = new Doctor.doctor "The Tenth Doctor" 903 rose in

(* Le Doctor peut voyager dans le temps *)
tenth#travel_in_time 2005 2010;  (* age passe de 903 à 908 *)

(* On ne peut PAS appeler regenerate car elle est privée *)
(* tenth#regenerate;  ← ERREUR DE COMPILATION *)
```

### Concept important : Composition vs Héritage

- **Composition** (utilisée ici) : "Doctor HAS-A sidekick"
- **Héritage** (non utilisé) : "Doctor IS-A Time Lord"

OCaml privilégie la composition pour plus de flexibilité.

---

## 📝 Exercice 02 : Interactions entre objets

### Objectif

Faire **interagir** les objets entre eux, pas juste les créer et les afficher.

### Ce qui est enseigné

- Méthodes qui prennent d'autres objets en paramètres
- Module `Random` pour comportements aléatoires
- État mutable qui change selon les actions
- Génération procédurale (noms aléatoires)

### Implémentation : `class dalek`

```ocaml
let generate_dalek_name () : string =
  let suffixes = [|"Sec"; "Caan"; "Jast"; "Thay"|] in
  let random_suffix = suffixes.(Random.int (Array.length suffixes)) in
  "Dalek" ^ random_suffix

class dalek =
object (self)
  val name : string = generate_dalek_name ()  (* Génération aléatoire *)
  val mutable hp : int = 100
  val mutable shield : bool = true

  method talk : unit =
    let phrases = [|"Explain!"; "Exterminate!"; "I obey!"|] in
    let random_phrase = phrases.(Random.int (Array.length phrases)) in
    print_endline random_phrase

  (* INTERACTION : prend un objet People en paramètre *)
  method exterminate (victim : People.people) : unit =
    print_endline "EXTERMINATE!";
    victim#die;  (* Appelle une méthode sur l'objet passé *)
    shield <- not shield  (* Change l'état du Dalek *)
end
```

### Modifications par rapport aux Ex00-01

| Aspect             | Ex00-01          | Ex02                           | Justification                  |
| ------------------ | ---------------- | ------------------------------ | ------------------------------ |
| **Génération**     | Noms fixés       | Noms aléatoires                | Variété                        |
| **Module Random**  | Non utilisé      | Utilisé (noms, phrases)        | Comportement dynamique         |
| **Interaction**    | Méthodes isolées | `exterminate(People)`          | Communication inter-objets     |
| **État changeant** | État stable      | Shield change à chaque action  | Simulation réaliste            |
| **People.ml**      | Tout immutable   | `hp` devient mutable + setters | Permettre modification externe |

### Modifications nécessaires dans `people.ml`

```ocaml
class people (initial_name : string) =
object (self)
  val name : string = initial_name
  val mutable hp : int = 100  (* CHANGEMENT : mutable *)

  (* AJOUT : setters pour interaction *)
  method get_hp : int = hp
  method set_hp (new_hp : int) : unit =
    hp <- new_hp
end
```

**Pourquoi ces changements ?**
Pour qu'un Dalek puisse "tuer" un humain, il faut pouvoir modifier son HP de l'extérieur.

### Points clés

1. **Interaction** : `exterminate` prend un `People.people` et le modifie
2. **État dynamique** : `shield` change à chaque utilisation d'`exterminate`
3. **Génération aléatoire** : Chaque Dalek a un nom unique
4. **Module Random** : `Random.int`, `Random.self_init ()`
5. **Effet de bord** : Les méthodes modifient l'état (pas fonctionnel pur)

### Simulation de bataille

```ocaml
let () = Random.self_init ();  (* Initialiser le générateur *)

let dalek = new Dalek.dalek in  (* Nom aléatoire généré *)
let human = new People.people "Victim" in

dalek#talk;  (* Phrase aléatoire *)
dalek#exterminate human;  (* Tue l'humain, change le shield *)
print_endline (dalek#to_string);  (* Shield a changé *)
```

---

## 📝 Exercice 03 : Classes paramétrées (Généricité)

### Objectif

Créer des classes **génériques** qui fonctionnent avec n'importe quel type.

### Ce qui est enseigné

- Polymorphisme paramétrique (`class ['a]`)
- Collections typées (`'a list`)
- Pattern matching sur les listes
- Récursion pour parcourir les structures

### Implémentation : `class ['a] army`

```ocaml
class ['a] army =
object (self)
  val mutable members : 'a list = []

  method add (member : 'a) : unit =
    members <- member :: members  (* Ajout en tête - O(1) *)

  method add_back (member : 'a) : unit =
    members <- List.append members [member]  (* Ajout en queue - O(n) *)

  method delete : unit =
    match members with
    | [] -> print_endline "Army is empty"
    | _ :: rest -> members <- rest  (* Supprime la tête *)

  method size : int =
    List.length members
end
```

### Concept de généricité

```ocaml
(* Une SEULE classe peut contenir n'importe quel type *)
let human_army = new Army.army in
human_army#add (new People.people "Rose");
(* Type inféré : Army.army<People.people> *)

let doctor_army = new Army.army in
doctor_army#add (new Doctor.doctor "Tenth" 903 rose);
(* Type inféré : Army.army<Doctor.doctor> *)

let dalek_army = new Army.army in
dalek_army#add (new Dalek.dalek);
(* Type inféré : Army.army<Dalek.dalek> *)
```

### Modifications par rapport aux Ex00-02

| Aspect                   | Ex00-02           | Ex03                                       | Justification          |
| ------------------------ | ----------------- | ------------------------------------------ | ---------------------- |
| **Type paramétré**       | Classes concrètes | `class ['a]`                               | Réutilisabilité        |
| **Structure de données** | Objets isolés     | Collections (`'a list`)                    | Organisation           |
| **Module List**          | Peu utilisé       | Essentiel (`List.length`, `append`, `rev`) | Manipulation de listes |
| **Pattern matching**     | Basique           | Intensif (sur listes)                      | Traitement récursif    |
| **Polymorphisme**        | Non               | Oui (même classe, types différents)        | Code générique         |

### Points clés

1. **Syntaxe générique** : `class ['a] army` - `'a` est un **type paramètre**
2. **Inférence de type** : OCaml déduit automatiquement le type lors du premier `add`
3. **Opérations sur listes** :
   - `::` : ajout en tête (O(1))
   - `List.append` : concaténation (O(n))
   - `List.rev` : inversion (O(n))
4. **Pattern matching** : Déconstruction élégante des listes

### Exemple de parcours récursif

```ocaml
(* Dans main.ml *)
let rec make_people_talk people_list =
  match people_list with
  | [] -> ()  (* Cas de base : liste vide *)
  | person :: rest ->  (* Déconstruction *)
      person#talk;
      make_people_talk rest  (* Récursion sur le reste *)

let human_army = new Army.army in
(* ... ajout de plusieurs people ... *)
make_people_talk human_army#get_members
```

### Avantages de la généricité

**Sans généricité** (mauvais) :

```ocaml
class people_army = (* ... *)
class doctor_army = (* ... *)
class dalek_army = (* ... *)
(* Code dupliqué ! *)
```

**Avec généricité** (bon) :

```ocaml
class ['a] army = (* ... *)
(* Une seule classe pour tous les types ! *)
```

---

## 📝 Exercice 04 : Système complexe

### Objectif

Intégrer tous les concepts précédents dans un **système complet et fonctionnel**.

### Ce qui est enseigné

- Architecture de systèmes complexes
- Gestion de multiples listes hétérogènes
- Logique de jeu/simulation
- Récursion pour boucles de jeu
- Algorithmes de sélection et de ciblage

### Implémentation : `class galifrey`

```ocaml
class galifrey =
object (self)
  (* 3 listes SÉPARÉES pour 3 types différents *)
  val mutable dalek_members : Dalek.dalek list = []
  val mutable doctor_members : Doctor.doctor list = []
  val mutable people_members : People.people list = []

  (* Méthode principale : orchestration de la bataille *)
  method do_time_war : unit =
    let rec battle_round round_number =
      (* 1. Vérifier conditions d'arrêt *)
      let good_alive = self#any_alive_doctors || self#any_alive_people in
      let evil_alive = self#any_alive_daleks in

      if good_alive && evil_alive then begin
        (* 2. Phase Daleks *)
        self#daleks_attack dalek_members;

        (* 3. Phase Doctors *)
        self#doctors_attack doctor_members;

        (* 4. Phase Humans *)
        self#people_attack people_members;

        (* 5. Récursion pour round suivant *)
        battle_round (round_number + 1)
      end else
        (* Fin de partie : afficher vainqueur *)
        self#show_winner
    in
    battle_round 1

  (* Méthodes auxiliaires privées *)
  method private any_alive_daleks : bool =
    self#any_alive_in_dalek_list dalek_members

  method private daleks_attack (daleks : Dalek.dalek list) : unit =
    match daleks with
    | [] -> ()
    | dalek :: rest ->
        if dalek#is_alive then begin
          let target = self#get_random_alive_doctor in
          match target with
          | Some doctor -> doctor#take_damage (dalek#attack)
          | None -> ()
        end;
        self#daleks_attack rest  (* Récursion *)
end
```

### Architecture globale

```
main.ml
   ↓ crée
Galifrey
   ↓ contient
┌─────────┬──────────┬───────────┐
│ Daleks  │ Doctors  │  Humans   │
│  list   │   list   │   list    │
└─────────┴──────────┴───────────┘
   ↓          ↓           ↓
do_time_war orchestre tout
   ↓
Rounds de combat récursifs
   ↓
Daleks attaquent → Doctors ripostent → Humans aident
   ↓
Vérification survivants
   ↓
Récursion ou Fin
```

### Modifications par rapport aux Ex00-03

| Aspect                | Ex03            | Ex04                        | Justification    |
| --------------------- | --------------- | --------------------------- | ---------------- |
| **Nombre de listes**  | 1 générique     | 3 spécifiques               | Types différents |
| **Logique métier**    | Simple CRUD     | Simulation complète         | Système réel     |
| **Récursion**         | Parcours simple | Boucle de jeu récursive     | Game loop        |
| **Algorithmes**       | Basiques        | Ciblage, filtrage, comptage | IA basique       |
| **Classes modifiées** | Aucune          | Toutes (ajout combat)       | Interopérabilité |

### Modifications dans toutes les classes

**people.ml - Ajout système de combat** :

```ocaml
class people (initial_name : string) =
object (self)
  val mutable hp : int = 100

  (* NOUVELLES MÉTHODES *)
  method is_alive : bool = hp > 0

  method take_damage (damage : int) : unit =
    hp <- max 0 (hp - damage);
    if hp = 0 then self#die

  method attack : int =
    10 + Random.int 11  (* 10-20 damage *)
end
```

**doctor.ml - Doctor renforcé** :

```ocaml
class doctor (* ... *) =
object (self)
  val mutable hp : int = 150  (* Plus résistant *)

  method attack : int =
    25 + Random.int 16  (* 25-40 damage *)

  method private regenerate : unit =
    if hp < 50 && Random.int 100 < 30 then
      hp <- 150  (* Régénération automatique *)
end
```

**dalek.ml - Dalek avec shield** :

```ocaml
class dalek =
object (self)
  val mutable hp : int = 120
  val mutable shield : bool = true

  method take_damage (damage : int) : unit =
    let actual_damage = if shield then damage / 2 else damage in
    hp <- hp - actual_damage;
    shield <- not shield  (* Change après chaque attaque *)

  method attack : int =
    30 + Random.int 21  (* 30-50 damage - très puissant *)
end
```

### Points clés

1. **Listes hétérogènes** : 3 listes de types différents (pas de généricité ici)
2. **Récursion terminale** : `battle_round` s'appelle elle-même
3. **Algorithme de ciblage** :
   ```ocaml
   (* Daleks ciblent Doctors en priorité, sinon Humans *)
   match target_doctor, target_people with
   | Some doctor, _ -> (* attaque le doctor *)
   | None, Some person -> (* attaque l'humain *)
   | None, None -> (* aucune cible *)
   ```
4. **Filtrage fonctionnel** :
   ```ocaml
   method private filter_alive_daleks (daleks : Dalek.dalek list) =
     match daleks with
     | [] -> []
     | dalek :: rest ->
         if dalek#is_alive
         then dalek :: (self#filter_alive_daleks rest)
         else self#filter_alive_daleks rest
   ```
5. **Type Option** : `Some value | None` pour gérer l'absence de cible

### Exemple de simulation

```ocaml
let galifrey = new Galifrey.galifrey in

(* Recruter les forces *)
let rose = new People.people "Rose" in
let tenth = new Doctor.doctor "Tenth" 903 rose in
let dalek = new Dalek.dalek in

galifrey#add_doctor tenth;
galifrey#add_people rose;
galifrey#add_dalek dalek;

(* Lancer la guerre ! *)
galifrey#do_time_war;
(* Affiche tous les rounds jusqu'à victoire/défaite *)
```

---

## ⭐ Points importants et bonnes pratiques

### 1. Règles strictes OCaml Piscine

**Interdictions** :

- ❌ `open` : Pas d'ouverture de modules
- ❌ `for` / `while` : Pas de boucles impératives
- ❌ `Array` (sauf exceptions) : Préférer les listes

**Style imposé** :

- ✅ Tout fonctionnel (récursion au lieu de boucles)
- ✅ Pattern matching intensif
- ✅ Typage explicite des méthodes

### 2. Convention de nommage

```ocaml
(* Fichier : people.ml *)
class people = (* ... *)

(* Utilisation : Module.classe *)
let x = new People.people "name"
(*          ^majuscule     ^minuscule *)
```

**Règle** : Le nom du module est le nom du fichier avec majuscule.

### 3. Compilation OCaml

```bash
# Compilation séparée
ocamlopt -c people.ml      # → people.cmi, people.cmx
ocamlopt -c doctor.ml      # → doctor.cmi, doctor.cmx
ocamlopt -c main.ml        # → main.cmi, main.cmx

# Linkage
ocamlopt -o programme people.cmx doctor.cmx main.cmx

# Ou tout en une fois
ocamlopt -o programme people.ml doctor.ml main.ml
```

**Ordre important** : Les dépendances doivent être compilées avant.

### 4. Immutabilité vs Mutabilité

| Cas d'usage    | Choix         | Exemple                   |
| -------------- | ------------- | ------------------------- |
| Identité fixe  | `val`         | `val name : string`       |
| État changeant | `val mutable` | `val mutable hp : int`    |
| Configuration  | `val`         | `val max_health : int`    |
| Compteur       | `val mutable` | `val mutable score : int` |

**Principe** : Immutable par défaut, mutable uniquement si nécessaire.

### 5. Méthodes privées

```ocaml
method private regenerate : unit =
  hp <- 100

(* Accessible dans la classe *)
method public_method : unit =
  self#regenerate  (* OK *)

(* Inaccessible depuis l'extérieur *)
let doc = new Doctor.doctor (* ... *) in
doc#regenerate  (* ERREUR DE COMPILATION *)
```

**Usage** : Encapsuler la logique interne.

### 6. Pattern matching sur les listes

```ocaml
(* Déconstruction *)
match liste with
| [] -> (* liste vide *)
| [x] -> (* un seul élément *)
| [x; y] -> (* exactement deux éléments *)
| x :: rest -> (* au moins un élément *)
| _ -> (* tout autre cas *)
```

### 7. Récursion terminale

**Non-terminale** (mauvais pour grandes listes) :

```ocaml
let rec length lst =
  match lst with
  | [] -> 0
  | _ :: rest -> 1 + length rest  (* Accumulation après récursion *)
```

**Terminale** (bon) :

```ocaml
let length lst =
  let rec aux acc lst =
    match lst with
    | [] -> acc
    | _ :: rest -> aux (acc + 1) rest  (* Récursion en dernière position *)
  in
  aux 0 lst
```

### 8. Type Option pour valeurs absentes

```ocaml
type 'a option = None | Some of 'a

method get_random_alive : People.people option =
  let alive = self#filter_alive people_members in
  match alive with
  | [] -> None  (* Aucun survivant *)
  | _ -> Some (List.nth alive (Random.int (List.length alive)))

(* Utilisation *)
match self#get_random_alive with
| Some person -> person#take_damage 10
| None -> print_endline "No target available"
```

---

## 📊 Synthèse comparative

### Tableau récapitulatif des exercices

| Critère         | Ex00       | Ex01               | Ex02                      | Ex03             | Ex04                |
| --------------- | ---------- | ------------------ | ------------------------- | ---------------- | ------------------- |
| **Classes**     | 1 (people) | 2 (people, doctor) | 3 (people, doctor, dalek) | 4 (+army)        | 5 (+galifrey)       |
| **Composition** | Non        | Oui (sidekick)     | Oui                       | Oui              | Oui (3 listes)      |
| **Interaction** | Non        | Non                | Oui (exterminate)         | Oui (indirect)   | Oui (combat)        |
| **Généricité**  | Non        | Non                | Non                       | **Oui** (`['a]`) | Non (spécifique)    |
| **Mutabilité**  | Minimal    | Moyenne (age, hp)  | Forte (shield, hp)        | Forte (liste)    | Très forte          |
| **Random**      | Non        | Non                | **Oui** (noms, phrases)   | Non              | Oui (combat)        |
| **Récursion**   | Non        | Non                | Non                       | Oui (parcours)   | **Oui** (game loop) |
| **Complexité**  | ⭐         | ⭐⭐               | ⭐⭐⭐                    | ⭐⭐⭐⭐         | ⭐⭐⭐⭐⭐          |

### Progression des concepts

```
Ex00: Bases POO
  │
  ├─ Classes, méthodes, attributs
  └─ Initializer
     │
Ex01: Composition
  │
  ├─ Objets dans objets
  ├─ Attributs mutables
  └─ Méthodes privées
     │
Ex02: Interaction
  │
  ├─ Méthodes avec objets en paramètres
  ├─ Module Random
  └─ État dynamique
     │
Ex03: Généricité
  │
  ├─ Polymorphisme paramétrique
  ├─ Module List
  └─ Pattern matching avancé
     │
Ex04: Système complet
  │
  ├─ Architecture multi-classes
  ├─ Algorithmes (ciblage, filtrage)
  ├─ Récursion game loop
  └─ Intégration totale
```

### Fichiers cumulatifs

| Exercice | Fichiers requis                                                         | Nouveaux fichiers |
| -------- | ----------------------------------------------------------------------- | ----------------- |
| Ex00     | people.ml, main.ml, Makefile                                            | Tous              |
| Ex01     | people.ml, doctor.ml, main.ml, Makefile                                 | doctor.ml         |
| Ex02     | people.ml, doctor.ml, dalek.ml, main.ml, Makefile                       | dalek.ml          |
| Ex03     | people.ml, doctor.ml, dalek.ml, army.ml, main.ml, Makefile              | army.ml           |
| Ex04     | people.ml, doctor.ml, dalek.ml, army.ml, galifrey.ml, main.ml, Makefile | galifrey.ml       |

---

## 🎓 Conclusion

### Ce que vous avez appris

1. **POO en OCaml** : Syntaxe, classes, objets, méthodes
2. **Composition** : Construire des objets complexes
3. **Interaction** : Faire communiquer les objets
4. **Généricité** : Code réutilisable avec types paramétrés
5. **Architecture** : Concevoir des systèmes complets

### Différence avec POO classique (Java, C++)

| Aspect         | Java/C++        | OCaml                           |
| -------------- | --------------- | ------------------------------- |
| **Héritage**   | Central         | Marginal (composition préférée) |
| **Interfaces** | Explicites      | Implicites (structural typing)  |
| **Mutabilité** | Par défaut      | Opt-in (val mutable)            |
| **Style**      | Impératif-objet | Fonctionnel-objet               |

### Quand utiliser POO vs Fonctionnel en OCaml ?

**POO** (ce Day) :

- ✅ État mutable nécessaire
- ✅ Modélisation d'entités du monde réel
- ✅ Systèmes avec interactions complexes
- ✅ Encapsulation importante

**Fonctionnel pur** (Days précédents) :

- ✅ Transformations de données
- ✅ Calculs mathématiques
- ✅ Immutabilité essentielle
- ✅ Composition de fonctions

**Hybride** (meilleure approche) :

- ✅ OCaml permet de combiner les deux !
- ✅ Fonctionnel pour la logique
- ✅ Objet pour l'architecture

---

## 📚 Ressources complémentaires

### Documentation officielle

- [OCaml Manual - Objects](https://ocaml.org/manual/objectexamples.html)
- [Real World OCaml - Objects](https://dev.realworldocaml.org/objects.html)

### Concepts avancés (hors scope Day 20)

- Héritage et polymorphisme
- Classes virtuelles et abstraites
- Covariance/Contravariance
- Modules vs Classes

### Pour aller plus loin

- Day 14-15 : Applications pratiques
- Projets personnels combinant fonctionnel et objet
- Étude de codebases OCaml réelles (compilateur OCaml lui-même !)

---

**Auteur** : Guide pédagogique Day 20 - OCaml Piscine  
**Date** : Novembre 2025  
**Thème** : Doctor Who Universe  
**Paradigme** : Programmation Orientée Objet en OCaml
