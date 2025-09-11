(* Types from all previous exercises *)
type phosphate = string
type deoxyribose = string

type nucleobase = 
	| A 
	| T 
	| C 
	| G 
	| U
	| None

type nucleotide = {
	phosphate : phosphate;
	deoxyribose : deoxyribose;
	nucleobase : nucleobase;
}

type helix = nucleotide list
type rna = nucleobase list

type aminoacid =
	| Stop
	| Ala | Arg | Asn | Asp | Cys | Gln | Glu
	| Gly | His | Ile | Leu | Lys | Met | Phe
	| Pro | Ser | Thr | Trp | Tyr | Val

type protein = aminoacid list

(* Helper functions *)
let create_nucleotide base =
	{
		phosphate = "phosphate";
		deoxyribose = "deoxyribose";
		nucleobase = base;
	}

let char_to_nucleobase = function
	| 'A' | 'a' -> A
	| 'T' | 't' -> T
	| 'C' | 'c' -> C
	| 'G' | 'g' -> G
	| 'U' | 'u' -> U
	| _ -> None

let nucleobase_to_string = function
	| A -> "A"
	| T -> "T"
	| C -> "C"
	| G -> "G"
	| U -> "U"
	| None -> "None"

let aminoacid_to_string = function
	| Stop -> "Stop"
	| Ala -> "Ala" | Arg -> "Arg" | Asn -> "Asn" | Asp -> "Asp"
	| Cys -> "Cys" | Gln -> "Gln" | Glu -> "Glu" | Gly -> "Gly"
	| His -> "His" | Ile -> "Ile" | Leu -> "Leu" | Lys -> "Lys"
	| Met -> "Met" | Phe -> "Phe" | Pro -> "Pro" | Ser -> "Ser"
	| Thr -> "Thr" | Trp -> "Trp" | Tyr -> "Tyr" | Val -> "Val"

(* Step 1: String to DNA Helix *)
let string_to_helix dna_string =
	let rec convert_chars i acc =
		if i >= String.length dna_string then acc
		else
			let base = char_to_nucleobase dna_string.[i] in
			let nucleotide = create_nucleotide base in
			convert_chars (i + 1) (acc @ [nucleotide])
	in
	convert_chars 0 []

(* Step 2: DNA to RNA transcription *)
let dna_to_rna helix =
	let dna_to_rna_base = function
		| A -> U | T -> A | C -> G | G -> C | U -> A | None -> None
	in
	let rec transcribe = function
		| [] -> []
		| nucleotide :: rest ->
			let rna_base = dna_to_rna_base nucleotide.nucleobase in
			rna_base :: transcribe rest
	in
	transcribe helix

(* Step 3: RNA to triplets *)
let generate_bases_triplets rna =
	let rec make_triplets acc = function
		| [] -> acc
		| [_] -> acc | [_; _] -> acc
		| b1 :: b2 :: b3 :: rest ->
			make_triplets (acc @ [(b1, b2, b3)]) rest
	in
	make_triplets [] rna

(* Step 4: Triplets to protein *)
let triplet_to_aminoacid (b1, b2, b3) =
	match (b1, b2, b3) with
	| (U, A, A) | (U, A, G) | (U, G, A) -> Stop
	| (G, C, A) | (G, C, C) | (G, C, G) | (G, C, U) -> Ala
	| (A, G, A) | (A, G, G) | (C, G, A) | (C, G, C) | (C, G, G) | (C, G, U) -> Arg
	| (A, A, C) | (A, A, U) -> Asn
	| (G, A, C) | (G, A, U) -> Asp
	| (U, G, C) | (U, G, U) -> Cys
	| (C, A, A) | (C, A, G) -> Gln
	| (G, A, A) | (G, A, G) -> Glu
	| (G, G, A) | (G, G, C) | (G, G, G) | (G, G, U) -> Gly
	| (C, A, C) | (C, A, U) -> His
	| (A, U, A) | (A, U, C) | (A, U, U) -> Ile
	| (C, U, A) | (C, U, C) | (C, U, G) | (C, U, U) | (U, U, A) | (U, U, G) -> Leu
	| (A, A, A) | (A, A, G) -> Lys
	| (A, U, G) -> Met
	| (U, U, C) | (U, U, U) -> Phe
	| (C, C, C) | (C, C, A) | (C, C, G) | (C, C, U) -> Pro
	| (U, C, A) | (U, C, C) | (U, C, G) | (U, C, U) | (A, G, U) | (A, G, C) -> Ser
	| (A, C, A) | (A, C, C) | (A, C, G) | (A, C, U) -> Thr
	| (U, G, G) -> Trp
	| (U, A, C) | (U, A, U) -> Tyr
	| (G, U, A) | (G, U, C) | (G, U, G) | (G, U, U) -> Val
	| _ -> Stop

