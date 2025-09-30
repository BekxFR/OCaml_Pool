let () =
  if Array.length Sys.argv <> 2 then
    (Printf.eprintf "Usage: %s <Secondes_to_sleep>\n" Sys.argv.(0);
    exit 1)
  else
    try
        let my_sleep () = Unix.sleep 1 in
        let sleeping_time = int_of_string Sys.argv.(1) in
        if sleeping_time < 0 then
          (Printf.eprintf "Please provide a non-negative integer for sleep time.\n";
          exit 1)
        else
          let rec loop n =
            if n <= 0 then ()
            else
              (my_sleep ();
              loop (n - 1))
          in
          loop sleeping_time
      with Failure _ ->
        Printf.eprintf "Invalid argument. Please provide a valid number.\n";
        exit 1