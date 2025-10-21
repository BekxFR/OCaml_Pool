(*
** Algorithme 1-Nearest Neighbor (1-NN)
** 
** Description : Implémente l'algorithme de classification par plus proche voisin
** avec un seul voisin. Pour classifier un nouveau point, on trouve le point
** d'entraînement le plus proche (selon la distance euclidienne) et on retourne
** sa classe.
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
** La distance euclidienne entre deux points A et B est :
** sqrt(sum((ai - bi)^2)) pour i de 0 à n-1, où n est la dimension des vecteurs.
*)
let euclidean_distance features1 features2 =
  let len1 = Array.length features1 in
  let len2 = Array.length features2 in
  if len1 <> len2 then
    failwith "Les vecteurs doivent avoir la même taille"
  else
    let rec sum_squares_rec i acc =
      if i >= len1 then acc
      else
        let diff = features1.(i) -. features2.(i) in
        sum_squares_rec (i + 1) (acc +. (diff *. diff))
    in
    sqrt (sum_squares_rec 0 0.0)

(*
** Fonction : find_nearest_neighbor
** Description : Trouve le radar le plus proche dans l'ensemble d'entraînement
** Type : radar list -> float array -> radar
** 
** Parcourt tous les radars d'entraînement et retourne celui avec la distance
** minimale au radar de test.
*)
let find_nearest_neighbor training_set test_features =
  match training_set with
  | [] -> failwith "L'ensemble d'entraînement ne peut pas être vide"
  | first_radar :: rest ->
      let (first_features, _) = first_radar in
      let min_distance = ref (euclidean_distance test_features first_features) in
      let nearest = ref first_radar in
      
      List.iter (fun radar ->
        let (features, _) = radar in
        let distance = euclidean_distance test_features features in
        if distance < !min_distance then begin
          min_distance := distance;
          nearest := radar
        end
      ) rest;
      
      !nearest

(*
** Fonction principale : one_nn
** Description : Algorithme 1-NN qui prédit la classe d'un nouveau radar
** Type : radar list -> radar -> string
** 
** Prend un ensemble d'entraînement et un radar de test, retourne la classe
** prédite basée sur le plus proche voisin.
*)
let one_nn training_set test_radar =
  let (test_features, _) = test_radar in
  let (_, nearest_class) = find_nearest_neighbor training_set test_features in
  nearest_class

(*
** Fonctions utilitaires pour les tests
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
** Fonction : test_distances
** Description : Teste le calcul de distances euclidiennes
*)
let test_distances () =
  print_endline "=== Test des distances euclidiennes ===";
  print_newline ();
  
  let point1 = [|0.0; 0.0; 0.0|] in
  let point2 = [|1.0; 1.0; 1.0|] in
  let point3 = [|3.0; 4.0; 0.0|] in
  
  Printf.printf "Distance entre [|0;0;0|] et [|1;1;1|] : %.2f (attendu: %.2f)\n"
    (euclidean_distance point1 point2) (sqrt 3.0);
  Printf.printf "Distance entre [|0;0;0|] et [|3;4;0|] : %.2f (attendu: %.2f)\n"
    (euclidean_distance point1 point3) 5.0;
  Printf.printf "Distance entre [|1;1;1|] et [|3;4;0|] : %.2f\n"
    (euclidean_distance point2 point3);
  print_newline ()

