(* Démonstration : Seule la clé est hachée *)

module DebugHashedType = struct
  type t = string
  let equal s1 s2 = (s1 = s2)
  
  let hash str =
    Printf.printf "HACHAGE appelé sur la clé: \"%s\"\n" str;
    let result = Hashtbl.hash str in
    Printf.printf "  -> hash(\"%s\") = %d\n" str result;
    result
end

module DebugHashtbl = Hashtbl.Make(DebugHashedType)

let demonstrate_key_hashing () =
  print_endline "=== Démonstration: Seule la clé est hachée ===";
  let table = DebugHashtbl.create 5 in
  
  print_endline "\n1. Ajout de (\"alice\", 25):";
  DebugHashtbl.add table "alice" 25;
  
  print_endline "\n2. Ajout de (\"bob\", 30):";
  DebugHashtbl.add table "bob" 30;
  
  print_endline "\n3. Recherche de \"alice\":";
  let age = DebugHashtbl.find table "alice" in
  Printf.printf "Âge trouvé: %d\n" age;
  
  print_endline "\n4. Modification de (\"alice\", 26):";
  DebugHashtbl.replace table "alice" 26;
  
  print_endline "\n5. Suppression de \"bob\":";
  DebugHashtbl.remove table "bob";

  print_endline "\n6. Ajout de (\"bob\", 30):";
  DebugHashtbl.add table "bob" 30;
  
  print_endline "\nContenu final:";
  DebugHashtbl.iter (fun key value ->
    Printf.printf "  %s -> %d (pas de hachage lors de l'affichage)\n" key value
  ) table

let () = demonstrate_key_hashing ()
