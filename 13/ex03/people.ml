(* Class people *)

class people (initial_name : string) =
object (self)
  (* Attributs *)
  val name : string = initial_name
  val mutable hp : int = 100
  
  (* Initializer *)
  initializer
    print_endline ("New person created: " ^ name ^ " with " ^ 
                   string_of_int hp ^ " HP. Allons-y!")
  
  (* to_string *)
  method to_string : string =
    "Name: " ^ name ^ ", HP: " ^ string_of_int hp
  
  (* talk *)
  method talk : unit =
    print_endline ("I'm " ^ name ^ "! Do you know the Doctor?")
  
  (* die *)
  method die : unit =
    print_endline "Aaaarghh!"
  
  (* Getters/setters *)
  method get_hp : int = hp
  method set_hp (new_hp : int) : unit = hp <- new_hp
  method get_name : string = name
end
