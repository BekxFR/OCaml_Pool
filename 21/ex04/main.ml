(* Main - Exercise 04
 * Tests for alkane combustion
 *)

let () =
  print_endline "=== Ex04: Testing Alkane Combustion ===";
  print_endline "";
  
  (* Test 1: Combustion simple - methane *)
  print_endline "Test 1: Methane combustion";
  let methane = new Alkane.methane in
  let comb_methane = new Alkane_combustion.alkane_combustion [methane] in
  print_endline "Created methane combustion";
  print_endline ("Is balanced initially: " ^ string_of_bool comb_methane#is_balanced);
  
  (try
    let _ = comb_methane#get_start in
    print_endline "Start molecules retrieved successfully"
  with Reaction.UnbalancedReaction ->
    print_endline "Correctly raised UnbalancedReaction before balance");
  
  let balanced_methane = comb_methane#balance in
  print_endline ("Is balanced after balance: " ^ string_of_bool balanced_methane#is_balanced);
  print_endline ("Reaction: " ^ balanced_methane#to_string);
  print_endline "";
  
  (* Test 2: Combustion - ethane *)
  print_endline "Test 2: Ethane combustion";
  let ethane = new Alkane.ethane in
  let comb_ethane = new Alkane_combustion.alkane_combustion [ethane] in
  let balanced_ethane = comb_ethane#balance in
  print_endline ("Ethane: " ^ balanced_ethane#to_string);
  print_endline "";
  
  (* Test 3: Combustion - propane *)
  print_endline "Test 3: Propane combustion";
  let propane = new Alkane.propane in
  let comb_propane = new Alkane_combustion.alkane_combustion [propane] in
  let balanced_propane = comb_propane#balance in
  print_endline ("Propane: " ^ balanced_propane#to_string);
  print_endline "";
  
  (* Test 4: Combustion - octane *)
  print_endline "Test 4: Octane combustion";
  let octane = new Alkane.octane in
  let comb_octane = new Alkane_combustion.alkane_combustion [octane] in
  let balanced_octane = comb_octane#balance in
  print_endline ("Octane: " ^ balanced_octane#to_string);
  print_endline "";
  
  (* Test 5: Vérifier les coefficients *)
  print_endline "Test 5: Verify coefficients";
  let verify_combustion name alk =
    let comb = new Alkane_combustion.alkane_combustion [alk] in
    let balanced_comb = comb#balance in
    let n = alk#carbon_count in
    Printf.printf "%s (n=%d): %s\n" name n balanced_comb#to_string;
    
    (* Calculer la formule simplifiée *)
    let coeff_o2 = 3 * n + 1 in
    let rec gcd a b = if b = 0 then a else gcd b (a mod b) in
    let pgcd = gcd (gcd (gcd 2 coeff_o2) (2*n)) (2*(n+1)) in
    let simplified_alk = 2 / pgcd in
    let simplified_o2 = coeff_o2 / pgcd in
    let simplified_co2 = (2*n) / pgcd in
    let simplified_h2o = (2*(n+1)) / pgcd in
    
    Printf.printf "  Expected (simplified): %sC%dH%d + %d O2 -> %s%s\n"
      (if simplified_alk = 1 then "" else string_of_int simplified_alk ^ " x ")
      n (2*n+2) simplified_o2 
      (if simplified_co2 = 1 then "CO2 + " else string_of_int simplified_co2 ^ " CO2 + ")
      (if simplified_h2o = 1 then "H2O" else string_of_int simplified_h2o ^ " H2O")
  in
  
  verify_combustion "Methane" (new Alkane.methane);
  verify_combustion "Ethane" (new Alkane.ethane);
  verify_combustion "Propane" (new Alkane.propane);
  verify_combustion "Butane" (new Alkane.butane);
  print_endline "";
  
  (* Test 6: Multiple alkanes *)
  print_endline "Test 6: Multiple alkanes combustion";
  let methane2 = new Alkane.methane in
  let ethane2 = new Alkane.ethane in
  let comb_multi = new Alkane_combustion.alkane_combustion [methane2; ethane2] in
  let balanced_multi = comb_multi#balance in
  print_endline ("Multiple: " ^ balanced_multi#to_string);
  print_endline "";
  
  (* Test 7: Test exception avec liste vide *)
  print_endline "Test 7: Empty list exception";
  (try
    let _ = new Alkane_combustion.alkane_combustion [] in
    print_endline "ERROR: Should have raised exception for empty list"
  with Failure msg ->
    print_endline ("Correctly raised exception: " ^ msg));
  print_endline "";
  
  (* Test 8: Display reactants and products *)
  print_endline "Test 8: Detailed reactants and products";
  let pentane = new Alkane.pentane in
  let comb_pentane = new Alkane_combustion.alkane_combustion [pentane] in
  let balanced_pentane = comb_pentane#balance in
  
  print_endline "Pentane combustion:";
  print_endline "Reactants:";
  List.iter (fun (mol, coeff) ->
    Printf.printf "  %d x %s\n" coeff mol#to_string
  ) balanced_pentane#get_start;
  
  print_endline "Products:";
  List.iter (fun (mol, coeff) ->
    Printf.printf "  %d x %s\n" coeff mol#to_string
  ) balanced_pentane#get_result;
  print_endline "";

  (* Test de validation des coefficients *)
  print_endline "Test: Verify all reactions balanced";
  let verify_balanced name alk =
    let comb = new Alkane_combustion.alkane_combustion [alk] in
    assert (comb#is_balanced = true);
    Printf.printf "%s: - Balanced\n" name
  in
  verify_balanced "Methane" (new Alkane.methane);
  verify_balanced "Ethane" (new Alkane.ethane);
  verify_balanced "Propane" (new Alkane.propane);
  verify_balanced "Butane" (new Alkane.butane);
  verify_balanced "Pentane" (new Alkane.pentane);
  verify_balanced "Hexane" (new Alkane.hexane);
  verify_balanced "Heptane" (new Alkane.heptane);
  verify_balanced "Octane" (new Alkane.octane);
  verify_balanced "Nonane" (new Alkane.nonane);
  verify_balanced "Decane" (new Alkane.decane);
  verify_balanced "Undecane" (new Alkane.undecane);
  verify_balanced "Dodecane" (new Alkane.dodecane);


  (* Test de duplication d'alcanes *)
  print_endline "Test: Multiple same alkanes";
  let double_dodecane = new Alkane_combustion.alkane_combustion 
    [new Alkane.dodecane; new Alkane.dodecane] in
  print_endline ("Double dodecane: " ^ double_dodecane#to_string);

  (* Test avec liste longue *)
  print_endline "Test: Many different alkanes";
  let many = new Alkane_combustion.alkane_combustion [
    new Alkane.methane;
    new Alkane.ethane;
    new Alkane.propane;
    new Alkane.butane
  ] in
  print_endline ("Complex: " ^ many#to_string);

  
  print_endline "=== All tests completed ===";
  print_endline ""
