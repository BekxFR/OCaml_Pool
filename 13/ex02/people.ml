(* Class people - Day 13 Exercise 02
 * Respect des règles:
 * - Style fonctionnel (attributs immutables sauf hp pour être tué)
 * - Pas de open, for, while
 * - Stdlib modules autorisés
 *)

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
  
  (* Getter pour hp *)
  method get_hp : int = hp
  
  (* Setter pour hp - nécessaire pour exterminate *)
  method set_hp (new_hp : int) : unit =
    hp <- new_hp
end
