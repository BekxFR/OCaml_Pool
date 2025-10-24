(*
** Utilitaire d'analyse de la fonction de hachage djb2
** Pour comprendre l'ordre de sortie des éléments
*)

(* Réimplémentation de djb2 pour analyse *)
let djb2_hash str =
  let len = String.length str in
  let rec hash_aux acc i =
    if i >= len then acc
    else
      let char_code = Char.code (String.get str i) in
      let new_acc = ((acc lsl 5) + acc) + char_code in
      hash_aux new_acc (i + 1)
  in
  hash_aux 5381 0

let () =
  let values = [ "Hello"; "world"; "42"; "Ocaml"; "H" ] in
  
  print_endline "=== Analyse des hash values (djb2) ===";
  print_endline "";
  
  (* Calcul et affichage des hash values *)
  List.iter (fun s ->
    let hash_val = djb2_hash s in
    let hash_mod_5 = hash_val mod 5 in
    Printf.printf "%-8s : hash = %10d, hash %% 5 = %d\n" 
      ("\"" ^ s ^ "\"") hash_val hash_mod_5
  ) values;
  
  print_endline "";
  print_endline "=== Ordre dans la table de hachage ===";
  print_endline "(dépend de hash % table_size et de la gestion des collisions)";
  print_endline ""
