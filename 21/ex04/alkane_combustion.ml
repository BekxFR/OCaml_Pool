(* Alkane_combustion - Exercise 04
 * Complete combustion of alkanes: CnH(2n+2) + O2 -> CO2 + H2O
 * Implements automatic stoichiometric balancing with the smallest
 * possible coefficients and duplicate removal.
 *)

(* Deduplicate alkanes by their carbon count (same n = same alkane). *)
let dedup_alkanes (alkanes : Alkane.alkane list) : Alkane.alkane list =
  let rec aux seen acc = function
    | [] -> List.rev acc
    | a :: rest ->
        let n = a#carbon_count in
        if List.mem n seen then aux seen acc rest
        else aux (n :: seen) (a :: acc) rest
  in
  aux [] [] alkanes

(* Integer GCD *)
let rec gcd a b = if b = 0 then abs a else gcd b (a mod b)

(* GCD of a list of positive integers *)
let list_gcd = function
  | [] -> 1
  | x :: xs -> List.fold_left gcd x xs

(* Compute balanced reactants and products from a list of distinct alkanes,
 * reduced to the smallest possible stoichiometric coefficients.
 *
 * For each alkane CnH(2n+2):
 *     2 CnH(2n+2) + (3n+1) O2 -> 2n CO2 + (2n+2) H2O
 * Totals across alkanes are summed, then divided by their global GCD. *)
let compute_balanced (alkanes : Alkane.alkane list) =
  let per_alkane =
    List.map (fun alk ->
      let n = alk#carbon_count in
      (alk, 2, 3 * n + 1, 2 * n, 2 * (n + 1))
    ) alkanes
  in
  let total_o2 = List.fold_left (fun acc (_, _, o2, _, _) -> acc + o2) 0 per_alkane in
  let total_co2 = List.fold_left (fun acc (_, _, _, co2, _) -> acc + co2) 0 per_alkane in
  let total_h2o = List.fold_left (fun acc (_, _, _, _, h2o) -> acc + h2o) 0 per_alkane in
  let alk_coeffs = List.map (fun (_, c, _, _, _) -> c) per_alkane in
  let g = list_gcd (alk_coeffs @ [total_o2; total_co2; total_h2o]) in
  let g = if g = 0 then 1 else g in
  let start_list =
    List.map (fun (alk, c, _, _, _) ->
      ((alk :> Molecule.molecule), c / g)
    ) per_alkane
    @ [((new Molecule.dioxygen :> Molecule.molecule), total_o2 / g)]
  in
  let result_list =
    [
      ((new Molecule.carbon_dioxide :> Molecule.molecule), total_co2 / g);
      ((new Molecule.water :> Molecule.molecule), total_h2o / g)
    ]
  in
  (start_list, result_list)

class alkane_combustion (alkanes : Alkane.alkane list) =
  let () =
    if alkanes = [] then
      failwith "alkane_combustion: empty alkane list"
  in
  let unique_alkanes = dedup_alkanes alkanes in
  let (start_list, result_list) = compute_balanced unique_alkanes in
object
  inherit Reaction.reaction start_list result_list

  (* balance: returns a NEW alkane_combustion built from deduplicated
   * alkanes, producing the smallest possible stoichiometric coefficients. *)
  method balance : Reaction.reaction =
    (new alkane_combustion unique_alkanes :> Reaction.reaction)
end
