(* Main - Day 13 Exercise 03
 * Simulation de construction et destruction d'armées
 *)

(* Initialiser le générateur aléatoire pour les Daleks *)
let () = Random.self_init ()

let print_separator () =
  print_endline "";
  print_endline "═══════════════════════════════════════════════════════════════";
  print_endline ""

let () =
  print_endline "╔═══════════════════════════════════════════════════════════════╗";
  print_endline "║     Day 13 Ex03: The Day of The Doctor! - Army Management     ║";
  print_endline "╚═══════════════════════════════════════════════════════════════╝";
  print_endline "";
  
  (* ========== TEST 1: ARMÉE DE PEOPLE ========== *)
  print_endline "╔══════════════════════════════════════════════════════════════╗";
  print_endline "║              TEST 1: ARMY OF HUMANS (PEOPLE)                 ║";
  print_endline "╚══════════════════════════════════════════════════════════════╝";
  print_endline "";
  
  print_endline "--- Creating an army of humans ---";
  let human_army = new Army.army in
  print_endline ("Army size: " ^ string_of_int human_army#size);
  print_endline "";
  
  print_endline "--- Adding humans to the army (front) ---";
  let rose = new People.people "Rose Tyler" in
  human_army#add rose;
  print_endline ("Army size: " ^ string_of_int human_army#size);
  print_endline "";
  
  let martha = new People.people "Martha Jones" in
  human_army#add martha;
  print_endline ("Army size: " ^ string_of_int human_army#size);
  print_endline "";
  
  let donna = new People.people "Donna Noble" in
  human_army#add donna;
  print_endline ("Army size: " ^ string_of_int human_army#size);
  print_endline "";
  
  print_endline "--- Adding a human to the back ---";
  let amy = new People.people "Amy Pond" in
  human_army#add_back amy;
  print_endline ("Army size: " ^ string_of_int human_army#size);
  print_endline "";
  
  print_endline "--- All humans in the army talk ---";
  let rec make_people_talk people_list =
    match people_list with
    | [] -> ()
    | person :: rest ->
        person#talk;
        make_people_talk rest
  in
  make_people_talk human_army#get_members;
  print_endline "";
  
  print_endline "--- Removing humans from the army (front) ---";
  human_army#delete;
  print_endline ("Army size: " ^ string_of_int human_army#size);
  print_endline "";
  
  human_army#delete;
  print_endline ("Army size: " ^ string_of_int human_army#size);
  print_endline "";
  
  print_endline "--- Removing a human from the back ---";
  human_army#delete_back;
  print_endline ("Army size: " ^ string_of_int human_army#size);
  print_endline "";
  
  print_endline "--- Final deletion ---";
  human_army#delete;
  print_endline ("Army size: " ^ string_of_int human_army#size);
  print_endline ("Army is empty: " ^ string_of_bool human_army#is_empty);
  print_endline "";
  
  print_endline "--- Trying to delete from empty army ---";
  human_army#delete;
  print_endline "";
  
  print_separator ();
  
  (* ========== TEST 2: ARMÉE DE DOCTORS ========== *)
  print_endline "╔══════════════════════════════════════════════════════════════╗";
  print_endline "║              TEST 2: ARMY OF TIME LORDS (DOCTORS)            ║";
  print_endline "╚══════════════════════════════════════════════════════════════╝";
  print_endline "";
  
  print_endline "--- Creating an army of Doctors ---";
  let doctor_army = new Army.army in
  print_endline ("Army size: " ^ string_of_int doctor_army#size);
  print_endline "";
  
  print_endline "--- Creating sidekicks first ---";
  let sidekick1 = new People.people "Clara Oswald" in
  let sidekick2 = new People.people "River Song" in
  let sidekick3 = new People.people "Sarah Jane" in
  print_endline "";
  
  print_endline "--- Adding Doctors to the army ---";
  let ninth = new Doctor.doctor "The Ninth Doctor" 900 sidekick1 in
  doctor_army#add ninth;
  print_endline ("Army size: " ^ string_of_int doctor_army#size);
  print_endline "";
  
  let tenth = new Doctor.doctor "The Tenth Doctor" 903 sidekick2 in
  doctor_army#add tenth;
  print_endline ("Army size: " ^ string_of_int doctor_army#size);
  print_endline "";
  
  let eleventh = new Doctor.doctor "The Eleventh Doctor" 907 sidekick3 in
  doctor_army#add_back eleventh;
  print_endline ("Army size: " ^ string_of_int doctor_army#size);
  print_endline "";
  
  print_endline "--- All Doctors talk ---";
  let rec make_doctors_talk doctors_list =
    match doctors_list with
    | [] -> ()
    | doctor :: rest ->
        doctor#talk;
        make_doctors_talk rest
  in
  make_doctors_talk doctor_army#get_members;
  print_endline "";
  
  print_endline "--- Removing Doctors from the army ---";
  doctor_army#delete;
  print_endline ("Army size: " ^ string_of_int doctor_army#size);
  print_endline "";
  
  doctor_army#delete_back;
  print_endline ("Army size: " ^ string_of_int doctor_army#size);
  print_endline "";
  
  doctor_army#delete;
  print_endline ("Army size: " ^ string_of_int doctor_army#size);
  print_endline ("Army is empty: " ^ string_of_bool doctor_army#is_empty);
  print_endline "";
  
  print_separator ();
  
  (* ========== TEST 3: ARMÉE DE DALEKS ========== *)
  print_endline "╔══════════════════════════════════════════════════════════════╗";
  print_endline "║                 TEST 3: DALEK ARMY                           ║";
  print_endline "╚══════════════════════════════════════════════════════════════╝";
  print_endline "";
  
  print_endline "--- Creating a Dalek army ---";
  let dalek_army = new Army.army in
  print_endline ("Army size: " ^ string_of_int dalek_army#size);
  print_endline "";
  
  print_endline "--- Adding Daleks to the army ---";
  let dalek1 = new Dalek.dalek in
  dalek_army#add dalek1;
  print_endline ("Army size: " ^ string_of_int dalek_army#size);
  print_endline "";
  
  let dalek2 = new Dalek.dalek in
  dalek_army#add dalek2;
  print_endline ("Army size: " ^ string_of_int dalek_army#size);
  print_endline "";
  
  let dalek3 = new Dalek.dalek in
  dalek_army#add dalek3;
  print_endline ("Army size: " ^ string_of_int dalek_army#size);
  print_endline "";
  
  let dalek4 = new Dalek.dalek in
  dalek_army#add_back dalek4;
  print_endline ("Army size: " ^ string_of_int dalek_army#size);
  print_endline "";
  
  let dalek5 = new Dalek.dalek in
  dalek_army#add_back dalek5;
  print_endline ("Army size: " ^ string_of_int dalek_army#size);
  print_endline "";
  
  print_endline "--- All Daleks talk (random phrases) ---";
  let rec make_daleks_talk daleks_list =
    match daleks_list with
    | [] -> ()
    | dalek :: rest ->
        dalek#talk;
        make_daleks_talk rest
  in
  make_daleks_talk dalek_army#get_members;
  print_endline "";
  
  print_endline "--- Destroying the Dalek army ---";
  print_endline "Removing from front:";
  dalek_army#delete;
  print_endline ("Army size: " ^ string_of_int dalek_army#size);
  print_endline "";
  
  dalek_army#delete;
  print_endline ("Army size: " ^ string_of_int dalek_army#size);
  print_endline "";
  
  print_endline "Removing from back:";
  dalek_army#delete_back;
  print_endline ("Army size: " ^ string_of_int dalek_army#size);
  print_endline "";
  
  dalek_army#delete_back;
  print_endline ("Army size: " ^ string_of_int dalek_army#size);
  print_endline "";
  
  print_endline "Final deletion:";
  dalek_army#delete;
  print_endline ("Army size: " ^ string_of_int dalek_army#size);
  print_endline ("Army is empty: " ^ string_of_bool dalek_army#is_empty);
  print_endline "";
  
  print_separator ();
  
  (* ========== TEST 4: CONSTRUCTION ET DESTRUCTION MASSIVE ========== *)
  print_endline "╔══════════════════════════════════════════════════════════════╗";
  print_endline "║        TEST 4: MASSIVE CONSTRUCTION AND DESTRUCTION          ║";
  print_endline "╚══════════════════════════════════════════════════════════════╝";
  print_endline "";
  
  print_endline "--- Building a massive human army ---";
  let massive_army = new Army.army in
  
  (* Fonction récursive pour ajouter plusieurs personnes *)
  let rec add_people count =
    if count <= 0 then ()
    else begin
      let person = new People.people ("Soldier" ^ string_of_int count) in
      massive_army#add person;
      add_people (count - 1)
    end
  in
  
  add_people 5;
  print_endline ("Massive army size: " ^ string_of_int massive_army#size);
  print_endline "";
  
  print_endline "--- Destroying the massive army ---";
  let rec destroy_all () =
    if massive_army#is_empty then
      print_endline "  → Army completely destroyed"
    else begin
      massive_army#delete;
      destroy_all ()
    end
  in
  
  destroy_all ();
  print_endline ("Final army size: " ^ string_of_int massive_army#size);
  print_endline "";
  
  print_separator ();
  
  print_endline "╔══════════════════════════════════════════════════════════════╗";
  print_endline "║         All tests completed! The Day is saved!               ║";
  print_endline "╚══════════════════════════════════════════════════════════════╝";
  print_endline ""
