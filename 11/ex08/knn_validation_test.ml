(* Test de validation détaillé de find_k_nearest_neighbors *)

type radar = float array * string

let euclidean_distance features1 features2 =
  let len1 = Array.length features1 in
  let len2 = Array.length features2 in
  if len1 <> len2 then
    failwith "Les vecteurs doivent avoir la même taille"
  else
    let sum_squares = ref 0.0 in
    for i = 0 to len1 - 1 do
      let diff = features1.(i) -. features2.(i) in
      sum_squares := !sum_squares +. (diff *. diff)
    done;
    sqrt !sum_squares

type neighbor = {
  radar : radar;
  distance : float;
}

let compare_neighbors n1 n2 =
  if n1.distance < n2.distance then -1
  else if n1.distance > n2.distance then 1
  else 0

(* Reproduction exacte de la fonction du fichier *)
let find_k_nearest_neighbors training_set test_features k =
  if k <= 0 then
    failwith "k doit être strictement positif"
  else if training_set = [] then
    failwith "L'ensemble d'entraînement ne peut pas être vide"
  else
    let neighbors = List.map (fun radar ->
      let (features, _) = radar in
      let distance = euclidean_distance test_features features in
      { radar = radar; distance = distance }
    ) training_set in
    
    let sorted_neighbors = List.sort compare_neighbors neighbors in
    
    let rec take_k acc n lst =
      match n, lst with
      | 0, _ -> List.rev acc
      | _, [] -> List.rev acc
      | n, x :: xs -> take_k (x :: acc) (n - 1) xs
    in
    take_k [] k sorted_neighbors

(* Tests de validation *)
let test_algorithm_correctness () =
  print_endline "=== Test de validation de l'algorithme ===";
  print_newline ();
  
  (* Dataset simple pour validation manuelle *)
  let training_set = [
    ([|0.0; 0.0|], "origine");
    ([|1.0; 0.0|], "droite");
    ([|0.0; 1.0|], "haut");
    ([|-1.0; 0.0|], "gauche");
    ([|0.0; -1.0|], "bas");
    ([|2.0; 2.0|], "loin");
  ] in
  
  let test_point = [|0.1; 0.1|] in
  
  print_endline "Training set :";
  List.iteri (fun i (features, label) ->
    let dist = euclidean_distance test_point features in
    Printf.printf "  %d. %s -> distance = %.3f\n" (i+1) label dist
  ) training_set;
  print_newline ();
  
  Printf.printf "Point de test : [|%.1f; %.1f|]\n" test_point.(0) test_point.(1);
  print_newline ();
  
  (* Test avec différentes valeurs de k *)
  List.iter (fun k ->
    Printf.printf "k = %d :\n" k;
    let neighbors = find_k_nearest_neighbors training_set test_point k in
    List.iteri (fun i neighbor ->
      let (_, label) = neighbor.radar in
      Printf.printf "  %d. %s (distance = %.3f)\n" (i+1) label neighbor.distance
    ) neighbors;
    
    (* Vérification que les distances sont bien triées *)
    let distances = List.map (fun n -> n.distance) neighbors in
    let is_sorted = List.for_all2 (fun d1 d2 -> d1 <= d2) 
      distances (List.tl distances @ [infinity]) in
    Printf.printf "     Distances triées : %s\n" (if is_sorted then "✓" else "✗");
    print_newline ()
  ) [1; 2; 3; 5; 10];
  
  (* Test cas limites *)
  print_endline "=== Tests cas limites ===";
  
  (* k plus grand que le dataset *)
  let k_large = List.length training_set + 5 in
  let neighbors_large = find_k_nearest_neighbors training_set test_point k_large in
  Printf.printf "k=%d (> taille dataset) -> %d voisins retournés\n" 
    k_large (List.length neighbors_large);
  
  (* k = 1 *)
  let neighbors_1 = find_k_nearest_neighbors training_set test_point 1 in
  let (_, closest_label) = (List.hd neighbors_1).radar in
  Printf.printf "k=1 -> plus proche voisin : %s\n" closest_label;
  
  print_newline ()

(* Test avec des égalités de distance *)
let test_tie_handling () =
  print_endline "=== Test gestion des égalités ===";
  print_newline ();
  
  (* Dataset avec distances égales *)
  let training_set = [
    ([|1.0; 0.0|], "A");
    ([|0.0; 1.0|], "B");
    ([|-1.0; 0.0|], "C");
    ([|0.0; -1.0|], "D");
  ] in
  
  let test_point = [|0.0; 0.0|] in
  
  print_endline "Training set avec distances égales :";
  List.iter (fun (features, label) ->
    let dist = euclidean_distance test_point features in
    Printf.printf "  %s -> distance = %.3f\n" label dist
  ) training_set;
  print_newline ();
  
  let neighbors = find_k_nearest_neighbors training_set test_point 2 in
  print_endline "k=2 avec égalités :";
  List.iter (fun neighbor ->
    let (_, label) = neighbor.radar in
    Printf.printf "  %s (distance = %.3f)\n" label neighbor.distance
  ) neighbors;
  
  print_endline "Note : L'ordre dépend de la stabilité du tri et de l'ordre initial"

(* Test de performance avec timing simulé *)
let test_performance_simulation () =
  print_endline "=== Simulation de performance ===";
  print_newline ();
  
  let simulate_time n k =
    (* Simulation des opérations *)
    let map_ops = n in (* O(n) pour le map *)
    let sort_ops = n * (int_of_float (log (float_of_int n))) in (* O(n log n) *)
    let take_ops = k in (* O(k) pour prendre k éléments *)
    map_ops + sort_ops + take_ops
  in
  
  let sizes = [100; 500; 1000; 5000] in
  let k_values = [1; 3; 5; 10] in
  
  Printf.printf "%-8s %-8s %-15s\n" "n" "k" "Ops simulées";
  print_endline (String.make 35 '-');
  
  List.iter (fun n ->
    List.iter (fun k ->
      if k <= n then (
        let ops = simulate_time n k in
        Printf.printf "%-8d %-8d %-15d\n" n k ops
      )
    ) k_values
  ) sizes

let () =
  test_algorithm_correctness ();
  test_tie_handling ();
  test_performance_simulation ()
