(* Reproduction exacte de ton cas avec debug *)

module StringHashedType = struct
  type t = string
  let equal s1 s2 = (s1 = s2)
  
  let hash str =
    let len = String.length str in
    let rec hash_aux acc i =
      if i >= len then acc
      else
        let char_code = Char.code (String.get str i) in
        let new_acc = ((acc lsl 5) + acc) + char_code in
        hash_aux new_acc (i + 1)
    in
    let result = hash_aux 5381 0 in
    let pos = result mod 5 in
    Printf.printf "DEBUG: hash(\"%s\") = %d, position = %d\n" str result pos;
    result
end

module StringHashtbl = Hashtbl.Make(StringHashedType)

let () =
  print_endline "=== Reproduction avec debug ===";
  let ht = StringHashtbl.create 5 in
  let values = [ "Hello"; "world"; "42"; "Ocaml"; "H" ] in
  
  print_endline "\n--- Phase d'insertion ---";
  let pairs = List.map (fun s -> (s, String.length s)) values in
  List.iter (fun (k,v) -> 
    Printf.printf "Insertion de \"%s\"\n" k;
    StringHashtbl.add ht k v
  ) pairs;
  
  print_endline "\n--- Phase d'itération ---";
  StringHashtbl.iter (fun k v -> Printf.printf "k = \"%s\", v = %d\n" k v) ht
