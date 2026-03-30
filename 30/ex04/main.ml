(* Helper function to print a set of integers *)
let print_int_set set =
  print_string "[";
  let first = ref true in
  Set_monad.foreach set (fun x ->
    if not !first then print_string "; ";
    first := false;
    print_int x
  );
  print_string "]"

(* Helper function to print a set of strings *)
let print_string_set set =
  print_string "[";
  let first = ref true in
  Set_monad.foreach set (fun x ->
    if not !first then print_string "; ";
    first := false;
    print_string ("\"" ^ x ^ "\"")
  );
  print_string "]"

(* Helper function to check a test *)
let test_case name condition =
  print_string ("Test " ^ name ^ ": ");
  if condition then
    print_endline "- PASS"
  else
    print_endline "x FAIL"

let () =
  print_endline "=== Testing Set Monad ===";
  print_newline ();

  (* Test 1: return (singleton) *)
  print_endline "Test 1: return and union";
  let s1 = Set_monad.return 42 in
  print_string "Set.return 42 = ";
  print_int_set s1;
  print_newline ();
  test_case "return creates singleton" (s1 = [42]);
  let s11 = Set_monad.return 24 in
  print_string "Set.return 24 = ";
  print_int_set s11;
  let s12 = Set_monad.union s1 s11 in
  print_string "\nSet.union of two singletons = ";
  print_int_set s12;
  print_string "\n\n";

  (* Test 2: union *)
  print_endline "Test 2: union";
  let s2 = Set_monad.union [1; 2; 3] [3; 4; 5] in
  print_string "union [1; 2; 3] [3; 4; 5] = ";
  print_int_set s2;
  print_newline ();
  test_case "union removes duplicates" (List.length s2 = 5);
  test_case "union contains all elements" (
    List.for_all (fun x -> List.mem x s2) [1; 2; 3; 4; 5]
  );
  print_newline ();

  (* Test 3: inter *)
  print_endline "Test 3: inter";
  let s3 = Set_monad.inter [1; 2; 3; 4] [3; 4; 5; 6] in
  print_string "inter [1; 2; 3; 4] [3; 4; 5; 6] = ";
  print_int_set s3;
  print_newline ();
  test_case "inter finds common elements" (s3 = [3; 4]);
  
  let s3_empty = Set_monad.inter [1; 2] [3; 4] in
  print_string "inter [1; 2] [3; 4] = ";
  print_int_set s3_empty;
  print_newline ();
  test_case "inter with no common elements" (s3_empty = []);
  print_newline ();

  (* Test 4: diff *)
  print_endline "Test 4: diff";
  let s4 = Set_monad.diff [1; 2; 3; 4] [3; 4; 5] in
  print_string "diff [1; 2; 3; 4] [3; 4; 5] = ";
  print_int_set s4;
  print_newline ();
  test_case "diff removes common elements" (s4 = [1; 2]);
  
  let s4_full = Set_monad.diff [1; 2; 3] [4; 5] in
  print_string "diff [1; 2; 3] [4; 5] = ";
  print_int_set s4_full;
  print_newline ();
  test_case "diff with no common elements" (s4_full = [1; 2; 3]);
  print_newline ();

  (* Test 5: filter *)
  print_endline "Test 5: filter";
  let s5 = Set_monad.filter [1; 2; 3; 4; 5; 6] (fun x -> x mod 2 = 0) in
  print_string "filter [1; 2; 3; 4; 5; 6] (fun x -> x mod 2 = 0) = ";
  print_int_set s5;
  print_newline ();
  test_case "filter keeps only even numbers" (s5 = [2; 4; 6]);
  
  let s5_none = Set_monad.filter [1; 3; 5] (fun x -> x mod 2 = 0) in
  print_string "filter [1; 3; 5] (fun x -> x mod 2 = 0) = ";
  print_int_set s5_none;
  print_newline ();
  test_case "filter with no matches" (s5_none = []);
  print_newline ();

  (* Test 6: bind *)
  print_endline "Test 6: bind";
  let multi = ( * ) 10 in
  let s6 = Set_monad.bind [1; 2; 3] (fun x -> [x; multi x]) in
  print_string "bind [1; 2; 3] (fun x -> [x; x * 10]) = ";
  print_int_set s6;
  print_newline ();
  test_case "bind applies function to all elements" (
    List.length s6 = 6 && List.for_all (fun x -> List.mem x s6) [1; 10; 2; 20; 3; 30]
  );
  
  (* Test bind with duplicates removal *)
  let s6_dup = Set_monad.bind [1; 2] (fun x -> [x; x]) in
  print_string "bind [1; 2] (fun x -> [x; x]) = ";
  print_int_set s6_dup;
  print_newline ();
  test_case "bind removes duplicates" (s6_dup = [1; 2]);
  print_newline ();

  (* Test 7: foreach *)
  print_endline "Test 7: foreach";
  print_string "foreach [1; 2; 3] with print: ";
  let count = ref 0 in
  Set_monad.foreach [1; 2; 3] (fun x ->
    if !count > 0 then print_string ", ";
    print_int x;
    count := !count + 1
  );
  print_newline ();
  test_case "foreach executes on all elements" (!count = 3);
  print_newline ();

  (* Test 8: for_all *)
  print_endline "Test 8: for_all";
  let s8_true = Set_monad.for_all [2; 4; 6; 8] (fun x -> x mod 2 = 0) in
  print_string "for_all [2; 4; 6; 8] (fun x -> x mod 2 = 0) = ";
  print_endline (string_of_bool s8_true);
  test_case "for_all returns true when all satisfy predicate" s8_true;
  
  let s8_false = Set_monad.for_all [2; 3; 4] (fun x -> x mod 2 = 0) in
  print_string "for_all [2; 3; 4] (fun x -> x mod 2 = 0) = ";
  print_endline (string_of_bool s8_false);
  test_case "for_all returns false when not all satisfy" (not s8_false);
  
  let s8_empty = Set_monad.for_all [] (fun x -> x < 0) in
  print_string "for_all [] (fun x -> x < 0) = ";
  print_endline (string_of_bool s8_empty);
  test_case "for_all on empty set returns true" s8_empty;
  print_newline ();

  (* Test 9: exists *)
  print_endline "Test 9: exists";
  let s9_true = Set_monad.exists [1; 2; 3; 4] (fun x -> x = 3) in
  print_string "exists [1; 2; 3; 4] (fun x -> x = 3) = ";
  print_endline (string_of_bool s9_true);
  test_case "exists returns true when element exists" s9_true;
  
  let s9_false = Set_monad.exists [1; 2; 3] (fun x -> x > 10) in
  print_string "exists [1; 2; 3] (fun x -> x > 10) = ";
  print_endline (string_of_bool s9_false);
  test_case "exists returns false when no element satisfies" (not s9_false);
  
  let s9_empty = Set_monad.exists [] (fun x -> x = 1) in
  print_string "exists [] (fun x -> x = 1) = ";
  print_endline (string_of_bool s9_empty);
  test_case "exists on empty set returns false" (not s9_empty);
  print_newline ();

  (* Test 10: String sets *)
  print_endline "Test 10: String sets";
  let words1 = ["hello"; "world"; "ocaml"] in
  let words2 = ["ocaml"; "functional"; "programming"] in
  let words_union = Set_monad.union words1 words2 in
  print_string "union of string sets = ";
  print_string_set words_union;
  print_newline ();
  test_case "string set union" (List.length words_union = 5);
  
  let words_inter = Set_monad.inter words1 words2 in
  print_string "inter of string sets = ";
  print_string_set words_inter;
  print_newline ();
  test_case "string set inter" (words_inter = ["ocaml"]);
  print_newline ();

  (* Test 11: Monad laws *)
  print_endline "Test 11: Monad laws";
  
  (* Left identity: return a >>= f  ≡  f a *)
  let f x = [x; x + 1] in
  let left_id_1 = Set_monad.bind (Set_monad.return 5) f in
  let left_id_2 = f 5 in
  test_case "Monad law - Left identity" (left_id_1 = left_id_2);
  
  (* Right identity: m >>= return  ≡  m *)
  let m = [1; 2; 3] in
  let right_id = Set_monad.bind m Set_monad.return in
  test_case "Monad law - Right identity" (right_id = m);
  print_newline ();

  (* Test 12: Complex operations *)
  print_endline "Test 12: Complex operations";
  let set_a = [1; 2; 3; 4; 5] in
  let set_b = [4; 5; 6; 7; 8] in
  let filtered = Set_monad.filter (Set_monad.union set_a set_b) (fun x -> x > 3) in
  print_string "filter (union [1..5] [4..8]) (x > 3) = ";
  print_int_set filtered;
  print_newline ();
  test_case "complex filter+union" (
    List.for_all (fun x -> List.mem x filtered) [4; 5; 6; 7; 8]
  );
  
  let bound_filtered = Set_monad.bind (Set_monad.filter [1; 2; 3; 4] (fun x -> x > 2)) 
                                 (fun x -> [x; x * 2]) in
  print_string "bind (filter [1..4] (x > 2)) (x -> [x; x*2]) = ";
  print_int_set bound_filtered;
  print_newline ();
  test_case "complex bind+filter" (
    List.for_all (fun x -> List.mem x bound_filtered) [3; 6; 4; 8]
  );
  print_newline ();

  (* Summary *)
  print_endline "=== All tests completed ===";
