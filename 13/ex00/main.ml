let () =
  (* Test 1: Création et initializer *)
  print_endline "--- Test 1: Creating Rose Tyler ---";
  let rose = new People.people "Rose Tyler" in
  print_endline "";
  
  (* Test 2: Méthode to_string *)
  print_endline "--- Test 2: Method to_string ---";
  print_endline ("rose#to_string: " ^ rose#to_string);
  print_endline "";
  
  (* Test 3: Méthode talk *)
  print_endline "--- Test 3: Method talk ---";
  rose#talk;
  print_endline "";
  
  (* Test 4: Méthode die *)
  print_endline "--- Test 4: Method die ---";
  rose#die;
  print_endline "";
  
  (* Test 5: Multiples instances *)
  print_endline "--- Test 5: Multiple instances ---";
  let amy = new People.people "Amy Pond" in
  let clara = new People.people "Clara Oswald" in
  let river = new People.people "River Song" in
  print_endline "";
  
  (* Test 6: to_string pour chaque instance *)
  print_endline "--- Test 6: to_string for all instances ---";
  print_endline ("Amy: " ^ amy#to_string);
  print_endline ("Clara: " ^ clara#to_string);
  print_endline ("River: " ^ river#to_string);
  print_endline "";
  
  (* Test 7: talk pour chaque instance *)
  print_endline "--- Test 7: talk for all instances ---";
  amy#talk;
  clara#talk;
  river#talk;
  print_endline "";
  
  (* Test 8: die *)
  print_endline "--- Test 8: die method ---";
  print_endline "Amy dies:";
  amy#die;
  print_endline "";
  
  (* Test 9: Indépendance des instances *)
  print_endline "--- Test 9: Instance independence ---";
  print_endline "Rose is still alive:";
  print_endline (rose#to_string);
  rose#talk;
  print_endline "";
  
  print_endline "Wibbly wobbly timey wimey!"
