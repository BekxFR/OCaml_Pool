let () =
  let open App in
  let print_proj ((product_type, status, grade) : App.project) : unit =
    Printf.printf "Product Type: %s, Status: %s, Grade: %d\n" product_type status grade
  in

  let p1 : App.project = (("Gadget", "succeed", 90) : App.project) in
  let p2 : App.project = (("Widget", "fail", 70) : App.project) in
  print_proj p1;
  print_proj p2;
  let combined = App.combine p1 p2 in
  print_proj combined;
  let failed = App.fail p1 in
  print_proj failed;
  let succeeded = App.success p2 in
  print_proj succeeded;
  let empty = App.zero in
  print_proj empty;
  let combined_empty = App.combine p1 empty in
  print_proj combined_empty;
  let nested_combined = App.combine (App.combine p1 p2) empty in
  print_proj nested_combined;
  let negative_grade_proj = ("Thingamajig", "succeed", -10) in
  print_proj negative_grade_proj;
  let failed_negative = App.fail negative_grade_proj in
  print_proj failed_negative;
  print_proj negative_grade_proj;
  let succeeded_negative = App.success negative_grade_proj in
  print_proj succeeded_negative;
  let double_negative = App.combine negative_grade_proj negative_grade_proj in
  print_proj double_negative