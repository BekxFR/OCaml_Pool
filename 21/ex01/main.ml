(* Main - Exercise 01
 * Tests for molecule classes
 *)

let () =
  print_endline "=== Ex01: Testing Molecules ===";
  print_endline "";
  
  (* Test 1: Create molecules *)
  print_endline "Test 1: Creating molecules";
  let water = new Molecule.water in
  let co2 = new Molecule.carbon_dioxide in
  let methane = new Molecule.methane in
  let h2so4 = new Molecule.sulfuric_acid in
  let nh3 = new Molecule.ammonia in
  print_endline "Molecules created successfully";
  print_endline "";
  
  (* Test 2: to_string *)
  print_endline "Test 2: Molecule descriptions";
  print_endline water#to_string;
  print_endline co2#to_string;
  print_endline methane#to_string;
  print_endline h2so4#to_string;
  print_endline nh3#to_string;
  print_endline "";
  
  (* Test 3: Individual properties *)
  print_endline "Test 3: Individual properties";
  print_endline ("Water - Name: " ^ water#name ^ ", Formula: " ^ water#formula);
  print_endline ("CO2 - Name: " ^ co2#name ^ ", Formula: " ^ co2#formula);
  print_endline ("Methane - Name: " ^ methane#name ^ ", Formula: " ^ methane#formula);
  print_endline "";
  
  (* Test 4: Hill notation verification *)
  print_endline "Test 4: Hill notation verification";
  print_endline ("Water formula (should be H2O): " ^ water#formula);
  print_endline ("CO2 formula (should be CO2): " ^ co2#formula);
  print_endline ("Methane formula (should be CH4): " ^ methane#formula);
  print_endline ("Sulfuric acid formula (should be H2O4S): " ^ h2so4#formula);
  print_endline ("Ammonia formula (should be H3N): " ^ nh3#formula);
  print_endline "";
  
  (* Test 5: equals method *)
  print_endline "Test 5: Testing equals";
  let water2 = new Molecule.water in
  print_endline ("water equals water2: " ^ string_of_bool (water#equals water2));
  print_endline ("water equals co2: " ^ string_of_bool (water#equals co2));
  print_endline ("methane equals nh3: " ^ string_of_bool (methane#equals nh3));
  print_endline "";
  
  (* Test 6: Polymorphism - list of molecules *)
  (* Operateur :> Coercion de types (Upcasting - convertit classe fille vers classe parente) *)
  print_endline "Test 6: List of different molecules";
  let molecules : Molecule.molecule list = [
    (water :> Molecule.molecule);
    (co2 :> Molecule.molecule);
    (methane :> Molecule.molecule);
    (h2so4 :> Molecule.molecule);
    (nh3 :> Molecule.molecule)
  ] in
  List.iter (fun mol -> print_endline ("  " ^ mol#to_string)) molecules;
  print_endline "";
  
  print_endline "=== All tests completed ===";
  print_endline ""
