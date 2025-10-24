(* Analyse comparative de complexité pour find_k_nearest_neighbors *)

(* Version actuelle : tri complet *)
let find_k_nearest_current training_set test_features k =
  let neighbors = List.map (fun radar ->
    let (features, _) = radar in
    let distance = 
      (* Distance euclidienne simplifiée pour test *)
      let sum = ref 0.0 in
      Array.iteri (fun i x -> 
        let diff = x -. test_features.(i) in
        sum := !sum +. (diff *. diff)
      ) features;
      sqrt !sum
    in
    (radar, distance)
  ) training_set in
  
  let sorted = List.sort (fun (_, d1) (_, d2) -> compare d1 d2) neighbors in
  let rec take n lst acc =
    match n, lst with
    | 0, _ -> List.rev acc
    | _, [] -> List.rev acc
    | n, x :: xs -> take (n - 1) xs (x :: acc)
  in
  take k sorted []

(* Version optimisée avec heap simulée *)
let find_k_nearest_optimized training_set test_features k =
  (* Simule une max-heap de taille k *)
  let heap = ref [] in
  
  List.iter (fun radar ->
    let (features, _) = radar in
    let distance = 
      let sum = ref 0.0 in
      Array.iteri (fun i x -> 
        let diff = x -. test_features.(i) in
        sum := !sum +. (diff *. diff)
      ) features;
      sqrt !sum
    in
    
    if List.length !heap < k then
      (* Heap pas encore pleine *)
      heap := (radar, distance) :: !heap
    else
      (* Trouver le maximum dans la heap *)
      let (max_radar, max_dist) = List.fold_left (fun (r1, d1) (r2, d2) ->
        if d1 > d2 then (r1, d1) else (r2, d2)
      ) (List.hd !heap) !heap in
      
      if distance < max_dist then
        (* Remplacer le maximum *)
        heap := (radar, distance) :: (List.filter (fun (r, _) -> r != max_radar) !heap)
  ) training_set;
  
  List.sort (fun (_, d1) (_, d2) -> compare d1 d2) !heap

(* Test de performance conceptuel *)
let test_performance_comparison () =
  print_endline "=== Analyse de complexité ===";
  print_newline ();
  
  let sizes = [10; 100; 1000; 10000] in
  let k_values = [1; 3; 5; 10] in
  
  Printf.printf "%-8s %-8s %-15s %-15s %-10s\n" "n" "k" "Tri complet" "Heap optimisé" "Ratio";
  print_endline (String.make 60 '-');
  
  List.iter (fun n ->
    List.iter (fun k ->
      if k <= n then (
        let tri_ops = n * (int_of_float (log (float_of_int n))) in
        let heap_ops = n * (int_of_float (log (float_of_int k))) in
        let ratio = (float_of_int tri_ops) /. (float_of_int heap_ops) in
        Printf.printf "%-8d %-8d %-15d %-15d %-10.2f\n" n k tri_ops heap_ops ratio
      )
    ) k_values
  ) sizes;
  
  print_newline ();
  print_endline "Conclusion : Plus n est grand et k petit, plus l'optimisation est profitable"

let () = test_performance_comparison ()
