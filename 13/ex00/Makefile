# Makefile for Day 13 Ex00
# Compiler: ocamlopt as required

.PHONY: all test clean fclean re

OCAMLOPT = ocamlopt
EXEC = a.out

all: $(EXEC)

$(EXEC):
	$(OCAMLOPT) -o $(EXEC) people.ml main.ml

clean:
	rm -f *.cmi *.cmx *.o *.cmo *.out

fclean: clean
	rm -f $(EXEC)

re: fclean all

test: all
	./$(EXEC)
