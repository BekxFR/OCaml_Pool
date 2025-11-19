(* Main - Exercise 00
 * Tests for atom classes
 *)

let () =
  print_endline "===Ex00: Testing Atoms ===";
  print_endline "";
  
  (* Test 1: Create atoms *)
  print_endline "--- Test 1: Creating atoms ---";
  let h = new Atom.hydrogen in
  let c = new Atom.carbon in
  let o = new Atom.oxygen in
  let n = new Atom.nitrogen in
  let s = new Atom.sulfur in
  let cl = new Atom.chlorine in
  print_endline "";
  
  (* Test 2: to_string *)
  print_endline "--- Test 2: Atom descriptions ---";
  print_endline h#to_string;
  print_endline c#to_string;
  print_endline o#to_string;
  print_endline n#to_string;
  print_endline s#to_string;
  print_endline cl#to_string;
  print_endline "";
  
  (* Test 3: Individual properties *)
  print_endline "--- Test 3: Individual properties ---";
  print_endline ("Hydrogen - Name: " ^ h#name ^ ", Symbol: " ^ h#symbol ^ 
                 ", Z: " ^ string_of_int h#atomic_number);
  print_endline ("Carbon - Name: " ^ c#name ^ ", Symbol: " ^ c#symbol ^ 
                 ", Z: " ^ string_of_int c#atomic_number);
  print_endline "";
  
  (* Test 4: equals method *)
  print_endline "--- Test 4: Testing equals ---";
  let h2 = new Atom.hydrogen in
  print_endline ("h equals h2: " ^ string_of_bool (h#equals h2));
  print_endline ("h equals c: " ^ string_of_bool (h#equals c));
  print_endline ("c equals o: " ^ string_of_bool (c#equals o));
  print_endline "";
  
  (* Test 5: Polymorphism - list of atoms *)
  print_endline "--- Test 5: List of different atoms ---";
  let atoms : Atom.atom list = [
    (h :> Atom.atom);
    (c :> Atom.atom);
    (o :> Atom.atom);
    (n :> Atom.atom);
    (s :> Atom.atom);
    (cl :> Atom.atom)
  ] in
  List.iter (fun atom -> print_endline ("  " ^ atom#to_string)) atoms;
  print_endline "";
  
  print_endline "=== All tests completed ===";
  print_endline ""
