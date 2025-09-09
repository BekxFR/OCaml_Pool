.PHONY: all test clean fclean re

OCAML = ocamlopt

all:
	$(OCAML) *.ml

clean:
	rm -f *.cmi
	rm -f *.cmx
	rm -f *.o

fclean: clean
	rm -f *.cmi
	rm -f *.cmx
	rm -f *.o
	rm -f *.out

re: fclean all

test: all
	./a.out

interpret:
	rlwrap ocaml
