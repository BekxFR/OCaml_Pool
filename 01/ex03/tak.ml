let rec tak x y z =
	if y < x then tak (tak (x - 1) y z) (tak (y - 1) z x) (tak (z - 1) x y)
	else z

let () =
	print_endline(string_of_int (tak 1 2 3));
	print_endline(string_of_int (tak 5 23 7));
	print_endline(string_of_int (tak 9 1 0));
	print_endline(string_of_int (tak 1 1 1));
	print_endline(string_of_int (tak 0 42 0));
	print_endline(string_of_int (tak 3498 98734 98776))

(* 
Takeuchi Ikuo (竹内郁雄) est un informaticien japonais qui a travaillé dans le domaine des langages de programmation et de l'intelligence artificielle.
La fonction Tak (parfois appelée fonction de Takeuchi) a été introduite par Ikuo Takeuchi en 1978 comme un benchmark pour évaluer les performances des implémentations de langages fonctionnels,
particulièrement pour tester l'efficacité des mécanismes d'évaluation et d'optimisation de la récursion.
C'est un benchmark pertinent pour évaluer les performances des langages de programmation fonctionnels et leurs implémentations.
Benchmark pour les langages fonctionnels : Conçue spécifiquement pour tester l'efficacité des implémentations de langages fonctionnels, en particulier leur capacité à gérer la récursion multiple et profonde.
Elle est devenue l'un des benchmarks standard pour comparer les performances des différents langages et compilateurs fonctionnels.
Test d'optimisation de récursion : Génère un très grand nombre d'appels récursifs pour des valeurs d'entrée relativement petites, ce qui en fait un excellent test pour les techniques d'optimisation de récursion comme la mémorisation et l'élimination de la récursion terminale.
Évaluation des stratégies d'évaluation : Permet de comparer l'efficacité de différentes stratégies d'évaluation (évaluation stricte vs paresseuse) dans les langages fonctionnels.
Dans les langages à évaluation paresseuse comme Haskell, la fonction Tak se comporte différemment que dans les langages à évaluation stricte comme OCaml.
Étude des propriétés mathématiques : La fonction a des propriétés mathématiques intéressantes, notamment sa terminaison garantie malgré sa récursivité complexe.
Démonstration de l'importance de la mise en cache : Calcule de nombreuses fois les mêmes valeurs, ce qui en fait un excellent exemple pour démontrer l'importance des techniques de mise en cache et de mémorisation.
 *)