(*
** Exercice 01: The Hashtbl module and the Hashtbl.Make functor
** 
** Description : Utilisation du foncteur Hashtbl.Make pour créer un module StringHashtbl
** permettant de manipuler des tables de hachage avec des clés string.
** 
** Concepts abordés :
** - Foncteurs OCaml (Hashtbl.Make)
** - Signature HashedType
** - Fonctions de hachage (djb2)
** - Tables de hachage et collisions
** 
** Contraintes :
** - Modules autorisés : Hashtbl, String.length, String.get
** - Fonction de hachage "vraie" et connue requise
** - Ordre de sortie non déterministe (dépend du hachage)
*)

(*
** Module StringHashedType
** Description : Implémentation du type haché requis par Hashtbl.Make
** 
** Le foncteur Hashtbl.Make attend un module respectant la signature HashedType :
** - type t : le type des clés
** - val equal : t -> t -> bool : fonction d'égalité
** - val hash : t -> int : fonction de hachage
** 
** Fonction de hachage choisie : djb2 (Daniel J. Bernstein)
** Algorithme reconnu et efficace pour les chaînes de caractères
** 
** djb2 : hash = hash * 33 + char_value
** - Initialisé à 5381
** - Multiplie par 33 (décalage + addition optimisé)
** - Ajoute la valeur ASCII du caractère
*)
module StringHashedType = struct
  type t = string
  
  (* Fonction d'égalité standard pour les strings *)
  let equal s1 s2 = (s1 = s2)
  
  (*
  ** Fonction de hachage djb2
  ** Implémentation avec String.get et String.length uniquement
  ** 
  ** Algorithme djb2 :
  ** hash(i) = hash(i-1) * 33 + str[i]
  ** avec hash(0) = 5381
  ** 
  ** Optimisation : 33 = 32 + 1 = (x << 5) + x
  *)
  let hash str =
    let len = String.length str in
    let rec hash_aux acc i =
      if i >= len then acc
      else
        let char_code = Char.code (String.get str i) in
        let new_acc = ((acc lsl 5) + acc) + char_code in
        hash_aux new_acc (i + 1)
    in
    hash_aux 5381 0
end

(*
** Module StringHashtbl
** Description : Table de hachage pour chaînes de caractères créée via Hashtbl.Make
** 
** Hashtbl.Make prend en paramètre un module respectant HashedType
** et retourne un module respectant la signature Hashtbl.S
** 
** Opérations principales disponibles :
** - create : créer une table de taille donnée
** - add : ajouter une association clé-valeur
** - find : rechercher une valeur par clé
** - iter : itérer sur toutes les associations
** - remove : supprimer une association
*)
module StringHashtbl = Hashtbl.Make(StringHashedType)

(*
** Programme principal
** Description : Démonstration des fonctionnalités du StringHashtbl
** 
** Étapes :
** 1. Création d'une table de hachage de taille 5
** 2. Création des paires (string, length)
** 3. Ajout de toutes les paires dans la table
** 4. Affichage de toutes les associations
** 
** Note : L'ordre d'affichage dépend de la fonction de hachage djb2
*)
let () =
  let ht = StringHashtbl.create 5 in
  let values = [ "Hello"; "world"; "42"; "Ocaml"; "H" ] in
  let pairs = List.map (fun s -> (s, String.length s)) values in
  List.iter (fun (k,v) -> StringHashtbl.add ht k v) pairs;
  StringHashtbl.iter (fun k v -> Printf.printf "k = \"%s\", v = %d\n" k v) ht
