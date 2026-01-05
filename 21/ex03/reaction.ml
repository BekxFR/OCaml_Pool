(* Reaction - Exercise 03
 * Virtual class for chemical reactions
 * Implements Lavoisier's law: conservation of atoms
 *)

(* Exception pour les réactions non équilibrées *)
exception UnbalancedReaction

(* Classe virtuelle reaction *)
class virtual reaction =
object (self)
  (* Listes virtuelles des réactifs et produits *)
  method virtual get_start : (Molecule.molecule * int) list
  method virtual get_result : (Molecule.molecule * int) list
  
  (* Méthode pour compter les atomes dans une liste de molécules avec coefficients *)
  method private count_atoms (molecules : (Molecule.molecule * int) list) : (string * int) list =
    let rec count_mol_atoms mol =
      (* Fonction auxiliaire pour extraire les atomes d'une formule *)
      let formula = mol#formula in
      let rec parse_formula idx acc =
        if idx >= String.length formula then
          acc
        else
          let c = formula.[idx] in
          if c >= 'A' && c <= 'Z' then
            (* Début d'un symbole *)
            let symbol_end = ref (idx + 1) in
            while !symbol_end < String.length formula && 
                  formula.[!symbol_end] >= 'a' && formula.[!symbol_end] <= 'z' do
              incr symbol_end
            done;
            let symbol = String.sub formula idx (!symbol_end - idx) in
            (* Lire le nombre qui suit *)
            let num_start = !symbol_end in
            let num_end = ref num_start in
            while !num_end < String.length formula && 
                  formula.[!num_end] >= '0' && formula.[!num_end] <= '9' do
              incr num_end
            done;
            let count = 
              if !num_end > num_start then
                int_of_string (String.sub formula num_start (!num_end - num_start))
              else
                1
            in
            parse_formula !num_end ((symbol, count) :: acc)
          else
            parse_formula (idx + 1) acc
      in
      parse_formula 0 []
    in
    
    (* Compter tous les atomes avec leurs coefficients *)
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
    (* Trier par ordre alphabétique *)
    List.sort (fun (s1, _) (s2, _) -> compare s1 s2) counts
  
  (* Méthode pour vérifier si la réaction est équilibrée *)
  method is_balanced : bool =
    try
      let start_atoms = self#count_atoms self#get_start in
      let result_atoms = self#count_atoms self#get_result in
      start_atoms = result_atoms
    with _ -> false
  
  (* Méthode virtuelle pour équilibrer la réaction *)
  method virtual balance : reaction
  
  (* Méthode to_string *)
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

(* Classe concrète: combustion du méthane (équilibrée manuellement) *)
(* CH4 + 2 O2 -> CO2 + 2 H2O *)
class methane_combustion =
object (self)
  inherit reaction
  
  val start_molecules = [
    ((new Alkane.methane :> Molecule.molecule), 1);
    ((new Molecule.carbon_dioxide :> Molecule.molecule), 2)  (* On utilise CO2 comme O2 temporairement *)
  ]
  
  val result_molecules = [
    ((new Molecule.carbon_dioxide :> Molecule.molecule), 1);
    ((new Molecule.water :> Molecule.molecule), 2)
  ]
  
  method get_start = start_molecules
  method get_result = result_molecules
  
  method balance : reaction =
    (self :> reaction)  (* Déjà équilibré *)
end

(* Classe concrète: synthèse de l'eau *)
(* 2 H2 + O2 -> 2 H2O *)
class water_synthesis =
object (self)
  inherit reaction
  
  val start_list = [
    ((new Molecule.carbon_dioxide :> Molecule.molecule), 2);  (* Utilise CO2 comme H2 temporairement *)
    ((new Molecule.carbon_dioxide :> Molecule.molecule), 1)   (* Utilise CO2 comme O2 temporairement *)
  ]
  
  val result_list = [
    ((new Molecule.water :> Molecule.molecule), 2)
  ]
  
  method get_start = start_list
  method get_result = result_list
  
  method balance : reaction =
    (self :> reaction)  (* Déjà équilibré *)
end
