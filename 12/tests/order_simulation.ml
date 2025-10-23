(* Simulation de l'ordre d'affichage d'une hashtable *)

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

let simulate_hashtbl_order values table_size =
  (* Créer des buckets vides *)
  let buckets = Array.make table_size [] in
  
  (* Insérer chaque élément dans son bucket *)
  List.iter (fun s ->
    let pos = (hash s) mod table_size in
    let len = String.length s in
    buckets.(pos) <- (s, len) :: buckets.(pos)
  ) values;
  
  (* Afficher dans l'ordre des buckets *)
  print_endline "=== Simulation de l'ordre d'affichage ===";
  for i = 0 to table_size - 1 do
    List.iter (fun (k, v) ->
      Printf.printf "k = \"%s\", v = %d (bucket %d)\n" k v i
    ) (List.rev buckets.(i))  (* rev car insertion en tête *)
  done

let () =
  let values = [ "Hello"; "world"; "42"; "Ocaml"; "H" ] in
  simulate_hashtbl_order values 5
