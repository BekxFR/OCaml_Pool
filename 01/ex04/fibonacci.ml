let fibonacci n =
    let rec aux n x y =
        if n = 0 then x
        else aux (n - 1) y (x + y)
    in
    if n < 0 then -1
    else aux n 0 1

let () = 
    print_endline (string_of_int (fibonacci (-42)));
    print_endline (string_of_int (fibonacci 1));
    print_endline (string_of_int (fibonacci 3));
    print_endline (string_of_int (fibonacci 6))