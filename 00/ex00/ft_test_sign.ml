let ft_test_sign (a: int) =
    if a >= 0 then print_endline("positive")
    else if a < 0 then print_endline("negative")

let () =
  print_string "Test with [42]: ";
  ft_test_sign 42;
  
  print_string "Test with [-42]: ";
  ft_test_sign (-42);
  
  print_string "Test with [0]: ";
  ft_test_sign 0;
