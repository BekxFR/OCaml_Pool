(* 
  UTILISATION:
  ./jokes programming_jokes.txt
  
  FORMAT DU FICHIER:
  - Une blague par ligne
  - Lignes commençant par '#' = commentaires (ignorées)
  - Lignes vides = ignorées
*)

let read_lines filename =
  let ic = open_in filename in
  let rec read_all_lines acc =
    try
      let line = input_line ic in
      read_all_lines (line :: acc)
    with End_of_file ->
      close_in ic;
      List.rev acc
  in
  read_all_lines []

let is_valid_joke_line line =
  let trimmed = String.trim line in
  String.length trimmed > 0 && not (String.get trimmed 0 = '#')

let load_jokes_from_file filename =
  try
    let all_lines = read_lines filename in
    let valid_lines = List.filter is_valid_joke_line all_lines in
    if List.length valid_lines = 0 then (
      Printf.eprintf "Error: No jokes found in file '%s'\n" filename;
      exit 1
    ) else
      Array.of_list valid_lines
  with
  | Sys_error msg ->
      Printf.eprintf "Error opening file: %s\n" msg;
      exit 1
  | exn ->
      Printf.eprintf "Unexpected error: %s\n" (Printexc.to_string exn);
      exit 1

let print_stats jokes_array filename =
  Printf.printf "Jokes file: %s\n" filename;
  Printf.printf "Jokes found: %d\n" (Array.length jokes_array);
  Printf.printf "Average length: %.1f characters\n\n" 
    (float_of_int (Array.fold_left (fun acc joke -> acc + String.length joke) 0 jokes_array) /. 
     float_of_int (Array.length jokes_array))

let display_random_joke jokes_array =
  Random.self_init ();
  let random_index = Random.int (Array.length jokes_array) in
  let selected_joke = jokes_array.(random_index) in
  Printf.printf "Random joke #%d:\n" (random_index + 1);
  Printf.printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
  Printf.printf "%s\n" selected_joke;
  Printf.printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"

let print_usage program_name =
  Printf.printf "Usage: %s <jokes_file>\n\n" program_name;
  Printf.printf "Example: %s programming_jokes.txt\n\n" program_name;
  Printf.printf "File format:\n";
  Printf.printf "  - One joke per line\n";
  Printf.printf "  - Lines starting with '#' = comments\n";
  Printf.printf "  - Empty lines = ignored\n"

let () =
  match Array.length Sys.argv with
  | 2 ->
      let filename = Sys.argv.(1) in
      
      let jokes_array = load_jokes_from_file filename in
      print_stats jokes_array filename;
      display_random_joke jokes_array;
  | _ ->
      Printf.printf "Error: Wrong number of arguments\n\n";
      print_usage Sys.argv.(0);
      exit 1
