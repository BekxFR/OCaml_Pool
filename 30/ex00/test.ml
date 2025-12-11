module type Watchtower =
  sig
    type hour = int
    val zero : hour
    val add : hour -> hour -> hour
    val sub : hour -> hour -> hour
  end

module Watchtower =
  struct
    type hour = int
    let zero = 12
    let add h1 h2 = if (h1 + h2) mod zero == 0 then zero else (h1 + h2) mod zero
    let sub h1 h2 = if (h1 - h2 + zero) mod zero == 0 then zero else (h1 - h2 + zero) mod zero
  end

let () =
  (* let open Watchtower in
  let h1 = 10 in
  let h2 = 5 in
  Printf.printf "Zero hour is %d\n" zero;
  Printf.printf "Adding %d and %d gives %d\n" h1 h2 (add h1 h2);
  Printf.printf "Adding %d and %d gives %d\n" 12 12 (add 12 12);
  Printf.printf "Adding %d and %d gives %d\n" 0 12 (add 0 12);
  Printf.printf "Adding %d and %d gives %d\n" 5 5 (add 5 5);
  Printf.printf "Adding %d and %d gives %d\n" 9 12 (add 9 12);
  Printf.printf "Adding %d and %d gives %d\n" 8 8 (add 8 8);
  Printf.printf "Adding %d and %d gives %d\n" 10 36 (add 10 36);
  Printf.printf "Subtracting %d from %d gives %d\n" h2 h1 (sub h1 h2);
  Printf.printf "Subtracting %d from %d gives %d\n" 12 12 (sub 12 12);
  Printf.printf "Subtracting %d from %d gives %d\n" 0 12 (sub 0 12);
  Printf.printf "Subtracting %d from %d gives %d\n" 5 5 (sub 5 5);
  Printf.printf "Subtracting %d from %d gives %d\n" 9 12 (sub 12 9);
  Printf.printf "Subtracting %d from %d gives %d\n" 8 8 (sub 8 8);
  Printf.printf "Subtracting %d from %d gives %d\n" 10 36 (sub 36 10); *)
  let clock = Watchtower.zero in
  Printf.printf "Current hour is %d\n" clock;
  Printf.printf "After adding 12 hours, current hour is %d\n" (Watchtower.add clock (12:Watchtower.hour));
  Printf.printf "After adding 0 hours, current hour is %d\n" (Watchtower.add clock (0:Watchtower.hour));
  Printf.printf "After adding 5 hours, current hour is %d\n" (Watchtower.add clock (5:Watchtower.hour));
  Printf.printf "After adding 5 hours, current hour is %d\n" (Watchtower.add clock (5:Watchtower.hour));
  Printf.printf "Current hour is %d\n" clock;
  Printf.printf "After subbing 5 hours, current hour is %d\n" (Watchtower.sub clock (5:Watchtower.hour));
  Printf.printf "After subbing 5 hours, current hour is %d\n" (Watchtower.sub clock (5:Watchtower.hour));
  Printf.printf "After subbing 0 hours, current hour is %d\n" (Watchtower.sub clock (0:Watchtower.hour));
  Printf.printf "After subbing 12 hours, current hour is %d\n" (Watchtower.sub clock (12:Watchtower.hour));