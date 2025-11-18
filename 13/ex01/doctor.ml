(* Class doctor - Day 13 Exercise 01
 * Respect des règles:
 * - Style fonctionnel (attributs immutables sauf hp qui peut régénérer)
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
  
  (* Initializer - message créatif Doctor Who *)
  initializer
    print_endline ("The Doctor has arrived! Name: " ^ name ^ 
                   ", Age: " ^ string_of_int age ^ 
                   ", Sidekick: " ^ sidekick#to_string ^
                   ". Time and space await!")
  
  (* to_string - retourne une représentation string avec tous les attributs *)
  method to_string : string =
    "Doctor [Name: " ^ name ^ 
    ", Age: " ^ string_of_int age ^ 
    ", HP: " ^ string_of_int hp ^ 
    ", Sidekick: " ^ sidekick#to_string ^ "]"
  
  (* talk - affiche le message requis *)
  method talk : unit =
    print_endline "Hi! I'm the Doctor!"
  
  (* travel_in_time - modifie l'âge logiquement et affiche un TARDIS *)
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
  
  (* use_sonic_screwdriver - affiche le son du tournevis sonique *)
  method use_sonic_screwdriver : unit =
    print_endline "Whiiiiwhiiiwhiii Whiiiiwhiiiwhiii Whiiiiwhiiiwhiii"
  
  (* regenerate - méthode PRIVÉE qui régénère les HP à 100 *)
  method private regenerate : unit =
    hp <- 100;
    print_endline "✨ Regeneration complete! HP restored to 100 ✨"
end
