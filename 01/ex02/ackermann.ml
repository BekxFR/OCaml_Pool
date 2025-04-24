let rec ackermann m n =
    if n < 0 || m < 0 then -1
    else if m = 0 then n + 1
    else if n = 0 then ackermann (m - 1) 1
    else ackermann (m - 1) (ackermann m (n - 1))

let () =
    print_endline (string_of_int (ackermann (-1) 7));
    print_endline (string_of_int (ackermann 0 0));
    print_endline (string_of_int (ackermann 2 3));
    print_endline (string_of_int (ackermann 4 1))

(* 
Wilhelm Ackermann (1896-1962) était un mathématicien allemand qui travaillait dans les domaines de la logique mathématique et de la théorie des fondements.
La fonction qui porte son nom a été introduite en 1928 dans sa thèse sur la cohérence de l'arithmétique.
Initialement à trois arguments, mais c'est la version simplifiée à deux arguments qui est devenue célèbre.
Elle a contribué à établir les fondements théoriques de l'informatique en démontrant les limites de certains types de calculs.
Calculabilité et complexité : une des premieres fonctions calculables (récursive) qui n'est pas primitive récursive.
Elle ne peut pas être calculée uniquement avec des boucles for imbriquées avec des bornes fixes, démontrant ainsi les limites des fonctions primitives récursives.
Croissance non primitive récursive : La fonction croît extrêmement rapidement. Par exemple, A(4,2) est déjà un nombre si grand qu'il dépasse largement le nombre d'atomes dans l'univers observable.
Cette croissance rapide en fait un outil important pour étudier les limites de la calculabilité.
Théorie de la complexité : Elle est utilisée comme référence pour mesurer la complexité des algorithmes, notamment pour définir la hiérarchie des fonctions de croissance.
Structure de données : Une version inverse de la fonction d'Ackermann est utilisée dans l'analyse de complexité de certaines structures de données comme l'Union-Find avec compression de chemin.
Limites de la récursion : Débordement de pile (stack overflow) pour des valeurs relativement petites (comme A(4,1) que vous testez), ce qui illustre parfaitement les limites pratiques de la récursion sur les ordinateurs actuels.
La fonction d'Ackermann occupe une position particulière, correspondant à f_ω dans cette hiérarchie.
Cela signifie qu'elle croît plus rapidement que toutes les fonctions f_k pour n'importe quel entier k fixe.
 *)