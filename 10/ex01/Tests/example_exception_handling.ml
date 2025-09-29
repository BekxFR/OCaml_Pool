(* Exemple d'utilisation avec gestion d'exception *)

(* Exemple 1 : Sans gestion d'exception - le programme s'arrête *)
let test_without_handling () =
  print_endline "Test sans gestion d'exception :";
  let result = Value.previous Value.T2 in
  print_endline ("Résultat : " ^ Value.toString result)

(* Exemple 2 : Avec gestion d'exception - le programme continue *)
let test_with_handling () =
  print_endline "Test avec gestion d'exception :";
  try
    let result = Value.previous Value.T2 in
    print_endline ("Résultat : " ^ Value.toString result)
  with
  | Invalid_argument msg -> 
    print_endline ("Erreur capturée : " ^ msg);
    print_endline "Le programme continue normalement !"

(* Exemple 3 : Fonction alternative qui retourne un Option au lieu de lever une exception *)
let safe_previous card =
  try
    Some (Value.previous card)
  with
  | Invalid_argument _ -> None

let test_safe_version () =
  print_endline "Test avec version sécurisée :";
  match safe_previous Value.T2 with
  | Some result -> print_endline ("Résultat : " ^ Value.toString result)
  | None -> print_endline "Aucune carte précédente pour T2"

(* Exemple 4 : Gestion de plusieurs cartes *)
let test_multiple_cards () =
  print_endline "Test avec plusieurs cartes :";
  let cards = [Value.T3; Value.T2; Value.Jack] in
  List.iter (fun card ->
    try
      let prev = Value.previous card in
      Printf.printf "%s -> %s\n" (Value.toString card) (Value.toString prev)
    with
    | Invalid_argument msg -> 
      Printf.printf "%s -> Erreur : %s\n" (Value.toString card) msg
  ) cards

(* Exécution des tests *)
let () =
  print_endline "=== Démonstration de la gestion d'exceptions avec invalid_arg ===\n";
  
  (* Test avec gestion d'exception *)
  test_with_handling ();
  print_endline "";
  
  (* Test avec version sécurisée *)
  test_safe_version ();
  print_endline "";
  
  (* Test avec plusieurs cartes *)
  test_multiple_cards ();
  print_endline "";
  
  print_endline "Fin du programme - toutes les exceptions ont été gérées !";
