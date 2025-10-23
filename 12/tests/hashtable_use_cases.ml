(* Exemples pratiques d'exploitation de StringHashtbl *)

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
    hash_aux 5381 0
end

module StringHashtbl = Hashtbl.Make(StringHashedType)

(* 1. Analyse de fréquence des mots *)
let analyze_word_frequency text_words =
  let freq_table = StringHashtbl.create 100 in
  
  (* Compter les occurrences *)
  List.iter (fun word ->
    try
      let count = StringHashtbl.find freq_table word in
      StringHashtbl.replace freq_table word (count + 1)
    with Not_found ->
      StringHashtbl.add freq_table word 1
  ) text_words;
  
  (* Convertir en liste triée pour exploitation *)
  let freq_list = ref [] in
  StringHashtbl.iter (fun word count ->
    freq_list := (word, count) :: !freq_list
  ) freq_table;
  
  (* Trier par fréquence décroissante *)
  List.sort (fun (_, c1) (_, c2) -> compare c2 c1) !freq_list

(* 2. Cache avec expiration *)
type cached_value = {
  data: int;
  timestamp: float;
}

let create_cache_with_ttl ttl_seconds =
  let cache = StringHashtbl.create 50 in
  let get key =
    try
      let cached = StringHashtbl.find cache key in
      let now = Unix.time () in
      if now -. cached.timestamp < ttl_seconds then
        Some cached.data
      else (
        StringHashtbl.remove cache key;
        None
      )
    with Not_found -> None
  in
  let set key value =
    let cached = { data = value; timestamp = Unix.time () } in
    StringHashtbl.replace cache key cached
  in
  (get, set)

(* 3. Dictionnaire bidirectionnel *)
let create_bidirectional_dict () =
  let forward = StringHashtbl.create 100 in
  let backward = StringHashtbl.create 100 in
  
  let add key value =
    StringHashtbl.replace forward key value;
    StringHashtbl.replace backward value key
  in
  
  let find_by_key key = StringHashtbl.find forward key in
  let find_by_value value = StringHashtbl.find backward value in
  
  (add, find_by_key, find_by_value)

(* 4. Configuration système *)
let create_config_manager () =
  let config = StringHashtbl.create 20 in
  
  (* Valeurs par défaut *)
  List.iter (fun (k, v) -> StringHashtbl.add config k v) [
    ("debug", "false");
    ("max_connections", "100");
    ("timeout", "30");
    ("log_level", "info");
  ];
  
  let get key default =
    try StringHashtbl.find config key
    with Not_found -> default
  in
  
  let set key value = StringHashtbl.replace config key value in
  
  let export_sorted () =
    let items = ref [] in
    StringHashtbl.iter (fun k v -> items := (k, v) :: !items) config;
    List.sort (fun (k1, _) (k2, _) -> String.compare k1 k2) !items
  in
  
  (get, set, export_sorted)

(* Tests et démonstrations *)
let () =
  print_endline "=== 1. Analyse de fréquence ===";
  let words = ["hello"; "world"; "hello"; "ocaml"; "world"; "hello"] in
  let frequencies = analyze_word_frequency words in
  List.iter (fun (word, count) ->
    Printf.printf "%s: %d occurrences\n" word count
  ) frequencies;
  
  print_endline "\n=== 2. Cache avec TTL ===";
  let (cache_get, cache_set) = create_cache_with_ttl 1.0 in
  cache_set "expensive_calc" 42;
  (match cache_get "expensive_calc" with
   | Some value -> Printf.printf "Cache hit: %d\n" value
   | None -> print_endline "Cache miss");
  
  print_endline "\n=== 3. Dictionnaire bidirectionnel ===";
  let (add_mapping, find_by_key, find_by_value) = create_bidirectional_dict () in
  add_mapping "fr" "français";
  add_mapping "en" "english";
  Printf.printf "fr -> %s\n" (find_by_key "fr");
  Printf.printf "english <- %s\n" (find_by_value "english");
  
  print_endline "\n=== 4. Configuration triée ===";
  let (get_config, set_config, export_config) = create_config_manager () in
  set_config "new_feature" "enabled";
  let sorted_config = export_config () in
  List.iter (fun (key, value) ->
    Printf.printf "%s = %s\n" key value
  ) sorted_config
