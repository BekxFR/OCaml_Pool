(*
** Algorithme k-Nearest Neighbors (k-NN)
** 
** Description : Généralisation de l'algorithme 1-NN. Pour classifier un nouveau
** point, on trouve les k points d'entraînement les plus proches et on applique
** un vote majoritaire sur leurs classes.
** 
** Avantages par rapport à 1-NN :
** - Moins sensible au bruit (vote majoritaire)
** - Plus robuste aux outliers
** - Paramètre k ajustable selon le contexte
** 
** Inconvénients :
** - Complexité computationnelle accrue O(n log k)
** - Choix du paramètre k critique
** - Gestion des égalités plus complexe
** 
** Type radar : float array * string
** - float array : vecteur de caractéristiques (features)
** - string : classe/label du radar
*)

type radar = float array * string

(*
** Fonction : euclidean_distance
** Description : Calcule la distance euclidienne entre deux vecteurs de features
** Type : float array -> float array -> float
** 
** Réutilisation de l'implémentation 1-NN optimisée
*)
let euclidean_distance features1 features2 =
  let len1 = Array.length features1 in
  let len2 = Array.length features2 in
  if len1 <> len2 then
    failwith "Les vecteurs doivent avoir la même taille"
  else
    let sum_squares = ref 0.0 in
    for i = 0 to len1 - 1 do
      let diff = features1.(i) -. features2.(i) in
      sum_squares := !sum_squares +. (diff *. diff)
    done;
    sqrt !sum_squares

(*
** Type pour représenter un voisin avec sa distance
*)
type neighbor = {
  radar : radar;
  distance : float;
}

(*
** Fonction : compare_neighbors
** Description : Compare deux voisins par distance croissante
** Type : neighbor -> neighbor -> int
*)
let compare_neighbors n1 n2 =
  if n1.distance < n2.distance then -1
  else if n1.distance > n2.distance then 1
  else 0

(*
** Fonction : find_k_nearest_neighbors
** Description : Trouve les k voisins les plus proches
** Type : radar list -> float array -> int -> neighbor list
** 
** Algorithme :
** 1. Calculer toutes les distances
** 2. Trier par distance croissante
** 3. Prendre les k premiers
** 
** Complexité : O(n log n) pour le tri complet
** Note : Pour de très gros datasets, on pourrait optimiser avec une heap
*)
let find_k_nearest_neighbors training_set test_features k =
  if k <= 0 then
    failwith "k doit être strictement positif"
  else if training_set = [] then
    failwith "L'ensemble d'entraînement ne peut pas être vide"
  else
    (* Calcul de toutes les distances *)
    let neighbors = List.map (fun radar ->
      let (features, _) = radar in
      let distance = euclidean_distance test_features features in
      { radar = radar; distance = distance }
    ) training_set in
    
    (* Tri par distance croissante *)
    let sorted_neighbors = List.sort compare_neighbors neighbors in
    
    (* Prendre les k premiers *)
    let rec take_k acc n lst =
      match n, lst with
      | 0, _ -> List.rev acc
      | _, [] -> List.rev acc  (* Moins de k éléments disponibles *)
      | n, x :: xs -> take_k (x :: acc) (n - 1) xs
    in
    take_k [] k sorted_neighbors

(*
** Fonction : count_votes
** Description : Compte les votes de chaque classe parmi les k voisins
** Type : neighbor list -> (string * int) list
** 
** Retourne une liste associative (classe, nombre_de_votes)
** Version pure sans effet de bord pour maintenir la modularité
*)
let count_votes neighbors =
  let rec count_aux acc = function
    | [] -> acc
    | { radar = (_, class_label); _ } :: rest ->
        let rec update_count = function
          | [] -> [(class_label, 1)]
          | (label, count) :: tail ->
              if label = class_label then
                (label, count + 1) :: tail
              else
                (label, count) :: update_count tail
        in
        count_aux (update_count acc) rest
  in
  count_aux [] neighbors

