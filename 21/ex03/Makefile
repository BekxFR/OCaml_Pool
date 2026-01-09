# Ex03: Reactions
# Compilation des classes OCaml

NAME = ex03

ATOM_DIR = ../ex00
MOL_DIR = ../ex01
ALK_DIR = ../ex02

SOURCES = reaction.ml main.ml

CMX = $(SOURCES:.ml=.cmx)

OCAMLOPT = ocamlopt

OCAML_FLAGS = -I $(ATOM_DIR) -I $(MOL_DIR) -I $(ALK_DIR)

all: $(NAME)

$(NAME): $(CMX)
	$(OCAMLOPT) $(OCAML_FLAGS) -o $(NAME) \
		$(ATOM_DIR)/atom.cmx \
		$(MOL_DIR)/molecule.cmx \
		$(ALK_DIR)/alkane.cmx \
		$(CMX)

%.cmx: %.ml
	$(MAKE) -C $(ALK_DIR)
	$(OCAMLOPT) $(OCAML_FLAGS) -c $<

clean:
	rm -f *.cm[iox] *.o

fclean: clean
	$(MAKE) -C $(ALK_DIR) fclean
	rm -f $(NAME)

re: fclean all

test: all
	./$(NAME)

.PHONY: all clean fclean re test
