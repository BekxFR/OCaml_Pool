let ft_rot_n n str = 
    let check_letter letter =
        let diff = ref 0 in
        let res = ref 0 in
        if n > 26 then (
            (* diff := abs (n - (26 * (n / 26))) *)
            diff := n mod 26
        ) else (
             diff := n
        );
        if letter >= 65 && letter <= 90 then (
            if letter + !diff > 90 then (
                res := 64 + ((!diff + letter) - 90)
            )
            else res := letter + !diff
        ) else if letter >= 97 && letter <= 122 then (
            if letter + !diff > 122 then (
                res :=  96 + ((!diff + letter) - 122)
            )
            else res := letter + !diff
        ) else res := letter;
        char_of_int !res
    in
    String.map (function c -> check_letter (int_of_char c)) str

let () =
    print_endline (ft_rot_n 1 "abcdefghijklmnopqrstuvwxyz");
    print_endline (ft_rot_n 13 "abcdefghijklmnopqrstuvwxyz");
    print_endline (ft_rot_n 42 "0123456789");
    print_endline (ft_rot_n 2 "OI2EAS67B9");
    print_endline (ft_rot_n 0 "Damned !");
    print_endline (ft_rot_n 42 "");
    print_endline (ft_rot_n 1 "NBzlk qnbjr !");
    print_endline (ft_rot_n 27 "NBzlk qnbjr !");
    print_endline (ft_rot_n 53 "NBzlk qnbjr !");
    print_endline (ft_rot_n 79 "NBzlk qnbjr !")