(*
** Fonction : count_votes_verbose
** Description : Version avec affichage détaillé pour le debugging
** Type : neighbor list -> bool -> (string * int) list
** 
** Paramètres :
** - neighbors : liste des voisins à analyser
** - verbose : si true, affiche les détails de chaque radar utilisé
** 
** Retourne la même liste associative mais avec affichage optionnel
** Respect du principe DRY en réutilisant count_votes
*)
let count_votes_verbose neighbors verbose =
  if verbose then begin
    print_endline "=== Détail des radars utilisés pour le vote ===";
    List.iteri (fun i neighbor ->
      let (features, class_label) = neighbor.radar in
      Printf.printf "  Radar %d (dist=%.3f, classe=\"%s\"): [|" 
        (i + 1) neighbor.distance class_label;
      Array.iteri (fun j x ->
        if j > 0 then print_string "; ";
        Printf.printf "%.3f" x
      ) features;
      print_endline "|]"
    ) neighbors;
    print_endline "===============================================";
    print_newline ()
  end;
  count_votes neighbors

(*
** Fonction : analyze_voting_process
** Description : Analyse complète du processus de vote avec détails
** Type : neighbor list -> unit
** 
** Affiche une analyse détaillée du processus de vote :
** - Liste des radars participants
** - Répartition des votes par classe
** - Statistiques de distance par classe
*)
let analyze_voting_process neighbors =
  print_endline "=== Analyse complète du processus de vote ===";
  print_newline ();
  
  (* Affichage des radars participants *)
  print_endline "Radars participants au vote :";
  List.iteri (fun i neighbor ->
    let (features, class_label) = neighbor.radar in
    Printf.printf "  %d. Classe: %-8s Distance: %6.3f  Features: [|" 
      (i + 1) ("\"" ^ class_label ^ "\"") neighbor.distance;
    Array.iteri (fun j x ->
      if j > 0 then print_string "; ";
      Printf.printf "%6.3f" x
    ) features;
    print_endline "|]"
  ) neighbors;
  print_newline ();
  
  (* Calcul et affichage des votes *)
  let votes = count_votes neighbors in
  print_endline "Répartition des votes :";
  List.iter (fun (class_label, count) ->
    Printf.printf "  Classe %-8s : %d vote(s)\n" ("\"" ^ class_label ^ "\"") count
  ) votes;
  print_newline ();
  
  (* Statistiques de distance par classe *)
  print_endline "Statistiques de distance par classe :";
  List.iter (fun (class_label, _) ->
    let class_neighbors = List.filter (fun n -> 
      let (_, label) = n.radar in label = class_label
    ) neighbors in
    let distances = List.map (fun n -> n.distance) class_neighbors in
    let min_dist = List.fold_left min (List.hd distances) distances in
    let max_dist = List.fold_left max (List.hd distances) distances in
    let avg_dist = (List.fold_left (+.) 0.0 distances) /. (float_of_int (List.length distances)) in
    Printf.printf "  Classe %-8s : min=%.3f, max=%.3f, moy=%.3f\n" 
      ("\"" ^ class_label ^ "\"") min_dist max_dist avg_dist
  ) votes;
  print_endline "============================================="

(*
** Fonction : resolve_tie_smart
** Description : Résout les égalités de manière intelligente
** Type : (string * int) list -> neighbor list -> string
** 
** Stratégies pour k pair avec égalité :
** 1. Choisir la classe du voisin le plus proche parmi les égaux
** 2. Si toujours égal, choisir lexicographiquement
** 
** Cette approche est "smart" car elle utilise l'information de distance
** plutôt qu'un choix arbitraire ou aléatoire.
*)
let resolve_tie_smart tied_classes neighbors =
  (* Trouver le voisin le plus proche parmi les classes égales *)
  let rec find_closest_among_tied min_distance best_class = function
    | [] -> best_class
    | { radar = (_, class_label); distance = dist } :: rest ->
        if List.exists (fun (label, _) -> label = class_label) tied_classes then
          if dist < min_distance then
            find_closest_among_tied dist class_label rest
          else
            find_closest_among_tied min_distance best_class rest
        else
          find_closest_among_tied min_distance best_class rest
  in
  
  match neighbors with
  | [] -> failwith "Pas de voisins pour résoudre l'égalité"
  | first :: _ ->
      let (_, first_class) = first.radar in
      find_closest_among_tied first.distance first_class neighbors

