let () =
  print_endline "╔════════════════════════════════════════════════════════════════╗";
  print_endline "║       Ex01: Testing class doctor - The Name of the Doctor!     ║";
  print_endline "╚════════════════════════════════════════════════════════════════╝";
  print_endline "";
  
  (* Test 1: Création d'un sidekick (people) *)
  print_endline "--- Test 1: Creating a sidekick (Rose Tyler) ---";
  let rose = new People.people "Rose Tyler" in
  print_endline "";
  
  (* Test 2: Création du Doctor avec initializer *)
  print_endline "--- Test 2: Creating the Doctor (Tenth Doctor) ---";
  let tenth_doctor = new Doctor.doctor "The Tenth Doctor" 903 rose in
  print_endline "";
  
  (* Test 3: Méthode to_string *)
  print_endline "--- Test 3: Method to_string ---";
  print_endline ("Doctor info: " ^ tenth_doctor#to_string);
  print_endline "";
  
  (* Test 4: Méthode talk *)
  print_endline "--- Test 4: Method talk ---";
  tenth_doctor#talk;
  (* tenth_doctor#make_nap; *)
  print_endline "";
  
  (* Test 5: Méthode use_sonic_screwdriver *)
  print_endline "--- Test 5: Method use_sonic_screwdriver ---";
  print_endline "Using the sonic screwdriver:";
  tenth_doctor#use_sonic_screwdriver;
  print_endline "";
  
  (* Test 6: Méthode travel_in_time - voyage dans le futur *)
  print_endline "--- Test 6: Method travel_in_time (forward) ---";
  print_endline "Traveling from 2005 to 2010:";
  tenth_doctor#travel_in_time 2005 2010;
  print_endline ("After time travel: " ^ tenth_doctor#to_string);
  print_endline "";
  
  (* Test 7: Méthode travel_in_time - voyage dans le passé *)
  print_endline "--- Test 7: Method travel_in_time (backward) ---";
  print_endline "Traveling from 2010 to 1963 (back to the beginning!):";
  tenth_doctor#travel_in_time 2010 1963;
  print_endline ("After time travel: " ^ tenth_doctor#to_string);
  print_endline "";
  
  (* Test 8: Création d'un autre Doctor avec un autre sidekick *)
  print_endline "--- Test 8: Creating another Doctor (Eleventh Doctor) ---";
  let amy = new People.people "Amy Pond" in
  print_endline "";
  let eleventh_doctor = new Doctor.doctor "The Eleventh Doctor" 907 amy in
  print_endline "";
  
  (* Test 9: Comparaison des deux Doctors *)
  print_endline "--- Test 9: Comparing two Doctors ---";
  print_endline ("Tenth: " ^ tenth_doctor#to_string);
  print_endline ("Eleventh: " ^ eleventh_doctor#to_string);
  print_endline "";
  
  (* Test 10: Les deux Doctors utilisent leurs sonic screwdrivers *)
  print_endline "--- Test 10: Both Doctors using sonic screwdrivers ---";
  print_endline "Tenth Doctor:";
  tenth_doctor#use_sonic_screwdriver;
  print_endline "Eleventh Doctor:";
  eleventh_doctor#use_sonic_screwdriver;
  print_endline "";
  
  (* Test 11: Les deux Doctors parlent *)
  print_endline "--- Test 11: Both Doctors talking ---";
  print_endline "Tenth Doctor:";
  tenth_doctor#talk;
  print_endline "Eleventh Doctor:";
  eleventh_doctor#talk;
  print_endline "";
  
  (* Test 12: Voyage temporel complexe *)
  print_endline "--- Test 12: Complex time travel ---";
  print_endline "Eleventh Doctor travels from 2010 to 2013:";
  eleventh_doctor#travel_in_time 2010 2013;
  print_endline ("After travel: " ^ eleventh_doctor#to_string);
  print_endline "";
  
  (* Test 13: Vérification que les sidekicks sont indépendants *)
  print_endline "--- Test 13: Sidekicks are independent ---";
  print_endline "Rose (Tenth's sidekick):";
  rose#talk;
  print_endline "Amy (Eleventh's sidekick):";
  amy#talk;
  print_endline "";
  
  print_endline "╔════════════════════════════════════════════════════════════════╗";
  print_endline "║          All tests completed successfully! Geronimo!           ║";
  print_endline "╚════════════════════════════════════════════════════════════════╝";
  print_endline ""
