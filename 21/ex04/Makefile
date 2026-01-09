# Ex04: Alkane Combustion
# Compilation des classes OCaml

NAME = ex04

ATOM_DIR = ../ex00
MOL_DIR = ../ex01
ALK_DIR = ../ex02
REAC_DIR = ../ex03

SOURCES = alkane_combustion.ml main.ml

CMX = $(SOURCES:.ml=.cmx)

OCAMLOPT = ocamlopt

OCAML_FLAGS = -I $(ATOM_DIR) -I $(MOL_DIR) -I $(ALK_DIR) -I $(REAC_DIR)

all: $(NAME)

$(NAME): $(CMX)
	$(OCAMLOPT) $(OCAML_FLAGS) -o $(NAME) \
		$(ATOM_DIR)/atom.cmx \
		$(MOL_DIR)/molecule.cmx \
		$(ALK_DIR)/alkane.cmx \
		$(REAC_DIR)/reaction.cmx \
		$(CMX)

%.cmx: %.ml
	$(MAKE) -C $(REAC_DIR)
	$(OCAMLOPT) $(OCAML_FLAGS) -c $<

clean:
	rm -f *.cm[iox] *.o

fclean: clean
	$(MAKE) -C $(REAC_DIR) fclean
	rm -f $(NAME)

re: fclean all

test: all
	./$(NAME)

.PHONY: all clean fclean re test
