let encode lst =
	let rec countOccurrence current count acc = function
	| [] -> 
		if count > 0 then acc @ [(count, current)]
		else acc
	| x::xs ->
		if x = current then countOccurrence current (count + 1) acc xs
		else countOccurrence x 1 (acc @ [(count, current)]) xs
	in
	match lst with
	| [] -> []
	| x::xs -> countOccurrence x 1 [] xs

let () =

	let rec iter_list lst to_string =
		let print_tuple_values_by_line (count, value) =
			print_string ("(" ^ string_of_int count ^ ", " ^ to_string value ^ ")")
		in
		match lst with
		| [] -> ()
		| x::xs -> print_tuple_values_by_line x; iter_list xs to_string
	in



	let rec iter_empty_list lst =
		let print_tuple (count, value) =
			print_endline (string_of_int count ^ ", " ^ string_of_int value)
		in
		match lst with
		| [] -> print_endline "Empty (int * 'a) list"
		| x::xs -> print_tuple x; iter_empty_list xs
	in

	let rec print_on_line_for_all lst acc to_string =
		let change_values_on_string (count, value) =
			string_of_int count ^ to_string value
		in
		match lst with
		| [] -> acc
		| x::xs -> print_on_line_for_all xs (acc ^ change_values_on_string x) to_string
	in

	let myCharLst = ['a'; 'a'; 'b'; 'c'; 'c'; 'd'; 'a'; 'a'; 'a'] in
	let myIntLst = [1; 1; 2; 3; 3; 4; 1; 1; 1] in
	let encodedCharLst = encode myCharLst in
	let encodedIntLst = encode myIntLst in
	let resultChar = print_on_line_for_all encodedCharLst "" (String.make 1) in
	let resultInt = print_on_line_for_all encodedIntLst "" string_of_int in

	print_string ("Encoded list = [");
	iter_list encodedCharLst (String.make 1);
	print_endline ("]");
	print_endline ("Le resultat est : " ^ resultChar);


	print_string ("Encoded list = [");
	iter_list encodedIntLst string_of_int;
	print_endline ("]");
	print_endline ("Le resultat est : " ^ resultInt);

	print_string ("Encoded list = [");
	iter_list (encode [42]) string_of_int;
	print_endline ("]");
	Printf.printf "Le resultat est : %s\n" (print_on_line_for_all (encode [42]) "" string_of_int);

	iter_empty_list (encode [])

