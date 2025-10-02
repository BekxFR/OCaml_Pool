(* ========================================================================== *)
(*                  REMPLIR UN ARRAY AVEC Array.init                         *)
(* ========================================================================== *)

let jokes = [
  "What is green and move on water? It's a sub cabbage!";
  "What do you call a can opener that doesn’t work? A can't opener!";
  "Did you hear about the Italian chef who died? He pasta way.";
  "Did you hear the story about the claustrophobic astronaut? He just needed some space.";
  "What do you call an alligator in a vest? An investigator!";
]

let () =
  print_endline "=== DIFFÉRENTES MÉTHODES AVEC Array.init ===\n";
  
  (* ================================================================== *)
  (* MÉTHODE 1 : Array.init simple avec List.nth *)
  (* ================================================================== *)
  
  print_endline "--- Méthode 1: Array.init + List.nth ---";
  let method1 = Array.init (List.length jokes) (fun i -> List.nth jokes i) in
  Array.iteri (fun i joke -> Printf.printf "[%d] %s\n" i joke) method1;
  
  (* ================================================================== *)
  (* MÉTHODE 2 : Array.init avec gestion des index hors limites *)
  (* ================================================================== *)
  
  print_endline "\n--- Méthode 2: Array.init avec index sécurisés ---";
  let method2 = Array.init 7 (fun i -> 
    if i < List.length jokes then List.nth jokes i 
    else Printf.sprintf "Index %d: Pas de blague ici!" i
  ) in
  Array.iteri (fun i joke -> Printf.printf "[%d] %s\n" i joke) method2;
  
  (* ================================================================== *)
  (* MÉTHODE 3 : Conversion en array puis Array.init *)
  (* ================================================================== *)
  
  print_endline "\n--- Méthode 3: List -> Array -> Array.init ---";
  let jokes_array = Array.of_list jokes in
  let method3 = Array.init (Array.length jokes_array) (fun i -> jokes_array.(i)) in
  Array.iteri (fun i joke -> Printf.printf "[%d] %s\n" i joke) method3;
  
  (* ================================================================== *)
  (* MÉTHODE 4 : Array.init avec transformation *)
  (* ================================================================== *)
  
  print_endline "\n--- Méthode 4: Array.init avec transformation ---";
  let method4 = Array.init (List.length jokes) (fun i -> 
    Printf.sprintf "Blague #%d: %s" (i + 1) (List.nth jokes i)
  ) in
  Array.iter (fun joke -> Printf.printf "%s\n" joke) method4;
  
  (* ================================================================== *)
  (* MÉTHODE 5 : Array.init avec fonction helper *)
  (* ================================================================== *)
  
  print_endline "\n--- Méthode 5: Array.init avec fonction helper ---";
  let get_joke_safe i = 
    try Some (List.nth jokes i)
    with _ -> None 
  in
  
  let method5 = Array.init 7 (fun i -> 
    match get_joke_safe i with
    | Some joke -> joke
    | None -> "🤷 Aucune blague à cet index"
  ) in
  Array.iteri (fun i joke -> Printf.printf "[%d] %s\n" i joke) method5;
  
  (* ================================================================== *)
  (* COMPARAISON AVEC D'AUTRES MÉTHODES *)
  (* ================================================================== *)
  
  print_endline "\n=== COMPARAISON AVEC D'AUTRES MÉTHODES ===\n";
  
  print_endline "--- Array.make puis Array.iteri ---";
  let method_make = Array.make (List.length jokes) "" in
  List.iteri (fun i joke -> method_make.(i) <- joke) jokes;
  Array.iteri (fun i joke -> Printf.printf "[%d] %s\n" i joke) method_make;
  
  print_endline "\n--- Array.of_list (plus simple) ---";
  let method_of_list = Array.of_list jokes in
  Array.iteri (fun i joke -> Printf.printf "[%d] %s\n" i joke) method_of_list;
  
  print_endline "\n=== AVANTAGES DE CHAQUE MÉTHODE ===";
  print_endline "• Array.init : Flexible, permet transformations et conditions";
  print_endline "• Array.of_list : Plus simple, conversion directe";
  print_endline "• Array.make + iteri : Contrôle total, bon pour cas complexes";
  print_endline "• List.nth : Pratique mais O(n) pour chaque accès"
