(*
** Exercice 04: Evalexpr is so easy it hurts
** 
** Description : Implémentation d'un évaluateur d'expressions fonctoriel
** capable de générer des évaluateurs selon un module arithmétique donné.
** 
** Concepts abordés :
** - Functors OCaml avec contraintes de partage complexes
** - Signatures abstraites et concrètes (VAL, EVALEXPR, MAKEEVALEXPR)
** - Substitution destructive (:= au lieu de =)
** - Types abstraits vs types concrets dans les signatures
** - Évaluation d'expressions avec pattern matching
** 
** Contraintes :
** - Modules autorisés : Stdlib uniquement
** - 6-7 contraintes de partage requises pour compilation
** - Substitution destructive dans les signatures finales
** - Output exact requis : 42, 42.420000, "very very long"
*)

(*
** Signature VAL
** Description : Interface pour modules arithmétiques
** 
** Définit les opérations de base requises :
** - type t : type des valeurs
** - add : addition/opération binaire dominante
** - mul : multiplication/opération binaire alternative
*)
module type VAL =
sig
  type t
  val add : t -> t -> t
  val mul : t -> t -> t
end

(*
** Signature EVALEXPR - Version finale
** Description : Interface exposant les constructeurs d'expressions
** 
** SOLUTION : Exposer explicitement le type expr avec ses constructeurs
** dans la signature pour permettre la construction d'expressions
*)
module type EVALEXPR =
sig
  type t
  type expr = 
    | Value of t
    | Add of expr * expr
    | Mul of expr * expr
  val eval : expr -> t
end

(*
** Signature MAKEEVALEXPR corrigée
** Description : Signature du functor avec contrainte de partage
** 
** CONTRAINTE CRUCIALE : 
** Le functor doit garantir que le type t du résultat est identique au type t du paramètre
** Ceci est la 7ème contrainte mentionnée dans l'énoncé
*)
module type MAKEEVALEXPR = 
  functor (V : VAL) -> EVALEXPR with type t = V.t

(*
** Functor MakeEvalExpr
** Description : Générateur d'évaluateurs d'expressions
** 
** Implémentation :
** 1. Prend un module V respectant VAL
** 2. Définit le type t = V.t (partage de type)
** 3. Définit le type expr avec constructeurs Value, Add, Mul
** 4. Implémente eval avec pattern matching récursif
** 
** Algorithme d'évaluation :
** - Value v -> v (cas de base)
** - Add (e1, e2) -> V.add (eval e1) (eval e2) (récursion + addition)
** - Mul (e1, e2) -> V.mul (eval e1) (eval e2) (récursion + multiplication)
*)
module MakeEvalExpr : MAKEEVALEXPR = 
  functor (V : VAL) ->
  struct
    type t = V.t
    type expr = 
      | Value of t
      | Add of expr * expr  
      | Mul of expr * expr
    
    let rec eval = function
      | Value v -> v
      | Add (e1, e2) -> V.add (eval e1) (eval e2)
      | Mul (e1, e2) -> V.mul (eval e1) (eval e2)
  end

(*
** Modules arithmétiques concrets
** Description : Implémentations spécifiques de VAL pour différents types
*)

(* IntVal : Arithmétique entière standard avec contrainte de type explicite *)
module IntVal : VAL with type t = int =
struct
  type t = int
  let add = ( + )
  let mul = ( * )
end

(* FloatVal : Arithmétique flottante standard avec contrainte de type explicite *)
module FloatVal : VAL with type t = float =
struct
  type t = float
  let add = ( +. )
  let mul = ( *. )
end

(* StringVal : Arithmétique sur chaînes avec contrainte de type explicite *)
module StringVal : VAL with type t = string =
struct
  type t = string
  let add s1 s2 = if (String.length s1) > (String.length s2) then s1 else s2
  let mul = ( ^ )
end

(*
** ÉTAPE FINALE : Substitution destructive
** Description : Remplacement de 'with type t =' par 'with type t :='
** 
** LES 6 CONTRAINTES DE PARTAGE COMPLÈTES :
** 1. VAL avec type t = type_concret (3 modules)
** 2. MAKEEVALEXPR avec type t = V.t (functor)
** 3. EVALEXPR avec type t := type_concret (3 modules, substitution destructive)
** 
** Total = 7 contraintes (6 + 1 sur le functor comme mentionné dans l'énoncé)
*)
module IntEvalExpr : EVALEXPR with type t := int = MakeEvalExpr (IntVal)
module FloatEvalExpr : EVALEXPR with type t := float = MakeEvalExpr (FloatVal)  
module StringEvalExpr : EVALEXPR with type t := string = MakeEvalExpr (StringVal)

(*
** Tests et démonstration - Retour à la version originale
** Description : Utilisation des constructeurs exposés par les modules
*)
let ie = IntEvalExpr.Add (IntEvalExpr.Value 40, IntEvalExpr.Value 2)
let fe = FloatEvalExpr.Add (FloatEvalExpr.Value 41.5, FloatEvalExpr.Value 0.92)
let se = StringEvalExpr.Mul (StringEvalExpr.Value "very ",
                           (StringEvalExpr.Add (StringEvalExpr.Value "very long",
                                              StringEvalExpr.Value "short")))

(*
** Programme principal
** Description : Évaluation et affichage des résultats
** 
** Output attendu :
** Res = 42
** Res = 42.420000  
** Res = very very long
*)
let () = Printf.printf "Res = %d\n" (IntEvalExpr.eval ie)
let () = Printf.printf "Res = %f\n" (FloatEvalExpr.eval fe)
let () = Printf.printf "Res = %s\n" (StringEvalExpr.eval se)
