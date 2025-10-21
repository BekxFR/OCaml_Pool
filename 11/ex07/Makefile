# Makefile pour l'exercice 07 - one_nn

.PHONY: all test clean fclean re

OCAML = ocamlopt
NAME = one_nn
SRC = one_nn.ml

all: $(NAME)

$(NAME): $(SRC)
	$(OCAML) $(SRC) -o $(NAME)

test: $(NAME)
	./$(NAME)

clean:
	rm -f *.cmi *.cmx *.o

fclean: clean
	rm -f $(NAME)

re: fclean all

# Compilation avec debug
debug:
	$(OCAML) -g $(SRC) -o $(NAME)_debug

# Test de performance
perf: $(NAME)
	time ./$(NAME)

# Aide
help:
	@echo "Targets disponibles:"
	@echo "  all    - Compile le programme"
	@echo "  test   - Compile et exécute les tests"
	@echo "  clean  - Supprime les fichiers de compilation"
	@echo "  fclean - Supprime tous les fichiers générés"
	@echo "  re     - Nettoie et recompile"
	@echo "  debug  - Compile avec les symboles de debug"
	@echo "  perf   - Teste les performances"
	@echo "  help   - Affiche cette aide"
