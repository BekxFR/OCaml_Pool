(* army.ml
 * Ce fichier est requis dans les fichiers à rendre mais non utilisé
 * car galifrey.ml gère directement les listes de combattants.
 *)

class ['a] army =
object (self)
  val mutable members : 'a list = []
  
  method add (member : 'a) : unit =
    members <- member :: members
  
  method delete : unit =
    match members with
    | [] -> ()
    | _ :: rest -> members <- rest
  
  method size : int =
    List.length members
end
