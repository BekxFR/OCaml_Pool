(* Exemple pour la piscine : Système de gestion de notes *)

module StringHashedType = struct
  type t = string
  let equal s1 s2 = (s1 = s2)
  let hash str =
    let len = String.length str in
    let rec hash_aux acc i =
      if i >= len then acc
      else
        let char_code = Char.code (String.get str i) in
        let new_acc = ((acc lsl 5) + acc) + char_code in
        hash_aux new_acc (i + 1)
    in
    hash_aux 5381 0
end

module StudentGrades = Hashtbl.Make(StringHashedType)

type student_info = {
  name: string;
  grades: float list;
  average: float;
}

let create_grade_system () =
  let students = StudentGrades.create 100 in
  
  let add_student name =
    let info = { name; grades = []; average = 0.0 } in
    StudentGrades.add students name info
  in
  
  let add_grade student_name grade =
    try
      let info = StudentGrades.find students student_name in
      let new_grades = grade :: info.grades in
      let new_avg = (List.fold_left (+.) 0.0 new_grades) /. (float_of_int (List.length new_grades)) in
      let updated_info = { info with grades = new_grades; average = new_avg } in
      StudentGrades.replace students student_name updated_info
    with Not_found ->
      Printf.printf "Étudiant %s non trouvé\n" student_name
  in
  
  let get_ranking () =
    let all_students = ref [] in
    StudentGrades.iter (fun _ info -> 
      all_students := info :: !all_students
    ) students;
    List.sort (fun s1 s2 -> compare s2.average s1.average) !all_students
  in
  
  let get_statistics () =
    let count = ref 0 in
    let sum = ref 0.0 in
    StudentGrades.iter (fun _ info ->
      incr count;
      sum := !sum +. info.average
    ) students;
    if !count > 0 then (!sum /. float_of_int !count, !count) else (0.0, 0)
  in
  
  (add_student, add_grade, get_ranking, get_statistics)

let () =
  print_endline "=== Système de gestion de notes ===";
  let (add_student, add_grade, get_ranking, get_statistics) = create_grade_system () in
  
  (* Ajouter des étudiants *)
  List.iter add_student ["Alice"; "Bob"; "Charlie"; "Diana"];
  
  (* Ajouter des notes *)
  add_grade "Alice" 18.5;
  add_grade "Alice" 16.0;
  add_grade "Bob" 14.5;
  add_grade "Bob" 15.5;
  add_grade "Charlie" 19.0;
  add_grade "Diana" 17.5;
  add_grade "Diana" 18.0;
  
  (* Afficher le classement *)
  print_endline "Classement par moyenne :";
  let ranking = get_ranking () in
  List.iteri (fun i student ->
    Printf.printf "%d. %s - Moyenne: %.2f\n" (i+1) student.name student.average
  ) ranking;
  
  (* Statistiques générales *)
  let (class_avg, student_count) = get_statistics () in
  Printf.printf "\nMoyenne de classe: %.2f (%d étudiants)\n" class_avg student_count
