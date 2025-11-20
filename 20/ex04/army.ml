(* army.ml
 * Ce fichier est requis dans les fichiers à rendre mais non utilisé
 * car galifrey.ml gère directement les listes de combattants.
 *)

class ['a] army =
object (self)
  (* Attribut members - liste d'instances de type 'a *)
  val mutable members : 'a list = []
  
  (* Initializer *)
  initializer
    print_endline "A new army has been formed!"
  
  (* add - ajoute un membre à la liste
   * Par défaut, j'ajoute en tête (front) car c'est plus efficace en OCaml
   * Méthode add_back pour ajouter à la fin *)
  method add (member : 'a) : unit =
    let random_pos = Random.int 2 in
    if random_pos = 0 then
      self#add_front member
    else 
      self#add_back member
  
  (* add_front - ajoute un membre au début de la liste *)
  method add_front (member : 'a) : unit =
    members <- member :: members;
    print_endline "  -> New member added to the army (front)"
  
  (* add_back - ajoute un membre à la fin de la liste *)
  method add_back (member : 'a) : unit =
    members <- List.append members [member];
    print_endline "  -> New member added to the army (back)"
  
  (* delete - retire le premier élément de la liste (front)
   * Retourne unit *)
  method delete : unit =
    let random_pos = Random.int 2 in
    if random_pos = 0 then
      self#delete_front
    else
      self#delete_back
  
  (* delete_front - retire le premier élément de la liste (front) *)
  method delete_front : unit =
    match members with
    | [] -> print_endline "  -> Army is empty, cannot delete"
    | _ :: rest -> 
        members <- rest;
        print_endline "  -> Member removed from the army (front)"
  
  (* delete_back - retire le dernier élément de la liste (back) *)
  method delete_back : unit =
    match List.rev members with
    | [] -> print_endline "  -> Army is empty, cannot delete"
    | _ :: rest -> 
        members <- List.rev rest;
        print_endline "  -> Member removed from the army (back)"
  
  (* size - retourne la taille de l'armée *)
  method size : int =
    List.length members
  
  (* is_empty - vérifie si l'armée est vide *)
  method is_empty : bool =
    members = []
  
  (* get_members - retourne la liste des membres *)
  method get_members : 'a list =
    members
end
