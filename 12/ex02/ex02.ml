(*
** Exercice 02: Projections
** 
** Description : Création de foncteurs pour extraire les composantes d'une paire
** Implémentation de MakeFst et MakeSnd avec la signature MAKEPROJECTION
** 
** Concepts abordés :
** - Création de foncteurs personnalisés
** - Signatures de foncteurs
** - Projections sur les paires
** - Utilisation de Stdlib.fst et Stdlib.snd
** 
** Contraintes :
** - Fonctions autorisées : Stdlib.fst et Stdlib.snd uniquement
** - Signature MAKEPROJECTION à définir
** - Code fourni doit compiler exactement
*)

(*
** Types fournis dans l'énoncé
*)
module type PAIR = sig val pair : (int * int) end
module type VAL = sig val x : int end

(*
** Signature MAKEPROJECTION
** Description : Signature des foncteurs de projection
** 
** Cette signature définit l'interface que doivent respecter
** les foncteurs MakeFst et MakeSnd :
** - Prennent un module respectant PAIR en paramètre
** - Retournent un module respectant VAL
** 
** Déduction logique :
** - Le module d'entrée doit contenir une paire (int * int)
** - Le module de sortie doit contenir un entier x
** - Les foncteurs extraient soit le premier, soit le second élément
*)
module type MAKEPROJECTION = functor (P : PAIR) -> VAL

(*
** Foncteur MakeFst
** Description : Extrait le premier élément d'une paire
** 
** Paramètre : P (module respectant PAIR)
** Retour : module respectant VAL avec x = fst(P.pair)
** 
** Utilisation de Stdlib.fst conformément aux contraintes
*)
module MakeFst : MAKEPROJECTION = functor (P : PAIR) -> struct
  let x = Stdlib.fst P.pair
end

(*
** Foncteur MakeSnd  
** Description : Extrait le second élément d'une paire
** 
** Paramètre : P (module respectant PAIR)
** Retour : module respectant VAL avec x = snd(P.pair)
** 
** Utilisation de Stdlib.snd conformément aux contraintes
*)
module MakeSnd : MAKEPROJECTION = functor (P : PAIR) -> struct
  let x = Stdlib.snd P.pair
end

(*
** Code de test fourni dans l'énoncé
** 
** Étapes :
** 1. Définition du module Pair avec pair = (21, 42)
** 2. Application des foncteurs MakeFst et MakeSnd
** 3. Affichage des résultats : Fst.x = 21, Snd.x = 42
*)
module Pair : PAIR = struct let pair = ( 21, 42 ) end
module Fst : VAL = MakeFst (Pair)
module Snd : VAL = MakeSnd (Pair)

let () = Printf.printf "Fst.x = %d, Snd.x = %d\n" Fst.x Snd.x
