let () =
  let open Watchtower in
  let h1 = 10 in
  let h2 = 5 in
  Printf.printf "Zero hour is %d\n" Watchtower.zero;
  Printf.printf "Adding %d and %d gives %d\n" h1 h2 (Watchtower.add h1 h2);
  Printf.printf "Adding %d and %d gives %d\n" 12 12 (Watchtower.add 12 12);
  Printf.printf "Adding %d and %d gives %d\n" 0 12 (Watchtower.add 0 12);
  Printf.printf "Adding %d and %d gives %d\n" 5 5 (Watchtower.add 5 5);
  Printf.printf "Adding %d and %d gives %d\n" 9 12 (Watchtower.add 9 12);
  Printf.printf "Adding %d and %d gives %d\n" 8 8 (Watchtower.add 8 8);
  Printf.printf "Adding %d and %d gives %d\n" 10 36 (Watchtower.add 10 36);
  Printf.printf "Subtracting %d from %d gives %d\n" h2 h1 (Watchtower.sub h1 h2);
  Printf.printf "Subtracting %d from %d gives %d\n" 12 12 (Watchtower.sub 12 12);
  Printf.printf "Subtracting %d from %d gives %d\n" 0 12 (Watchtower.sub 0 12);
  Printf.printf "Subtracting %d from %d gives %d\n" 5 5 (Watchtower.sub 5 5);
  Printf.printf "Subtracting %d from %d gives %d\n" 9 12 (Watchtower.sub 12 9);
  Printf.printf "Subtracting %d from %d gives %d\n" 8 9 (Watchtower.sub 8 9);
  Printf.printf "Subtracting %d from %d gives %d\n" 10 36 (Watchtower.sub 10 36);
  let clock = Watchtower.zero in
  Printf.printf "Current hour is %d\n" clock;
  Printf.printf "After adding 12 hours, current hour is %d\n" (Watchtower.add clock (12:Watchtower.hour));
  Printf.printf "After adding 0 hours, current hour is %d\n" (Watchtower.add clock (0:Watchtower.hour));
  Printf.printf "After adding 5 hours, current hour is %d\n" (Watchtower.add clock (5:Watchtower.hour));
  Printf.printf "After adding 10 hours, current hour is %d\n" (Watchtower.add clock (10:Watchtower.hour));
  Printf.printf "Current hour is %d\n" clock;
  Printf.printf "After subbing 5 hours, current hour is %d\n" (Watchtower.sub clock (5:Watchtower.hour));
  Printf.printf "After subbing 10 hours, current hour is %d\n" (Watchtower.sub clock (10:Watchtower.hour));
  Printf.printf "After subbing 0 hours, current hour is %d\n" (Watchtower.sub clock (0:Watchtower.hour));
  Printf.printf "After subbing 12 hours, current hour is %d\n" (Watchtower.sub clock (12:Watchtower.hour));
  Printf.printf "After adding -42 hours, current hour is %d\n" (Watchtower.add clock (-42:Watchtower.hour));
  Printf.printf "After adding -0 hours, current hour is %d\n" (Watchtower.add clock (-0:Watchtower.hour));
  Printf.printf "After subbing -42 hours, current hour is %d\n" (Watchtower.sub clock (-42:Watchtower.hour));
  Printf.printf "After subbing -0 hours, current hour is %d\n" (Watchtower.sub clock (-0:Watchtower.hour));