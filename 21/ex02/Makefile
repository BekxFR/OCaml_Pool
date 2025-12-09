# Ex02: Alkanes
# Compilation des classes OCaml

NAME = ex02

# Répertoires
ATOM_DIR = ../ex00
MOL_DIR = ../ex01

# Fichiers sources
SOURCES = alkane.ml main.ml

# Fichiers objets natifs
CMX = $(SOURCES:.ml=.cmx)

# Compilateur natif
OCAMLOPT = ocamlopt

# Options de compilation
OCAML_FLAGS = -I $(ATOM_DIR) -I $(MOL_DIR)

# Cible par défaut
# all: base $(NAME)
all: $(NAME)

# Précompilation des dépendances
# base:
# 	@echo "Compiling dependencies..."
# 	$(MAKE) -C $(ATOM_DIR)
# 	$(MAKE) -C $(MOL_DIR)

# Compilation de l'exécutable natif
$(NAME): $(CMX)
	$(OCAMLOPT) $(OCAML_FLAGS) -o $(NAME) $(ATOM_DIR)/atom.cmx $(MOL_DIR)/molecule.cmx $(CMX)

# Règle de compilation OCaml natif
%.cmx: %.ml
	$(MAKE) -C $(MOL_DIR)
	$(OCAMLOPT) $(OCAML_FLAGS) -c $<

# Nettoyage des fichiers temporaires
clean:
	rm -f *.cm[iox] *.o

# Nettoyage complet
fclean: clean
	$(MAKE) -C $(MOL_DIR) fclean
	rm -f $(NAME)

# Reconstruction complète
re: fclean all

# Exécution après compilation
test: all
	./$(NAME)

.PHONY: all clean fclean re test
