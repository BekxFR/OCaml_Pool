(* Class galifrey - Day 13 Exercise 04 - Time War Manager
 * Respect des règles:
 * - Style fonctionnel (pas de while, for, Array)
 * - Pas de open
 *)

class galifrey =
object (self)
  (* Attributs - 3 listes de combattants *)
  val mutable dalek_members : Dalek.dalek list = []
  val mutable doctor_members : Doctor.doctor list = []
  val mutable people_members : People.people list = []
  
  (* Initializer *)
  initializer
    print_endline "╔═══════════════════════════════════════════════════════════════╗";
    print_endline "║                    GALIFREY INITIALIZED                       ║";
    print_endline "║              The Time War Command Center is ready             ║";
    print_endline "╚═══════════════════════════════════════════════════════════════╝"
  
  (* Méthodes pour ajouter des membres *)
  method add_dalek (dalek : Dalek.dalek) : unit =
    dalek_members <- dalek :: dalek_members
  
  method add_doctor (doctor : Doctor.doctor) : unit =
    doctor_members <- doctor :: doctor_members
  
  method add_people (person : People.people) : unit =
    people_members <- person :: people_members
  
  (* Méthode pour vérifier si une liste contient des survivants *)
  method private any_alive_in_dalek_list (daleks : Dalek.dalek list) : bool =
    match daleks with
    | [] -> false
    | dalek :: rest -> 
        if dalek#is_alive then true
        else self#any_alive_in_dalek_list rest
  
  method private any_alive_in_doctor_list (doctors : Doctor.doctor list) : bool =
    match doctors with
    | [] -> false
    | doctor :: rest ->
        if doctor#is_alive then true
        else self#any_alive_in_doctor_list rest
  
  method private any_alive_in_people_list (people : People.people list) : bool =
    match people with
    | [] -> false
    | person :: rest ->
        if person#is_alive then true
        else self#any_alive_in_people_list rest
  
  (* Méthode pour filtrer les survivants *)
  method private filter_alive_daleks (daleks : Dalek.dalek list) : Dalek.dalek list =
    match daleks with
    | [] -> []
    | dalek :: rest ->
        if dalek#is_alive then
          dalek :: (self#filter_alive_daleks rest)
        else
          self#filter_alive_daleks rest
  
  method private filter_alive_doctors (doctors : Doctor.doctor list) : Doctor.doctor list =
    match doctors with
    | [] -> []
    | doctor :: rest ->
        if doctor#is_alive then
          doctor :: (self#filter_alive_doctors rest)
        else
          self#filter_alive_doctors rest
  
  method private filter_alive_people (people : People.people list) : People.people list =
    match people with
    | [] -> []
    | person :: rest ->
        if person#is_alive then
          person :: (self#filter_alive_people rest)
        else
          self#filter_alive_people rest
  
  (* Méthode pour compter les survivants *)
  method private count_alive : (int * int * int) =
    let alive_daleks = List.length (self#filter_alive_daleks dalek_members) in
    let alive_doctors = List.length (self#filter_alive_doctors doctor_members) in
    let alive_people = List.length (self#filter_alive_people people_members) in
    (alive_daleks, alive_doctors, alive_people)
  
  (* Méthode pour afficher le statut *)
  method private show_status : unit =
    let (daleks, doctors, people) = self#count_alive in
    print_endline "";
    print_endline "═══════════════════════════════════════════════════════════════";
    print_endline ("  Status: " ^ string_of_int daleks ^ " Daleks | " ^
                   string_of_int doctors ^ " Doctors | " ^
                   string_of_int people ^ " Humans");
    print_endline "═══════════════════════════════════════════════════════════════";
    print_endline ""
  
  (* Méthode pour sélectionner une cible aléatoire vivante dans une liste *)
  method private get_random_alive_dalek : Dalek.dalek option =
    let alive = self#filter_alive_daleks dalek_members in
    match alive with
    | [] -> None
    | _ -> 
        let index = Random.int (List.length alive) in
        Some (List.nth alive index)
  
  method private get_random_alive_doctor : Doctor.doctor option =
    let alive = self#filter_alive_doctors doctor_members in
    match alive with
    | [] -> None
    | _ ->
        let index = Random.int (List.length alive) in
        Some (List.nth alive index)
  
  method private get_random_alive_people : People.people option =
    let alive = self#filter_alive_people people_members in
    match alive with
    | [] -> None
    | _ ->
        let index = Random.int (List.length alive) in
        Some (List.nth alive index)
  
  (* Méthode pour faire attaquer les Daleks *)
  method private daleks_attack (daleks : Dalek.dalek list) : unit =
    match daleks with
    | [] -> ()
    | dalek :: rest ->
        if dalek#is_alive then begin
          (* Daleks attaquent prioritairement les Doctors, sinon les humans *)
          let target_doctor = self#get_random_alive_doctor in
          let target_people = self#get_random_alive_people in
          match target_doctor, target_people with
          | Some doctor, _ ->
              let damage = dalek#attack in
              doctor#take_damage damage
          | None, Some person ->
              let damage = dalek#attack in
              person#take_damage damage
          | None, None -> ()
        end;
        self#daleks_attack rest
  
  (* Méthode pour faire attaquer les Doctors *)
  method private doctors_attack (doctors : Doctor.doctor list) : unit =
    match doctors with
    | [] -> ()
    | doctor :: rest ->
        if doctor#is_alive then begin
          (* Doctors attaquent les Daleks en priorité *)
          let target = self#get_random_alive_dalek in
          match target with
          | Some dalek ->
              let damage = doctor#attack in
              dalek#take_damage damage
          | None -> ()
        end;
        self#doctors_attack rest
  
  (* Méthode pour faire attaquer les humans *)
  method private people_attack (people : People.people list) : unit =
    match people with
    | [] -> ()
    | person :: rest ->
        if person#is_alive then begin
          (* Humans attaquent les Daleks *)
          let target = self#get_random_alive_dalek in
          match target with
          | Some dalek ->
              let damage = person#attack in
              dalek#take_damage damage
          | None -> ()
        end;
        self#people_attack rest
  
  (* LA MÉTHODE PRINCIPALE: do_time_war *)
  method do_time_war : unit =
    print_endline "";
    print_endline "╔═══════════════════════════════════════════════════════════════╗";
    print_endline "║                    THE TIME WAR BEGINS!                       ║";
    print_endline "╚═══════════════════════════════════════════════════════════════╝";
    print_endline "";
    
    self#show_status;
    
    (* Fonction récursive pour exécuter les rounds *)
    let rec battle_round round_number =
      let (alive_daleks, alive_doctors, alive_people) = self#count_alive in
      
      (* Condition d'arrêt: un camp est éliminé *)
      let good_side_alive = alive_doctors > 0 || alive_people > 0 in
      let evil_side_alive = alive_daleks > 0 in
      
      if good_side_alive && evil_side_alive then begin
        print_endline ("╔══════════════════════════════════════════════════════════════╗");
        print_endline ("║                     ROUND " ^ string_of_int round_number ^ 
                      "                                   ║");
        print_endline ("╚══════════════════════════════════════════════════════════════╝");
        print_endline "";
        
        (* Phase 1: Daleks attaquent *)
        print_endline ">>> Daleks Phase <<<";
        self#daleks_attack dalek_members;
        print_endline "";
        
        (* Phase 2: Doctors attaquent *)
        if self#any_alive_in_doctor_list doctor_members then begin
          print_endline ">>> Doctors Phase <<<";
          self#doctors_attack doctor_members;
          print_endline ""
        end;
        
        (* Phase 3: Humans attaquent *)
        if self#any_alive_in_people_list people_members then begin
          print_endline ">>> Humans Phase <<<";
          self#people_attack people_members;
          print_endline ""
        end;
        
        self#show_status;
        
        (* Round suivant *)
        battle_round (round_number + 1)
      end else begin
        (* Fin de la guerre *)
        print_endline "";
        print_endline "╔═══════════════════════════════════════════════════════════════╗";
        print_endline "║                    THE TIME WAR ENDS!                         ║";
        print_endline "╚═══════════════════════════════════════════════════════════════╝";
        print_endline "";
        
        if alive_daleks = 0 && (alive_doctors > 0 || alive_people > 0) then begin
          print_endline "🎉 VICTORY! The Daleks have been defeated!";
          print_endline ("   Survivors: " ^ string_of_int alive_doctors ^ 
                        " Doctors, " ^ string_of_int alive_people ^ " Humans")
        end else if alive_daleks > 0 then begin
          print_endline "💀 DEFEAT! The Daleks have won...";
          print_endline ("   Remaining Daleks: " ^ string_of_int alive_daleks)
        end else begin
          print_endline "⚖️  MUTUAL DESTRUCTION! No survivors..."
        end;
        print_endline ""
      end
    in
    
    battle_round 1
end
