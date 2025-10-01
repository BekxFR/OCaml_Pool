(* ========================================================================== *)
(*                    EXPLICATION DE FT_REF - REPRODUCTION DE REF            *)
(* ========================================================================== *)

(*
   COMMENT REPRODUIRE REF SANS UTILISER REF ?
   
   La clé est de comprendre que ref n'est pas un type primitif en OCaml,
   mais plutôt un type défini avec des records mutables.
*)

(* ========================================================================== *)
(* 1. COMPRÉHENSION DU TYPE REF STANDARD *)
(* ========================================================================== *)

(*
   En OCaml, le type ref est défini comme :
   
   type 'a ref = { mutable contents : 'a }
   
   Et les opérateurs sont :
   - ref x        ≡ { contents = x }
   - !r           ≡ r.contents  
   - r := v       ≡ r.contents <- v
   
   DONC ref n'est qu'un SUCRE SYNTAXIQUE pour un record mutable !
*)

(* ========================================================================== *)
(* 2. NOTRE IMPLÉMENTATION FT_REF *)
(* ========================================================================== *)

(*
   type 'a ft_ref = { mutable contents : 'a }
   
   Cette définition est IDENTIQUE au type ref standard.
   La seule différence est le nom du type.
   
   CHAMP MUTABLE :
   - mutable : permet de modifier le champ après création
   - contents : le nom du champ qui stocke la valeur
   - 'a : type générique (polymorphe)
*)

(*
   FONCTIONS IMPLÉMENTÉES :
   
   1. return : 'a -> 'a ft_ref
      Équivalent de 'ref' standard
      Crée un nouveau record avec la valeur
   
   2. get : 'a ft_ref -> 'a  
      Équivalent de '!' standard
      Accède au champ contents
   
   3. set : 'a ft_ref -> 'a -> unit
      Équivalent de ':=' standard  
      Modifie le champ contents
   
   4. bind : 'a ft_ref -> ('a -> 'b ft_ref) -> 'b ft_ref
      Fonction monadique (plus avancée)
      Applique une transformation sur la valeur
*)

(* ========================================================================== *)
(* 3. ÉQUIVALENCES AVEC REF STANDARD *)
(* ========================================================================== *)

(*
   REF STANDARD          →    NOTRE FT_REF
   
   ref 42                →    return 42
   !r                    →    get r  
   r := 100              →    set r 100
   
   EXEMPLE DE CONVERSION :
   
   Standard :
   let x = ref 42 in
   !x + 10;;
   x := 100;;
   
   Notre version :
   let x = return 42 in
   get x + 10;;
   set x 100;;
*)

(* ========================================================================== *)
(* 4. LA FONCTION BIND - INTRODUCTION AUX MONADES *)
(* ========================================================================== *)

(*
   BIND : 'a ft_ref -> ('a -> 'b ft_ref) -> 'b ft_ref
   
   Cette fonction permet de "chaîner" des opérations sur des références.
   
   FONCTIONNEMENT :
   1. Prend une référence 'a ft_ref
   2. Prend une fonction 'a -> 'b ft_ref  
   3. Applique la fonction à la valeur déréférencée
   4. Retourne le résultat (une nouvelle référence)
   
   IMPLÉMENTATION :
   let bind ft_ref f = f (get ft_ref)
   
   C'est simple : on déréférence et on applique la fonction !
*)

(*
   EXEMPLES D'UTILISATION DE BIND :
   
   let double_ref x = return (x * 2) in
   let y = return 5 in
   let y_doubled = bind y double_ref in
   (* y_doubled contient 10 *)
   
   BIND EN CHAÎNE (composition) :
   bind (return 3) (fun x -> 
     bind (return (x * 2)) (fun y ->
       return (y + 1)))
   
   Cela calcule : (3 * 2) + 1 = 7
*)

(* ========================================================================== *)
(* 5. POURQUOI BIND EST UTILE ? *)
(* ========================================================================== *)

(*
   BIND permet de composer des fonctions qui travaillent avec des références
   sans avoir à déréférencer manuellement à chaque étape.
   
   SANS BIND (verbose) :
   let x = return 5 in
   let temp1 = get x in
   let temp2 = temp1 * 2 in
   let y = return temp2 in
   let temp3 = get y in
   let temp4 = temp3 + 1 in
   let result = return temp4 in
   
   AVEC BIND (élégant) :
   bind (return 5) (fun x ->
   bind (return (x * 2)) (fun y ->
   return (y + 1)))
   
   BIND cache la gestion des références et permet un code plus lisible.
*)

(* ========================================================================== *)
(* 6. RECORDS MUTABLES - CONCEPTS CLÉS *)
(* ========================================================================== *)

(*
   CHAMPS MUTABLES :
   
   type point = { mutable x : int; mutable y : int }
   
   let p = { x = 0; y = 0 } in
   p.x <- 10;  (* Modification du champ x *)
   p.y <- 20;  (* Modification du champ y *)
   
   AVANTAGES :
   - Modification en place (efficace)
   - Partage de références possible
   
   INCONVÉNIENTS :
   - Effets de bord
   - Plus difficile à raisonner
*)

(*
   PARTAGE DE RÉFÉRENCES :
   
   let r1 = return 42 in
   let r2 = r1 in      (* r2 pointe vers la même référence *)
   set r1 100;;
   get r2;;            (* Retourne 100 ! *)
   
   C'est le même comportement qu'avec ref standard.
*)

(* ========================================================================== *)
(* 7. INTRODUCTION AUX MONADES *)
(* ========================================================================== *)

(*
   Une MONADE est un pattern de design fonctionnel avec :
   
   1. Un type M<T> (ici ft_ref)
   2. Une fonction return : T -> M<T>  
   3. Une fonction bind : M<T> -> (T -> M<U>) -> M<U>
   
   LOIS DES MONADES :
   
   1. Identité gauche :
      bind (return a) f  ≡  f a
   
   2. Identité droite :
      bind m return  ≡  m
   
   3. Associativité :
      bind (bind m f) g  ≡  bind m (fun x -> bind (f x) g)
   
   Notre ft_ref respecte ces lois !
*)

(*
   AUTRES MONADES COURANTES :
   
   - Option : Some/None pour gérer l'absence de valeur
   - List : pour le non-déterminisme  
   - IO : pour les entrées/sorties
   - State : pour l'état mutable
   - Reader : pour l'environnement partagé
   
   Les monades permettent de composer des computations
   avec des "effets" (nullabilité, multiples valeurs, état, etc.)
*)

(* ========================================================================== *)
(* 8. COMPARAISON DES PERFORMANCES *)
(* ========================================================================== *)

(*
   NOTRE FT_REF vs REF STANDARD :
   
   Performance : IDENTIQUE
   - Même représentation mémoire
   - Même coût d'accès
   - Même coût de modification
   
   Lisibilité :
   - ref : Plus concis (sucre syntaxique)
   - ft_ref : Plus explicite (fonctions nommées)
   
   Extensibilité :
   - ft_ref : Peut être étendu avec d'autres fonctions
   - ref : Limité aux opérateurs prédéfinis
*)

(* ========================================================================== *)
(* CONCLUSION *)
(* ========================================================================== *)

(*
   Reproduire ref sans utiliser ref nous apprend :
   
   1. ref n'est qu'un record mutable
   2. Les références sont un concept simple
   3. On peut créer nos propres abstractions
   4. Introduction aux monades
   5. Importance des types mutables en programmation impérative
   
   Cette compréhension nous prépare pour :
   - Jour 09 (monades avancées)
   - Structures de données mutables
   - Patterns fonctionnels avec effets
   - Design d'APIs élégantes
*)
