(* Reaction - Exercise 03
 * Virtual class for chemical reactions
 * Implements Lavoisier's law: conservation of atoms
 *)

(* Exception for unbalanced reactions *)
exception UnbalancedReaction

(* Virtual class reaction *)
class virtual reaction =
object (self)
  (* Virtual lists of reactants and products *)
  method virtual get_start : (Molecule.molecule * int) list
  method virtual get_result : (Molecule.molecule * int) list

  (* Count atoms in a list of molecules with coefficients *)
  method private count_atoms (molecules : (Molecule.molecule * int) list) : (string * int) list =
    let rec count_mol_atoms mol =
      (* Helper to extract atoms from a formula string *)
      let formula = mol#formula in
      let len = String.length formula in
      (* Scan lowercase letters starting at idx *)
      let rec scan_lower idx =
        if idx < len && formula.[idx] >= 'a' && formula.[idx] <= 'z' then
          scan_lower (idx + 1)
        else idx
      in
      (* Scan digits starting at idx, return (end_idx, number) *)
      let rec scan_digits idx =
        if idx < len && formula.[idx] >= '0' && formula.[idx] <= '9' then
          scan_digits (idx + 1)
        else idx
      in
      let rec parse_formula idx acc =
        if idx >= len then
          acc
        else
          let c = formula.[idx] in
          if c >= 'A' && c <= 'Z' then
            (* Start of element symbol *)
            let symbol_end = scan_lower (idx + 1) in
            let symbol = String.sub formula idx (symbol_end - idx) in
            (* Read the number that follows *)
            let num_end = scan_digits symbol_end in
            let count =
              if num_end > symbol_end then
                int_of_string (String.sub formula symbol_end (num_end - symbol_end))
              else
                1
            in
            parse_formula num_end ((symbol, count) :: acc)
          else
            parse_formula (idx + 1) acc
      in
      parse_formula 0 []
    in

    (* Count all atoms with their coefficients *)
    let rec process_list acc = function
      | [] -> acc
      | (mol, coeff) :: rest ->
          let mol_atoms = count_mol_atoms mol in
          let updated_acc = List.fold_left (fun a (symbol, count) ->
            let total_count = count * coeff in
            let current = try List.assoc symbol a with Not_found -> 0 in
            (symbol, current + total_count) :: (List.remove_assoc symbol a)
          ) acc mol_atoms in
          process_list updated_acc rest
    in

    let counts = process_list [] molecules in
    (* Sort alphabetically *)
    List.sort (fun (s1, _) (s2, _) -> compare s1 s2) counts

  (* Check if the reaction is balanced *)
  method is_balanced : bool =
    try
      let start_atoms = self#count_atoms self#get_start in
      let result_atoms = self#count_atoms self#get_result in
      start_atoms = result_atoms
    with _ -> false

  (* Virtual method to balance the reaction *)
  method virtual balance : reaction

  (* String representation *)
  method to_string : string =
    let format_molecule_list lst =
      String.concat " + " (List.map (fun (mol, coeff) ->
        if coeff = 1 then mol#to_string
        else string_of_int coeff ^ " " ^ mol#to_string
      ) lst)
    in
    let start_str = format_molecule_list self#get_start in
    let result_str = format_molecule_list self#get_result in
    start_str ^ " -> " ^ result_str
end

(* Concrete class: methane combustion (manually balanced) *)
(* CH4 + 2 O2 -> CO2 + 2 H2O *)
class methane_combustion =
object (self)
  inherit reaction

  val start_molecules = [
    ((new Alkane.methane :> Molecule.molecule), 1);
    ((new Molecule.dioxygen :> Molecule.molecule), 2)
  ]

  val result_molecules = [
    ((new Molecule.carbon_dioxide :> Molecule.molecule), 1);
    ((new Molecule.water :> Molecule.molecule), 2)
  ]

  method get_start = start_molecules
  method get_result = result_molecules

  method balance : reaction =
    (self :> reaction)
end

(* Concrete class: water synthesis *)
(* 2 H2 + O2 -> 2 H2O *)
class water_synthesis =
object (self)
  inherit reaction

  val start_list = [
    ((new Molecule.dihydrogen :> Molecule.molecule), 2);
    ((new Molecule.dioxygen :> Molecule.molecule), 1)
  ]

  val result_list = [
    ((new Molecule.water :> Molecule.molecule), 2)
  ]

  method get_start = start_list
  method get_result = result_list

  method balance : reaction =
    (self :> reaction)
end
