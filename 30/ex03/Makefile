NAME = try_monad

SRCS = try_monad.ml
MAIN = main.ml

OCAMLC = ocamlc
OCAMLOPT = ocamlopt

all: $(NAME)

$(NAME):
	$(OCAMLOPT) -c $(SRCS)
	$(OCAMLOPT) -o $(NAME) try_monad.cmx $(MAIN)

test: $(NAME)
	./$(NAME)

clean:
	rm -f *.cm[iox] *.o

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all test clean fclean re
