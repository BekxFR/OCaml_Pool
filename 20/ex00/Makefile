# Compiler: ocamlopt as required
# Files: people.ml, main.ml

.PHONY: all test clean fclean re

OCAMLOPT = ocamlopt
EXEC = people_test

all: $(EXEC)

$(EXEC):
	$(OCAMLOPT) -o $(EXEC) people.ml main.ml

clean:
	rm -f *.cmi *.cmx *.o *.cmo

fclean: clean
	rm -f $(EXEC)

re: fclean all

test: all
	./$(EXEC)
