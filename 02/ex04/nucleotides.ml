(* Type aliases *)
type phosphate = string
type deoxyribose = string

(* Variant type for nucleobase *)
type nucleobase = 
	| A 
	| T 
	| C 
	| G 
	| None

(* Nucleotide type as a record *)
type nucleotide = {
	phosphate : phosphate;
	deoxyribose : deoxyribose;
	nucleobase : nucleobase;
}

(* Function to generate a nucleotide from a char *)
let generate_nucleotide c =
	let base = match c with
		| 'A' | 'a' -> A
		| 'T' | 't' -> T
		| 'C' | 'c' -> C
		| 'G' | 'g' -> G
		| _ -> None
	in
	{
		phosphate = "phosphate";
		deoxyribose = "deoxyribose";
		nucleobase = base;
	}

let () =
	let print_nucleobase = function
		| A -> "A"
		| T -> "T"
		| C -> "C"
		| G -> "G"
		| None -> "None"
	in
	
	let print_nucleotide nucleotide =
		Printf.printf "{ phosphate = \"%s\"; deoxyribose = \"%s\"; nucleobase = %s }\n"
			nucleotide.phosphate
			nucleotide.deoxyribose
			(print_nucleobase nucleotide.nucleobase)
	in
	
	let test_chars = ['A'; 'T'; 'C'; 'G'; 'a'; 't'; 'c'; 'g'; 'X'; '1'] in
	let rec test_generation = function
		| [] -> ()
		| c :: cs ->
			Printf.printf "generate_nucleotide('%c') = " c;
			print_nucleotide (generate_nucleotide c);
			test_generation cs
	in
	
	print_endline "Testing nucleotide generation:";
	test_generation test_chars
