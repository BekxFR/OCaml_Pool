(* Types from previous exercise *)
type phosphate = string
type deoxyribose = string

type nucleobase = 
	| A 
	| T 
	| C 
	| G 
	| None

type nucleotide = {
	phosphate : phosphate;
	deoxyribose : deoxyribose;
	nucleobase : nucleobase;
}

(* Helix type *)
type helix = nucleotide list

(* Function to generate a nucleotide from a nucleobase *)
let create_nucleotide base =
	{
		phosphate = "phosphate";
		deoxyribose = "deoxyribose";
		nucleobase = base;
	}

(* Function to generate a random helix of size n *)
(* let generate_helix n =
	Random.self_init ();
	let rec generate_list size acc =
		if size <= 0 then acc
		else
			let random_index = Random.int 4 in
			let random_base = match random_index with
				| 0 -> A
				| 1 -> T
				| 2 -> C
				| _ -> G
			in
			let nucleotide = create_nucleotide random_base in
			generate_list (size - 1) (acc @ [nucleotide])
	in
	generate_list n [] *)

let generate_helix n =
	Random.self_init ();
	let rec generate_list size acc =
		if size <= 0 then List.rev acc
		(* if size <= 0 then acc *)
		else
			let random_index = Random.int 4 in
			let random_base = match random_index with
				| 0 -> A
				| 1 -> T
				| 2 -> C
				| _ -> G
			in
			let nucleotide = create_nucleotide random_base in
			(* generate_list (size - 1) (acc @ [nucleotide]) *)
			generate_list (size - 1) (nucleotide :: acc)
	in
	generate_list n []

(* Function to convert helix to string *)
let helix_to_string helix =
	let nucleobase_to_char = function
		| A -> "A"
		| T -> "T"
		| C -> "C"
		| G -> "G"
		| None -> "X"
	in
	let rec build_string = function
		| [] -> ""
		| nucleotide :: rest ->
			let char = nucleobase_to_char nucleotide.nucleobase in
			char ^ build_string rest
	in
	build_string helix

(* Function to generate complementary helix *)
let complementary_helix helix =
	let complement_base = function
		| A -> T
		| T -> A
		| C -> G
		| G -> C
		| None -> None
	in
	let rec build_complement = function
		| [] -> []
		| nucleotide :: rest ->
			let complement = create_nucleotide (complement_base nucleotide.nucleobase) in
			complement :: build_complement rest
	in
	build_complement helix

let () =
	let print_nucleobase = function
		| A -> "A"
		| T -> "T"
		| C -> "C"
		| G -> "G"
		| None -> "None"
	in
	
	let print_helix helix =
		let rec print_list = function
			| [] -> print_endline "]"
			| nucleotide :: [] ->
				print_string (print_nucleobase nucleotide.nucleobase);
				print_endline "]"
			| nucleotide :: rest ->
				print_string (print_nucleobase nucleotide.nucleobase ^ "; ");
				print_list rest
		in
		print_string "[";
		print_list helix
	in
	
	print_endline "Testing helix functions:";
	print_endline "";
	
	(* Test generate_helix *)
	let test_helix = generate_helix 8 in
	print_string "Generated helix (size 8): ";
	print_helix test_helix;
	
	(* Test helix_to_string *)
	let helix_string = helix_to_string test_helix in
	print_endline ("Helix as string: " ^ helix_string);
	print_endline "";
	
	(* Test complementary_helix *)
	let complement = complementary_helix test_helix in
	print_string "Complementary helix: ";
	print_helix complement;
	
	let complement_string = helix_to_string complement in
	print_endline ("Complement as string: " ^ complement_string);
	print_endline "";
	
	(* Test with known sequence *)
	let known_helix = [
		create_nucleotide A;
		create_nucleotide T;
		create_nucleotide C;
		create_nucleotide G;
	] in
	print_string "Known helix [A; T; C; G]: ";
	print_helix known_helix;
	print_endline ("As string: " ^ helix_to_string known_helix);
	
	let known_complement = complementary_helix known_helix in
	print_string "Its complement: ";
	print_helix known_complement;
	print_endline ("As string: " ^ helix_to_string known_complement);
	print_endline "";
	
	(* Test empty helix *)
	let empty_helix = generate_helix 0 in
	print_string "Empty helix (size 0): ";
	print_helix empty_helix;
	print_endline ("As string: \"" ^ helix_to_string empty_helix ^ "\"")
