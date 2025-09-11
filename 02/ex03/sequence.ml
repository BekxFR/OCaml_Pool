let sequence n =
	if n <= 0 then ""
	else
		let rec look_and_say s =
			let rec count_consecutive current count acc = function
				| [] ->
					if count > 0 then acc @ [string_of_int count ^ string_of_int current]
					else acc
				| x :: xs ->
					if x = current then
						count_consecutive current (count + 1) acc xs
					else
						count_consecutive x 1 (acc @ [string_of_int count ^ string_of_int current]) xs
			in
			let string_to_int_list str =
				let rec aux i acc =
					if i >= String.length str then acc
					else
						let digit = int_of_char str.[i] - int_of_char '0' in
						aux (i + 1) (acc @ [digit])
				in
				aux 0 []
			in
			let int_list = string_to_int_list s in
			match int_list with
			| [] -> ""
			| x :: xs ->
				let result_list = count_consecutive x 1 [] xs in
				String.concat "" result_list
		in
		let rec generate_sequence current_n current_value =
			if current_n = n then current_value
			else
				generate_sequence (current_n + 1) (look_and_say current_value)
		in
		generate_sequence 1 "1"

let () =
	let test_values = [1; 2; 3; 4; 5; 6; 7; 8; 0; -1] in
	let rec test_sequence = function
		| [] -> ()
		| x :: xs ->
			let result = sequence x in
			if result = "" then
				Printf.printf "sequence(%d) = \"\" (invalid parameter)\n" x
			else
				Printf.printf "sequence(%d) = \"%s\"\n" x result;
			test_sequence xs
	in
	print_endline "Testing sequence function:";
	test_sequence test_values
