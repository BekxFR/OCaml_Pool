(* Main - Exercise 04
 * Tests for alkane combustion
 *)

let () =
  print_endline "===Ex04: Testing Alkane Combustion ===";
  print_endline "";
  
  (* Test 1: Combustion simple - methane *)
  print_endline "--- Test 1: Methane combustion ---";
  let methane = Alkane.methane () in
  let comb_methane = new Alkane_combustion.alkane_combustion [methane] in
  print_endline "Created methane combustion";
  print_endline ("Is balanced initially: " ^ string_of_bool comb_methane#is_balanced);
  
  (* Tenter d'obtenir start avant balance - devrait échouer *)
  (try
    let _ = comb_methane#get_start in
    print_endline "ERROR: Should have raised UnbalancedReaction"
  with Reaction.UnbalancedReaction ->
    print_endline "Correctly raised UnbalancedReaction before balance");
  
  (* Équilibrer *)
  comb_methane#balance;
  print_endline ("Is balanced after balance: " ^ string_of_bool comb_methane#is_balanced);
  print_endline ("Reaction: " ^ comb_methane#to_string);
  print_endline "";
  
  (* Test 2: Combustion - ethane *)
  print_endline "--- Test 2: Ethane combustion ---";
  let ethane = Alkane.ethane () in
  let comb_ethane = new Alkane_combustion.alkane_combustion [ethane] in
  comb_ethane#balance;
  print_endline ("Ethane: " ^ comb_ethane#to_string);
  print_endline "";
  
  (* Test 3: Combustion - propane *)
  print_endline "--- Test 3: Propane combustion ---";
  let propane = Alkane.propane () in
  let comb_propane = new Alkane_combustion.alkane_combustion [propane] in
  comb_propane#balance;
  print_endline ("Propane: " ^ comb_propane#to_string);
  print_endline "";
  
  (* Test 4: Combustion - octane *)
  print_endline "--- Test 4: Octane combustion ---";
  let octane = Alkane.octane () in
  let comb_octane = new Alkane_combustion.alkane_combustion [octane] in
  comb_octane#balance;
  print_endline ("Octane: " ^ comb_octane#to_string);
  print_endline "";
  
  (* Test 5: Vérifier les coefficients *)
  print_endline "--- Test 5: Verify coefficients ---";
  let verify_combustion name alk =
    let comb = new Alkane_combustion.alkane_combustion [alk] in
    comb#balance;
    let n = alk#carbon_count in
    Printf.printf "%s (n=%d): %s\n" name n comb#to_string;
    
    (* Vérifier avec la formule: 2 CnH(2n+2) + (2n+3) O2 -> 2n CO2 + 2(n+1) H2O *)
    Printf.printf "  Expected: 2 x C%dH%d + %d O2 -> %d CO2 + %d H2O\n"
      n (2*n+2) (2*n+3) (2*n) (2*(n+1))
  in
  
  verify_combustion "Methane" (Alkane.methane ());
  verify_combustion "Ethane" (Alkane.ethane ());
  verify_combustion "Propane" (Alkane.propane ());
  verify_combustion "Butane" (Alkane.butane ());
  print_endline "";
  
  (* Test 6: Multiple alkanes *)
  print_endline "--- Test 6: Multiple alkanes combustion ---";
  let methane2 = Alkane.methane () in
  let ethane2 = Alkane.ethane () in
  let comb_multi = new Alkane_combustion.alkane_combustion [methane2; ethane2] in
  comb_multi#balance;
  print_endline ("Multiple: " ^ comb_multi#to_string);
  print_endline "";
  
  (* Test 7: Test exception avec liste vide *)
  print_endline "--- Test 7: Empty list exception ---";
  (try
    let _ = new Alkane_combustion.alkane_combustion [] in
    print_endline "ERROR: Should have raised exception for empty list"
  with Failure msg ->
    print_endline ("Correctly raised exception: " ^ msg));
  print_endline "";
  
  (* Test 8: Display reactants and products *)
  print_endline "--- Test 8: Detailed reactants and products ---";
  let pentane = Alkane.pentane () in
  let comb_pentane = new Alkane_combustion.alkane_combustion [pentane] in
  comb_pentane#balance;
  
  print_endline "Pentane combustion:";
  print_endline "Reactants:";
  List.iter (fun (mol, coeff) ->
    Printf.printf "  %d x %s\n" coeff mol#to_string
  ) comb_pentane#get_start;
  
  print_endline "Products:";
  List.iter (fun (mol, coeff) ->
    Printf.printf "  %d x %s\n" coeff mol#to_string
  ) comb_pentane#get_result;
  print_endline "";
  
  print_endline "=== All tests completed ===";
  print_endline ""
