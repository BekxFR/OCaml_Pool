NAME = try_monad

SRCS = param.ml
MAIN = main.ml

OCAMLC = ocamlc
OCAMLOPT = ocamlopt

all: $(NAME)

$(NAME):
	$(OCAMLOPT) -c $(SRCS)
	$(OCAMLOPT) -o $(NAME) param.cmx $(MAIN)

test: all
	./$(NAME)

clean:
	rm -f *.cm[iox] *.o

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all test clean fclean re
