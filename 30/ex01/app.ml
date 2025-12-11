module type App =
  sig
  type project = string * string * int
  val zero : project
  val combine : project -> project -> project
  val fail : project -> project
  val success : project -> project
  end

module App : App =
  struct
    type project = string * string * int

    let zero : project = ("", "", 0)

    let combine (product_type1, status1, grade1) (product_type2, status2, grade2) : project =
      let product_type = if product_type1 = "" then product_type2 else product_type1 in
      let status = if status1 = "" then status2 else status1 in
      let grade = max grade1 grade2 in
      (product_type, status, grade)

    let fail (product_type, status, grade) : project =
      (product_type, "failed", 0)

    let success (product_type, status, grade) : project =
      (product_type, "success", 80)
  end