let converges f x n =
	let rec aux curr_x curr_n =
		if curr_n < 0 then false
		else
			let next_x = f curr_x in
			if next_x = curr_x then true
			else aux next_x (curr_n - 1)
	in
	if n < 0 then false
	else aux x n

let () = 
	print_endline (string_of_bool (converges (( * ) 2) 2 5));
	let f x = x / 2 in
	print_endline (string_of_bool (converges f 2 3));
	print_endline (string_of_bool (converges f 2 2));
	print_endline (string_of_bool (converges f 0 2));
    let h x = x + 1 in
    print_endline (string_of_bool (converges h 0 100));
    let j x = x in
    print_endline (string_of_bool (converges j 42 10));
    print_endline (string_of_bool (converges f 1024 20));
    print_endline (string_of_bool (converges f 1024 10));
    let l x = x * x in
    print_endline (string_of_bool (converges l 2 5)) (* Ne converge pas, diverge vers l'infini *)