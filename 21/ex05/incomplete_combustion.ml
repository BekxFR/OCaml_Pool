(* Incomplete_combustion - Exercise 05
 * Combustion incomplète des alcanes avec différentes quantités d'O2
 * Génère toutes les combinaisons possibles de CO2, CO, C et H2O
 *)

(* Classe pour le carbone pur (suie) *)
class carbon =
object
  inherit Molecule.molecule [new Atom.carbon]
  method name = "Carbon"
end

(* Classe pour le monoxyde de carbone CO *)
class carbon_monoxide =
object
  inherit Molecule.molecule [
    new Atom.carbon;
    new Atom.oxygen
  ]
  method name = "Carbon monoxide"
end

(* Classe alkane_combustion étendue avec combustion incomplète *)
class incomplete_combustion (alkanes : Alkane.alkane list) =
  (* Vérifier que la liste n'est pas vide *)
  let () = 
    if alkanes = [] then
      failwith "incomplete_combustion: empty alkane list"
  in
  
  (* Calculer le nombre total de carbones et d'hydrogènes *)
  let total_carbons = List.fold_left (fun acc alk -> 
    acc + alk#carbon_count
  ) 0 alkanes in
  
  let total_hydrogens = List.fold_left (fun acc alk -> 
    acc + (2 * alk#carbon_count + 2)
  ) 0 alkanes in
  
  (* Pour la combustion complète, calculer le coefficient d'O2 max *)
  let max_o2 = List.fold_left (fun acc alk ->
    let n = alk#carbon_count in
    acc + (2 * n + 3)  (* Formule: 2 CnH(2n+2) + (2n+3) O2 *)
  ) 0 alkanes in

object (self)
  inherit Alkane_combustion.alkane_combustion alkanes
  
  (* Méthode pour générer les résultats de combustion incomplète
   * Retourne: (int * (molecule * int) list) list
   * où int = quantité d'O2 et la liste = produits
   *)
  method get_incomplete_results : (int * (Molecule.molecule * int) list) list =
    (* Fonction pour générer toutes les combinaisons valides de CO2, CO, C
     * pour un nombre donné d'atomes d'oxygène disponibles
     *)
    let generate_outcomes o2_amount =
      (* Calculer combien d'oxygène disponible *)
      let available_oxygen = 2 * o2_amount in
      
      (* L'eau consomme toujours total_hydrogens/2 oxygènes *)
      let water_oxygen = total_hydrogens / 2 in
      let remaining_oxygen = available_oxygen - water_oxygen in
      
      (* Si pas assez d'oxygène pour l'eau, pas de solution *)
      if remaining_oxygen < 0 then
        []
      else
        (* Générer toutes les combinaisons de CO2, CO, C qui utilisent
         * exactly total_carbons carbones et remaining_oxygen oxygènes
         * CO2 utilise 2 O par C, CO utilise 1 O par C, C utilise 0 O
         *)
        let rec generate_combos c_remaining o_remaining acc =
          if c_remaining = 0 && o_remaining = 0 then
            (* Solution valide trouvée *)
            [acc]
          else if c_remaining = 0 then
            (* Plus de carbone mais encore de l'oxygène - pas de solution *)
            []
          else if o_remaining < 0 then
            (* Pas assez d'oxygène *)
            []
          else
            (* Essayer d'ajouter CO2, CO, ou C *)
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
        
        (* Filtrer les combustions complètes (pas de CO ni C) *)
        let is_incomplete combo =
          List.exists (fun (mol, _) -> mol = "CO" || mol = "C") combo
        in
        
        let incomplete_combos = List.filter is_incomplete raw_combos in
        
        (* Convertir les combos en listes de molécules avec coefficients *)
        let combo_to_molecules combo =
          (* Agréger les coefficients *)
          let rec aggregate acc = function
            | [] -> acc
            | (mol_type, count) :: rest ->
                let current = try List.assoc mol_type acc with Not_found -> 0 in
                aggregate ((mol_type, current + count) :: (List.remove_assoc mol_type acc)) rest
          in
          let aggregated = aggregate [] combo in
          
          (* Convertir en objets molécule *)
          let molecules = List.map (fun (mol_type, coeff) ->
            let mol = match mol_type with
              | "CO2" -> (new Molecule.carbon_dioxide :> Molecule.molecule)
              | "CO" -> (new carbon_monoxide :> Molecule.molecule)
              | "C" -> (new carbon :> Molecule.molecule)
              | _ -> failwith "Unknown molecule type"
            in
            (mol, coeff)
          ) aggregated in
          
          (* Ajouter l'eau *)
          let h2o_coeff = total_hydrogens / 2 in
          molecules @ [((new Molecule.water :> Molecule.molecule), h2o_coeff)]
        in
        
        List.map combo_to_molecules incomplete_combos
    in
    
    (* Générer les résultats pour différentes quantités d'O2 *)
    (* On teste de 1 jusqu'à max_o2 - 1 (max_o2 est la combustion complète) *)
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
    
    (* Filtrer pour ne garder que les entrées avec au moins une solution *)
    let all_results = generate_all_outcomes 1 [] in
    
    (* Aplatir la structure: au lieu de (o2, outcomes list), 
     * créer une entrée par outcome *)
    let rec flat_results acc = function
      | [] -> List.rev acc
      | (o2, outcomes) :: rest ->
          let new_entries = List.map (fun outcome -> (o2, outcome)) outcomes in
          flat_results (List.rev_append new_entries acc) rest
    in
    
    flat_results [] all_results
end
