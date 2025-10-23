(* Explication de la complexité O(1) *)

let explain_o1_complexity () =
  print_endline "=== Explication de la complexité O(1) ===";
  print_endline "";
  
  print_endline "1. STRUCTURE INTERNE d'une hashtable:";
  print_endline "   - Un tableau de 'buckets' (cases)";
  print_endline "   - Chaque bucket contient une liste d'éléments";
  print_endline "   - Taille fixe du tableau (ex: 5 cases)";
  print_endline "";
  
  print_endline "2. ALGORITHME pour toute opération:";
  print_endline "   a) Calculer hash(clé)           -> O(k) où k = longueur de la clé";
  print_endline "   b) Calculer position = hash % taille_tableau -> O(1)";
  print_endline "   c) Accéder à tableau[position]  -> O(1) (accès direct)";
  print_endline "   d) Chercher dans la liste du bucket -> O(m) où m = nb éléments dans ce bucket";
  print_endline "";
  
  print_endline "3. COMPLEXITÉ TOTALE:";
  print_endline "   - Si bonne fonction de hash: m ≈ 1 (peu de collisions)";
  print_endline "   - Donc: O(k) + O(1) + O(1) + O(1) = O(k)";
  print_endline "   - Pour des clés de taille constante: O(1)";
  print_endline "";
  
  print_endline "4. SIMULATION VISUELLE:";
  
  (* Simulation simple *)
  let table_size = 5 in
  let keys = ["alice"; "bob"; "charlie"; "diana"] in
  
  Array.init table_size (fun i -> Printf.printf "Bucket %d: " i; i) |> ignore;
  print_endline "";
  
  List.iter (fun key ->
    let hash_val = Hashtbl.hash key in
    let position = hash_val mod table_size in
    Printf.printf "  \"%s\" -> hash=%d -> position=%d\n" key hash_val position
  ) keys;
  
  print_endline "";
  print_endline "5. POURQUOI C'EST RAPIDE:";
  print_endline "   - Pas besoin de parcourir tout le tableau";
  print_endline "   - Accès direct à la bonne case";
  print_endline "   - Recherche limitée à une petite liste"

(* Comparaison avec d'autres structures *)
let compare_data_structures () =
  print_endline "\n=== COMPARAISON DES COMPLEXITÉS ===";
  print_endline "";
  
  let operations = [
    ("Recherche", "O(1) moyen", "O(log n)", "O(n)");
    ("Insertion", "O(1) moyen", "O(log n)", "O(1) en tête, O(n) ailleurs");
    ("Suppression", "O(1) moyen", "O(log n)", "O(n)");
  ] in
  
  Printf.printf "%-12s %-12s %-12s %-12s\n" "Opération" "Hashtable" "Arbre/Map" "Liste";
  print_endline (String.make 60 '-');
  
  List.iter (fun (op, ht, tree, list) ->
    Printf.printf "%-12s %-12s %-12s %-12s\n" op ht tree list
  ) operations;
  
  print_endline "";
  print_endline "Note: 'O(1) moyen' signifie que dans le pire cas (toutes les clés";
  print_endline "dans le même bucket), ça peut devenir O(n). Mais avec une bonne";
  print_endline "fonction de hash, c'est très rare."

let () =
  explain_o1_complexity ();
  compare_data_structures ()
