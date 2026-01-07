(* Main - Exercise 05
 * Tests for incomplete combustion
 *)

let () =
  print_endline "=== Ex05: Testing Incomplete Combustion ===";
  print_endline "";
  
  (* Test 1: Ethane incomplete combustion *)
  print_endline "Test 1: Ethane incomplete combustion";
  let ethane = new Alkane.ethane in
  let incomplete_ethane = new Incomplete_combustion.incomplete_combustion [ethane] in
  
  print_endline "Generating incomplete combustion outcomes for Ethane...";
  let ethane_results = incomplete_ethane#get_incomplete_results in
  
  Printf.printf "Found %d incomplete combustion scenarios\n" (List.length ethane_results);
  print_endline "";
  
  (* Afficher quelques exemples *)
  print_endline "Sample outcomes:";
  let sample_count = min 5 (List.length ethane_results) in
  List.iter (fun (o2, products) ->
    Printf.printf "With %d O2: " o2;
    let product_strs = List.map (fun (mol, coeff) ->
      if coeff = 1 then mol#to_string
      else string_of_int coeff ^ " " ^ mol#to_string
    ) products in
    print_endline (String.concat " + " product_strs)
  ) (List.filteri (fun i _ -> i < sample_count) ethane_results);
  print_endline "";
  
  (* Test 2: Propane incomplete combustion *)
  print_endline "Test 2: Propane incomplete combustion";
  let propane = new Alkane.propane in
  let incomplete_propane = new Incomplete_combustion.incomplete_combustion [propane] in
  
  print_endline "Generating incomplete combustion outcomes for Propane...";
  let propane_results = incomplete_propane#get_incomplete_results in
  
  Printf.printf "Found %d incomplete combustion scenarios\n" (List.length propane_results);
  print_endline "";
  
  (* Afficher quelques exemples *)
  print_endline "Sample outcomes (first 8):";
  let sample_count = min 13 (List.length propane_results) in
  List.iter (fun (o2, products) ->
    Printf.printf "With %d O2: " o2;
    let product_strs = List.map (fun (mol, coeff) ->
      if coeff = 1 then mol#to_string
      else string_of_int coeff ^ " " ^ mol#to_string
    ) products in
    print_endline (String.concat " + " product_strs)
  ) (List.filteri (fun i _ -> i < sample_count) propane_results);
  print_endline "";
  
  (* Test 3: Methane incomplete combustion *)
  print_endline "Test 3: Methane incomplete combustion";
  let methane = new Alkane.methane in
  let incomplete_methane = new Incomplete_combustion.incomplete_combustion [methane] in
  
  print_endline "Generating incomplete combustion outcomes for Methane...";
  let methane_results = incomplete_methane#get_incomplete_results in
  
  Printf.printf "Found %d incomplete combustion scenarios\n" (List.length methane_results);
  print_endline "";
  
  (* Afficher tous les résultats pour le méthane (plus petit) *)
  print_endline "All outcomes:";
  List.iter (fun (o2, products) ->
    Printf.printf "With %d O2: " o2;
    let product_strs = List.map (fun (mol, coeff) ->
      if coeff = 1 then mol#to_string
      else string_of_int coeff ^ " " ^ mol#to_string
    ) products in
    print_endline (String.concat " + " product_strs)
  ) methane_results;
  print_endline "";
  
  (* Test 4: Vérifier que la combustion complète est bien héritée *)
  print_endline "Test 4: Complete combustion still works";
  let butane = new Alkane.butane in
  let incomplete_butane = new Incomplete_combustion.incomplete_combustion [butane] in
  print_endline ("Butane complete combustion: " ^ incomplete_butane#balance#to_string);
  print_endline "";
  
  (* Test 5: Statistiques par quantité d'O2 *)
  print_endline "Test 5: Statistics by O2 amount (Propane)";
  let o2_groups = List.fold_left (fun acc (o2, _) ->
    let count = try List.assoc o2 acc with Not_found -> 0 in
    (o2, count + 1) :: (List.remove_assoc o2 acc)
  ) [] propane_results in
  
  let sorted_groups = List.sort (fun (o2_1, _) (o2_2, _) -> compare o2_1 o2_2) o2_groups in
  
  print_endline "Number of incomplete outcomes per O2 amount:";
  List.iter (fun (o2, count) ->
    Printf.printf "  %d O2: %d different outcomes\n" o2 count
  ) sorted_groups;
  print_endline "";

  (* Test 6: Methane andPropane incomplete combustion *)
  print_endline "Test 6: Propane incomplete combustion";
  let incomplete_propane2 = new Incomplete_combustion.incomplete_combustion [propane; methane] in
  
  print_endline "Generating incomplete combustion outcomes for Propane...";
  let propane_results2 = incomplete_propane2#get_incomplete_results in
  
  Printf.printf "Found %d incomplete combustion scenarios\n" (List.length propane_results2);
  print_endline "";
  
  (* Afficher quelques exemples *)
  print_endline "Sample outcomes (first 8):";
  let sample_count = min 8 (List.length propane_results2) in
  List.iter (fun (o2, products) ->
    Printf.printf "With %d O2: " o2;
    let product_strs = List.map (fun (mol, coeff) ->
      if coeff = 1 then mol#to_string
      else string_of_int coeff ^ " " ^ mol#to_string
    ) products in
    print_endline (String.concat " + " product_strs)
  ) (List.filteri (fun i _ -> i < sample_count) propane_results2);
  print_endline "";

  
  print_endline "=== All tests completed ===";
  print_endline ""
