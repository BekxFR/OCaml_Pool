# Makefile for Day 13 Ex00
# Compiler: ocamlopt as required

.PHONY: all test clean fclean re

OCAMLOPT = ocamlopt
EXEC = people_test

all: $(EXEC)

$(EXEC): people.ml main.ml
	$(OCAMLOPT) -o $(EXEC) people.ml main.ml

clean:
	rm -f *.cmi *.cmx *.o

fclean: clean
	rm -f $(EXEC)

re: fclean all

test: all
	./$(EXEC)
