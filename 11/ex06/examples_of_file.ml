(*
** Fonction : examples_of_file
** Description : Lit un fichier CSV et retourne une liste de tuples (features, class)
** Type : string -> (float array * string) list
** 
** Le fichier CSV doit avoir le format suivant :
** - Chaque ligne contient des valeurs séparées par des virgules
** - Les n-1 premières valeurs sont des nombres flottants (features)
** - La dernière valeur est une chaîne de caractères (classe)
** 
** Exemple d'entrée : "1.0,0.5,0.3,g"
** Résultat : ([|1.0; 0.5; 0.3|], "g")
*)

let examples_of_file filepath =
  let ic = open_in filepath in
  let rec read_lines acc =
    try
      let line = input_line ic in
      let trimmed_line = String.trim line in
      if trimmed_line = "" then
        read_lines acc
      else
        let fields = String.split_on_char ',' trimmed_line in
        match List.rev fields with
        | [] -> read_lines acc
        | class_label :: rev_features ->
            let features = List.rev rev_features in
            let float_features = List.map float_of_string features in
            let feature_array = Array.of_list float_features in
            let final_values = (feature_array, String.trim class_label) in
            read_lines (final_values :: acc)
    with
    | End_of_file -> 
        close_in ic;
        List.rev acc
    | Failure _ ->
        close_in ic;
        failwith ("Erreur de format dans le fichier : " ^ filepath)
    | Sys_error msg ->
        failwith ("Erreur système : " ^ msg)
  in
  read_lines []

(*
** Fonction utilitaire pour afficher un exemple
*)
let print_example (features, class_label) =
  print_string "[|";
  Array.iteri (fun i x ->
    if i > 0 then print_string "; ";
    print_float x
  ) features;
  print_string "|], \"";
  print_string class_label;
  print_string "\""

(*
** Fonction utilitaire pour afficher tous les exemples
*)
let print_examples examples =
  List.iteri (fun i example ->
    print_string ("Exemple " ^ string_of_int (i + 1) ^ ": ");
    print_example example;
    print_newline ()
  ) examples

(*
** Tests de la fonction examples_of_file
*)
let test_examples_of_file () =
  print_endline "=== Test de examples_of_file ===";
  print_newline ();
  
  (* Test avec ionosphere.test.csv *)
  (try
    print_endline "Test avec ionosphere.test.csv :";
    let examples_test = examples_of_file "ionosphere.test.csv" in
    print_examples examples_test;
    print_newline ();
  with
  | Failure msg -> print_endline ("Erreur : " ^ msg)
  | Sys_error msg -> print_endline ("Erreur système : " ^ msg));
  
  (* Test avec ionosphere.train.csv *)
  (try
    print_endline "Test avec ionosphere.train.csv :";
    let examples_train = examples_of_file "ionosphere.train.csv" in
    print_examples examples_train;
    print_newline ();
  with
  | Failure msg -> print_endline ("Erreur : " ^ msg)
  | Sys_error msg -> print_endline ("Erreur système : " ^ msg));
  
  (* Test avec un fichier inexistant *)
  (try
    print_endline "Test avec un fichier inexistant :";
    let _ = examples_of_file "fichier_inexistant.csv" in
    ()
  with
  | Failure msg -> print_endline ("Erreur attendue : " ^ msg)
  | Sys_error msg -> print_endline ("Erreur système attendue : " ^ msg));
  
  (* Test avec un fichier au format invalide *)
  (try
    print_endline "Test avec un fichier au format invalide :";
    let _ = examples_of_file "test_invalid.csv" in
    ()
  with
  | Failure msg -> print_endline ("Erreur de format attendue : " ^ msg)
  | Sys_error msg -> print_endline ("Erreur système : " ^ msg))

let () =
  test_examples_of_file ()