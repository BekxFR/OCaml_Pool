(* Main - Exercise 02
 * Tests for alkane classes
 *)

let () =
  print_endline "===Ex02: Testing Alkanes ===";
  print_endline "";
  
  (* Test 1: Create specific alkanes *)
  print_endline "--- Test 1: Creating specific alkanes ---";
  let methane = new Alkane.methane in
  let ethane = new Alkane.ethane in
  let octane = new Alkane.octane in
  let dodecane = new Alkane.dodecane in
  print_endline "Alkanes created successfully";
  print_endline "";
  
  (* Test 2: to_string *)
  print_endline "--- Test 2: Alkane descriptions ---";
  print_endline methane#to_string;
  print_endline ethane#to_string;
  print_endline octane#to_string;
  print_endline dodecane#to_string;
  print_endline "";
  
  (* Test 3: Verify formulas *)
  print_endline "--- Test 3: Formula verification (CnH2n+2) ---";
  print_endline ("Methane (C1H4): " ^ methane#formula);
  print_endline ("Ethane (C2H6): " ^ ethane#formula);
  print_endline ("Octane (C8H18): " ^ octane#formula);
  print_endline ("Dodecane (C12H26): " ^ dodecane#formula);
  print_endline "";
  
  (* Test 4: Create all alkanes from n=1 to n=12 *)
  print_endline "--- Test 4: All alkanes (n=1 to 12) ---";
  for i = 1 to 12 do
    let alk = new Alkane.alkane i in
    Printf.printf "n=%2d: %s\n" i alk#to_string
  done;
  print_endline "";
  
  (* Test 5: Test bounds *)
  print_endline "--- Test 5: Testing bounds ---";
  (try
    let _ = new Alkane.alkane 0 in
    print_endline "ERROR: n=0 should fail"
  with Failure msg ->
    print_endline ("n=0 correctly rejected: " ^ msg));
  
  (try
    let _ = new Alkane.alkane 13 in
    print_endline "ERROR: n=13 should fail"
  with Failure msg ->
    print_endline ("n=13 correctly rejected: " ^ msg));
  print_endline "";
  
  (* Test 6: Polymorphism with molecules *)
  print_endline "--- Test 6: Alkanes as molecules ---";
  let propane = new Alkane.propane in
  let butane = new Alkane.butane in
  let molecules : Molecule.molecule list = [
    (propane :> Molecule.molecule);
    (butane :> Molecule.molecule);
    (octane :> Molecule.molecule)
  ] in
  List.iter (fun mol -> print_endline ("  " ^ mol#to_string)) molecules;
  print_endline "";
  
  (* Test 7: Equals *)
  print_endline "--- Test 7: Testing equals ---";
  let methane2 = new Alkane.methane in
  print_endline ("methane equals methane2: " ^ 
    string_of_bool (methane#equals (methane2 :> Molecule.molecule)));
  print_endline ("methane equals ethane: " ^ 
    string_of_bool (methane#equals (ethane :> Molecule.molecule)));
  print_endline "";
  
  print_endline "=== All tests completed ===";
  print_endline ""
