(* Alkane_combustion - Exercise 04
 * Complete combustion of alkanes: CnH(2n+2) + O2 -> CO2 + H2O
 * Implements automatic stoichiometric balancing
 *)

(* Molecules for combustion - Dioxygen O2 *)
class dioxygen =
object
  inherit Molecule.molecule [
    new Atom.oxygen;
    new Atom.oxygen
  ]
  method name = "Dioxygen"
end

(* Alkane_combustion class inheriting from reaction *)
class alkane_combustion (alkanes : Alkane.alkane list) =
  let () =
    if alkanes = [] then
      failwith "alkane_combustion: empty alkane list"
  in

  (* Compute coefficients to balance the reaction
   * For CnH(2n+2) + O2 -> CO2 + H2O
   * Balance: CnH(2n+2) + (3n+1)/2 O2 -> n CO2 + (n+1) H2O
   *
   * Multiply by 2 to avoid fractions:
   * 2 CnH(2n+2) + (3n+1) O2 -> 2n CO2 + 2(n+1) H2O
   *)
  let compute_coefficients alkane_list =
    (* Compute coefficients for one alkane *)
    let compute_one_alkane alk =
      let n = alk#carbon_count in
      (* Coefficients multiplied by 2 to avoid fractions *)
      (* Formula: 2 CnH(2n+2) + (3n+1) O2 -> 2n CO2 + 2(n+1) H2O *)
      let coeff_alk = 2 in
      let coeff_o2 = 3 * n + 1 in
      let coeff_co2 = 2 * n in
      let coeff_h2o = 2 * (n + 1) in

      (* Compute GCD to simplify *)
      let rec gcd a b = if b = 0 then a else gcd b (a mod b) in
      let g = gcd (gcd (gcd coeff_alk coeff_o2) coeff_co2) coeff_h2o in

      (coeff_alk / g, coeff_o2 / g, coeff_co2 / g, coeff_h2o / g)
    in

    (* Compute for each alkane and aggregate *)
    let coeffs_list = List.map compute_one_alkane alkane_list in

    coeffs_list
  in

  let coefficients = compute_coefficients alkanes in

  (* Build reactant and product lists *)
  let build_start_list alkanes coeffs =
    let alkane_entries = List.map2 (fun alk (coeff_alk, _, _, _) ->
      ((alk :> Molecule.molecule), coeff_alk)
    ) alkanes coeffs in

    (* Sum all O2 coefficients *)
    let total_o2 = List.fold_left (fun acc (_, coeff_o2, _, _) ->
      acc + coeff_o2
    ) 0 coeffs in

    alkane_entries @ [((new dioxygen :> Molecule.molecule), total_o2)]
  in

  let build_result_list alkanes coeffs =
    (* Sum all CO2 and H2O coefficients *)
    let total_co2 = List.fold_left (fun acc (_, _, coeff_co2, _) ->
      acc + coeff_co2
    ) 0 coeffs in

    let total_h2o = List.fold_left (fun acc (_, _, _, coeff_h2o) ->
      acc + coeff_h2o
    ) 0 coeffs in

    [
      ((new Molecule.carbon_dioxide :> Molecule.molecule), total_co2);
      ((new Molecule.water :> Molecule.molecule), total_h2o)
    ]
  in

  let start_list = build_start_list alkanes coefficients in
  let result_list = build_result_list alkanes coefficients in

object (self)
  inherit Reaction.reaction

  val start = start_list
  val result = result_list

  (* get_start and get_result: no exception since already balanced *)
  method get_start = start

  method get_result = result

  (* balance: returns self since coefficients are already correctly computed *)
  method balance : Reaction.reaction =
    (self :> Reaction.reaction)

  (* is_balanced: uses inherited method from reaction to verify *)
end
