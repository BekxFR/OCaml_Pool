let repeat_x (n: int) =
    (* let rec return_x x acc =
         if x = 0 then acc
        else return_x (x - 1) ("x" ^ acc)
        (* "x" ^ acc a une complexité de O(k) ou k est la longueur de la chaine acc. 
         Comme cette concaténation est effectué à chaque étape la complexité devient O(n²) (quadratique) *) 
    in
    *)
    let rec return_x x =
        if x = 0 then ""
        else "x" ^ return_x (x - 1)
    in
    if n < 0 then "Error"
    else return_x n

let () = 
    print_endline (repeat_x 3);
    print_endline (repeat_x (-1));
    print_endline (repeat_x 0);
    print_endline (repeat_x 10);
    print_endline (repeat_x 999)