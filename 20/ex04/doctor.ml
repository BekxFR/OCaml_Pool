(* Class doctor *)

class doctor (initial_name : string) (initial_age : int) (initial_sidekick : People.people) =
object (self)
  (* Attributs *)
  val name : string = initial_name
  val mutable age : int = initial_age
  val sidekick : People.people = initial_sidekick
  val mutable hp : int = 150
  
  (* Initializer *)
  initializer
    print_endline ("  [TIME LORD] " ^ name ^ " arrives! Age: " ^ 
                   string_of_int age ^ ", HP: " ^ string_of_int hp)
  
  (* to_string *)
  method to_string : string =
    name ^ " (HP: " ^ string_of_int hp ^ ", Age: " ^ string_of_int age ^ ")"
  
  (* talk *)
  method talk : unit =
    print_endline (name ^ ": Hi! I'm the Doctor!")
  
  (* travel_in_time *)
  method travel_in_time (start : int) (arrival : int) : unit =
    let time_diff = arrival - start in
    age <- age + time_diff
  
  (* use_sonic_screwdriver *)
  method use_sonic_screwdriver : unit =
    print_endline "Whiiiiwhiiiwhiii Whiiiiwhiiiwhiii Whiiiiwhiiiwhiii"
  
  (* regenerate - méthode PRIVÉE *)
  method private regenerate : unit =
    if hp < 150 && hp > 0 then begin
      hp <- 150;
      print_endline ("    ✨ " ^ name ^ " regenerates! HP restored to 150!")
    end
  
  (* Getters *)
  method get_hp : int = hp
  method get_name : string = name
  
  (* Combat methods *)
  method is_alive : bool = hp > 0
  
  method take_damage (damage : int) : unit =
    if self#is_alive then begin
      hp <- max 0 (hp - damage);
      if hp = 0 then begin
        print_endline ("    💀 " ^ name ^ " falls in battle!");
        print_endline (name ^ ": The Doctor is regenerating...");
      end else begin
        print_endline ("    → " ^ name ^ " takes " ^ string_of_int damage ^ 
                      " damage! (HP: " ^ string_of_int hp ^ ")");
        (* Chance de régénération si HP < 50 *)
        if hp < 50 && Random.int 100 < 40 then
          self#regenerate
      end
    end
  
  method attack : int =
    if self#is_alive then begin
      let damage = 25 + Random.int 16 in (* 25-40 damage - plus puissant *)
      self#use_sonic_screwdriver;
      print_endline ("    🔧 " ^ name ^ " uses sonic screwdriver! (Damage: " ^ 
                    string_of_int damage ^ ")");
      damage
    end else 0
  
  method die : unit =
    print_endline (name ^ ": The regeneration failed...")
end
