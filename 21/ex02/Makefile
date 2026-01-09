# Ex02: Alkanes
# Compilation des classes OCaml

NAME = ex02

ATOM_DIR = ../ex00
MOL_DIR = ../ex01

SOURCES = alkane.ml main.ml

CMX = $(SOURCES:.ml=.cmx)

OCAMLOPT = ocamlopt

OCAML_FLAGS = -I $(ATOM_DIR) -I $(MOL_DIR)

all: $(NAME)

$(NAME): $(CMX)
	$(OCAMLOPT) $(OCAML_FLAGS) -o $(NAME) $(ATOM_DIR)/atom.cmx $(MOL_DIR)/molecule.cmx $(CMX)

%.cmx: %.ml
	$(MAKE) -C $(MOL_DIR)
	$(OCAMLOPT) $(OCAML_FLAGS) -c $<

clean:
	rm -f *.cm[iox] *.o

fclean: clean
	$(MAKE) -C $(MOL_DIR) fclean
	rm -f $(NAME)

re: fclean all

test: all
	./$(NAME)

.PHONY: all clean fclean re test
