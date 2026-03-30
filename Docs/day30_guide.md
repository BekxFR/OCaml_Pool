# Module 30 — Monoides et Monades : Guide pour debutants

Ce guide explique pas a pas les concepts du module 30 de la piscine OCaml.
Aucune connaissance prealable en algebre abstraite n'est requise.

---

## Qu'est-ce qu'un monoide ?

Un monoide est une idee tres simple qu'on utilise tous les jours sans le savoir.
Il faut trois ingredients :

1. **Un ensemble de valeurs** — les "choses" qu'on manipule
2. **Une operation** qui combine deux valeurs en une seule
3. **Un element neutre** — une valeur speciale qui, combinee avec n'importe quelle autre, ne change rien

### Exemple du quotidien

L'addition sur les entiers est un monoide :
- Ensemble : les nombres entiers
- Operation : l'addition (`+`)
- Element neutre : `0` (car `x + 0 = x` pour tout `x`)

La concatenation de texte aussi :
- Ensemble : les chaines de caracteres
- Operation : la concatenation (`^`)
- Element neutre : `""` (la chaine vide, car `"hello" ^ "" = "hello"`)

### Pourquoi c'est utile ?

Des qu'on identifie un monoide, on sait automatiquement qu'on peut :
- Combiner autant d'elements qu'on veut, dans n'importe quel ordre de regroupement
- Partir de l'element neutre et accumuler des resultats
- Ecrire du code generique qui marche pour n'importe quel monoide

---

## Qu'est-ce qu'une monade ?

Une monade est un "conteneur intelligent" pour des valeurs. Elle fournit :

1. **`return`** — met une valeur dans le conteneur
2. **`bind`** — applique une fonction a la valeur contenue, en respectant les regles du conteneur

### Analogie

Imaginons une boite qui peut contenir un gateau :
- **`return gateau`** : on met le gateau dans la boite
- **`bind boite decoupe`** : on ouvre la boite, on decoupe le gateau, on remet le resultat dans une nouvelle boite. Si la boite etait vide ou cassee, on ne fait rien.

Chaque type de "boite" a ses propres regles :
- **Try** : la boite peut etre `Success` (tout va bien) ou `Failure` (une erreur est survenue). Si c'est un `Failure`, on ne touche plus a rien — l'erreur se propage.
- **Set** : la boite contient un ensemble de valeurs sans doublons. Quand on applique une fonction, on l'applique a chaque element.

---

## Exercice par exercice

---

### ex00 — Watchtower (le monoide horloge)

**Concept** : Une horloge a 12 heures est un monoide.

