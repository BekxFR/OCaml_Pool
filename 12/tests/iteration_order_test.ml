(* Test pour comprendre l'ordre d'itération exact de Hashtbl *)

(* Module avec hash simple qui retourne directement la position *)
module PositionHashedType = struct
  type t = int
  let equal = (=)
  let hash x = x  (* Hash = la valeur elle-même *)
end

module PositionHashtbl = Hashtbl.Make(PositionHashedType)

let test_iteration_order () =
  print_endline "=== Test de l'ordre d'itération avec positions explicites ===";
  let ht = PositionHashtbl.create 5 in
  
  (* Insérer dans l'ordre : position 0, 1, 2, 3, 4 *)
  List.iter (fun i -> 
    PositionHashtbl.add ht i (i * 10);
    Printf.printf "Ajout: position %d, valeur %d\n" i (i * 10)
  ) [0; 1; 2; 3; 4];
  
  print_endline "\nOrdre d'itération :";
  PositionHashtbl.iter (fun k v -> 
    Printf.printf "Position %d: valeur %d\n" k v
  ) ht;
  
  print_endline "\n=== Test avec insertion dans un autre ordre ===";
  let ht2 = PositionHashtbl.create 5 in
  
  (* Insérer dans l'ordre : 3, 4, 0, 1, 2 *)
  List.iter (fun i -> 
    PositionHashtbl.add ht2 i (i * 10)
  ) [3; 4; 0; 1; 2];
  
  print_endline "Ordre d'itération après insertion [3,4,0,1,2] :";
  PositionHashtbl.iter (fun k v -> 
    Printf.printf "Position %d: valeur %d\n" k v
  ) ht2

let () = test_iteration_order ()
