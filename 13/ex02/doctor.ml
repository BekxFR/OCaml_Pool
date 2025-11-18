(* Class doctor - Day 13 Exercise 02
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
                   ", Age: " ^ string_of_int age ^ 
                   ", Sidekick: " ^ sidekick#to_string ^
                   ". Time and space await!")
  
  (* to_string *)
  method to_string : string =
    "Doctor [Name: " ^ name ^ 
    ", Age: " ^ string_of_int age ^ 
    ", HP: " ^ string_of_int hp ^ 
    ", Sidekick: " ^ sidekick#to_string ^ "]"
  
  (* talk *)
  method talk : unit =
    print_endline "Hi! I'm the Doctor!"
  
  (* travel_in_time *)
  method travel_in_time (start : int) (arrival : int) : unit =
    let time_diff = arrival - start in
    age <- age + time_diff;
    print_endline "";
    print_endline "╔═══════════════════════════════════════╗";
    print_endline "║  _____  _    ____  ____ ___ ____     ║";
    print_endline "║ |_   _|/ \\  |  _ \\|  _ \\_ _/ ___|    ║";
    print_endline "║   | | / _ \\ | |_) | | | | |\\___ \\    ║";
    print_endline "║   | |/ ___ \\|  _ <| |_| | | ___) |   ║";
    print_endline "║   |_/_/   \\_\\_| \\_\\____/___|____/    ║";
    print_endline "║                                       ║";
    print_endline "║    VWORP VWORP VWORP VWORP VWORP     ║";
    print_endline "╚═══════════════════════════════════════╝";
    print_endline ("Traveled from year " ^ string_of_int start ^ 
                   " to year " ^ string_of_int arrival);
    print_endline ("Doctor's age changed by " ^ string_of_int time_diff ^ 
                   " years. Current age: " ^ string_of_int age);
    print_endline ""
  
  (* use_sonic_screwdriver *)
  method use_sonic_screwdriver : unit =
    print_endline "Whiiiiwhiiiwhiii Whiiiiwhiiiwhiii Whiiiiwhiiiwhiii"
  
  (* regenerate - méthode PRIVÉE *)
  method private regenerate : unit =
    hp <- 100;
    print_endline "✨ Regeneration complete! HP restored to 100 ✨"
  
  (* Getters/setters pour bataille *)
  method get_hp : int = hp
  
  method set_hp (new_hp : int) : unit =
    hp <- new_hp
  
  method die : unit =
    print_endline "The Doctor is regenerating..."
    
  (* Méthode d'attaque pour la bataille *)
  method sonic_attack : int =
    print_endline "The Doctor uses sonic screwdriver!";
    self#use_sonic_screwdriver;
    20  (* dégâts *)
end