**L'idee** : Sur une horloge, les heures vont de 1 a 12. Il n'y a pas de "0 heure".
Quand on additionne des heures, on "boucle" : 10 + 5 = 3 (car 15 sur une horloge de 12, c'est 3).

**Les trois ingredients du monoide** :
- Ensemble : les heures {1, 2, ..., 12}
- Operation : l'addition modulaire
- Element neutre : `12` (car `h + 12 = h` sur une horloge — ajouter 12h ne change rien)

**Ce que le code fait** :

```
Watchtower.zero        = 12
Watchtower.add 10 5    = 3     (10h + 5h = 15h = 3h sur l'horloge)
Watchtower.add 12 12   = 12    (element neutre + element neutre)
Watchtower.sub 5 8     = 9     (5h - 8h = -3h = 9h en reculant)
```

**Difficulte technique** : Le `mod` d'OCaml peut retourner des valeurs negatives
(ex: `(-3) mod 12 = -3`). L'implementation ajoute `+12+12` avant le modulo pour
garantir un resultat positif.

**Fichiers** : `ex00/watchtower.ml` (module), `ex00/main.ml` (tests)

---

### ex01 — App (le monoide projet)

**Concept** : La gestion de projets peut aussi etre modelisee comme un monoide.

**L'idee** : Un projet est un triplet `(nom, statut, note)`. On peut combiner deux
projets en un seul : les noms sont concatenes, les notes sont moyennees, et le statut
depend de la moyenne (>= 80 = "succeed", sinon "failed").

**Les trois ingredients du monoide** :
- Ensemble : les projets `(string, string, int)`
- Operation : `combine` (concatene, moyenne, evalue)
- Element neutre : `("", "", 0)` — le projet vide

**Ce que le code fait** :

```
App.zero                                    = ("", "", 0)
App.combine ("A", _, 91) ("B", _, 68)       = ("AB", "failed", 79)
App.fail ("Projet", _, 90)                  = ("Projet", "failed", 0)
App.success ("Projet", _, 30)               = ("Projet", "succeed", 80)
```

**Point notable** : `fail` et `success` ne sont pas des operations du monoide
a proprement parler — ce sont des operations utilitaires qui transforment un projet.

**Fichiers** : `ex01/app.ml` (module), `ex01/main.ml` (tests)

---

### ex02 — Calc (le foncteur arithmetique)

**Concept** : Un foncteur permet d'ecrire du code generique qui marche pour
n'importe quel type numerique.

**L'idee en 3 etapes** :

**Etape 1 — Definir un contrat (module type MONOID)** :
Tout type numerique doit fournir : un type `element`, deux zeros (`zero1` pour
l'addition, `zero2` pour la multiplication), et les 4 operations de base.

**Etape 2 — Implementer le contrat pour int et float** :
```
INT  : element = int,   zero1 = 0,   zero2 = 1,   add = (+),  mul = (*)...
FLOAT: element = float, zero1 = 0.0, zero2 = 1.0, add = (+.), mul = (*.)...
```

**Etape 3 — Ecrire un foncteur Calc** :
Le foncteur prend un module MONOID en parametre et fournit des fonctions avancees
(`power`, `fact`) qui marchent automatiquement pour int ET float :

```
Calc_int.power 3 3    = 27       (int)
Calc_float.power 3.0 3 = 27.0   (float)
Calc_int.fact 5       = 120      (int)
Calc_float.fact 5.0   = 120.0   (float)
```

**Pourquoi deux zeros ?** `zero1 = 0` est le neutre de l'addition (x + 0 = x).
`zero2 = 1` est le neutre de la multiplication (x * 1 = x). `power` et `fact`
utilisent `zero2` comme cas de base car ils enchainent des multiplications.

**Fichiers** : `ex02/monoid.ml` (modules + foncteur), `ex02/main.ml` (tests)

---

### ex03 — Try (la monade d'exceptions)

**Concept** : Au lieu de laisser les exceptions exploser le programme, on les
capture dans un conteneur `Success`/`Failure` et on chaine les operations
en toute securite.

**L'idee** : En programmation classique, une exception interrompt tout :

```
let x = 100 / 0          (* BOOM — Division_by_zero, le programme s'arrete *)
let y = x + 1             (* jamais execute *)
```

Avec la monade Try, l'erreur est capturee et propagee proprement :

```
let x = Try_monad.return 0                                      (* Success 0 *)
let y = Try_monad.bind x (fun v -> Try_monad.return (100 / v))  (* Failure Division_by_zero *)
let z = Try_monad.bind y (fun v -> Try_monad.return (v + 1))    (* Failure Division_by_zero — propage *)
```

**Les 5 fonctions** :

| Fonction | Role | Quand elle agit |
|----------|------|-----------------|
| `return x` | Emballe `x` dans `Success x` | Toujours |
| `bind m f` | Applique `f` a la valeur dans `m`, capture les exceptions | Seulement si `m` est `Success` |
| `recover m f` | Applique `f` a l'exception dans `m` pour tenter une recuperation | Seulement si `m` est `Failure` |
| `filter m p` | Convertit en `Failure` si le predicat `p` n'est pas satisfait | Seulement si `m` est `Success` |
| `flatten m` | Deplie un `Try` imbrique (`Success (Success v)` -> `Success v`) | Toujours |

**Exemple concret — calculatrice securisee** :

```
safe_divide 100 4                          (* Success 25 *)
|> bind safe_sqrt                          (* Success 5  *)
|> bind (fun x -> return (x * 2))         (* Success 10 *)

safe_divide 100 0                          (* Failure Division_by_zero *)
|> bind safe_sqrt                          (* Failure Division_by_zero — propage *)
|> recover (fun _ -> return 0)             (* Success 0  — recuperation *)
```

**Fichiers** : `ex03/try_monad.ml` (module), `ex03/main.ml` (tests)

---

### ex04 — Set (la monade ensemble)

**Concept** : Un ensemble (collection sans doublons) est aussi une monade.

**L'idee** : Un ensemble garantit l'unicite de ses elements. Quand on applique
une fonction a un ensemble, on l'applique a chaque element et on fusionne les
resultats en eliminant les doublons.

**Implementation** : En interne, l'ensemble est simplement une liste OCaml (`'a list`)
avec une fonction `remove_duplicates` qui garantit l'unicite.

**Les fonctions monadiques** :

```
Set_monad.return 42                         = [42]           (singleton)
Set_monad.bind [1; 2] (fun x -> [x; x*10]) = [1; 10; 2; 20] (applique + fusionne)
Set_monad.bind [1; 2] (fun x -> [x; x])    = [1; 2]         (doublons supprimes)
```

**Les operations ensemblistes** :

| Fonction | Role | Exemple |
|----------|------|---------|
| `union a b` | Elements dans `a` OU `b` | `union [1;2;3] [3;4;5]` = `[1;2;3;4;5]` |
| `inter a b` | Elements dans `a` ET `b` | `inter [1;2;3] [3;4;5]` = `[3]` |
| `diff a b` | Elements dans `a` mais PAS dans `b` | `diff [1;2;3] [3;4;5]` = `[1;2]` |
| `filter s p` | Elements satisfaisant le predicat | `filter [1;2;3;4] pair` = `[2;4]` |
| `foreach s f` | Execute `f` sur chaque element | (effet de bord, I/O) |
| `for_all s p` | Tous satisfont `p` ? | `for_all [2;4;6] pair` = `true` |
| `exists s p` | Au moins un satisfait `p` ? | `exists [1;2;3] pair` = `true` |

**Lois monadiques verifiees** :
- Identite gauche : `bind (return a) f = f a`
- Identite droite : `bind m return = m`

**Fichiers** : `ex04/set_monad.ml` (module), `ex04/main.ml` (tests)

---

## Progression pedagogique du module

```
ex00  Monoide simple        ->  Un type, un zero, une operation
ex01  Monoide sur un tuple  ->  Meme structure, donnees plus complexes
ex02  Foncteur              ->  Generaliser le monoide avec un foncteur
ex03  Monade Try            ->  Conteneur pour gerer les erreurs fonctionnellement
ex04  Monade Set            ->  Conteneur pour gerer les collections sans doublons
```

Le fil rouge est la **montee en abstraction** :
- Les exercices 00-01 montrent qu'un meme patron (neutre + operation) s'applique a des domaines differents.
- L'exercice 02 formalise ce patron dans un foncteur pour ecrire du code generique.
- Les exercices 03-04 introduisent les monades : un niveau d'abstraction superieur ou le conteneur lui-meme encapsule une logique (gestion d'erreurs, deduplication).

---

## Structure des fichiers

```
30/
  ex00/  watchtower.ml   main.ml   Makefile
  ex01/  app.ml          main.ml   Makefile
  ex02/  monoid.ml       main.ml   Makefile
  ex03/  try_monad.ml    main.ml   Makefile
  ex04/  set_monad.ml    main.ml   Makefile
```

Chaque exercice se compile avec `make` et se teste avec `make test`.
