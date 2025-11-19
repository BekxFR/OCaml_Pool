(* Class dalek *)

class dalek =
object (self)
  (* Attributs *)
  val name : string =
    let suffixes = [|"Sec"; "Caan"; "Jast"; "Thay"; "Khan"; "Rabe"; "Zalk"; 
                   "Taan"; "Ruk"; "Vex"; "Zor"; "Gan"; "Lek"; "Mor"|] in
    let random_suffix = suffixes.(Random.int (Array.length suffixes)) in
    "Dalek" ^ random_suffix
  val mutable hp : int = 100
  val mutable shield : bool = true
  
  (* Initializer *)
  initializer
    print_endline ("A Dalek has been created: " ^ name ^ 
                   " with shield " ^ (if shield then "ACTIVE" else "INACTIVE") ^
                   ". EXTERMINATE!")
  
  (* to_string *)
  method to_string : string =
    "Dalek [Name: " ^ name ^ 
    ", HP: " ^ string_of_int hp ^ 
    ", Shield: " ^ (if shield then "ACTIVE" else "INACTIVE") ^ "]"
  
  (* talk - affiche aléatoirement l'une des phrases *)
  method talk : unit =
    let phrases = [|
      "Explain! Explain!";
      "Exterminate! Exterminate!";
      "I obey!";
      "You are the Doctor! You are the enemy of the Daleks!"
    |] in
    let random_phrase = phrases.(Random.int (Array.length phrases)) in
    print_endline random_phrase
  
  (* exterminate - tue instantanément un people et change le shield *)
  method exterminate (victim : People.people) : unit =
    print_endline "EXTERMINATE!";
    victim#set_hp 0;
    victim#die;
    shield <- not shield
  
  (* die *)
  method die : unit =
    print_endline "Emergency Temporal Shift!"
  
  (* Getters *)
  method get_hp : int = hp
  method set_hp (new_hp : int) : unit = hp <- new_hp
  method get_shield : bool = shield
  method get_name : string = name
end
