(* Fichier pour explorer les signatures des modules *)

(* 1. Regarder ce qui est disponible dans Set *)
let () = 
  print_endline "=== Exploration des signatures ==="

(* 2. Créer un module simple pour voir sa signature *)
module MyOrderedType = struct
  type t = int
  let compare = Int.compare
end

(* 3. Utiliser le foncteur Set.Make *)
module MySet = Set.Make(MyOrderedType)

(* 4. Tester quelques fonctions *)
let test_set = 
  let s = MySet.empty in
  let s = MySet.add 1 s in
  let s = MySet.add 3 s in
  let s = MySet.add 2 s in
  s

let () = 
  print_endline ("Taille du set: " ^ string_of_int (MySet.cardinal test_set));
  print_endline ("Contient 2: " ^ string_of_bool (MySet.mem 2 test_set))


  #show Set.OrderedType;;
  #show Set;;
  #show Set.S;;
  #show Map.OrderedType;;

  #show List;;
  #show String;;
  #show Array;;

  (* Lancer: ocaml *)

  (* Voir la signature OrderedType *)
  #show Set.OrderedType;;

  (* Créer un module qui respecte cette signature *)
  module IntOrder = struct
    type t = int
    let compare = Int.compare
  end;;

  (* Voir ce que OCaml a inféré *)
  #show IntOrder;;

  (* Créer un Set avec ce module *)
  module IntSet = Set.Make(IntOrder);;

  (* Voir la signature du Set créé *)
  #show IntSet;;
