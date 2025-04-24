let repeat_string ?(str="x") n =
    let repeat_x (n: int) =
        let rec return_x x =
            if x = 0 then ""
            else str ^ return_x (x - 1)
        in
        if n < 0 then "Error"
        else return_x n
    in
    repeat_x n

let () =
    print_endline (repeat_string (-1));
    print_endline (repeat_string 0);
    print_endline (repeat_string ~str:"Toto" 1);
    print_endline (repeat_string ~str:"Toto" 0);
    print_endline (repeat_string ~str:"Toto" 5);
    print_endline (repeat_string 2);
    print_endline (repeat_string ~str:"a" 5);
    print_endline (repeat_string ~str:"what" 3);
    print_endline (repeat_string ~str:"what" (-1));
    print_endline (repeat_string 20);
