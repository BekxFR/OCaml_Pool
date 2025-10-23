(* Cas 1: Optimisation pour des données spécifiques *)

(* Exemple: IDs numériques séquentiels *)
module IntIdHashedType = struct
  type t = int
  let equal = (=)
  
  (* Pour des IDs 1,2,3,4... la fonction par défaut peut créer des collisions *)
  (* Notre fonction optimisée *)
  let hash id = id * 2654435761 (* Nombre premier pour meilleure distribution *)
end

(* Exemple: Strings avec préfixe commun *)
module PrefixedStringHashedType = struct
  type t = string
  let equal = String.equal
  
  (* Si toutes les strings commencent par "user_", on ignore le préfixe *)
  let hash str =
    let len = String.length str in
    if len > 5 && String.sub str 0 5 = "user_" then
      (* Hasher seulement la partie après "user_" *)
      let suffix = String.sub str 5 (len - 5) in
      Hashtbl.hash suffix
    else
      Hashtbl.hash str
end

let test_performance_optimization () =
  print_endline "=== Test d'optimisation de performance ===";
  
  (* Test avec IDs séquentiels *)
  module IdHashtbl = Hashtbl.Make(IntIdHashedType) in
  let id_table = IdHashtbl.create 10 in
  
  List.iter (fun i -> IdHashtbl.add id_table i ("user_" ^ string_of_int i)) [1;2;3;4;5];
  
  print_endline "Hashtable optimisée pour IDs :";
  IdHashtbl.iter (fun id name -> Printf.printf "ID %d: %s\n" id name) id_table;
  
  (* Test avec strings préfixées *)
  module PrefixHashtbl = Hashtbl.Make(PrefixedStringHashedType) in
  let prefix_table = PrefixHashtbl.create 10 in
  
  List.iter (fun name -> 
    PrefixHashtbl.add prefix_table name (String.length name)
  ) ["user_alice"; "user_bob"; "user_charlie"];
  
  print_endline "\nHashtable optimisée pour préfixes :";
  PrefixHashtbl.iter (fun name len -> Printf.printf "%s: %d chars\n" name len) prefix_table

let () = test_performance_optimization ()
