# Ex01: Molecules
# Compilation des classes OCaml

NAME = ex01

# Fichiers sources
ATOM_DIR = ../ex00
SOURCES = molecule.ml main.ml

# Fichiers objets natifs
CMX = $(SOURCES:.ml=.cmx)

# Compilateur natif
OCAMLOPT = ocamlopt

# Cible par défaut
all: $(NAME)

# Compilation de l'exécutable natif
$(NAME): $(CMX)
	$(OCAMLOPT) -I $(ATOM_DIR) -o $(NAME) $(ATOM_DIR)/atom.cmx $(CMX)

# Règle de compilation OCaml natif
%.cmx: %.ml
	$(OCAMLOPT) -I $(ATOM_DIR) -c $<

# Nettoyage des fichiers temporaires
clean:
	rm -f *.cm[iox] *.o

# Nettoyage complet
fclean: clean
	rm -f $(NAME)

# Reconstruction complète
re: fclean all

# Exécution après compilation
run: all
	./$(NAME)

.PHONY: all clean fclean re run
