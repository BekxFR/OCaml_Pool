(* Class people *)

class people (initial_name : string) =
object (self)
  (* Attributs immutables - style fonctionnel *)
  val name : string = initial_name
  val hp : int = 100
  
  (* Initializer *)
  initializer
    print_endline ("New person created: " ^ name ^ " with " ^ 
                   string_of_int hp ^ " HP. Allons-y!")
  
  (* to_string - retourne une représentation string *)
  method to_string : string =
    "Name: " ^ name ^ ", HP: " ^ string_of_int hp
  
  (* talk - affiche le message requis avec [NAME] *)
  method talk : unit =
    print_endline ("I'm " ^ name ^ "! Do you know the Doctor?")
  
  (* die - affiche le message de mort *)
  method die : unit =
    print_endline "Aaaarghh!"
end