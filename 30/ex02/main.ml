let () =
  let open Monoid in

  print_endline (string_of_int (Calc_int.power 3 3));
  print_endline (string_of_float (Calc_float.power 3.0 3));
  print_endline (string_of_int (Calc_int.mul (Calc_int.add 20 1) 2));
  print_endline (string_of_float (Calc_float.mul (Calc_float.add 20.0 1.0) 2.0));
  print_endline (string_of_int (Calc_int.fact 5));
  print_endline (string_of_float (Calc_float.fact 5.0));
  (
    try
      print_endline (string_of_int (Calc_int.div 10 0));
    with Failure msg -> print_endline msg
  );
  (
    try
      print_endline (string_of_float (Calc_float.div 10.0 0.0));
    with Failure msg -> print_endline msg;
  );
  print_endline (string_of_int (Calc_int.sub 100 42));
  print_endline (string_of_float (Calc_float.sub 100.0 42.5));
  print_endline (string_of_int (Calc_int.div 100 5));
  print_endline (string_of_float (Calc_float.div 100.0 4.0));
  print_endline (string_of_int (Calc_int.power 2 10));
  print_endline (string_of_float (Calc_float.power 2.0 5));
  print_endline (string_of_int (Calc_int.power 5 0));
  print_endline (string_of_float (Calc_float.power 10.0 0));
  print_endline (string_of_int (Calc_int.fact 0));
  print_endline (string_of_float (Calc_float.fact 0.0));
  print_endline (string_of_int (Calc_int.fact 10));
  print_endline (string_of_float (Calc_float.fact 7.0));
  print_endline (string_of_int (Calc_int.mul (Calc_int.sub 50 10) (Calc_int.add 2 3)));
  print_endline (string_of_float (Calc_float.mul (Calc_float.sub 50.0 10.0) (Calc_float.add 2.0 3.0)))