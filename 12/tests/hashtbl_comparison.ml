(* Comparaison : Hashtbl simple vs Hashtbl.Make *)

let () =
  print_endline "=== 1. Hashtbl standard (polymorphe) ===";
  let simple_ht = Hashtbl.create 5 in
  
  (* Ajouter des strings directement *)
  Hashtbl.add simple_ht "Hello" 5;
  Hashtbl.add simple_ht "world" 5;
  Hashtbl.add simple_ht "42" 2;
  Hashtbl.add simple_ht "Ocaml" 5;
  Hashtbl.add simple_ht "H" 1;
  
  print_endline "Ordre avec Hashtbl standard :";
  Hashtbl.iter (fun k v -> Printf.printf "k = \"%s\", v = %d\n" k v) simple_ht;
  
  print_endline "\n=== 2. Comparaison des fonctions de hachage ===";
  let values = ["Hello"; "world"; "42"; "Ocaml"; "H"] in
  
  List.iter (fun s ->
    let std_hash = Hashtbl.hash s in
    let std_pos = std_hash mod 5 in
    Printf.printf "\"%s\": hash standard = %d, position = %d\n" s std_hash std_pos
  ) values;
  
  print_endline "\n=== 3. Test avec types personnalisés ===";
  print_endline "Avec Hashtbl standard, on peut utiliser des types simples directement"
