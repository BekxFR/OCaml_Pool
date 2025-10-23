(* Test pour vérifier si le problème vient des grands hashs *)

let hash str =
  let len = String.length str in
  let rec hash_aux acc i =
    if i >= len then acc
    else
      let char_code = Char.code (String.get str i) in
      let new_acc = ((acc lsl 5) + acc) + char_code in
      hash_aux new_acc (i + 1)
  in
  hash_aux 5381 0

let test_modulo_issue () =
  let values = [ "Hello"; "world"; "42"; "Ocaml"; "H" ] in
  
  print_endline "=== Test détaillé des calculs modulo ===";
  List.iter (fun s ->
    let h = hash s in
    let pos = h mod 5 in
    Printf.printf "\"%s\":\n" s;
    Printf.printf "  Hash: %d\n" h;
    Printf.printf "  Hash mod 5: %d\n" pos;
    Printf.printf "  Hash en hexa: 0x%x\n" h;
    print_endline ""
  ) values;
  
  (* Test spécifique pour Ocaml *)
  let ocaml_hash = hash "Ocaml" in
  print_endline "=== Analyse spécifique pour 'Ocaml' ===";
  Printf.printf "Hash de 'Ocaml': %d\n" ocaml_hash;
  Printf.printf "Modulo 5: %d\n" (ocaml_hash mod 5);
  Printf.printf "Division entière: %d\n" (ocaml_hash / 5);
  Printf.printf "Reste attendu: %d\n" (ocaml_hash - (ocaml_hash / 5) * 5)

let () = test_modulo_issue ()
