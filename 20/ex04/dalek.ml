(* Class dalek *)

class dalek =
object (self)
  (* Attributs *)
  val name : string =
    let suffixes = [|"Bek"; "Kah"; "Sec"; "Caan"; "Jast"; "Thay"; "Khan"; "Rabe"; "Zalk"; 
                   "Meh"; "Taan"; "Ruk"; "Vex"; "Zor"; "Gan"; "Lek"; "Mor"|] in
    let random_suffix = suffixes.(Random.int (Array.length suffixes)) in
    "Dalek" ^ random_suffix
  val mutable hp : int = 120
  val mutable shield : bool = true
  
  (* Initializer *)
  initializer
    print_endline ("  [DALEK] " ^ name ^ " materializes! Shield: " ^
                   (if shield then "ACTIVE" else "INACTIVE") ^ 
                   ", HP: " ^ string_of_int hp)
  
  (* to_string *)
  method to_string : string =
    name ^ " (HP: " ^ string_of_int hp ^ ", Shield: " ^ 
    (if shield then "ON" else "OFF") ^ ")"
  
  (* talk - affiche aléatoirement l'une des phrases *)
  method talk : unit =
    let phrases = [|
      "Explain! Explain!";
      "Exterminate! Exterminate!";
      "I obey!";
      "You are the Doctor! You are the enemy of the Daleks!"
    |] in
    let random_phrase = phrases.(Random.int (Array.length phrases)) in
    print_endline (name ^ ": " ^ random_phrase)
  
  (* exterminate - tue instantanément un people *)
  method exterminate (victim : People.people) : unit =
    print_endline (name ^ ": EXTERMINATE!");
    victim#take_damage 999;
    shield <- not shield
  
  (* die *)
  method die : unit =
    print_endline (name ^ ": Emergency Temporal Shift!")
  
  (* Getters *)
  method get_hp : int = hp
  method get_shield : bool = shield
  method get_name : string = name
  
  (* Combat methods *)
  method is_alive : bool = hp > 0
  
  method take_damage (damage : int) : unit =
    if self#is_alive then begin
      (* Le shield absorbe 50% des dégâts *)
      let actual_damage = if shield then damage / 2 else damage in
      hp <- max 0 (hp - actual_damage);
      
      if shield && actual_damage < damage then
        print_endline ("    🛡️  " ^ name ^ "'s shield absorbs " ^ 
                      string_of_int (damage - actual_damage) ^ " damage!");
      
      if hp = 0 then begin
        print_endline ("    💀 " ^ name ^ " is destroyed!");
        self#die
      end else begin
        print_endline ("    → " ^ name ^ " takes " ^ string_of_int actual_damage ^ 
                      " damage! (HP: " ^ string_of_int hp ^ ")");
        (* Le shield change d'état après chaque attaque *)
        shield <- not shield;
        print_endline ("    🛡️  Shield status: " ^ 
                      (if shield then "ACTIVE" else "INACTIVE"))
      end
    end
  
  method attack : int =
    if self#is_alive then begin
      let damage = 30 + Random.int 21 in
      print_endline ("    💥 " ^ name ^ " fires extermination ray! (Damage: " ^ 
                    string_of_int damage ^ ")");
      damage
    end else 0
end
