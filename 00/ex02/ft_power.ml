let rec ft_power a p =
    if p = 0 then 1
    else a * ft_power a (p - 1)

let () =
    let result = ft_power 2 4 in
    print_endline (string_of_int result);
    let result = ft_power 3 0 in
    print_endline (string_of_int result);
    let result = ft_power 0 5 in
    print_endline (string_of_int result);
    let result = ft_power 3 4 in
    print_endline (string_of_int result);
