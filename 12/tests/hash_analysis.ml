(* Programme pour calculer et analyser les hashs *)

(* Copie de ta fonction hash pour les calculs *)
let hash str =
  let len = String.length str in
  let rec hash_aux acc i =
    if i >= len then acc
    else
      let char_code = Char.code (String.get str i) in
      let new_acc = ((acc lsl 5) + acc) + char_code in
      hash_aux new_acc (i + 1)
  in
  hash_aux 5381 0

(* Fonction pour calculer la position dans la table (modulo taille) *)
let hash_position str table_size =
  let h = hash str in
  let pos = h mod table_size in
  (h, pos)

let () =
  let values = [ "Hello"; "world"; "42"; "Ocaml"; "H" ] in
  let table_size = 5 in
  
  print_endline "=== Calcul des hashs et positions ===";
  print_endline "String\t\tHash\t\tPosition (hash % 5)";
  print_endline "------\t\t----\t\t---------------";
  
  List.iter (fun s ->
    let (h, pos) = hash_position s table_size in
    Printf.printf "\"%s\"\t\t%d\t\t\t%d\n" s h pos
  ) values;
  
  print_endline "\n=== Analyse de l'ordre de sortie ===";
  print_endline "La table de hachage itère dans l'ordre des positions internes :";
  
  (* Créer une liste avec positions pour tri *)
  let with_positions = List.map (fun s ->
    let (h, pos) = hash_position s table_size in
    (s, String.length s, h, pos)
  ) values in
  
  (* Trier par position pour voir l'ordre probable *)
  let sorted = List.sort (fun (_,_,_,pos1) (_,_,_,pos2) -> 
    compare pos1 pos2) with_positions in
  
  print_endline "Ordre probable d'affichage (par position croissante) :";
  List.iter (fun (s, len, h, pos) ->
    Printf.printf "Position %d: \"%s\" (length=%d, hash=%d)\n" pos s len h
  ) sorted
