(*
** Exercice 00: The Set module and the Set.Make functor
** 
** Description : Utilisation du foncteur Set.Make pour créer un module StringSet
** permettant de manipuler des ensembles de chaînes de caractères ordonnées.
** 
** Concepts abordés :
** - Foncteurs OCaml (Set.Make)
** - Signature OrderedType
** - Modules et types abstraits
** - Opérations sur les ensembles (add, iter, fold)
** 
** Objectif : Créer un StringSet qui affiche les éléments dans l'ordre lexicographique
*)

(*
** Module StringOrderedType
** Description : Implémentation du type ordonné requis par Set.Make
** 
** Le foncteur Set.Make attend un module respectant la signature OrderedType :
** - type t : le type des éléments
** - val compare : t -> t -> int : fonction de comparaison
** 
** La fonction compare doit retourner :
** - 0 si les éléments sont égaux
** - valeur négative si le premier < second
** - valeur positive si le premier > second
*)
module StringOrderedType = struct
  type t = string
  let compare = String.compare
end

(*
** Module StringSet
** Description : Ensemble de chaînes de caractères créé via le foncteur Set.Make
** 
** Set.Make prend en paramètre un module respectant OrderedType
** et retourne un module respectant la signature Set.S
** 
** Opérations principales disponibles :
** - empty : ensemble vide
** - add : ajouter un élément
** - iter : itérer sur tous les éléments (dans l'ordre)
** - fold : réduction avec accumulation (dans l'ordre)
** - mem : test d'appartenance
** - remove : suppression d'élément
*)
module StringSet = Set.Make(StringOrderedType)

(*
** Programme principal
** Description : Démonstration des fonctionnalités du StringSet
** 
** Étapes :
** 1. Création d'un ensemble avec List.fold_right et StringSet.add
** 2. Affichage de chaque élément avec StringSet.iter
** 3. Concaténation de tous les éléments avec StringSet.fold
** 
** Note : L'ordre lexicographique garantit : "bar" < "baz" < "foo" < "qux"
*)
let () =
  let set = List.fold_right StringSet.add [ "foo"; "bar"; "baz"; "qux" ] StringSet.empty in
  StringSet.iter print_endline set;
  print_endline (StringSet.fold ( ^ ) set "")
