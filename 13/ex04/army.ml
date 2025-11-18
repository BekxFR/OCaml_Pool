(* army.ml - Day 13 Exercise 04
 * Ce fichier est requis dans les fichiers à rendre mais non utilisé
 * car galifrey.ml gère directement les listes de combattants.
 *)

(* Classe army non utilisée dans cet exercice *)
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
