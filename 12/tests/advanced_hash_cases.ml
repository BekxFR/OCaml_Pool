(* Cas 2: Sécurité - Hash avec sel pour éviter les attaques *)

module SecureHashedType = struct
  type t = string
  let equal = String.equal
  
  (* Sel secret pour éviter les attaques par collision intentionnelle *)
  let secret_salt = 0x9e3779b9
  
  let hash str =
    let len = String.length str in
    let rec hash_aux acc i =
      if i >= len then acc
      else
        let char_code = Char.code (String.get str i) in
        (* Mélanger avec le sel secret *)
        let new_acc = ((acc lsl 5) + acc + secret_salt) lxor char_code in
        hash_aux new_acc (i + 1)
    in
    hash_aux 5381 0
end

(* Cas 3: Hash géographique pour des coordonnées *)
module GeoHashedType = struct
  type t = float * float (* latitude, longitude *)
  let equal (lat1, lon1) (lat2, lon2) = 
    abs_float (lat1 -. lat2) < 0.0001 && abs_float (lon1 -. lon2) < 0.0001
  
  (* Hash optimisé pour la géolocalisation *)
  let hash (lat, lon) =
    (* Convertir en entiers avec précision contrôlée *)
    let lat_int = int_of_float (lat *. 10000.0) in
    let lon_int = int_of_float (lon *. 10000.0) in
    (* Mélanger les deux coordonnées *)
    lat_int * 31 + lon_int
end

let test_security_and_geo () =
  print_endline "=== Tests sécurisés et géographiques ===";
  
  module SecureHashtbl = Hashtbl.Make(SecureHashedType) in
  let secure_table = SecureHashtbl.create 10 in
  
  List.iter (fun word -> 
    SecureHashtbl.add secure_table word (String.length word)
  ) ["attack"; "collision"; "test"];
  
  print_endline "Hashtable sécurisée :";
  SecureHashtbl.iter (fun word len -> Printf.printf "%s: %d\n" word len) secure_table;
  
  module GeoHashtbl = Hashtbl.Make(GeoHashedType) in
  let geo_table = GeoHashtbl.create 10 in
  
  List.iter (fun (name, lat, lon) ->
    GeoHashtbl.add geo_table (lat, lon) name
  ) [("Paris", 48.8566, 2.3522); ("Londres", 51.5074, -0.1278); ("Berlin", 52.5200, 13.4050)];
  
  print_endline "\nHashtable géographique :";
  GeoHashtbl.iter (fun (lat, lon) city -> 
    Printf.printf "(%.4f, %.4f): %s\n" lat lon city
  ) geo_table

let () = test_security_and_geo ()
