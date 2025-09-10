(* Types from previous exercises *)
type nucleobase = 
	| A 
	| T 
	| C 
	| G 
	| U
	| None

type rna = nucleobase list

(* Aminoacid type *)
type aminoacid =
	| Stop
	| Ala  (* Alanine *)
	| Arg  (* Arginine *)
	| Asn  (* Asparagine *)
	| Asp  (* Aspartique *)
	| Cys  (* Cysteine *)
	| Gln  (* Glutamine *)
	| Glu  (* Glutamique *)
	| Gly  (* Glycine *)
	| His  (* Histidine *)
	| Ile  (* Isoleucine *)
	| Leu  (* Leucine *)
	| Lys  (* Lysine *)
	| Met  (* Methionine *)
	| Phe  (* Phenylalanine *)
	| Pro  (* Proline *)
	| Ser  (* Serine *)
	| Thr  (* Threonine *)
	| Trp  (* Tryptophane *)
	| Tyr  (* Tyrosine *)
	| Val  (* Valine *)

(* Protein type *)
type protein = aminoacid list

(* Function to convert protein to string *)
let string_of_protein protein =
	let aminoacid_to_string = function
		| Stop -> "Stop"
		| Ala -> "Ala"
		| Arg -> "Arg"
		| Asn -> "Asn"
		| Asp -> "Asp"
		| Cys -> "Cys"
		| Gln -> "Gln"
		| Glu -> "Glu"
		| Gly -> "Gly"
		| His -> "His"
		| Ile -> "Ile"
		| Leu -> "Leu"
		| Lys -> "Lys"
		| Met -> "Met"
		| Phe -> "Phe"
		| Pro -> "Pro"
		| Ser -> "Ser"
		| Thr -> "Thr"
		| Trp -> "Trp"
		| Tyr -> "Tyr"
		| Val -> "Val"
	in
	let rec build_string = function
		| [] -> ""
		| [aa] -> aminoacid_to_string aa
		| aa :: rest -> aminoacid_to_string aa ^ "-" ^ build_string rest
	in
	build_string protein

(* Function to generate triplets from RNA *)
let generate_bases_triplets rna =
	let rec make_triplets acc = function
		| [] -> acc
		| [_] -> acc  (* Ignore incomplete triplet *)
		| [_; _] -> acc  (* Ignore incomplete triplet *)
		| b1 :: b2 :: b3 :: rest ->
			make_triplets (acc @ [(b1, b2, b3)]) rest
	in
	make_triplets [] rna

(* Function to decode a triplet to aminoacid *)
let triplet_to_aminoacid (b1, b2, b3) =
	match (b1, b2, b3) with
	(* Stop codons *)
	| (U, A, A) | (U, A, G) | (U, G, A) -> Stop
	(* Alanine *)
	| (G, C, A) | (G, C, C) | (G, C, G) | (G, C, U) -> Ala
	(* Arginine *)
	| (A, G, A) | (A, G, G) | (C, G, A) | (C, G, C) | (C, G, G) | (C, G, U) -> Arg
	(* Asparagine *)
	| (A, A, C) | (A, A, U) -> Asn
	(* Aspartique *)
	| (G, A, C) | (G, A, U) -> Asp
	(* Cysteine *)
	| (U, G, C) | (U, G, U) -> Cys
	(* Glutamine *)
	| (C, A, A) | (C, A, G) -> Gln
	(* Glutamique *)
	| (G, A, A) | (G, A, G) -> Glu
	(* Glycine *)
	| (G, G, A) | (G, G, C) | (G, G, G) | (G, G, U) -> Gly
	(* Histidine *)
	| (C, A, C) | (C, A, U) -> His
	(* Isoleucine *)
	| (A, U, A) | (A, U, C) | (A, U, U) -> Ile
	(* Leucine *)
	| (C, U, A) | (C, U, C) | (C, U, G) | (C, U, U) | (U, U, A) | (U, U, G) -> Leu
	(* Lysine *)
	| (A, A, A) | (A, A, G) -> Lys
	(* Methionine *)
	| (A, U, G) -> Met
	(* Phenylalanine *)
	| (U, U, C) | (U, U, U) -> Phe
	(* Proline *)
	| (C, C, C) | (C, C, A) | (C, C, G) | (C, C, U) -> Pro
	(* Serine *)
	| (U, C, A) | (U, C, C) | (U, C, G) | (U, C, U) | (A, G, U) | (A, G, C) -> Ser
	(* Threonine *)
	| (A, C, A) | (A, C, C) | (A, C, G) | (A, C, U) -> Thr
	(* Tryptophane *)
	| (U, G, G) -> Trp
	(* Tyrosine *)
	| (U, A, C) | (U, A, U) -> Tyr
	(* Valine *)
	| (G, U, A) | (G, U, C) | (G, U, G) | (G, U, U) -> Val
	(* Unknown triplet *)
	| _ -> Stop

