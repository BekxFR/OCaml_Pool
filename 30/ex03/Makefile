NAME = try_monad

SRCS = param.ml
MAIN = main.ml

OCAMLC = ocamlc
OCAMLOPT = ocamlopt

all: $(NAME)

$(NAME):
	@echo "Compilation du module Try..."
	$(OCAMLOPT) -c $(SRCS)
	$(OCAMLOPT) -o $(NAME) param.cmx $(MAIN)
	@echo "✓ Compilation terminée"

test: $(NAME)
	@echo "Exécution des tests..."
	./$(NAME)

interactive:
	@echo "Lancement du toplevel OCaml avec le module Try..."
	ocaml main.ml

clean:
	@echo "Nettoyage des fichiers objets..."
	rm -f *.cm[iox] *.o *.cmt *.cmti

fclean: clean
	@echo "Nettoyage complet..."
	rm -f $(NAME)

re: fclean all

.PHONY: all test interactive clean fclean re
