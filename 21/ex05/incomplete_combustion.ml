(* Incomplete_combustion - Exercise 05
 * Incomplete combustion of alkanes with varying amounts of O2
 * Generates all possible combinations of CO2, CO, C and H2O
 *)

(* Class for pure carbon (soot/suie) *)
class carbon =
object
  inherit Molecule.molecule [new Atom.carbon]
  method name = "Carbon"
end

(* Class for carbon monoxide CO *)
class carbon_monoxide =
object
  inherit Molecule.molecule [
    new Atom.carbon;
    new Atom.oxygen
  ]
  method name = "Carbon monoxide"
end

(* Extended alkane_combustion class with incomplete combustion *)
class incomplete_combustion (alkanes : Alkane.alkane list) =
  let () =
    if alkanes = [] then
      failwith "incomplete_combustion: empty alkane list"
  in

  (* Compute total number of carbons and hydrogens *)
  let total_carbons = List.fold_left (fun acc alk ->
    acc + alk#carbon_count
  ) 0 alkanes in

  let total_hydrogens = List.fold_left (fun acc alk ->
    acc + (2 * alk#carbon_count + 2)
  ) 0 alkanes in

  (* Compute max O2 coefficient for complete combustion *)
  let max_o2 = List.fold_left (fun acc alk ->
    let n = alk#carbon_count in
    acc + (2 * n + 3)  (* Formula: upper bound for O2 in incomplete combustion *)
  ) 0 alkanes in

object (self)
  inherit Alkane_combustion.alkane_combustion alkanes

  (* Generate incomplete combustion results
   * Returns: (int * (molecule * int) list) list
   * where int = O2 amount and the list = products
   *)
  method get_incomplete_results : (int * (Molecule.molecule * int) list) list =
    (* Generate all valid combinations of CO2, CO, C
     * for a given number of available oxygen atoms
     *)
    let generate_outcomes o2_amount =
      let available_oxygen = 2 * o2_amount in

      (* Water always consumes total_hydrogens/2 oxygens *)
      let water_oxygen = total_hydrogens / 2 in
      let remaining_oxygen = available_oxygen - water_oxygen in

      (* If not enough oxygen for water, no solution *)
      if remaining_oxygen < 0 then
        []
      else
        (* Generate all combinations of CO2, CO, C that use
         * exactly total_carbons carbons and remaining_oxygen oxygens
         * CO2 uses 2 O per C, CO uses 1 O per C, C uses 0 O
         *)
        let rec generate_combos c_remaining o_remaining acc =
          if c_remaining = 0 && o_remaining = 0 then
            (* Valid solution found *)
            [acc]
          else if c_remaining = 0 then
            []
          else if o_remaining < 0 then
            []
          else
            (* Try adding CO2, CO, or C *)
            let with_co2 =
              if o_remaining >= 2 then
                generate_combos (c_remaining - 1) (o_remaining - 2)
                  (("CO2", 1) :: acc)
              else []
            in
            let with_co =
              if o_remaining >= 1 then
                generate_combos (c_remaining - 1) (o_remaining - 1)
                  (("CO", 1) :: acc)
              else []
            in
            let with_c =
              if o_remaining >= 0 then
                generate_combos (c_remaining - 1) o_remaining
                  (("C", 1) :: acc)
              else []
            in
            with_co2 @ with_co @ with_c
        in

        let raw_combos = generate_combos total_carbons remaining_oxygen [] in

        (* Aggregate each combo: [("CO2",1);("C",1);("C",1)] -> [("CO2",1);("C",2)] *)
        let rec aggregate acc = function
          | [] -> acc
          | (mol_type, count) :: rest ->
              let current = try List.assoc mol_type acc with Not_found -> 0 in
              aggregate ((mol_type, current + count) :: (List.remove_assoc mol_type acc)) rest
        in
        let aggregated_combos = List.map (aggregate []) raw_combos in

        (* Sort each combo to normalize order, then deduplicate *)
        let normalized = List.map (List.sort compare) aggregated_combos in
        let unique_combos = List.sort_uniq compare normalized in

        (* Filter out complete combustions (no CO or C) *)
        let is_incomplete combo =
          List.exists (fun (mol, _) -> mol = "CO" || mol = "C") combo
        in
        let incomplete_combos = List.filter is_incomplete unique_combos in

        (* Convert combos to molecule lists with coefficients *)
        let combo_to_molecules combo =
          let molecules = List.map (fun (mol_type, coeff) ->
            let mol = match mol_type with
              | "CO2" -> (new Molecule.carbon_dioxide :> Molecule.molecule)
              | "CO" -> (new carbon_monoxide :> Molecule.molecule)
              | "C" -> (new carbon :> Molecule.molecule)
              | _ -> failwith "Unknown molecule type"
            in
            (mol, coeff)
          ) combo in

          (* Add water *)
          let h2o_coeff = total_hydrogens / 2 in
          molecules @ [((new Molecule.water :> Molecule.molecule), h2o_coeff)]
        in

        List.map combo_to_molecules incomplete_combos
    in

    (* Generate results for different O2 amounts *)
    (* Test from 1 up to max_o2 - 1 (max_o2 is complete combustion) *)
    let rec generate_all_outcomes o2 acc =
      if o2 >= max_o2 then
        List.rev acc
      else
        let outcomes = generate_outcomes o2 in
        let new_acc =
          if outcomes = [] then acc
          else (o2, outcomes) :: acc
        in
        generate_all_outcomes (o2 + 1) new_acc
    in

    (* Filter to keep only entries with at least one solution *)
    let all_results = generate_all_outcomes 1 [] in

    (* Flatten the structure: instead of (o2, outcomes list),
     * create one entry per outcome *)
    let rec flat_results acc = function
      | [] -> List.rev acc
      | (o2, outcomes) :: rest ->
          let new_entries = List.map (fun outcome -> (o2, outcome)) outcomes in
          flat_results (List.rev_append new_entries acc) rest
    in

    flat_results [] all_results
end
