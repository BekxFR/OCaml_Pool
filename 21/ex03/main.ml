(* Main - Exercise 03
 * Tests for reaction classes
 *)

let () =
  print_endline "===Ex03: Testing Reactions ===";
  print_endline "";
  
  (* Test 1: Create reactions *)
  print_endline "Test 1: Creating reactions";
  let methane_comb = new Reaction.methane_combustion in
  let water_synth = new Reaction.water_synthesis in
  print_endline "Reactions created successfully";
  print_endline "";
  
  (* Test 2: Display reactions *)
  print_endline "Test 2: Displaying reactions";
  print_endline ("Methane combustion: " ^ methane_comb#to_string);
  print_endline ("Water synthesis: " ^ water_synth#to_string);
  print_endline "";
  
  (* Test 3: Get start molecules *)
  print_endline "Test 3: Start molecules (reactants)";
  let start_methane = methane_comb#get_start in
  print_endline "Methane combustion reactants:";
  List.iter (fun (mol, coeff) ->
    Printf.printf "  %d x %s\n" coeff mol#to_string
  ) start_methane;
  print_endline "";
  
  (* Test 4: Get result molecules *)
  print_endline "Test 4: Result molecules (products)";
  let result_methane = methane_comb#get_result in
  print_endline "Methane combustion products:";
  List.iter (fun (mol, coeff) ->
    Printf.printf "  %d x %s\n" coeff mol#to_string
  ) result_methane;
  print_endline "";
  
  (* Test 5: Check if balanced *)
  print_endline "Test 5: Checking if reactions are balanced";
  print_endline ("Methane combustion balanced: " ^ 
    string_of_bool methane_comb#is_balanced);
  print_endline ("Water synthesis balanced: " ^ 
    string_of_bool water_synth#is_balanced);
  print_endline "";
  
  (* Test 6: Balance method *)
  print_endline "Test 6: Calling balance method";
  let _ = methane_comb#balance in
  let _ = water_synth#balance in
  print_endline "Balance methods called successfully";
  print_endline "";
  
  (* Test 7: Create an unbalanced reaction manually *)
  print_endline "Test 7: Testing unbalanced reaction";
  let unbalanced_reaction =
    object (self)
      inherit Reaction.reaction
      
      val start = [
        ((new Alkane.methane :> Molecule.molecule), 1)
      ]
      
      val result = [
        ((new Molecule.water :> Molecule.molecule), 1)
      ]
      
      method get_start = start
      method get_result = result
      method balance : Reaction.reaction = (self :> Reaction.reaction)
    end
  in
  print_endline ("Unbalanced reaction: " ^ unbalanced_reaction#to_string);
  print_endline ("Is balanced: " ^ string_of_bool unbalanced_reaction#is_balanced);
  print_endline "";
  
  (* Test 8: Polymorphism - list of reactions *)
  print_endline "Test 8: List of reactions";
  let reactions : Reaction.reaction list = [
    (methane_comb :> Reaction.reaction);
    (water_synth :> Reaction.reaction)
  ] in
  List.iter (fun reaction -> 
    Printf.printf "  %s (balanced: %b)\n" 
      reaction#to_string 
      reaction#is_balanced
  ) reactions;
  print_endline "";
  
  print_endline "=== All tests completed ===";
  print_endline ""
