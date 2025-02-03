let ft_string_all f s =
    let rec check n =
        if n < 0 then true
        else if f (String.get s n) then check (n - 1)
        else false
    in
    check (String.length s - 1)


let () =
    let is_digit c = c >= '0' && c <= '9' in

    let res = ft_string_all is_digit "0123456789" in
    print_endline (string_of_bool res);
    let res = ft_string_all is_digit "O12EAS67B9" in
    print_endline (string_of_bool res);
    let res = ft_string_all is_digit "01234b56789" in
    print_endline (string_of_bool res);
    let res = ft_string_all is_digit "0123456789 " in
    print_endline (string_of_bool res)
