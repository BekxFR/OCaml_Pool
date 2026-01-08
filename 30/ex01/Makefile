NAME = ex01

SOURCES = parson.ml main.ml

CMX = $(SOURCES:.ml=.cmx)

OCAMLOPT = ocamlopt

all: $(NAME)

$(NAME): $(CMX)
	$(OCAMLOPT) -o $(NAME) $(CMX)

%.cmx: %.ml
	$(OCAMLOPT) -c $<

clean:
	rm -f *.cm[iox] *.o

fclean: clean
	rm -f $(NAME)

re: fclean all

test: all
	./$(NAME)

.PHONY: all clean fclean re test