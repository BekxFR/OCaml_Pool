(* Exemple sans gestion d'exception - provoque l'arrêt du programme *)

let test_crash () =
  print_endline "Tentative d'appel de Value.previous avec T2 sans gestion d'exception :";
  let result = Value.previous Value.T2 in (* Cette ligne va lever une exception *)
  print_endline ("Ce message ne sera jamais affiché : " ^ Value.toString result)

let () =
  print_endline "Début du programme";
  test_crash ();
  print_endline "Cette ligne ne sera jamais atteinte"