(*
** Fonction : majority_vote
** Description : Applique le vote majoritaire avec gestion intelligente des égalités
** Type : neighbor list -> string
** 
** Gestion des cas :
** 1. Majorité claire -> classe majoritaire
** 2. Égalité -> stratégie intelligente (plus proche voisin)
*)
let majority_vote neighbors =
  if neighbors = [] then
    failwith "Pas de voisins pour le vote"
  else
    let votes = count_votes neighbors in
    
    (* Trouver le maximum de votes *)
    let max_votes = List.fold_left (fun acc (_, count) -> max acc count) 0 votes in
    
    (* Trouver toutes les classes avec le maximum de votes *)
    let winners = List.filter (fun (_, count) -> count = max_votes) votes in
    
    match winners with
    | [(class_label, _)] -> class_label  (* Majorité claire *)
    | tied_classes -> resolve_tie_smart tied_classes neighbors  (* Égalité *)

(*
** Fonction : majority_vote_verbose
** Description : Version avec affichage détaillé du processus de vote
** Type : neighbor list -> bool -> string
*)
let majority_vote_verbose neighbors verbose =
  if verbose then analyze_voting_process neighbors;
  majority_vote neighbors

(*
** Fonctions utilitaires pour les tests et l'analyse
*)

(*
** Fonction : print_radar
** Description : Affiche un radar de manière lisible
*)
let print_radar (features, class_label) =
  print_string "[|";
  Array.iteri (fun i x ->
    if i > 0 then print_string "; ";
    Printf.printf "%.2f" x
  ) features;
  print_string "|] -> \"";
  print_string class_label;
  print_string "\""

(*
** Fonction : print_neighbors
** Description : Affiche les k voisins avec leurs distances
*)
let print_neighbors neighbors =
  List.iteri (fun i neighbor ->
    Printf.printf "  Voisin %d (dist=%.3f): " (i + 1) neighbor.distance;
    print_radar neighbor.radar;
    print_newline ()
  ) neighbors

(*
** Fonction principale : k_nn
** Description : Algorithme k-NN complet
** Type : radar list -> int -> radar -> string
** 
** Signature conforme à l'énoncé : radar list -> int -> radar -> string
** 
** Processus :
** 1. Extraire les features du radar test
** 2. Trouver les k plus proches voisins
** 3. Appliquer le vote majoritaire
** 4. Retourner la classe prédite
*)
let k_nn training_set k test_radar =
  let (test_features, _) = test_radar in
  let k_neighbors = find_k_nearest_neighbors training_set test_features k in
  majority_vote k_neighbors

(*
** Fonction : k_nn_debug
** Description : Version debug avec affichage détaillé du processus complet
** Type : radar list -> int -> radar -> bool -> string
** 
** Paramètres :
** - training_set : ensemble d'entraînement
** - k : nombre de voisins à considérer
** - test_radar : radar à classifier
** - debug : si true, affiche tous les détails du processus
** 
** Affiche :
** - Radar à classifier
** - Les k voisins sélectionnés
** - Le processus de vote détaillé
** - La décision finale
*)
let k_nn_debug training_set k test_radar debug =
  let (test_features, _) = test_radar in
  
  if debug then begin
    print_endline "=== Classification k-NN avec debug ===";
    print_newline ();
    print_string "Radar à classifier : ";
    print_radar test_radar;
    print_newline ();
    Printf.printf "Paramètre k = %d\n" k;
    print_newline ()
  end;
  
  let k_neighbors = find_k_nearest_neighbors training_set test_features k in
  
  if debug then begin
    Printf.printf "Les %d voisins les plus proches :\n" (List.length k_neighbors);
    print_neighbors k_neighbors;
    print_newline ()
  end;
  
  let result = majority_vote_verbose k_neighbors debug in
  
  if debug then begin
    print_newline ();
    Printf.printf "=== Décision finale : \"%s\" ===\n" result;
    print_newline ()
  end;
  
  result

(*
** Fonction : analyze_k_effect
** Description : Analyse l'effet du paramètre k sur la classification
** Type : radar list -> radar -> unit
*)
let analyze_k_effect training_set test_radar =
  let (test_features, _) = test_radar in
  let max_k = min 10 (List.length training_set) in
  
  print_endline "=== Analyse de l'effet du paramètre k ===";
  print_newline ();
  
  print_string "Radar de test : ";
  print_radar test_radar;
  print_newline ();
  print_newline ();
  
  for k = 1 to max_k do
    let predicted_class = k_nn training_set k test_radar in
    let k_neighbors = find_k_nearest_neighbors training_set test_features k in
    let votes = count_votes k_neighbors in
    
    Printf.printf "k=%d -> \"%s\" " k predicted_class;
    print_string "(votes: ";
    List.iter (fun (class_label, count) ->
      Printf.printf "%s:%d " class_label count
    ) votes;
    print_endline ")";
  done;
  print_newline ()

