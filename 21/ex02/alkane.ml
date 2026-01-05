(* Alkane - Exercise 02
 * Alkanes: hydrocarbons with formula CnH(2n+2)
 * where 1 <= n <= 12
 *)

(* Classe alkane héritant de molecule *)
class alkane (n : int) =
  (* Vérification que n est dans [1, 12] *)
  let () = 
    if n < 1 || n > 12 then
      failwith "Alkane: n must be between 1 and 12"
  in
  (* Génération de la liste d'atomes selon CnH(2n+2) *)
  let atoms_list =
    let carbons = List.init n (fun _ -> (new Atom.carbon :> Atom.atom)) in
    let hydrogens = List.init (2 * n + 2) (fun _ -> (new Atom.hydrogen :> Atom.atom)) in
    carbons @ hydrogens
  in
object (self)
  (* Héritage de molecule *)
  inherit Molecule.molecule atoms_list as super
  
  (* Noms des alcanes selon n *)
  method name =
    match n with
    | 1 -> "Methane"
    | 2 -> "Ethane"
    | 3 -> "Propane"
    | 4 -> "Butane"
    | 5 -> "Pentane"
    | 6 -> "Hexane"
    | 7 -> "Heptane"
    | 8 -> "Octane"
    | 9 -> "Nonane"
    | 10 -> "Decane"
    | 11 -> "Undecane"
    | 12 -> "Dodecane"
    | _ -> failwith "Invalid alkane number"
  
  (* Méthode pour obtenir la valeur de n *)
  method carbon_count = n
end

(* Fonctions de commodité pour créer des alcanes spécifiques - factory methods *)
(* let methane () = new alkane 1
let ethane () = new alkane 2
let propane () = new alkane 3
let butane () = new alkane 4
let pentane () = new alkane 5
let hexane () = new alkane 6
let heptane () = new alkane 7
let octane () = new alkane 8
let nonane () = new alkane 9
let decane () = new alkane 10
let undecane () = new alkane 11
let dodecane () = new alkane 12 *)

class methane =
object
  inherit alkane 1
end

class ethane =
object
  inherit alkane 2
end

class propane =
object
  inherit alkane 3
end

class butane =
object
  inherit alkane 4
end

class pentane =
object
  inherit alkane 5
end

class hexane =
object
  inherit alkane 6
end

class heptane =
object
  inherit alkane 7
end

class octane =
object
  inherit alkane 8
end

class nonane =
object
  inherit alkane 9
end

class decane =
object
  inherit alkane 10
end

class undecane =
object
  inherit alkane 11
end

class dodecane =
object
  inherit alkane 12
end
