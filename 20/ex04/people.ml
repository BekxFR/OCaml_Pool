(* Class people *)

class people (initial_name : string) =
object (self)
  (* Attributs *)
  val name : string = initial_name
  val mutable hp : int = 100
  
  (* Initializer *)
  initializer
    print_endline ("  [RECRUIT] " ^ name ^ " joins the battle! HP: " ^ 
                   string_of_int hp)
  
  (* to_string *)
  method to_string : string =
    name ^ " (HP: " ^ string_of_int hp ^ ")"
  
  (* talk *)
  method talk : unit =
    print_endline (name ^ ": I'm " ^ name ^ "! Do you know the Doctor?")
  
  (* die *)
  method die : unit =
    print_endline (name ^ ": Aaaarghh!")
  
  (* Getters *)
  method get_hp : int = hp
  method get_name : string = name
  
  (* Combat methods *)
  method is_alive : bool = hp > 0
  
  method take_damage (damage : int) : unit =
    if self#is_alive then begin
      hp <- max 0 (hp - damage);
      if hp = 0 then begin
        print_endline ("    💀 " ^ name ^ " has been eliminated!");
        self#die
      end else
        print_endline ("    → " ^ name ^ " takes " ^ string_of_int damage ^ 
                      " damage! (HP: " ^ string_of_int hp ^ ")")
    end
  
  method attack : int =
    if self#is_alive then begin
      let damage = 10 + Random.int 11 in (* 10-20 damage *)
      print_endline ("    ⚔️  " ^ name ^ " attacks! (Damage: " ^ 
                    string_of_int damage ^ ")");
      damage
    end else 0
end
