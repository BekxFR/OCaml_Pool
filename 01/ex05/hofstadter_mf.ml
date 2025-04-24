let rec hfs_f n =
	if n < 0 then -1
	else if n = 0 then 1
	else (n - (hfs_m (hfs_f (n - 1))))

and hfs_m n = 
	if n < 0 then -1
	else if n = 0 then 0
	else (n - (hfs_f (hfs_m (n - 1))))

let () =
	print_endline (string_of_int (hfs_m 0));
	print_endline (string_of_int (hfs_f 0));
	print_endline (string_of_int (hfs_m 1));
	print_endline (string_of_int (hfs_m 2));
	print_endline (string_of_int (hfs_f 2));
	print_endline (string_of_int (hfs_m 3));
	print_endline (string_of_int (hfs_f 4));
	print_endline (string_of_int (hfs_m 5));
	print_endline (string_of_int (hfs_f 6));
	print_endline (string_of_int (hfs_m 7));
	print_endline (string_of_int (hfs_f 8));
	print_endline (string_of_int (hfs_m 8));
	print_endline (string_of_int (hfs_m 9));
	print_endline (string_of_int (hfs_f 10))


(* 
Douglas Hofstadter (né en 1945) est un universitaire américain, physicien, informaticien et philosophe cognitif.*
Les séquences de Hofstadter Femelle (F) et Mâle (M) ont été introduites par Douglas Hofstadter dans son livre "Gödel, Escher, Bach".
Ces séquences font partie d'une famille plus large de séquences auto-référentielles qu'il a créées.
Importance en informatique et en mathématiques :
- Auto-référence et récursivité : Ces séquences sont des exemples parfaits de définitions auto-référentielles et mutuellement récursives.
Elles illustrent comment des règles simples peuvent générer des comportements complexes.
- Théorie de la complexité : Les séquences de Hofstadter sont étudiées pour leurs propriétés mathématiques et leur comportement asymptotique.
Elles présentent des motifs intéressants qui ne sont pas immédiatement évidents à partir de leur définition.
- Systèmes formels : Elles servent d'exemples de systèmes formels simples qui génèrent des comportements difficiles à prédire, illustrant ainsi les limites de la prévisibilité dans les systèmes formels.
- Intelligence artificielle : Ces séquences ont été utilisées pour explorer des concepts d'émergence et d'auto-organisation, qui sont importants dans l'étude de l'intelligence artificielle.
Propriétés mathématiques :
Pour tout n > 0, F(n) + M(n) = n
 *)