(* Function to decode RNA to protein *)
let decode_arn rna =
	let triplets = generate_bases_triplets rna in
	let rec translate acc = function
		| [] -> acc
		| triplet :: rest ->
			let aa = triplet_to_aminoacid triplet in
			if aa = Stop then acc  (* Stop translation *)
			else translate (acc @ [aa]) rest
	in
	translate [] triplets

let () =
	let print_nucleobase = function
		| A -> "A"
		| T -> "T"
		| C -> "C"
		| G -> "G"
		| U -> "U"
		| None -> "None"
	in
	
	let print_rna rna =
		let rec print_list = function
			| [] -> print_endline "]"
			| base :: [] ->
				print_string (print_nucleobase base);
				print_endline "]"
			| base :: rest ->
				print_string (print_nucleobase base ^ "; ");
				print_list rest
		in
		print_string "[";
		print_list rna
	in
	
	let print_triplets triplets =
		let print_triplet (b1, b2, b3) =
			"(" ^ print_nucleobase b1 ^ ", " ^ print_nucleobase b2 ^ ", " ^ print_nucleobase b3 ^ ")"
		in
		let rec print_list = function
			| [] -> print_endline "]"
			| triplet :: [] ->
				print_string (print_triplet triplet);
				print_endline "]"
			| triplet :: rest ->
				print_string (print_triplet triplet ^ "; ");
				print_list rest
		in
		print_string "[";
		print_list triplets
	in
	
	print_endline "Testing ribosome functions:";
	print_endline "";
	
	(* Test with a simple RNA sequence *)
	let test_rna = [A; U; G; U; U; C; U; A; A] in  (* AUG UUC UAA *)
	print_string "Test RNA: ";
	print_rna test_rna;
	
	let triplets = generate_bases_triplets test_rna in
	print_string "Generated triplets: ";
	print_triplets triplets;
	
	let protein = decode_arn test_rna in
	print_endline ("Decoded protein: " ^ string_of_protein protein);
	print_endline "Expected: Met-Phe (stops at UAA)";
	print_endline "";
	
	(* Test with incomplete triplet *)
	let incomplete_rna = [A; U; G; U; U; C; U; A] in  (* AUG UUC UA incomplete *)
	print_string "Incomplete RNA: ";
	print_rna incomplete_rna;
	
	let incomplete_triplets = generate_bases_triplets incomplete_rna in
	print_string "Generated triplets (ignores incomplete): ";
	print_triplets incomplete_triplets;
	
	let incomplete_protein = decode_arn incomplete_rna in
	print_endline ("Decoded protein: " ^ string_of_protein incomplete_protein);
	print_endline "";
	
	(* Test with various amino acids *)
	let complex_rna = [G; C; A; C; G; A; A; A; C; U; G; G; U; A; A] in  (* GCA CGA AAC UGG UAA *)
	print_string "Complex RNA: ";
	print_rna complex_rna;
	
	let complex_triplets = generate_bases_triplets complex_rna in
	print_string "Generated triplets: ";
	print_triplets complex_triplets;
	
	let complex_protein = decode_arn complex_rna in
	print_endline ("Decoded protein: " ^ string_of_protein complex_protein);
	print_endline "Expected: Ala-Arg-Asn-Trp (stops at UAA)";
	print_endline "";
	
	(* Test empty RNA *)
	let empty_rna = [] in
	print_string "Empty RNA: ";
	print_rna empty_rna;
	let empty_protein = decode_arn empty_rna in
	print_endline ("Empty protein: \"" ^ string_of_protein empty_protein ^ "\"")
