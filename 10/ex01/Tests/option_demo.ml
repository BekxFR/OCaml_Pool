(* Démonstration du pattern matching avec option *)

(* Fonction safe_previous (rappel) *)
let safe_previous card =
  try
    Some (Value.previous card)
  with
  | Invalid_argument _ -> None

(* Fonction qui peut réussir ou échouer *)
let safe_division x y =
  if y = 0 then
    None  (* Échec : division par zéro *)
  else
    Some (x / y)  (* Succès : retourne le résultat *)

let test_option_pattern () =
  print_endline "=== Démonstration du pattern matching avec option ===\n";
  
  (* Test 1 : Division réussie *)
  print_endline "Test 1 : 10 / 2";
  (match safe_division 10 2 with
   | Some result -> Printf.printf "Succès : résultat = %d\n" result
   | None -> print_endline "Échec : division impossible");
  
  (* Test 2 : Division par zéro *)
  print_endline "\nTest 2 : 10 / 0";
  (match safe_division 10 0 with
   | Some result -> Printf.printf "Succès : résultat = %d\n" result
   | None -> print_endline "Échec : division par zéro détectée");
  
  (* Test 3 : Avec la fonction safe_previous *)
  print_endline "\nTest 3 : Carte précédente de T3";
  (match safe_previous Value.T3 with
   | Some result -> Printf.printf "Succès : carte précédente = %s\n" (Value.toString result)
   | None -> print_endline "Échec : pas de carte précédente");
   
  print_endline "\nTest 4 : Carte précédente de T2";
  (match safe_previous Value.T2 with
   | Some result -> Printf.printf "Succès : carte précédente = %s\n" (Value.toString result)
   | None -> print_endline "Échec : pas de carte précédente pour T2")

let () = test_option_pattern ()
