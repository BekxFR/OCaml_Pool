(* ========================================================================== *)
(*                    PROBLÈME CONCRET AVEC L'IMMUTABLE                      *)
(* ========================================================================== *)

type 'a ft_ref_mutable = { mutable contents : 'a }
type 'a ft_ref_immutable = { contents : 'a }

let return_mut a : 'a ft_ref_mutable = { contents = a }
let get_mut (ft_ref : 'a ft_ref_mutable) = ft_ref.contents
let set_mut (ft_ref : 'a ft_ref_mutable) value = ft_ref.contents <- value

let return_imm a : 'a ft_ref_immutable = { contents = a }
let get_imm (ft_ref : 'a ft_ref_immutable) = ft_ref.contents
let set_imm (ft_ref : 'a ft_ref_immutable) value : 'a ft_ref_immutable = { contents = value }

(* ========================================================================== *)
(* EXEMPLE : COMPTEUR PARTAGÉ *)
(* ========================================================================== *)

let test_compteur () =
  print_endline "=== EXEMPLE COMPTEUR PARTAGÉ ===\n";
  
  print_endline "--- AVEC MUTABLE (fonctionne) ---";
  
  let compteur = return_mut 0 in
  
  let increment () = 
    let current = get_mut compteur in
    set_mut compteur (current + 1) in
  
  let get_compteur () = get_mut compteur in
  
  Printf.printf "Compteur initial: %d\n" (get_compteur ());
  increment ();
  Printf.printf "Après increment 1: %d\n" (get_compteur ());
  increment ();
  Printf.printf "Après increment 2: %d\n" (get_compteur ());
  
  print_endline "\n--- AVEC IMMUTABLE (problématique) ---";
  
  let compteur_imm = ref (return_imm 0) in  (* On doit wrapper dans une ref ! *)
  
  let increment_imm () = 
    let current = get_imm !compteur_imm in
    compteur_imm := set_imm !compteur_imm (current + 1) in  (* Pas élégant *)
  
  let get_compteur_imm () = get_imm !compteur_imm in
  
  Printf.printf "Compteur immutable initial: %d\n" (get_compteur_imm ());
  increment_imm ();
  Printf.printf "Après increment 1: %d\n" (get_compteur_imm ());
  increment_imm ();
  Printf.printf "Après increment 2: %d\n" (get_compteur_imm ());
  
  print_endline "\n--- CONCLUSION ---";
  print_endline "• Avec immutable, on doit utiliser une vraie ref !";
  print_endline "• C'est contradictoire avec l'objectif de reproduire ref";
  print_endline "• Le code devient plus complexe, pas plus simple"

(* ========================================================================== *)
(* EXEMPLE : MISE À JOUR DE STRUCTURE *)
(* ========================================================================== *)

type personne = { nom : string; age : int }

let test_personne () =
  print_endline "\n=== EXEMPLE MISE À JOUR PERSONNE ===\n";
  
  print_endline "--- AVEC MUTABLE ---";
  
  let p_mut = return_mut { nom = "Alice"; age = 25 } in
  let p_alias = p_mut in  (* Alias vers la même référence *)
  
  Printf.printf "p_mut: %s, %d ans\n" (get_mut p_mut).nom (get_mut p_mut).age;
  Printf.printf "p_alias: %s, %d ans\n" (get_mut p_alias).nom (get_mut p_alias).age;
  
  (* Vieillissement *)
  let current = get_mut p_mut in
  set_mut p_mut { current with age = current.age + 1 };
  
  Printf.printf "Après vieillissement:\n";
  Printf.printf "p_mut: %s, %d ans\n" (get_mut p_mut).nom (get_mut p_mut).age;
  Printf.printf "p_alias: %s, %d ans\n" (get_mut p_alias).nom (get_mut p_alias).age;
  
  print_endline "\n--- AVEC IMMUTABLE ---";
  
  let p_imm = return_imm { nom = "Bob"; age = 25 } in
  let p_alias_imm = p_imm in
  
  Printf.printf "p_imm: %s, %d ans\n" (get_imm p_imm).nom (get_imm p_imm).age;
  Printf.printf "p_alias_imm: %s, %d ans\n" (get_imm p_alias_imm).nom (get_imm p_alias_imm).age;
  
  (* Vieillissement *)
  let current = get_imm p_imm in
  let p_imm_new = set_imm p_imm { current with age = current.age + 1 } in
  
  Printf.printf "Après vieillissement:\n";
  Printf.printf "p_imm (original): %s, %d ans\n" (get_imm p_imm).nom (get_imm p_imm).age;
  Printf.printf "p_imm_new: %s, %d ans\n" (get_imm p_imm_new).nom (get_imm p_imm_new).age;
  Printf.printf "p_alias_imm: %s, %d ans\n" (get_imm p_alias_imm).nom (get_imm p_alias_imm).age;
  
  print_endline "\n--- DIFFÉRENCE CLÉE ---";
  print_endline "• Mutable: p_alias voit le changement (référence partagée)";
  print_endline "• Immutable: p_alias_imm ne voit PAS le changement"

let () =
  test_compteur ();
  test_personne ();
