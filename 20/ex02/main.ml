(* Main - Exercise 02
 * Simulation de bataille entre Doctor, Dalek et humains
 *)

(* Initialiser le générateur aléatoire *)
let () = Random.self_init ()

let print_separator () =
  print_endline "";
  print_endline "═══════════════════════════════════════════════════════════════";
  print_endline ""

let () =
  print_endline "╔═══════════════════════════════════════════════════════════════╗";
  print_endline "║      Ex02: You are a good Daaaaaalek! - BATTLE SIMULATION     ║";
  print_endline "╚═══════════════════════════════════════════════════════════════╝";
  print_endline "";
  
  (* Test 1: Création des personnages *)
  print_endline "--- Test 1: Creating Characters ---";
  print_endline "";
  
  (* Créer un humain (Rose Tyler) *)
  print_endline "Creating a human:";
  let rose = new People.people "Rose Tyler" in
  print_endline "";
  
  (* Créer le Doctor *)
  print_endline "Creating the Doctor:";
  let clara = new People.people "Clara Oswald" in
  let doctor = new Doctor.doctor "The Eleventh Doctor" 907 clara in
  print_endline "";
  
  (* Créer un Dalek *)
  print_endline "Creating a Dalek:";
  let dalek = new Dalek.dalek in
  print_endline "";
  
  print_separator ();
  
  (* Test 2: to_string de tous les personnages *)
  print_endline "--- Test 2: Character Information ---";
  print_endline ("Human: " ^ rose#to_string);
  print_endline ("Doctor: " ^ doctor#to_string);
  print_endline ("Dalek: " ^ dalek#to_string);
  print_endline "";
  
  print_separator ();
  
  (* Test 3: Tout le monde parle *)
  print_endline "--- Test 3: Everyone Talks ---";
  print_endline "Rose speaks:";
  rose#talk;
  print_endline "";
  
  print_endline "Doctor speaks:";
  doctor#talk;
  print_endline "";
  
  print_endline "Dalek speaks (random phrase):";
  dalek#talk;
  print_endline "";
  
  print_endline "Dalek speaks again (another random phrase):";
  dalek#talk;
  print_endline "";
  
  print_endline "Dalek speaks once more:";
  dalek#talk;
  print_endline "";
  
  print_separator ();
  
  (* Test 4: Le Doctor utilise son sonic screwdriver *)
  print_endline "--- Test 4: Doctor Uses Sonic Screwdriver ---";
  doctor#use_sonic_screwdriver;
  print_endline "";
  
  print_separator ();
  
  (* Test 5: Le Dalek extermine un humain innocent *)
  print_endline "--- Test 5: Dalek Exterminates a Human ---";
  print_endline ("Shield status before: " ^ 
                 (if dalek#get_shield then "ACTIVE" else "INACTIVE"));
  
  (* Créer un humain sacrificiel *)
  let victim = new People.people "Random Human" in
  print_endline "";
  
  (* Le Dalek extermine la victime *)
  dalek#exterminate victim;
  
  print_endline ("Shield status after: " ^ 
                 (if dalek#get_shield then "ACTIVE" else "INACTIVE"));
  print_endline "";
  
  print_separator ();
  
  (* Test 6: Le Dalek extermine encore (change le shield) *)
  print_endline "--- Test 6: Dalek Exterminates Again (Shield Changes) ---";
  print_endline ("Shield status before: " ^ 
                 (if dalek#get_shield then "ACTIVE" else "INACTIVE"));
  
  let victim2 = new People.people "Another Human" in
  print_endline "";
  
  dalek#exterminate victim2;
  
  print_endline ("Shield status after: " ^ 
                 (if dalek#get_shield then "ACTIVE" else "INACTIVE"));
  print_endline "";
  
  print_separator ();
  
  (* Test 7: BATAILLE FINALE *)
  print_endline "--- Test 7: EPIC BATTLE - Doctor vs Dalek ---";
  print_endline "";
  print_endline "╔═══════════════════════════════════════════════════════════════╗";
  print_endline "║                    THE BATTLE BEGINS!                         ║";
  print_endline "╚═══════════════════════════════════════════════════════════════╝";
  print_endline "";
  
  print_endline ("Initial state:");
  print_endline ("  " ^ doctor#to_string);
  print_endline ("  " ^ dalek#to_string);
  print_endline "";
  
  print_endline "Round 1: Dalek attacks!";
  dalek#talk;
  let thirty_damage = 30 in
  doctor#set_hp (doctor#get_hp - thirty_damage);
  print_endline ("Dalek deals " ^ string_of_int thirty_damage ^ " damage!");
  print_endline ("  " ^ doctor#to_string);
  print_endline "";
  
  print_endline "Round 2: Doctor counterattacks!";
  let damage_to_dalek = doctor#sonic_attack in
  dalek#set_hp (dalek#get_hp - damage_to_dalek);
  print_endline ("Doctor deals " ^ string_of_int damage_to_dalek ^ " damage!");
  print_endline ("  " ^ dalek#to_string);
  print_endline "";
  
  print_endline "Round 3: Dalek attacks again!";
  dalek#talk;
  let forty_damage = 40 in
  doctor#set_hp (doctor#get_hp - forty_damage);
  print_endline ("Dalek deals " ^ string_of_int forty_damage ^ " damage!");
  print_endline ("  " ^ doctor#to_string);
  print_endline "";
  
  print_endline "Round 4: Doctor uses strategy!";
  doctor#talk;
  dalek#set_hp (dalek#get_hp - damage_to_dalek);
  print_endline ("Doctor deals " ^ string_of_int damage_to_dalek ^ " damage!");
  print_endline ("  " ^ dalek#to_string);
  print_endline "";
  
  print_separator ();
  
  (* Test 8: Multiple Daleks *)
  print_endline "--- Test 8: Multiple Daleks (Random Names) ---";
  let dalek2 = new Dalek.dalek in
  let dalek3 = new Dalek.dalek in
  let dalek4 = new Dalek.dalek in
  print_endline "";
  print_endline "All Daleks speak:";
  dalek#talk;
  dalek2#talk;
  dalek3#talk;
  dalek4#talk;
  print_endline "";
  
  print_separator ();
  
  (* Test 9: Le Dalek meurt *)
  print_endline "--- Test 9: Dalek Dies ---";
  print_endline "Doctor delivers final blow!";
  dalek#set_hp 0;
  print_endline ("Final state: " ^ dalek#to_string);
  dalek#die;
  print_endline "";
  
  print_separator ();
  
  print_endline "╔═══════════════════════════════════════════════════════════════╗";
  print_endline "║           All tests completed! The Doctor wins!               ║";
  print_endline "╚═══════════════════════════════════════════════════════════════╝";
  print_endline ""
