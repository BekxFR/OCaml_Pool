let fibonacci n =
    let rec aux n a b =
        if n = 0 then a
        else aux (n - 1) b (a + b)
    in
    if n < 0 then -1
    else aux n 0 1

let () = 
    print_endline (string_of_int (fibonacci (-42)));
    print_endline (string_of_int (fibonacci 0));   (* Devrait afficher 0 *)
    print_endline (string_of_int (fibonacci 1));   (* Devrait afficher 1 *)
    print_endline (string_of_int (fibonacci 2));   (* Devrait afficher 1 *)
    print_endline (string_of_int (fibonacci 3));   (* Devrait afficher 2 *)
    print_endline (string_of_int (fibonacci 6));   (* Devrait afficher 8 *)
    print_endline (string_of_int (fibonacci 10));  (* Devrait afficher 55 *)
    print_endline (string_of_int (fibonacci 20))   (* Devrait afficher 6765 *)


(* 
Leonardo Fibonacci (1170-1240) était un mathématicien italien du Moyen Âge.
La séquence de Fibonacci a été introduite dans son livre "Liber Abaci" (1202) pour résoudre un problème concernant la reproduction des lapins.
Le problème était formulé ainsi :
"Combien de paires de lapins seront produites en un an, en commençant par une seule paire, si chaque mois chaque paire donne naissance à une nouvelle paire qui devient productive à partir du deuxième mois ?"
Fibonacci a découvert la séquence 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ... où chaque nombre est la somme des deux précédents.
Importance en mathématiques :
- Le nombre d'or (φ) : Le rapport entre deux nombres consécutifs tend vers le nombre d'or (environ 1,618...)
Ce nombre irrationnel a des propriétés mathématiques fascinantes.
- Théorie des nombres : Le PGCD de deux nombres de Fibonacci consécutifs est toujours 1.
- Spirale de Fibonacci : En dessinant des carrés dont les côtés correspondent aux nombres de Fibonacci et en traçant une spirale qui relie les coins opposés de ces carrés, on obtient une approximation de la spirale logarithmique.
Importance dans l'art et la nature :
- Proportions en art : Le nombre d'or, dérivé de la séquence de Fibonacci, a été utilisé par de nombreux artistes comme Léonard de Vinci pour créer des compositions harmonieuses.
- Architecture : On retrouve les proportions de Fibonacci dans de nombreux bâtiments célèbres, du Parthénon aux pyramides égyptiennes.
- Phyllotaxie : Dans la nature, la séquence de Fibonacci apparaît dans la disposition des feuilles autour d'une tige (phyllotaxie), dans les spirales des pommes de pin, des ananas, des tournesols, et dans de nombreuses autres structures biologiques.
- Coquilles d'escargots et nautiles : Ces structures naturelles suivent souvent une spirale logarithmique basée sur le nombre d'or.
Importance en informatique :
- Analyse d'algorithmes : Souvent utilisée pour illustrer différentes techniques algorithmiques (récursion, programmation dynamique, mémorisation).
- Structures de données : Les arbres de Fibonacci sont utilisés dans certaines implémentations efficaces de files de priorité.
- Générateurs de nombres pseudo-aléatoires : Certains générateurs utilisent des propriétés de la séquence de Fibonacci.
- Benchmark de performance : Permet de calculer les nombres de Fibonacci est souvent utilisé comme benchmark pour tester l'efficacité des langages de programmation et des techniques d'optimisation.
 *)