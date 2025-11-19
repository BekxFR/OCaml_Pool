# Ex03: Reactions
# Compilation des classes OCaml

NAME = ex03

# Répertoires
ATOM_DIR = ../ex00
MOL_DIR = ../ex01
ALK_DIR = ../ex02

# Fichiers sources
SOURCES = reaction.ml main.ml

# Fichiers objets natifs
CMX = $(SOURCES:.ml=.cmx)

# Compilateur natif
OCAMLOPT = ocamlopt

# Options de compilation
OCAML_FLAGS = -I $(ATOM_DIR) -I $(MOL_DIR) -I $(ALK_DIR)

# Cible par défaut
all: $(NAME)

# Compilation de l'exécutable natif
$(NAME): $(CMX)
	$(OCAMLOPT) $(OCAML_FLAGS) -o $(NAME) \
		$(ATOM_DIR)/atom.cmx \
		$(MOL_DIR)/molecule.cmx \
		$(ALK_DIR)/alkane.cmx \
		$(CMX)

# Règle de compilation OCaml natif
%.cmx: %.ml
	$(OCAMLOPT) $(OCAML_FLAGS) -c $<

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
