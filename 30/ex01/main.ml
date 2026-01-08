let () =
  let open Parson in
  let print_proj ((product_type, status, grade) : Parson.project) : unit =
    Printf.printf "Product Type: %s, Status: %s, Grade: %d\n" product_type status grade
  in

  let p1 : Parson.project = (("Gadget", "succeed", 91) : Parson.project) in
  let p2 : Parson.project = (("Widget", "fail", 68) : Parson.project) in
  print_proj p1;
  print_proj p2;
  let combined = Parson.combine p1 p2 in
  print_proj combined;
  let failed = Parson.fail p1 in
  print_proj failed;
  let succeeded = Parson.success p2 in
  print_proj succeeded;
  print_proj p1;
  print_proj p2;
  let empty = Parson.zero in
  print_proj empty;
  let combined_empty = Parson.combine p1 empty in
  print_proj combined_empty;
  let nested_combined = Parson.combine (Parson.combine p1 p2) empty in
  print_proj nested_combined;
  let negative_grade_proj: Parson.project = (("Thingamajig", "succeed", -10) : Parson.project) in
  print_proj negative_grade_proj;
  let failed_negative = Parson.fail negative_grade_proj in
  print_proj failed_negative;
  print_proj negative_grade_proj;
  let succeeded_negative = Parson.success negative_grade_proj in
  print_proj succeeded_negative;
  let double_negative = Parson.combine negative_grade_proj negative_grade_proj in
  print_proj double_negative