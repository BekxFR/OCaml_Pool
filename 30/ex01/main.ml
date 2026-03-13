let () =
  let print_proj ((product_type, status, grade) : App.App.project) : unit =
    Printf.printf "Product Type: %s, Status: %s, Grade: %d\n" product_type status grade
  in

  let p1 : App.App.project = (("Gadget", "succeed", 91) : App.App.project) in
  let p2 : App.App.project = (("Widget", "failed", 68) : App.App.project) in
  print_proj p1;
  print_proj p2;
  let combined = App.App.combine p1 p2 in
  print_proj combined;
  let failed = App.App.fail p1 in
  print_proj failed;
  let succeeded = App.App.success p2 in
  print_proj succeeded;
  print_proj p1;
  print_proj p2;
  let empty = App.App.zero in
  print_proj empty;
  let combined_empty = App.App.combine p1 empty in
  print_proj combined_empty;
  let nested_combined = App.App.combine (App.App.combine p1 p2) empty in
  print_proj nested_combined;
  let negative_grade_proj: App.App.project = (("Thingamajig", "succeed", -10) : App.App.project) in
  print_proj negative_grade_proj;
  let failed_negative = App.App.fail negative_grade_proj in
  print_proj failed_negative;
  print_proj negative_grade_proj;
  let succeeded_negative = App.App.success negative_grade_proj in
  print_proj succeeded_negative;
  let double_negative = App.App.combine negative_grade_proj negative_grade_proj in
  print_proj double_negative
