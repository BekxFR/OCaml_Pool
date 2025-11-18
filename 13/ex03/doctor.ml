(* Class doctor - Day 13 Exercise 03
 * Respect des règles:
 * - Style fonctionnel (attributs immutables sauf age et hp)
 * - Pas de open, for, while
 * - Stdlib modules autorisés
 *)

class doctor (initial_name : string) (initial_age : int) (initial_sidekick : People.people) =
object (self)
  (* Attributs *)
  val name : string = initial_name
  val mutable age : int = initial_age
  val sidekick : People.people = initial_sidekick
  val mutable hp : int = 100
  
  (* Initializer *)
  initializer
    print_endline ("The Doctor has arrived! Name: " ^ name ^ 
                   ", Age: " ^ string_of_int age ^ ". Time Lord ready!")
  
  (* to_string *)
  method to_string : string =
    "Doctor [Name: " ^ name ^ 
    ", Age: " ^ string_of_int age ^ 
    ", HP: " ^ string_of_int hp ^ "]"
  
  (* talk *)
  method talk : unit =
    print_endline "Hi! I'm the Doctor!"
  
  (* travel_in_time *)
  method travel_in_time (start : int) (arrival : int) : unit =
    let time_diff = arrival - start in
    age <- age + time_diff
  
  (* use_sonic_screwdriver *)
  method use_sonic_screwdriver : unit =
    print_endline "Whiiiiwhiiiwhiii Whiiiiwhiiiwhiii Whiiiiwhiiiwhiii"
  
  (* regenerate - méthode PRIVÉE *)
  method private regenerate : unit =
    hp <- 100
  
  (* Getters *)
  method get_hp : int = hp
  method set_hp (new_hp : int) : unit = hp <- new_hp
  method get_name : string = name
  
  method die : unit =
    print_endline "The Doctor is regenerating..."
end
