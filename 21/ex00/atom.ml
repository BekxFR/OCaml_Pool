(* Atom - Exercise 00
 * Virtual class for atoms
 *)

class virtual atom =
object (self)
  (* Virtual methods - must be implemented by subclasses *)
  method virtual name : string
  method virtual symbol : string
  method virtual atomic_number : int
  
  (* to_string - describe the atom *)
  method to_string : string =
    self#name ^ ": [" ^ self#symbol ^ ", Z=" ^ 
    string_of_int self#atomic_number ^ "]"
  
  (* equals - compare two atoms by atomic number *)
  method equals (other : atom) : bool =
    self#atomic_number = other#atomic_number
end

(* Concrete atom classes *)
class hydrogen =
object
  inherit atom
  method name = "Hydrogen"
  method symbol = "H"
  method atomic_number = 1
end

class carbon =
object
  inherit atom
  method name = "Carbon"
  method symbol = "C"
  method atomic_number = 6
end

class oxygen =
object
  inherit atom
  method name = "Oxygen"
  method symbol = "O"
  method atomic_number = 8
end

class nitrogen =
object
  inherit atom
  method name = "Nitrogen"
  method symbol = "N"
  method atomic_number = 7
end

class sulfur =
object
  inherit atom
  method name = "Sulfur"
  method symbol = "S"
  method atomic_number = 16
end

class chlorine =
object
  inherit atom
  method name = "Chlorine"
  method symbol = "Cl"
  method atomic_number = 17
end
