# Ex01: Molecules
# Compilation des classes OCaml

NAME = ex01

ATOM_DIR = ../ex00
SOURCES = molecule.ml main.ml

CMX = $(SOURCES:.ml=.cmx)

OCAMLOPT = ocamlopt

all: $(NAME)

$(NAME): $(CMX)
	$(OCAMLOPT) -I $(ATOM_DIR) -o $(NAME) $(ATOM_DIR)/atom.cmx $(CMX)

%.cmx: %.ml
	$(MAKE) -C $(ATOM_DIR)
	$(OCAMLOPT) -I $(ATOM_DIR) -c $<

clean:
	$(MAKE) -C $(ATOM_DIR) fclean
	rm -f *.cm[iox] *.o

fclean: clean
	rm -f $(NAME)

re: fclean all

test: all
	./$(NAME)

.PHONY: all clean fclean re test
