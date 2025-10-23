(* Test avec une fonction hash simple pour voir la différence *)

module SimpleHashedType = struct
  type t = string
  let equal s1 s2 = (s1 = s2)
  
  (* Hash simple : somme des codes ASCII *)
  let hash str =
    let len = String.length str in
    let rec sum_chars acc i =
      if i >= len then acc
      else sum_chars (acc + Char.code (String.get str i)) (i + 1)
    in
    sum_chars 0 0
end

module SimpleHashtbl = Hashtbl.Make(SimpleHashedType)

let test_with_simple_hash () =
  print_endline "=== Test avec hash simple (somme ASCII) ===";
  let ht = SimpleHashtbl.create 5 in
  let values = [ "Hello"; "world"; "42"; "Ocaml"; "H" ] in
  
  (* Afficher les hashs simples *)
  List.iter (fun s ->
    let h = SimpleHashedType.hash s in
    let pos = h mod 5 in
    Printf.printf "\"%s\": hash=%d, position=%d\n" s h pos
  ) values;
  
  print_endline "\nAjout et affichage :";
  let pairs = List.map (fun s -> (s, String.length s)) values in
  List.iter (fun (k,v) -> SimpleHashtbl.add ht k v) pairs;
  SimpleHashtbl.iter (fun k v -> Printf.printf "k = \"%s\", v = %d\n" k v) ht

let () = test_with_simple_hash ()
