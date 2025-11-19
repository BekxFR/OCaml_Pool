# Ex00: Atoms
# Compilation des classes OCaml

NAME = ex00

# Fichiers sources
SOURCES = atom.ml main.ml

# Fichiers objets natifs
CMX = $(SOURCES:.ml=.cmx)

# Compilateur natif
OCAMLOPT = ocamlopt

# Cible par défaut
all: $(NAME)

# Compilation de l'exécutable natif
$(NAME): $(CMX)
	$(OCAMLOPT) -o $(NAME) $(CMX)

# Règle de compilation OCaml natif
%.cmx: %.ml
	$(OCAMLOPT) -c $<

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
