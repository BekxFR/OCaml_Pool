# Ex05: Incomplete Combustion
# Compilation des classes OCaml

NAME = ex05

ATOM_DIR = ../ex00
MOL_DIR = ../ex01
ALK_DIR = ../ex02
REAC_DIR = ../ex03
COMB_DIR = ../ex04

SOURCES = incomplete_combustion.ml main.ml

CMX = $(SOURCES:.ml=.cmx)

OCAMLOPT = ocamlopt

OCAML_FLAGS = -I $(ATOM_DIR) -I $(MOL_DIR) -I $(ALK_DIR) -I $(REAC_DIR) -I $(COMB_DIR)

all: $(NAME)

$(NAME): $(CMX)
	$(OCAMLOPT) $(OCAML_FLAGS) -o $(NAME) \
		$(ATOM_DIR)/atom.cmx \
		$(MOL_DIR)/molecule.cmx \
		$(ALK_DIR)/alkane.cmx \
		$(REAC_DIR)/reaction.cmx \
		$(COMB_DIR)/alkane_combustion.cmx \
		$(CMX)

%.cmx: %.ml
	$(MAKE) -C $(COMB_DIR)
	$(OCAMLOPT) $(OCAML_FLAGS) -c $<

clean:
	rm -f *.cm[iox] *.o

fclean: clean
	$(MAKE) -C $(COMB_DIR) fclean
	rm -f $(NAME)

re: fclean all

test: all
	./$(NAME)

.PHONY: all clean fclean re test
