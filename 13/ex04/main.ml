(* Main - Day 13 Exercise 04
 * Simulation de la Time War sur Galifrey
 *)

(* Initialiser le générateur aléatoire *)
let () = Random.self_init ()

let () =
  print_endline "";
  print_endline "╔═══════════════════════════════════════════════════════════════╗";
  print_endline "║                                                               ║";
  print_endline "║              THE TIME WAR - BATTLE FOR GALIFREY               ║";
  print_endline "║                                                               ║";
  print_endline "║           Day 13 Ex04: The Greatest Battle in Time            ║";
  print_endline "║                                                               ║";
  print_endline "╚═══════════════════════════════════════════════════════════════╝";
  print_endline "";
  print_endline "";
  
  (* ========== SCENARIO 1: BALANCED BATTLE ========== *)
  print_endline "╔═══════════════════════════════════════════════════════════════╗";
  print_endline "║                   SCENARIO 1: BALANCED FORCES                 ║";
  print_endline "╚═══════════════════════════════════════════════════════════════╝";
  print_endline "";
  
  (* Créer Galifrey *)
  let galifrey1 = new Galifrey.galifrey in
  print_endline "";
  
  print_endline "--- Recruiting Forces ---";
  print_endline "";
  
  (* Créer les sidekicks pour les Doctors *)
  print_endline "[Creating Companions]";
  let rose = new People.people "Rose Tyler" in
  let martha = new People.people "Martha Jones" in
  let donna = new People.people "Donna Noble" in
  print_endline "";
  
  (* Ajouter les Doctors *)
  print_endline "[Recruiting Time Lords]";
  let ninth = new Doctor.doctor "The Ninth Doctor" 900 rose in
  galifrey1#add_doctor ninth;
  
  let tenth = new Doctor.doctor "The Tenth Doctor" 903 martha in
  galifrey1#add_doctor tenth;
  
  let war_doctor = new Doctor.doctor "The War Doctor" 800 donna in
  galifrey1#add_doctor war_doctor;
  print_endline "";
  
  (* Ajouter des humains *)
  print_endline "[Recruiting Human Soldiers]";
  let human1 = new People.people "Captain Jack" in
  galifrey1#add_people human1;
  
  let human2 = new People.people "Sarah Jane" in
  galifrey1#add_people human2;
  print_endline "";
  
  (* Ajouter les Daleks *)
  print_endline "[Dalek Forces Arriving]";
  let dalek1 = new Dalek.dalek in
  galifrey1#add_dalek dalek1;
  
  let dalek2 = new Dalek.dalek in
  galifrey1#add_dalek dalek2;
  
  let dalek3 = new Dalek.dalek in
  galifrey1#add_dalek dalek3;
  
  let dalek4 = new Dalek.dalek in
  galifrey1#add_dalek dalek4;
  print_endline "";
  
  (* Lancer la Time War *)
  galifrey1#do_time_war;
  
  print_endline "";
  print_endline "═══════════════════════════════════════════════════════════════";
  print_endline "";
  print_endline "";
  
  (* ========== SCENARIO 2: DALEK OVERWHELMING FORCE ========== *)
  print_endline "╔═══════════════════════════════════════════════════════════════╗";
  print_endline "║              SCENARIO 2: DALEK OVERWHELMING FORCE             ║";
  print_endline "╚═══════════════════════════════════════════════════════════════╝";
  print_endline "";
  
  let galifrey2 = new Galifrey.galifrey in
  print_endline "";
  
  print_endline "--- Recruiting Forces ---";
  print_endline "";
  
  (* Un seul Doctor avec son compagnon *)
  print_endline "[Last Hope: Single Time Lord]";
  let amy = new People.people "Amy Pond" in
  let eleventh = new Doctor.doctor "The Eleventh Doctor" 907 amy in
  galifrey2#add_doctor eleventh;
  print_endline "";
  
  (* Un humain *)
  print_endline "[Lone Human Soldier]";
  let rory = new People.people "Rory Williams" in
  galifrey2#add_people rory;
  print_endline "";
  
  (* Horde de Daleks *)
  print_endline "[Massive Dalek Invasion]";
  let rec create_daleks count =
    if count <= 0 then ()
    else begin
      let dalek = new Dalek.dalek in
      galifrey2#add_dalek dalek;
      create_daleks (count - 1)
    end
  in
  create_daleks 8;
  print_endline "";
  
  (* Lancer la Time War *)
  galifrey2#do_time_war;
  
  print_endline "";
  print_endline "═══════════════════════════════════════════════════════════════";
  print_endline "";
  print_endline "";
  
  (* ========== SCENARIO 3: TIME LORD SUPREMACY ========== *)
  print_endline "╔═══════════════════════════════════════════════════════════════╗";
  print_endline "║               SCENARIO 3: TIME LORD SUPREMACY                 ║";
  print_endline "╚═══════════════════════════════════════════════════════════════╝";
  print_endline "";
  
  let galifrey3 = new Galifrey.galifrey in
  print_endline "";
  
  print_endline "--- Recruiting Forces ---";
  print_endline "";
  
  (* Créer plusieurs compagnons *)
  print_endline "[Creating Companions]";
  let clara = new People.people "Clara Oswald" in
  let river = new People.people "River Song" in
  let bill = new People.people "Bill Potts" in
  let nardole = new People.people "Nardole" in
  print_endline "";
  
  (* Armée de Time Lords *)
  print_endline "[Gathering All Time Lords]";
  let first = new Doctor.doctor "The First Doctor" 450 clara in
  galifrey3#add_doctor first;
  
  let fifth = new Doctor.doctor "The Fifth Doctor" 700 river in
  galifrey3#add_doctor fifth;
  
  let seventh = new Doctor.doctor "The Seventh Doctor" 850 bill in
  galifrey3#add_doctor seventh;
  
  let twelfth = new Doctor.doctor "The Twelfth Doctor" 2000 nardole in
  galifrey3#add_doctor twelfth;
  
  let thirteenth = new Doctor.doctor "The Thirteenth Doctor" 2100 clara in
  galifrey3#add_doctor thirteenth;
  print_endline "";
  
  (* Beaucoup d'humains *)
  print_endline "[Human Resistance Army]";
  let rec create_humans count =
    if count <= 0 then ()
    else begin
      let human = new People.people ("Soldier" ^ string_of_int count) in
      galifrey3#add_people human;
      create_humans (count - 1)
    end
  in
  create_humans 5;
  print_endline "";
  
  (* Quelques Daleks *)
  print_endline "[Small Dalek Squad]";
  let rec create_daleks_3 count =
    if count <= 0 then ()
    else begin
      let dalek = new Dalek.dalek in
      galifrey3#add_dalek dalek;
      create_daleks_3 (count - 1)
    end
  in
  create_daleks_3 3;
  print_endline "";
  
  (* Lancer la Time War *)
  galifrey3#do_time_war;
  
  print_endline "";
  print_endline "═══════════════════════════════════════════════════════════════";
  print_endline "";
  print_endline "";
  
  (* ========== FINALE ========== *)
  print_endline "╔═══════════════════════════════════════════════════════════════╗";
  print_endline "║                                                               ║";
  print_endline "║                  THE TIME WAR HAS ENDED                       ║";
  print_endline "║                                                               ║";
  print_endline "║         All scenarios completed. Galifrey stands...           ║";
  print_endline "║                       or falls.                               ║";
  print_endline "║                                                               ║";
  print_endline "╚═══════════════════════════════════════════════════════════════╝";
  print_endline ""
