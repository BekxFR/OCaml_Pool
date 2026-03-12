(* Molecule - Exercise 01
 * Virtual class for chemical molecules
 * Uses Hill notation for chemical formulas
 *)

class virtual molecule (atom_list : Atom.atom list) =
object (self)
  (* Private atoms list *)
  val atoms = atom_list
  
  (* Virtual method for the name *)
  method virtual name : string
  
  (* Method to get the formula in Hill notation
   * Format: C first, then H, then the others in alphabetical order
   *)
  method formula : string =
    (* Auxiliary function to count the occurrences of each symbol *)
    let count_atoms atoms =
      let rec count acc = function
        | [] -> acc
        | atom :: rest ->
            let symbol = atom#symbol in
            let current_count = 
              try List.assoc symbol acc 
              with Not_found -> 0 
            in
            let new_acc = (symbol, current_count + 1) :: 
                          (List.remove_assoc symbol acc) in
            count new_acc rest
      in
      count [] atoms
    in
    
    (* Function to sort according to Hill notation rules:
     * 1. C first
     * 2. H second
     * 3. Others in alphabetical order
     *)
    let hill_sort counts =
      let c_count = try [("C", List.assoc "C" counts)] with Not_found -> [] in
      let h_count = try [("H", List.assoc "H" counts)] with Not_found -> [] in
      let others = List.filter (fun (s, _) -> s <> "C" && s <> "H") counts in
      let sorted_others = List.sort (fun (s1, _) (s2, _) -> compare s1 s2) others in
      c_count @ h_count @ sorted_others
    in
    
    (* Function to format the display of an element *)
    let format_element (symbol, count) =
      if count = 1 then symbol
      else symbol ^ string_of_int count
    in
    
    let counts = count_atoms atoms in
    let sorted_counts = hill_sort counts in
    String.concat "" (List.map format_element sorted_counts)
  
  (* Method to_string *)
  method to_string : string =
    self#name ^ " (" ^ self#formula ^ ")"
  
  (* Method equals *)
  method equals (other : molecule) : bool =
    self#formula = other#formula
end

(* Concrete molecule: Water (H2O) *)
class water =
object
  inherit molecule [
    new Atom.oxygen;
    new Atom.hydrogen;
    new Atom.hydrogen;
  ]
  method name = "Water"
end

(* Concrete molecule: Carbon dioxide (CO2) *)
class carbon_dioxide =
object
  inherit molecule [
    new Atom.oxygen;
    new Atom.carbon;
    new Atom.oxygen;
  ]
  method name = "Carbon dioxide"
end

(* Concrete molecule: Methane (CH4) *)
class methane =
object
  inherit molecule [
    new Atom.carbon;
    new Atom.hydrogen;
    new Atom.hydrogen;
    new Atom.hydrogen;
    new Atom.hydrogen
  ]
  method name = "Methane"
end

(* Concrete molecule: Sulfuric acid (H2SO4) *)
class sulfuric_acid =
object
  inherit molecule [
    new Atom.hydrogen;
    new Atom.hydrogen;
    new Atom.sulfur;
    new Atom.oxygen;
    new Atom.oxygen;
    new Atom.oxygen;
    new Atom.oxygen
  ]
  method name = "Sulfuric acid"
end

(* Concrete molecule: Ammonia (NH3) *)
class ammonia =
object
  inherit molecule [
    new Atom.nitrogen;
    new Atom.hydrogen;
    new Atom.hydrogen;
    new Atom.hydrogen
  ]
  method name = "Ammonia"
end

(* Concrete molecule: Dioxygen (O2) *)
class dioxygen =
object
  inherit molecule [
    new Atom.oxygen;
    new Atom.oxygen
  ]
  method name = "Dioxygen"
end

(* Concrete molecule : Dihydrogen (H2) *)
class dihydrogen =
object
  inherit molecule [
    new Atom.hydrogen;
    new Atom.hydrogen
  ]
  method name = "Dihydrogen"
end
