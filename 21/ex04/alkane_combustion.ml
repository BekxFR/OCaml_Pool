(* Alkane_combustion - Exercise 04
 * Combustion complète des alcanes: CnH(2n+2) + O2 -> CO2 + H2O
 * Implémente l'équilibrage stœchiométrique automatique
 *)

(* Molécules pour la combustion - Dioxygène O2 *)
class dioxygen =
object
  inherit Molecule.molecule [
    new Atom.oxygen;
    new Atom.oxygen
  ]
  method name = "Dioxygen"
end

(* Classe alkane_combustion héritant de reaction *)
class alkane_combustion (alkanes : Alkane.alkane list) =
  (* Vérifier que la liste n'est pas vide *)
  let () = 
    if alkanes = [] then
      failwith "alkane_combustion: empty alkane list"
  in
  
  (* Calculer les coefficients pour équilibrer la réaction
   * Pour CnH(2n+2) + O2 -> CO2 + H2O
   * Équilibre: CnH(2n+2) + (3n+1)/2 O2 -> n CO2 + (n+1) H2O
   * 
   * Multiplier par 2 pour éviter les fractions:
   * 2 CnH(2n+2) + (3n+1) O2 -> 2n CO2 + 2(n+1) H2O
   *)
  let compute_coefficients alkane_list =
    (* Fonction pour calculer les coefficients d'un alcane *)
    let compute_one_alkane alk =
      let n = alk#carbon_count in
      (* Coefficients: (alkane, O2, CO2, H2O) *)
      (* Coefficients multipliés par 2 pour éviter fractions *)
      (* Formule: 2 CnH(2n+2) + (3n+1) O2 -> 2n CO2 + 2(n+1) H2O *)
      let coeff_alk = 2 in
      let coeff_o2 = 3 * n + 1 in
      let coeff_co2 = 2 * n in
      let coeff_h2o = 2 * (n + 1) in
      
      (* Calculer le PGCD pour simplifier *)
      let rec gcd a b = if b = 0 then a else gcd b (a mod b) in
      let pgcd = gcd (gcd (gcd coeff_alk coeff_o2) coeff_co2) coeff_h2o in
      
      (* Diviser par le PGCD *)
      (coeff_alk / pgcd, coeff_o2 / pgcd, coeff_co2 / pgcd, coeff_h2o / pgcd)
    in

    
    (* Calculer pour chaque alcane et agréger *)
    let coeffs_list = List.map compute_one_alkane alkane_list in
    
    (* Pour simplifier, on prend juste le premier alcane *)
    (* Dans une version complète, il faudrait trouver le PPCM *)
    coeffs_list
  in
  
  let coefficients = compute_coefficients alkanes in
  
  (* Construire les listes de réactifs et produits *)
  let build_start_list alkanes coeffs =
    let alkane_entries = List.map2 (fun alk (coeff_alk, coeff_o2, _, _) ->
      ((alk :> Molecule.molecule), coeff_alk)
    ) alkanes coeffs in
    
    (* Additionner tous les coefficients d'O2 *)
    let total_o2 = List.fold_left (fun acc (_, coeff_o2, _, _) -> 
      acc + coeff_o2
    ) 0 coeffs in
    
    alkane_entries @ [((new dioxygen :> Molecule.molecule), total_o2)]
  in
  
  let build_result_list alkanes coeffs =
    (* Additionner tous les coefficients de CO2 et H2O *)
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
  
  (* Méthodes get_start et get_result: pas d'exception car déjà équilibré *)
  method get_start = start
  
  method get_result = result
  
  (* balance: retourne self car les coefficients sont déjà calculés correctement *)
  method balance : Reaction.reaction =
    (self :> Reaction.reaction)
  
  (* is_balanced: utilise la méthode héritée de reaction pour vérifier *)
  (* Override optionnel: on sait que c'est toujours équilibré *)
  (* method is_balanced = true *)
end
