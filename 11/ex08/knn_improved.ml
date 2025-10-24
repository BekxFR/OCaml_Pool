(* Version améliorée de find_k_nearest_neighbors *)
(* Conserve la lisibilité tout en ajoutant des vérifications *)

type radar = float array * string

type neighbor = {
  radar : radar;
  distance : float;
}

let euclidean_distance features1 features2 =
  let len1 = Array.length features1 in
  let len2 = Array.length features2 in
  if len1 <> len2 then
    failwith ("Dimensions incompatibles : " ^ string_of_int len1 ^ " vs " ^ string_of_int len2)
  else
    let sum_squares = ref 0.0 in
    for i = 0 to len1 - 1 do
      let diff = features1.(i) -. features2.(i) in
      sum_squares := !sum_squares +. (diff *. diff)
    done;
    sqrt !sum_squares

let compare_neighbors n1 n2 =
  let cmp = compare n1.distance n2.distance in
  if cmp = 0 then
    (* En cas d'égalité de distance, trier par label pour la stabilité *)
    let (_, label1) = n1.radar in
    let (_, label2) = n2.radar in
    String.compare label1 label2
  else cmp

(* Version améliorée avec validations supplémentaires *)
let find_k_nearest_neighbors_improved training_set test_features k =
  (* Validations d'entrée *)
  if k <= 0 then
    failwith "k doit être strictement positif"
  else if training_set = [] then
    failwith "L'ensemble d'entraînement ne peut pas être vide"
  else
    (* Validation des dimensions *)
    (match training_set with
     | (features_sample, _) :: _ ->
         if Array.length test_features <> Array.length features_sample then
           failwith ("Dimension du point test (" ^ 
                    string_of_int (Array.length test_features) ^ 
                    ") != dimension training (" ^ 
                    string_of_int (Array.length features_sample) ^ ")")
     | [] -> ());
    
    (* Calcul des distances avec gestion des erreurs *)
    let neighbors = List.map (fun radar ->
      let (features, _) = radar in
      try
        let distance = euclidean_distance test_features features in
        { radar = radar; distance = distance }
      with
      | Failure msg -> failwith ("Erreur de calcul de distance : " ^ msg)
    ) training_set in
    
    (* Tri par distance croissante *)
    let sorted_neighbors = List.sort compare_neighbors neighbors in
    
    (* Prendre les k premiers avec information de troncature *)
    let available_neighbors = List.length sorted_neighbors in
    let actual_k = min k available_neighbors in
    
    let rec take_k acc n lst =
      match n, lst with
      | 0, _ -> List.rev acc
      | _, [] -> List.rev acc
      | n, x :: xs -> take_k (x :: acc) (n - 1) xs
    in
    
    let result = take_k [] actual_k sorted_neighbors in
    
    (* Avertissement si k > nombre d'exemples disponibles *)
    if k > available_neighbors then
      Printf.eprintf "Avertissement : k=%d demandé, mais seulement %d exemples disponibles\n" 
        k available_neighbors;
    
    result

(* Test de la version améliorée *)
let test_improved_version () =
  print_endline "=== Test de la version améliorée ===";
  print_newline ();
  
  let training_set = [
    ([|1.0; 2.0|], "A");
    ([|2.0; 1.0|], "B");
    ([|3.0; 3.0|], "C");
  ] in
  
  let test_point = [|1.5; 1.5|] in
  
  (* Test normal *)
  print_endline "Test normal :";
  let neighbors = find_k_nearest_neighbors_improved training_set test_point 2 in
  List.iter (fun neighbor ->
    let (_, label) = neighbor.radar in
    Printf.printf "  %s (distance = %.3f)\n" label neighbor.distance
  ) neighbors;
  print_newline ();
  
  (* Test erreur de dimension *)
  print_endline "Test erreur de dimension :";
  (try
    let bad_point = [|1.0|] in (* Dimension différente *)
    let _ = find_k_nearest_neighbors_improved training_set bad_point 1 in
    print_endline "ERREUR : devrait lever une exception"
  with
  | Failure msg -> Printf.printf "Exception attendue : %s\n" msg);
  print_newline ();
  
  (* Test k trop grand *)
  print_endline "Test k trop grand :";
  let _ = find_k_nearest_neighbors_improved training_set test_point 10 in
  print_endline "Traité avec avertissement";
  print_newline ()

let () = test_improved_version ()
