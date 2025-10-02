let sum (fa : float) (fb : float) = fa +. fb

let () =
  let a = 3.14 in
  let b = 2.71 in
  let result = sum a b in
  Printf.printf "La somme de %.2f et %.2f est %.2f\n" a b result