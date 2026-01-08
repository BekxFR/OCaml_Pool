(* ============================================================================ *)
(*                          EXERCICE 03 - MONADE TRY                          *)
(* ============================================================================ *)
(*
   Objectif : Implémenter une monade Try pour gérer les exceptions de manière
              fonctionnelle et élégante.
   
   Une instance de Try peut être :
   • Success of 'a  - Opération réussie avec une valeur
   • Failure of exn - Opération échouée avec une exception
   
   Cette monade remplace le style impératif try/catch par un style fonctionnel
   composable avec bind, recover, filter, etc.
*)

(* ============================================================================ *)
(*                             EXCEPTION CUSTOM                                *)
(* ============================================================================ *)

(* Exception personnalisée pour la fonction filter.
   Levée quand un prédicat n'est pas satisfait. *)
exception Filter_failed of string

(* ============================================================================ *)
(*                             MODULE TRY                                      *)
(* ============================================================================ *)

module Try = struct
  
  (* ========================================================================== *)
  (*                              TYPE DEFINITION                               *)
  (* ========================================================================== *)
  
  (* Type paramétrique 'a t représentant un calcul qui peut réussir ou échouer.
     
     'a est le type de la valeur en cas de succès.
     exn est le type des exceptions (type built-in OCaml).
     
     Exemples :
     - Success 42         : int t
     - Failure Not_found  : 'a t (polymorphe car pas de valeur)
  *)
  type 'a t = 
    | Success of 'a    (* Succès : contient une valeur de type 'a *)
    | Failure of exn   (* Échec : contient une exception *)

  (* ========================================================================== *)
  (*                           FONCTIONS MONADIQUES                             *)
  (* ========================================================================== *)
  
  (* -------------------------------------------------------------------------- *)
  (* return: 'a -> 'a t                                                         *)
  (* -------------------------------------------------------------------------- *)
  (* Crée un Success contenant la valeur donnée.
     
     C'est l'opération "unit" ou "pure" de la monade.
     Elle "injecte" une valeur dans le contexte monadique.
     
     Exemple :
       return 42  →  Success 42
  *)
  let return x = Success x

  (* -------------------------------------------------------------------------- *)
  (* bind: 'a t -> ('a -> 'b t) -> 'b t                                        *)
  (* -------------------------------------------------------------------------- *)
  (* Applique une fonction à la valeur contenue dans le monade.
     
     Comportements :
     1. Si le monade est Success : applique f à la valeur
     2. Si le monade est Failure : propage l'erreur sans appeler f
     3. Si f lève une exception : la capture et retourne Failure
     
     C'est l'opération fondamentale qui permet de CHAÎNER des opérations
     qui peuvent échouer, tout en gérant automatiquement la propagation d'erreurs.
     
     Exemples :
       bind (Success 10) (fun x -> Success (x * 2))  →  Success 20
       bind (Failure e) f                             →  Failure e
       bind (Success 0) (fun x -> Success (10/x))     →  Failure Division_by_zero
     
     Point crucial : Le try/with capture les exceptions levées par f.
     Sans cela, une exception ferait planter le programme au lieu d'être gérée.
  *)
  let bind m f =
    match m with
    | Success v -> 
        (try f v              (* Tente d'appliquer f à la valeur *)
         with e -> Failure e) (* Capture toute exception levée par f *)
    | Failure e -> Failure e  (* Propage l'erreur existante *)

  (* -------------------------------------------------------------------------- *)
  (* recover: 'a t -> (exn -> 'a t) -> 'a t                                    *)
  (* -------------------------------------------------------------------------- *)
  (* Permet de récupérer après une erreur en appliquant une fonction de recovery.
     
     Comportements :
     1. Si le monade est Success : ne fait rien, retourne Success inchangé
     2. Si le monade est Failure : applique f à l'exception
     
     C'est l'équivalent fonctionnel du bloc "catch" en programmation impérative.
     Permet de gérer différentes erreurs différemment.
     
     Exemples :
       recover (Success 42) handler        →  Success 42
       recover (Failure e) (fun _ -> Success 0)  →  Success 0
       recover (Failure e) (fun e -> Failure (Other_error e))  →  Failure ...
     
     Use case : Valeurs par défaut, logging d'erreurs, transformation d'exceptions
  *)
  let recover m f =
    match m with
    | Success v -> Success v  (* Pas d'erreur, rien à récupérer *)
    | Failure e -> f e        (* Erreur : applique la fonction de recovery *)

  (* -------------------------------------------------------------------------- *)
  (* filter: 'a t -> ('a -> bool) -> 'a t                                      *)
  (* -------------------------------------------------------------------------- *)
  (* Convertit un Success en Failure si la valeur ne satisfait pas le prédicat.
     
     Comportements :
     1. Success avec prédicat vrai : reste Success
     2. Success avec prédicat faux : devient Failure (Filter_failed)
     3. Failure : reste Failure (pas d'effet)
     
     Permet d'ajouter des contraintes de validation sur les valeurs.
     
     Exemples :
       filter (Success 42) (fun x -> x > 0)   →  Success 42
       filter (Success -5) (fun x -> x > 0)   →  Failure (Filter_failed ...)
       filter (Failure e) predicate           →  Failure e
     
     Use case : Validation de données, contraintes métier
  *)
  let filter m predicate =
    match m with
    | Success v -> 
        if predicate v 
        then Success v  (* Prédicat satisfait : garde la valeur *)
        else Failure (Filter_failed "Predicate not satisfied")  (* Échec *)
    | Failure e -> Failure e  (* Propage l'erreur existante *)

  (* -------------------------------------------------------------------------- *)
  (* flatten: 'a t t -> 'a t                                                   *)
  (* -------------------------------------------------------------------------- *)
  (* Aplatit un Try imbriqué en un Try simple.
     
     Cas importants :
     1. Success (Success v) → Success v   (double succès → succès simple)
     2. Success (Failure e) → Failure e   (succès d'un échec → échec!)
     3. Failure e           → Failure e   (échec → échec)
     
     Le cas 2 est CRUCIAL : un Success contenant un Failure est traité comme
     un Failure. C'est une règle explicite de l'énoncé.
     
     Exemples :
       flatten (Success (Success 42))        →  Success 42
       flatten (Success (Failure Not_found)) →  Failure Not_found
       flatten (Failure Division_by_zero)    →  Failure Division_by_zero
     
     Use case : Simplifier les résultats de bind qui retournent des Try imbriqués
  *)
  let flatten m =
    match m with
    | Success (Success v) -> Success v  (* Aplatit le double succès *)
    | Success (Failure e) -> Failure e  (* Success of Failure = Failure *)
    | Failure e -> Failure e            (* Échec reste échec *)
end

(* ============================================================================ *)
(*                          NOTES SUPPLÉMENTAIRES                              *)
(* ============================================================================ *)

(*
   LOIS DES MONADES (que Try respecte) :
   
   1. Identité gauche :
      bind (return x) f  =  f x
      
   2. Identité droite :
      bind m return  =  m
      
   3. Associativité :
      bind (bind m f) g  =  bind m (fun x -> bind (f x) g)
   
   
   PATTERN D'UTILISATION TYPIQUE :
   
   let safe_operation x =
     safe_divide x 2
     |> (fun m -> bind m safe_sqrt)
     |> (fun m -> bind m validate)
     |> (fun m -> recover m (fun _ -> return default_value))
   
   
   COMPARAISON AVEC D'AUTRES APPROCHES :
   
   Style impératif (try/catch) :
     try
       let x = risky1() in
       let y = risky2(x) in
       process(y)
     with
       | Exn1 -> handle1()
       | Exn2 -> handle2()
   
   Style Try monad :
     catch risky1
     >>= catch risky2
     >>= catch process
     |> recover (function
         | Exn1 -> handle1()
         | Exn2 -> handle2()
         | e -> raise e)
   
   
   AVANTAGES DE LA MONADE TRY :
   
   ✓ Composition fonctionnelle élégante
   ✓ Gestion d'erreurs explicite et visible
   ✓ Pas d'exceptions "surprises" non gérées
   ✓ Testabilité excellente (Success/Failure sont des valeurs)
   ✓ Chaînage d'opérations risquées facilité
   ✓ Sûreté des types garantie par le compilateur
*)
