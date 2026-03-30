type project = string * string * int

let zero : project = ("", "", 0)

let combine (product_type1, _, grade1) (product_type2, _, grade2) : project =
  let product_type = product_type1 ^ product_type2 in
  let grade = (grade1 + grade2) / 2 in
  let status = if grade >= 80 then "succeed" else "failed" in
  (product_type, status, grade)

let fail (product_type, _, _) : project =
  (product_type, "failed", 0)

let success (product_type, _, _) : project =
  (product_type, "succeed", 80)