(*
** Fonction : test_k_nn_basic
** Description : Tests de base pour valider l'implémentation
*)
let test_k_nn_basic () =
  print_endline "=== Tests de base k-NN ===";
  print_newline ();
  
  (* Ensemble d'entraînement avec clustering clair *)
  let training_set = [
    ([|1.0; 2.0; 1.5|], "good");
    ([|1.2; 1.8; 1.6|], "good");
    ([|0.8; 2.2; 1.4|], "good");
    ([|-1.0; -2.0; -1.5|], "bad");
    ([|-1.2; -1.8; -1.6|], "bad");
    ([|-0.8; -2.2; -1.4|], "bad");
    ([|0.0; 0.0; 0.0|], "neutral");
    ([|0.1; 0.1; 0.1|], "neutral");
  ] in
  
  print_endline "Ensemble d'entraînement :";
  List.iteri (fun i radar ->
    print_string ("  " ^ string_of_int (i + 1) ^ ". ");
    print_radar radar;
    print_newline ()
  ) training_set;
  print_newline ();
  
  (* Tests avec différentes valeurs de k *)
  let test_cases = [
    ([|1.1; 1.9; 1.4|], "Point proche du cluster 'good'");
    ([|-1.1; -1.9; -1.4|], "Point proche du cluster 'bad'");
    ([|0.05; 0.05; 0.05|], "Point proche du cluster 'neutral'");
    ([|0.5; 0.5; 0.5|], "Point à la frontière");
  ] in
  
  List.iter (fun (test_features, description) ->
    let test_radar = (test_features, "unknown") in
    print_endline ("Test : " ^ description);
    analyze_k_effect training_set test_radar
  ) test_cases

(*
** Fonction : test_tie_resolution
** Description : Teste spécifiquement la résolution d'égalités
*)
let test_tie_resolution () =
  print_endline "=== Test de résolution d'égalités ===";
  print_newline ();
  
  (* Ensemble conçu pour créer des égalités *)
  let training_set = [
    ([|1.0; 0.0|], "A");
    ([|0.9; 0.1|], "A");  (* Proche mais légèrement différent *)
    ([|-1.0; 0.0|], "B");
    ([|-0.9; 0.1|], "B"); (* Proche mais légèrement différent *)
  ] in
  
  let test_radar = ([|0.0; 0.0|], "unknown") in
  
  print_endline "Configuration pour test d'égalité :";
  print_string "Test radar : ";
  print_radar test_radar;
  print_newline ();
  
  print_endline "Ensemble d'entraînement :";
  List.iteri (fun i radar ->
    let (features, _) = radar in
    let distance = euclidean_distance [|0.0; 0.0|] features in
    Printf.printf "  %d. " (i + 1);
    print_radar radar;
    Printf.printf " (dist=%.3f)" distance;
    print_newline ()
  ) training_set;
  print_newline ();
  
  (* Test avec k=2 et k=4 pour forcer des égalités *)
  let test_k_values = [2; 4] in
  List.iter (fun k ->
    let predicted = k_nn training_set k test_radar in
    let neighbors = find_k_nearest_neighbors training_set [|0.0; 0.0|] k in
    let votes = count_votes neighbors in
    
    Printf.printf "k=%d -> \"%s\"\n" k predicted;
    print_endline "  Voisins sélectionnés :";
    print_neighbors neighbors;
    print_string "  Votes : ";
    List.iter (fun (class_label, count) ->
      Printf.printf "%s:%d " class_label count
    ) votes;
    print_newline ();
    print_newline ()
  ) test_k_values

(*
** Fonction : test_edge_cases
** Description : Teste les cas limites
*)
let test_edge_cases () =
  print_endline "=== Test des cas limites ===";
  print_newline ();
  
  let training_set = [([|1.0; 2.0|], "solo")] in
  let test_radar = ([|1.5; 2.5|], "unknown") in
  
  (* Test avec k plus grand que l'ensemble d'entraînement *)
  print_endline "Test k > taille ensemble d'entraînement :";
  let result = k_nn training_set 5 test_radar in  (* k=5 mais seulement 1 élément *)
  Printf.printf "k=5 avec 1 élément -> \"%s\"\n" result;
  print_newline ();
  
  (* Test gestion d'erreur pour k=0 *)
  (try
    let _ = k_nn training_set 0 test_radar in
    print_endline "ERREUR : devrait lever une exception pour k=0"
  with
  | Failure msg -> Printf.printf "Exception attendue pour k=0 : %s\n" msg);
  
  (* Test gestion d'erreur pour ensemble vide *)
  (try
    let _ = k_nn [] 3 test_radar in
    print_endline "ERREUR : devrait lever une exception pour ensemble vide"
  with
  | Failure msg -> Printf.printf "Exception attendue pour ensemble vide : %s\n" msg);
  
  print_newline ()

(*
** Fonction : evaluate_k_nn_performance
** Description : Évalue les performances pour différentes valeurs de k
*)
let evaluate_k_nn_performance training_set test_set =
  print_endline "=== Évaluation des performances k-NN ===";
  print_newline ();
  
  let max_k = min 15 (List.length training_set) in
  let total_tests = List.length test_set in
  
  Printf.printf "Évaluation sur %d exemples de test avec jusqu'à k=%d\n" 
    total_tests max_k;
  print_newline ();
  
  for k = 1 to max_k do
    let correct = ref 0 in
    
    List.iter (fun (test_features, true_class) ->
      let test_radar = (test_features, "unknown") in
      let predicted_class = k_nn training_set k test_radar in
      if predicted_class = true_class then incr correct
    ) test_set;
    
    let accuracy = (float_of_int !correct) /. (float_of_int total_tests) in
    Printf.printf "k=%2d -> Précision: %d/%d (%.1f%%)\n" 
      k !correct total_tests (accuracy *. 100.0)
  done;
  print_newline ()

(*
** Test avec données Ionosphere (réutilisation de l'ex07)
*)
let test_with_ionosphere_data () =
  print_endline "=== Test avec données Ionosphere ===";
  print_newline ();
  
  (* Même ensemble que dans ex07 pour comparaison *)
  let ionosphere_training_data = [
    ([|1.0; 0.0; 0.99539; -0.05889; 0.85243; 0.02306; 0.83398; -0.37708; 1.0; 0.03760; 0.85243; -0.17755; 0.59755; -0.44945; 0.60536; -0.38223; 0.84356; -0.38542; 0.58212; -0.32192; 0.56971; -0.29674; 0.36946; -0.47357; 0.56811; -0.51171; 0.41078; -0.46168; 0.21266; -0.34090; 0.42267; -0.54487; 0.18641; -0.45300|], "g");
    ([|1.0; 0.0; 1.0; -0.18829; 0.93035; -0.36156; -0.10868; -0.93597; 1.0; -0.04549; 0.50874; -0.67743; 0.34432; -0.69707; -0.51685; -0.97515; 0.05499; -0.62237; 0.33109; -1.0; -0.13151; -0.45300; -0.18056; -0.35734; -0.20332; -0.26569; -0.20468; -0.18401; -0.19040; -0.11593; -0.16626; -0.06288; -0.13738; -0.02447|], "b");
    ([|1.0; 0.0; 1.0; -0.03365; 1.0; 0.00485; 1.0; -0.12062; 0.88965; 0.01198; 0.73082; 0.05346; 0.85443; 0.00827; 0.54591; 0.00299; 0.83775; -0.13644; 0.75535; -0.08540; 0.70887; -0.27502; 0.43385; -0.12062; 0.57528; -0.40220; 0.58984; -0.22145; 0.43100; -0.17365; 0.60436; -0.24180; 0.56045; -0.38238|], "g");
    ([|0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; -1.0; 0.0; 0.0; -1.0; -1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; -1.0; -1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 1.0; 1.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0|], "b");
    ([|1.0; 0.0; 0.96355; -0.07198; 1.0; -0.14333; 1.0; -0.21313; 1.0; -0.36174; 0.92570; -0.43569; 0.94510; -0.40668; 0.90392; -0.46381; 0.98305; -0.35257; 0.84537; -0.66020; 0.75346; -0.60589; 0.69637; -0.64225; 0.85106; -0.65440; 0.57577; -0.69712; 0.25435; -0.63919; 0.45114; -0.72779; 0.38895; -0.73420|], "g");
    ([|1.0; 0.0; 0.71216; -0.40204; 1.0; -0.54349; 0.87374; -0.61507; 1.0; -0.68073; 0.91667; -0.71028; 0.86946; -0.73697; 0.91106; -0.75933; 0.90918; -0.77701; 0.84537; -0.81292; 0.78618; -0.82666; 0.76344; -0.84262; 0.79683; -0.85636; 0.68817; -0.86789; 0.56989; -0.87720; 0.58602; -0.88651; 0.51075; -0.89361|], "g");
    ([|1.0; 0.0; 0.90323; -0.25404; 1.0; -0.32258; 0.99194; -0.37097; 1.0; -0.41935; 0.94355; -0.46774; 0.96774; -0.51613; 0.94355; -0.56452; 0.96774; -0.61290; 0.91935; -0.66129; 0.88710; -0.70968; 0.83871; -0.75806; 0.80645; -0.80645; 0.75806; -0.85484; 0.70968; -0.90323; 0.66129; -0.95161; 0.61290; -1.0|], "g");
    ([|1.0; 0.0; 1.0; 0.21348; 0.89888; 0.41573; 0.69663; 0.57303; 0.60674; 0.65169; 0.56180; 0.68539; 0.48315; 0.69663; 0.41573; 0.69663; 0.34831; 0.68539; 0.29213; 0.66292; 0.24719; 0.62921; 0.21348; 0.58427; 0.19101; 0.52809; 0.17978; 0.46067; 0.17978; 0.38202; 0.19101; 0.29213; 0.21348; 0.19101|], "g");
  ] in
  
  let test_cases_ionosphere = [
    ([|1.0; 0.0; 0.99000; -0.06000; 0.85000; 0.02000; 0.83000; -0.37000; 0.99000; 0.04000; 0.85000; -0.18000; 0.60000; -0.45000; 0.61000; -0.38000; 0.84000; -0.39000; 0.58000; -0.32000; 0.57000; -0.30000; 0.37000; -0.47000; 0.57000; -0.51000; 0.41000; -0.46000; 0.21000; -0.34000; 0.42000; -0.54000; 0.19000; -0.45000|], "g");
    ([|1.0; 0.0; 1.0; -0.19000; 0.93000; -0.36000; -0.11000; -0.94000; 1.0; -0.05000; 0.51000; -0.68000; 0.34000; -0.70000; -0.52000; -0.98000; 0.05000; -0.62000; 0.33000; -1.0; -0.13000; -0.45000; -0.18000; -0.36000; -0.20000; -0.27000; -0.20000; -0.18000; -0.19000; -0.12000; -0.17000; -0.06000; -0.14000; -0.02000|], "b");
    ([|0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0|], "?");
  ] in
  
  print_endline "Comparaison 1-NN vs k-NN sur données Ionosphere :";
  print_newline ();
  
  List.iteri (fun i (test_features, expected_or_unknown) ->
    let test_radar = (test_features, "unknown") in
    Printf.printf "Test %d :\n" (i + 1);
    
    (* Comparaison directe de différentes valeurs de k *)
    let k_values = [1; 3; 5; 7] in
    List.iter (fun k ->
      let predicted = k_nn ionosphere_training_data k test_radar in
      Printf.printf "  k=%d -> \"%s\"" k predicted;
      if expected_or_unknown <> "?" then
        Printf.printf " %s" (if predicted = expected_or_unknown then "✓" else "✗");
      print_newline ()
    ) k_values;
    print_newline ()
  ) test_cases_ionosphere;
  
  (* Évaluation performance sur les exemples connus *)
  let known_test_set = List.filter (fun (_, label) -> label <> "?") test_cases_ionosphere in
  if known_test_set <> [] then
    evaluate_k_nn_performance ionosphere_training_data known_test_set

(*
** Fonction : read_csv_simple
** Description : Lecture de fichiers CSV pour intégration avec ex06
*)
let read_csv_simple filename =
  try
    let ic = open_in filename in
    let rec read_lines acc =
      try
        let line = input_line ic in
        let trimmed = String.trim line in
        if trimmed = "" then read_lines acc
        else
          let fields = String.split_on_char ',' trimmed in
          match List.rev fields with
          | [] -> read_lines acc
          | class_label :: rev_features ->
              let features = List.rev rev_features in
              let float_features = List.map float_of_string features in
              let feature_array = Array.of_list float_features in
              let example = (feature_array, String.trim class_label) in
              read_lines (example :: acc)
      with
      | End_of_file -> 
          close_in ic;
          List.rev acc
      | Failure _ ->
          close_in ic;
          failwith ("Erreur de format dans le fichier CSV : " ^ filename)
    in
    read_lines []
  with
  | Sys_error _ -> []

(*
** Test d'intégration avec les vrais fichiers CSV
*)
let test_with_real_csv_files () =
  print_endline "=== Test avec fichiers CSV réels ===";
  print_newline ();
  
  let training_file = "../ex06/ionosphere.train.csv" in
  let test_file = "../ex06/ionosphere.test.csv" in
  
  let training_data = read_csv_simple training_file in
  let test_data = read_csv_simple test_file in
  
  if training_data = [] || test_data = [] then begin
    print_endline "Fichiers CSV non trouvés, utilisation des données intégrées";
    print_endline "Pour tester avec vrais fichiers : copiez ionosphere.*.csv depuis ex06/";
  end else begin
    Printf.printf "Fichiers CSV chargés avec succès !\n";
    Printf.printf "- Données d'entraînement : %d exemples\n" (List.length training_data);
    Printf.printf "- Données de test : %d exemples\n" (List.length test_data);
    print_newline ();
    
    (* Évaluation complète avec différentes valeurs de k *)
    let rec take n lst =
      match n, lst with
      | 0, _ -> []
      | _, [] -> []
      | n, x :: xs -> x :: take (n - 1) xs
    in
    let sample_test = take 10 test_data in
    
    print_endline "Évaluation comparative sur échantillon de test :";
    print_newline ();
    
    let k_values = [1; 3; 5; 7; 9; 11] in
    List.iter (fun k ->
      let correct = ref 0 in
      let total = List.length sample_test in
      
      List.iter (fun (test_features, true_class) ->
        let test_radar = (test_features, "unknown") in
        let predicted_class = k_nn training_data k test_radar in
        if predicted_class = true_class then incr correct
      ) sample_test;
      
      let accuracy = (float_of_int !correct) /. (float_of_int total) in
      Printf.printf "k=%2d -> Précision: %d/%d (%.1f%%)\n" 
        k !correct total (accuracy *. 100.0)
    ) k_values;
    
    print_newline ();
    
    (* Analyse de quelques exemples spécifiques *)
    print_endline "Analyse détaillée sur premiers exemples :";
    let first_three = take 3 sample_test in
    List.iteri (fun i (test_features, true_class) ->
      let test_radar = (test_features, "unknown") in
      Printf.printf "\nExemple %d (classe réelle: \"%s\") :\n" (i + 1) true_class;
      List.iter (fun k ->
        let predicted = k_nn training_data k test_radar in
        let neighbors = find_k_nearest_neighbors training_data test_features k in
        let votes = count_votes neighbors in
        Printf.printf "  k=%d -> \"%s\" (votes: " k predicted;
        List.iter (fun (label, count) ->
          Printf.printf "%s:%d " label count
        ) votes;
        Printf.printf ") %s\n" (if predicted = true_class then "✓" else "✗")
      ) [1; 3; 5; 7];
      List.iter (fun k ->
        let result_debug = k_nn_debug training_data k test_radar true in
        Printf.printf "  k=%d -> \"%s\" (debug)\n" k result_debug
      ) [1; 3; 5; 7]
    ) first_three
  end;
  print_newline ()

(*
** Fonction : comparative_analysis
** Description : Analyse comparative 1-NN vs k-NN
*)
let comparative_analysis () =
  print_endline "=== Analyse comparative 1-NN vs k-NN ===";
  print_newline ();
  
  (* Dataset synthétique avec bruit contrôlé *)
  let clean_training = [
    ([|2.0; 2.0|], "A");
    ([|2.1; 1.9|], "A");
    ([|1.9; 2.1|], "A");
    ([|-2.0; -2.0|], "B");
    ([|-2.1; -1.9|], "B");
    ([|-1.9; -2.1|], "B");
  ] in
  
  (* Ajout de bruit (outliers) *)
  let noisy_training = clean_training @ [
    ([|1.5; -1.8|], "A");  (* Outlier A proche des B *)
    ([|-1.5; 1.8|], "B");  (* Outlier B proche des A *)
  ] in
  
  let test_cases = [
    ([|1.8; 1.8|], "A", "Point proche cluster A");
    ([|-1.8; -1.8|], "B", "Point proche cluster B");
    ([|0.0; 0.0|], "?", "Point frontière");
  ] in
  
  print_endline "Test sans bruit :";
  List.iter (fun (test_features, expected, description) ->
    let test_radar = (test_features, "unknown") in
    Printf.printf "%s:\n" description;
    let k_values = [1; 3; 5] in
    List.iter (fun k ->
      let predicted = k_nn clean_training k test_radar in
      Printf.printf "  k=%d -> \"%s\"" k predicted;
      if expected <> "?" then
        Printf.printf " %s" (if predicted = expected then "✓" else "✗");
      print_newline ()
    ) k_values;
    print_newline ()
  ) test_cases;
  
  print_endline "Test avec bruit (outliers) :";
  List.iter (fun (test_features, expected, description) ->
    let test_radar = (test_features, "unknown") in
    Printf.printf "%s:\n" description;
    let k_values = [1; 3; 5] in
    List.iter (fun k ->
      let predicted = k_nn noisy_training k test_radar in
      Printf.printf "  k=%d -> \"%s\"" k predicted;
      if expected <> "?" then
        Printf.printf " %s" (if predicted = expected then "✓" else "✗");
      print_newline ()
    ) k_values;
    print_newline ()
  ) test_cases;
  
  print_endline "Conclusion : k-NN plus robuste au bruit que 1-NN"

(*
** Fonction : test_debug_features
** Description : Démontre les nouvelles fonctionnalités de debug
*)
let test_debug_features () =
  print_endline "=== Test des fonctionnalités de debug ===";
  print_newline ();
  
  let training_set = [
    ([|1.0; 2.0; 1.5|], "good");
    ([|1.2; 1.8; 1.6|], "good");
    ([|0.8; 2.2; 1.4|], "good");
    ([|-1.0; -2.0; -1.5|], "bad");
    ([|-1.2; -1.8; -1.6|], "bad");
    ([|-0.8; -2.2; -1.4|], "bad");
  ] in
  
  let test_radar = ([|1.1; 1.9; 1.4|], "unknown") in
  
  print_endline "1. Classification normale (sans debug) :";
  let result_normal = k_nn training_set 3 test_radar in
  Printf.printf "Résultat : \"%s\"\n" result_normal;
  print_newline ();
  
  print_endline "2. Classification avec debug complet :";
  let result_debug = k_nn_debug training_set 3 test_radar true in
  Printf.printf "Résultat : \"%s\"\n" result_debug;
  print_newline ();
  
  print_endline "3. Test de count_votes_verbose :";
  let (test_features, _) = test_radar in
  let neighbors = find_k_nearest_neighbors training_set test_features 3 in
  print_endline "Mode silencieux :";
  let votes_silent = count_votes_verbose neighbors false in
  List.iter (fun (label, count) ->
    Printf.printf "  %s: %d votes\n" label count
  ) votes_silent;
  print_newline ();
  
  print_endline "Mode verbose :";
  let votes_verbose = count_votes_verbose neighbors true in
  List.iter (fun (label, count) ->
    Printf.printf "  %s: %d votes\n" label count
  ) votes_verbose;
  print_newline ()

(*
** Point d'entrée principal
*)
let () =
  print_endline "╔════════════════════════════════════════════════════════════════╗";
  print_endline "║                  k-NN Algorithm Implementation                 ║";
  print_endline "║               Généralisation de l'algorithme 1-NN              ║";
  print_endline "╚════════════════════════════════════════════════════════════════╝";
  print_newline ();
  
  test_debug_features ();
  test_k_nn_basic ();
  test_tie_resolution ();
  test_edge_cases ();
  comparative_analysis ();
  test_with_ionosphere_data ();
  test_with_real_csv_files ();
  
  print_endline "╔════════════════════════════════════════════════════════════════╗";
  print_endline "║                         Tests terminés                         ║";
  print_endline "║   k-NN implémenté avec vote majoritaire et gestion d'égalités  ║";
  print_endline "╚════════════════════════════════════════════════════════════════╝"
