(* let gray n =
  let rec build_gray k =
    if k = 0 then [""]  (* base: liste contenant la chaîne vide *)
    else
      let prev = build_gray (k - 1) in
      let with0 = List.map (fun s -> "0" ^ s) prev in
      let with1 = List.map (fun s -> "1" ^ s) (List.rev prev) in
      with0 @ with1
  in
  let seq = build_gray n in
  let rec print_seq = function
    | [] -> print_newline ()
    | [x] -> print_string x; print_newline ()
    | x :: xs -> print_string x; print_string " "; print_seq xs
  in
  print_seq seq *)

let gray n =
  let rec build_gray k =
    if k = 0 then [""]
    else
      let prev = build_gray (k - 1) in
      let with0 = List.map (fun s -> "0" ^ s) prev in
      let with1 = List.map (fun s -> "1" ^ s) (List.rev prev) in
      (* with0 @ with1 *)
      
  in
  let rec print_seq = function
    | [] -> print_newline ()
    | [x] -> print_string x; print_newline ()
    | x :: xs -> print_string x; print_string " "; print_seq xs
  in
  let seq = build_gray n in
  print_seq seq

let () =
  print_endline "Gray 1 :";
  gray 1;
  print_endline "Gray 2 :";
  gray 2;
  print_endline "Gray 3 :";
  gray 3;
  print_endline "Gray 4 :";
  gray 4
