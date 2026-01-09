module type Parson =
  sig
    type project = string * string * int
    val zero : project
    val combine : project -> project -> project
    val fail : project -> project
    val success : project -> project
  end

module Parson : Parson =
  struct
    type project = string * string * int

    let zero : project = ("", "", 0)

    let combine (product_type1, status1, grade1) (product_type2, status2, grade2) : project =
      let product_type = product_type1 ^ product_type2 in
      let grade = (grade1 + grade2) / 2 in
      let status = if grade >= 80 then "succeed" else "fail" in
      (product_type, status, grade)

    let fail (product_type, status, grade) : project =
      (product_type, "fail", 0)

    let success (product_type, status, grade) : project =
      (product_type, "succeed", 80)
  end