let decode_arn rna =
	let triplets = generate_bases_triplets rna in
	let rec translate acc = function
		| [] -> acc
		| triplet :: rest ->
			let aa = triplet_to_aminoacid triplet in
			if aa = Stop then acc
			else translate (acc @ [aa]) rest
	in
	translate [] triplets

(* Display functions *)
let display_helix helix =
	let rec build_string = function
		| [] -> ""
		| nucleotide :: rest ->
			nucleobase_to_string nucleotide.nucleobase ^ build_string rest
	in
	build_string helix

let display_rna rna =
	let rec build_string = function
		| [] -> ""
		| base :: rest ->
			nucleobase_to_string base ^ build_string rest
	in
	build_string rna

let display_triplets triplets =
	let triplet_to_string (b1, b2, b3) =
		nucleobase_to_string b1 ^ nucleobase_to_string b2 ^ nucleobase_to_string b3
	in
	let rec build_string = function
		| [] -> ""
		| [triplet] -> triplet_to_string triplet
		| triplet :: rest -> triplet_to_string triplet ^ " " ^ build_string rest
	in
	build_string triplets

let display_protein protein =
	let rec build_string = function
		| [] -> ""
		| [aa] -> aminoacid_to_string aa
		| aa :: rest -> aminoacid_to_string aa ^ "-" ^ build_string rest
	in
	build_string protein

(* Main function: Complete molecular biology pipeline *)
let life dna_string =
	print_endline "=== START MOLECULAR BIOLOGY SIMULATION ===";
	print_endline "";
	
	(* Step 1: Input DNA string *)
	print_endline ("1- Input DNA string: \"" ^ dna_string ^ "\"");
	print_endline ("   Length: " ^ string_of_int (String.length dna_string) ^ " nucleotides");
	print_endline "";
	
	(* Step 2: Generate DNA helix *)
	let dna_helix = string_to_helix dna_string in
	print_endline "2- DNA Helix Generation:";
	print_endline ("   DNA Helix: " ^ display_helix dna_helix);
	print_endline ("   Structure: Phosphate-Deoxyribose-Nucleobase chain");
	print_endline "";
	
	(* Step 3: Transcription DNA -> RNA *)
	let rna_sequence = dna_to_rna dna_helix in
	print_endline "3- Transcription (DNA -> RNA):";
	print_endline ("   DNA Template: " ^ display_helix dna_helix);
	print_endline ("   RNA Transcript: " ^ display_rna rna_sequence);
	print_endline ("   Rules: A->U, T->A, C->G, G->C");
	print_endline "";
	
	(* Step 4: Generate triplets *)
	let triplets = generate_bases_triplets rna_sequence in
	print_endline "4- Codons formation (Triplets):";
	print_endline ("   RNA Sequence: " ^ display_rna rna_sequence);
	print_endline ("   Codons: " ^ display_triplets triplets);
	if (List.length rna_sequence) mod 3 <> 0 then
		print_endline ("   Note: " ^ string_of_int ((List.length rna_sequence) mod 3) ^ " incomplete nucleotide(s) ignored");
	print_endline "";
	
	(* Step 5: Translation RNA -> Protein *)
	let protein = decode_arn rna_sequence in
	print_endline "5- Translation (RNA -> Protein):";
	print_endline ("   Codons: " ^ display_triplets triplets);
	print_endline ("   Protein: " ^ display_protein protein);
	if List.length protein = 0 then
		print_endline "   Result: No protein produced (stop codon encountered immediately or no valid codons)"
	else
		print_endline ("   Result: " ^ string_of_int (List.length protein) ^ " amino acid(s) synthesized");
	print_endline "";
	
	print_endline "================== END! ==================";
	protein

let () =
	print_endline "Testing complete molecular biology pipeline:";
	print_endline "";
	
	(* Test 1: Simple sequence *)
	let _ = life "ATGTTCTAA" in
	print_endline "";
	
	(* Test 2: Longer sequence *)
	let _ = life "GCACGAAACUGGUAA" in
	print_endline "";
	
	(* Test 3: Sequence with incomplete triplet *)
	let _ = life "ATGTTCTA" in
	print_endline "";
	
	(* Test 4: Short sequence *)
	let _ = life "TAA" in
	print_endline ""