(*
** Fonction : test_one_nn
** Description : Teste l'algorithme 1-NN avec des exemples prédéfinis
*)
let test_one_nn () =
  print_endline "=== Test de l'algorithme 1-NN ===";
  print_newline ();
  
  (* Ensemble d'entraînement *)
  let training_set = [
    ([|1.0; 2.0; 1.5|], "good");
    ([|2.0; 1.0; 2.0|], "good");
    ([|0.5; 0.5; 1.0|], "good");
    ([|-1.0; -2.0; -1.5|], "bad");
    ([|-2.0; -1.0; -2.0|], "bad");
    ([|-0.5; -0.5; -1.0|], "bad");
    ([|0.0; 0.0; 0.0|], "neutral");
  ] in
  
  print_endline "Ensemble d'entraînement :";
  List.iteri (fun i radar ->
    print_string ("  " ^ string_of_int (i + 1) ^ ". ");
    print_radar radar;
    print_newline ()
  ) training_set;
  print_newline ();
  
  (* Tests de classification *)
  let test_cases = [
    ([|1.1; 1.9; 1.4|], "Proche des 'good'");
    ([|-1.1; -1.9; -1.4|], "Proche des 'bad'");
    ([|0.1; 0.1; 0.1|], "Proche du 'neutral'");
    ([|5.0; 5.0; 5.0|], "Point éloigné");
    ([|-5.0; -5.0; -5.0|], "Point éloigné");
  ] in
  
  print_endline "Tests de classification :";
  List.iteri (fun i (test_features, description) ->
    let test_radar = (test_features, "unknown") in
    let predicted_class = one_nn training_set test_radar in
    print_string ("  Test " ^ string_of_int (i + 1) ^ " (" ^ description ^ ") : ");
    print_radar (test_features, predicted_class);
    print_newline ()
  ) test_cases;
  print_newline ()

(*
** Fonction : test_edge_cases
** Description : Teste les cas limites et la gestion d'erreur
*)
let test_edge_cases () =
  print_endline "=== Test des cas limites ===";
  print_newline ();
  
  (* Test avec un seul élément dans l'ensemble d'entraînement *)
  let single_training = [([|1.0; 2.0|], "solo")] in
  let test_radar = ([|1.5; 2.5|], "unknown") in
  let result = one_nn single_training test_radar in
  Printf.printf "Test avec un seul élément d'entraînement : %s\n" result;
  
  (* Test de gestion d'erreur pour ensemble vide *)
  (try
    let _ = one_nn [] test_radar in
    print_endline "ERREUR : devrait lever une exception pour ensemble vide"
  with
  | Failure msg -> Printf.printf "Exception attendue pour ensemble vide : %s\n" msg);
  
  (* Test de gestion d'erreur pour vecteurs de tailles différentes *)
  (try
    let mixed_training = [([|1.0; 2.0|], "small"); ([|1.0; 2.0; 3.0|], "big")] in
    let test_mixed = ([|1.0; 2.0|], "unknown") in
    let _ = one_nn mixed_training test_mixed in
    print_endline "ERREUR : devrait lever une exception pour tailles différentes"
  with
  | Failure msg -> Printf.printf "Exception attendue pour tailles différentes : %s\n" msg);
  
  print_newline ()

(*
** Test avec l'exercice précédent et vraies données
*)
let test_with_file_examples () =
  print_endline "=== Test avec exemples de fichier (données Ionosphere) ===";
  print_newline ();
  
  (* Test avec des données extraites des vrais fichiers CSV *)
  let ionosphere_training_data = [
    (* Quelques exemples extraits des fichiers CSV réels *)
    ([|1.0; 0.0; 0.99539; -0.05889; 0.85243; 0.02306; 0.83398; -0.37708; 1.0; 0.03760; 0.85243; -0.17755; 0.59755; -0.44945; 0.60536; -0.38223; 0.84356; -0.38542; 0.58212; -0.32192; 0.56971; -0.29674; 0.36946; -0.47357; 0.56811; -0.51171; 0.41078; -0.46168; 0.21266; -0.34090; 0.42267; -0.54487; 0.18641; -0.45300|], "g");
    ([|1.0; 0.0; 1.0; -0.18829; 0.93035; -0.36156; -0.10868; -0.93597; 1.0; -0.04549; 0.50874; -0.67743; 0.34432; -0.69707; -0.51685; -0.97515; 0.05499; -0.62237; 0.33109; -1.0; -0.13151; -0.45300; -0.18056; -0.35734; -0.20332; -0.26569; -0.20468; -0.18401; -0.19040; -0.11593; -0.16626; -0.06288; -0.13738; -0.02447|], "b");
    ([|1.0; 0.0; 1.0; -0.03365; 1.0; 0.00485; 1.0; -0.12062; 0.88965; 0.01198; 0.73082; 0.05346; 0.85443; 0.00827; 0.54591; 0.00299; 0.83775; -0.13644; 0.75535; -0.08540; 0.70887; -0.27502; 0.43385; -0.12062; 0.57528; -0.40220; 0.58984; -0.22145; 0.43100; -0.17365; 0.60436; -0.24180; 0.56045; -0.38238|], "g");
    ([|0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 1.0; -1.0; 0.0; 0.0; -1.0; -1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; -1.0; -1.0; 0.0; 0.0; 0.0; 0.0; 1.0; 1.0; 1.0; 1.0; 0.0; 0.0; 1.0; 1.0; 0.0; 0.0|], "b");
    ([|1.0; 0.0; 0.96355; -0.07198; 1.0; -0.14333; 1.0; -0.21313; 1.0; -0.36174; 0.92570; -0.43569; 0.94510; -0.40668; 0.90392; -0.46381; 0.98305; -0.35257; 0.84537; -0.66020; 0.75346; -0.60589; 0.69637; -0.64225; 0.85106; -0.65440; 0.57577; -0.69712; 0.25435; -0.63919; 0.45114; -0.72779; 0.38895; -0.73420|], "g");
  ] in
  
  let test_cases_ionosphere = [
    (* Test proche du premier 'g' *)
    ([|1.0; 0.0; 0.99000; -0.06000; 0.85000; 0.02000; 0.83000; -0.37000; 0.99000; 0.04000; 0.85000; -0.18000; 0.60000; -0.45000; 0.61000; -0.38000; 0.84000; -0.39000; 0.58000; -0.32000; 0.57000; -0.30000; 0.37000; -0.47000; 0.57000; -0.51000; 0.41000; -0.46000; 0.21000; -0.34000; 0.42000; -0.54000; 0.19000; -0.45000|], "Proche du 'g' de référence");
    (* Test proche du premier 'b' *)
    ([|1.0; 0.0; 1.0; -0.19000; 0.93000; -0.36000; -0.11000; -0.94000; 1.0; -0.05000; 0.51000; -0.68000; 0.34000; -0.70000; -0.52000; -0.98000; 0.05000; -0.62000; 0.33000; -1.0; -0.13000; -0.45000; -0.18000; -0.36000; -0.20000; -0.27000; -0.20000; -0.18000; -0.19000; -0.12000; -0.17000; -0.06000; -0.14000; -0.02000|], "Proche du 'b' de référence");
    (* Test point avec des valeurs moyennes *)
    ([|0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 0.0|], "Point avec valeurs moyennes");
  ] in
  
  print_endline "Test avec données réelles Ionosphere (34 features) :";
  List.iteri (fun i (test_features, description) ->
    let test_radar = (test_features, "unknown") in
    let predicted_class = one_nn ionosphere_training_data test_radar in
    Printf.printf "  Test %d (%s) : -> \"%s\"\n"
      (i + 1) description predicted_class;
    Printf.printf "    Premier feature: %.3f, Dernier feature: %.3f\n"
      test_features.(0) test_features.(Array.length test_features - 1)
  ) test_cases_ionosphere;
  print_newline ();
  
  (* Analyse des caractéristiques du dataset *)
  print_endline "Analyse du dataset Ionosphere :";
  Printf.printf "- Nombre de features : %d\n" (Array.length (fst (List.hd ionosphere_training_data)));
  Printf.printf "- Classes présentes : g (good radar), b (bad radar)\n";
  Printf.printf "- Domaine d'application : Détection d'électrons libres dans l'ionosphère\n";
  Printf.printf "- Format des données : Valeurs normalisées entre -1 et 1\n";
  print_newline ();
  
  (* Test de performance avec un petit échantillon *)
  print_endline "Test de performance sur échantillon :";
  let correct_predictions = ref 0 in
  let total_tests = List.length test_cases_ionosphere - 1 in
  List.iteri (fun i (test_features, description) ->
    if i < 2 then begin
      let test_radar = (test_features, "unknown") in
      let predicted_class = one_nn ionosphere_training_data test_radar in
      let expected_class = if i = 0 then "g" else "b" in
      let is_correct = predicted_class = expected_class in
      if is_correct then incr correct_predictions;
      Printf.printf "  Test %d : Prédit=%s, Attendu=%s %s\n"
        (i + 1) predicted_class expected_class (if is_correct then "✓" else "✗")
    end
  ) test_cases_ionosphere;
  
  let accuracy = (float_of_int !correct_predictions) /. (float_of_int total_tests) in
  Printf.printf "Précision sur échantillon : %d/%d (%.1f%%)\n" 
    !correct_predictions total_tests (accuracy *. 100.0);
  print_newline ()

(*
** Fonction d'évaluation avancée
*)
let evaluate_classifier training_set test_set =
  let correct = ref 0 in
  let total = List.length test_set in
  
  print_endline "=== Évaluation détaillée du classificateur ===";
  print_newline ();
  
  List.iteri (fun i (test_features, true_class) ->
    let test_radar = (test_features, "unknown") in
    let predicted_class = one_nn training_set test_radar in
    let is_correct = predicted_class = true_class in
    
    if is_correct then incr correct;
    
    Printf.printf "Test %d: [|" (i + 1);
    Array.iteri (fun j x ->
      if j > 0 then print_string "; ";
      Printf.printf "%.2f" x
    ) test_features;
    Printf.printf "|] -> Prédit: \"%s\", Réel: \"%s\" %s\n"
      predicted_class true_class 
      (if is_correct then "✓" else "✗")
  ) test_set;
  
  let accuracy = (float_of_int !correct) /. (float_of_int total) in
  Printf.printf "\nPrécision: %d/%d (%.1f%%)\n" !correct total (accuracy *. 100.0);
  print_newline ()

(*
** Test complet avec évaluation
*)
let test_complete_evaluation () =
  print_endline "=== Test complet avec évaluation ===";
  print_newline ();
  
  (* Ensemble d'entraînement plus large *)
  let training_set = [
    ([|2.0; 3.0; 1.0|], "A");
    ([|1.8; 2.9; 1.1|], "A");
    ([|2.2; 3.1; 0.9|], "A");
    ([|-1.0; -2.0; -0.5|], "B");
    ([|-1.2; -1.8; -0.6|], "B");
    ([|-0.8; -2.2; -0.4|], "B");
    ([|0.1; 0.1; 3.0|], "C");
    ([|0.0; 0.2; 2.9|], "C");
    ([|0.2; 0.0; 3.1|], "C");
  ] in
  
  (* Ensemble de test *)
  let test_set = [
    ([|1.9; 2.95; 1.05|], "A");  (* Devrait être classifié comme A *)
    ([|-1.1; -1.9; -0.55|], "B"); (* Devrait être classifié comme B *)
    ([|0.15; 0.15; 2.95|], "C");  (* Devrait être classifié comme C *)
    ([|0.0; 0.0; 0.0|], "?");     (* Point ambiguë *)
    ([|10.0; 10.0; 10.0|], "?");  (* Point très éloigné *)
  ] in
  
  evaluate_classifier training_set test_set

(*
** Fonction pour lire un fichier CSV simple (optionnelle)
** Note: Cette fonction est fournie pour montrer l'intégration avec l'ex06
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
** Test intégré avec les vrais fichiers CSV (si disponibles)
*)
let test_with_real_csv_files () =
  print_endline "=== Test avec fichiers CSV réels (si disponibles) ===";
  print_newline ();
  
  (* Tentative de lecture des fichiers depuis l'exercice précédent *)
  let training_file = "../ex06/ionosphere.train.csv" in
  let test_file = "../ex06/ionosphere.test.csv" in
  
  let training_data = read_csv_simple training_file in
  let test_data = read_csv_simple test_file in
  
  if training_data = [] || test_data = [] then begin
    print_endline "Fichiers CSV non trouvés, utilisation des données intégrées";
    print_endline "Pour utiliser les vrais fichiers, copiez ionosphere.*.csv depuis ex06/";
  end else begin
    Printf.printf "Fichiers CSV chargés avec succès !\n";
    Printf.printf "- Données d'entraînement : %d exemples\n" (List.length training_data);
    Printf.printf "- Données de test : %d exemples\n" (List.length test_data);
    print_newline ();
    
    (* Test sur un échantillon des vraies données *)
    let rec take n lst =
      match n, lst with
      | 0, _ -> []
      | _, [] -> []
      | n, x :: xs -> x :: take (n - 1) xs
    in
    let sample_test = take 5 test_data in
    print_endline "Test sur échantillon de données réelles :";
    let correct = ref 0 in
    List.iteri (fun i (test_features, true_class) ->
      let test_radar = (test_features, "unknown") in
      let predicted_class = one_nn training_data test_radar in
      let is_correct = predicted_class = true_class in
      if is_correct then incr correct;
      Printf.printf "  Test %d: Prédit=\"%s\", Réel=\"%s\" %s\n"
        (i + 1) predicted_class true_class (if is_correct then "✓" else "✗")
    ) sample_test;
    
    let accuracy = (float_of_int !correct) /. (float_of_int (List.length sample_test)) in
    Printf.printf "Précision sur échantillon : %d/%d (%.1f%%)\n" 
      !correct (List.length sample_test) (accuracy *. 100.0);
  end;
  print_newline ()

(*
** Point d'entrée principal
*)
let () =
  test_distances ();
  test_one_nn ();
  test_edge_cases ();
  test_with_file_examples ();
  test_complete_evaluation ();
  test_with_real_csv_files ()