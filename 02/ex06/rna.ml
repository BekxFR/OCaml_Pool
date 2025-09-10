(* Types from previous exercises - modified to include U *)
type phosphate = string
type deoxyribose = string

type nucleobase = 
	| A 
	| T 
	| C 
	| G 
	| U  (* Uracil for RNA *)
	| None

type nucleotide = {
	phosphate : phosphate;
	deoxyribose : deoxyribose;
	nucleobase : nucleobase;
}

type helix = nucleotide list

(* RNA type *)
type rna = nucleobase list

(* Function to create a nucleotide from a nucleobase *)
let create_nucleotide base =
	{
		phosphate = "phosphate";
		deoxyribose = "deoxyribose";
		nucleobase = base;
	}

(* Function to generate RNA from DNA helix *)
let generate_rna helix =
	let dna_to_rna_base = function
		| A -> U  (* A in DNA -> U in RNA *)
		| T -> A  (* T in DNA -> A in RNA *)
		| C -> G  (* C in DNA -> G in RNA *)
		| G -> C  (* G in DNA -> C in RNA *)
		| U -> A  (* U in DNA -> A in RNA (rare case) *)
		| None -> None
	in
	let rec transcribe = function
		| [] -> []
		| nucleotide :: rest ->
			let rna_base = dna_to_rna_base nucleotide.nucleobase in
			rna_base :: transcribe rest
	in
	transcribe helix

let () =
	let print_nucleobase = function
		| A -> "A"
		| T -> "T"
		| C -> "C"
		| G -> "G"
		| U -> "U"
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
	
	let rna_to_string rna =
		let rec build_string = function
			| [] -> ""
			| base :: rest ->
				let char = match base with
					| A -> "A"
					| T -> "T"
					| C -> "C"
					| G -> "G"
					| U -> "U"
					| None -> "X"
				in
				char ^ build_string rest
		in
		build_string rna
	in
	
	let helix_to_string helix =
		let rec build_string = function
			| [] -> ""
			| nucleotide :: rest ->
				let char = match nucleotide.nucleobase with
					| A -> "A"
					| T -> "T"
					| C -> "C"
					| G -> "G"
					| U -> "U"
					| None -> "X"
				in
				char ^ build_string rest
		in
		build_string helix
	in
	
	print_endline "Testing RNA transcription:";
	print_endline "";
	
	(* Test with the example from the subject: ATCGA -> UAGCU *)
	let test_helix = [
		create_nucleotide A;
		create_nucleotide T;
		create_nucleotide C;
		create_nucleotide G;
		create_nucleotide A;
	] in
	
	print_string "DNA Helix: ";
	print_helix test_helix;
	print_endline ("DNA as string: " ^ helix_to_string test_helix);
	print_endline "";
	
	let rna_result = generate_rna test_helix in
	print_string "Generated RNA: ";
	print_rna rna_result;
	print_endline ("RNA as string: " ^ rna_to_string rna_result);
	print_endline "";
	
	(* Test with all bases *)
	let complete_helix = [
		create_nucleotide A;
		create_nucleotide T;
		create_nucleotide C;
		create_nucleotide G;
	] in
	
	print_string "Complete DNA [A; T; C; G]: ";
	print_helix complete_helix;
	print_endline ("DNA as string: " ^ helix_to_string complete_helix);
	
	let complete_rna = generate_rna complete_helix in
	print_string "Transcribed RNA: ";
	print_rna complete_rna;
	print_endline ("RNA as string: " ^ rna_to_string complete_rna);
	print_endline "Transcription rules: A->U, T->A, C->G, G->C";
	print_endline "";
	
	(* Test with empty helix *)
	let empty_helix = [] in
	print_string "Empty DNA helix: ";
	print_helix empty_helix;
	
	let empty_rna = generate_rna empty_helix in
	print_string "Empty RNA: ";
	print_rna empty_rna
