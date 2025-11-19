(* Molecule - Exercise 01
 * Virtual class for chemical molecules
 * Uses Hill notation for chemical formulas
 *)

(* Classe virtuelle molecule *)
class virtual molecule (atom_list : Atom.atom list) =
object (self)
  (* Liste privée des atomes *)
  val atoms = atom_list
  
  (* Méthode virtuelle pour le nom *)
  method virtual name : string
  
  (* Méthode pour obtenir la formule en notation de Hill
   * Format: C d'abord, puis H, puis les autres par ordre alphabétique
   *)
  method formula : string =
    (* Fonction auxiliaire pour compter les occurrences de chaque symbole *)
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
    
    (* Fonction pour formater l'affichage d'un élément *)
    let format_element (symbol, count) =
      if count = 1 then symbol
      else symbol ^ string_of_int count
    in
    
    (* Fonction de tri selon les règles de Hill:
     * 1. C en premier
     * 2. H en second
     * 3. Les autres par ordre alphabétique
     *)
    let hill_sort counts =
      let c_count = try [("C", List.assoc "C" counts)] with Not_found -> [] in
      let h_count = try [("H", List.assoc "H" counts)] with Not_found -> [] in
      let others = List.filter (fun (s, _) -> s <> "C" && s <> "H") counts in
      let sorted_others = List.sort (fun (s1, _) (s2, _) -> compare s1 s2) others in
      c_count @ h_count @ sorted_others
    in
    
    let counts = count_atoms atoms in
    let sorted_counts = hill_sort counts in
    String.concat "" (List.map format_element sorted_counts)
  
  (* Méthode to_string *)
  method to_string : string =
    self#name ^ " (" ^ self#formula ^ ")"
  
  (* Méthode equals *)
  method equals (other : molecule) : bool =
    self#formula = other#formula
end

(* Molécule concrète: Water (H2O) *)
class water =
object
  inherit molecule [
    new Atom.hydrogen;
    new Atom.hydrogen;
    new Atom.oxygen
  ]
  method name = "Water"
end

(* Molécule concrète: Carbon dioxide (CO2) *)
class carbon_dioxide =
object
  inherit molecule [
    new Atom.carbon;
    new Atom.oxygen;
    new Atom.oxygen
  ]
  method name = "Carbon dioxide"
end

(* Molécule concrète: Methane (CH4) *)
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

(* Molécule concrète: Sulfuric acid (H2SO4) *)
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

(* Molécule concrète: Ammonia (NH3) *)
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
