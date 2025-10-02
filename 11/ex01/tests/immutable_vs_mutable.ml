(* ========================================================================== *)
(*           COMPARAISON RECORD MUTABLE vs IMMUTABLE POUR FT_REF           *)
(* ========================================================================== *)

(* ========================================================================== *)
(* 1. VERSION MUTABLE (celle qu'on a utilisée) *)
(* ========================================================================== *)

type 'a ft_ref_mutable = { mutable contents : 'a }

let return_mut a = { contents = a }
let get_mut ft_ref = ft_ref.contents
let set_mut ft_ref value = ft_ref.contents <- value (* MODIFICATION EN PLACE *)

(* ========================================================================== *)
(* 2. VERSION IMMUTABLE (alternative théorique) *)
(* ========================================================================== *)

type 'a ft_ref_immutable = { contents : 'a }  (* PAS de mutable *)

let return_imm a = { contents = a }
let get_imm ft_ref = ft_ref.contents

(* PROBLÈME : comment implémenter set ? *)
let set_imm ft_ref value = 
  { contents = value }  (* Retourne un NOUVEAU record, ne modifie pas l'ancien *)

(* ========================================================================== *)
(* 3. DÉMONSTRATION DES DIFFÉRENCES *)
(* ========================================================================== *)

let () =
  print_endline "=== COMPARAISON MUTABLE vs IMMUTABLE ===\n";
  
  print_endline "--- VERSION MUTABLE ---";
  let x_mut = return_mut 42 in
  Printf.printf "x_mut initial: %d\n" (get_mut x_mut);
  
  (* Partage de référence *)
  let y_mut = x_mut in  (* y_mut pointe vers le MÊME record *)
  Printf.printf "y_mut (même référence): %d\n" (get_mut y_mut);
  
  (* Modification de x_mut *)
  set_mut x_mut 100;
  Printf.printf "x_mut après set: %d\n" (get_mut x_mut);
  Printf.printf "y_mut après set de x_mut: %d\n" (get_mut y_mut);  (* AUSSI 100 ! *)
  
  print_endline "\n--- VERSION IMMUTABLE ---";
  let x_imm = return_imm 42 in
  Printf.printf "x_imm initial: %d\n" (get_imm x_imm);
  
  (* Partage de référence *)
  let y_imm = x_imm in  (* y_imm pointe vers le MÊME record *)
  Printf.printf "y_imm (même référence): %d\n" (get_imm y_imm);
  
  (* "Modification" de x_imm *)
  let x_imm_new = set_imm x_imm 100 in  (* NOUVEAU record *)
  Printf.printf "x_imm après set: %d\n" (get_imm x_imm);        (* TOUJOURS 42 ! *)
  Printf.printf "x_imm_new: %d\n" (get_imm x_imm_new);          (* 100 *)
  Printf.printf "y_imm après set: %d\n" (get_imm y_imm);        (* TOUJOURS 42 ! *)
  
  print_endline "\n--- PROBLÈME AVEC L'IMMUTABLE ---";
  print_endline "• set_imm retourne un NOUVEAU record";
  print_endline "• L'ancien record n'est PAS modifié";
  print_endline "• Impossible de reproduire le comportement de ref";
  print_endline "• Les références partagées ne marchent plus";
  
  print_endline "\n--- POURQUOI MUTABLE EST NÉCESSAIRE ---";
  print_endline "• ref permet la modification en place";
  print_endline "• Partage de références avec mise à jour";
  print_endline "• Comportement impératif authentique";
  print_endline "• Performance (pas de nouvelles allocations)"
