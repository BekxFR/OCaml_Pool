# Makefile - Day 20 Exercise 03
# Compilation: ocamlopt
# Files: people.ml, doctor.ml, dalek.ml, army.ml, main.ml

.PHONY: all test clean fclean re

OCAML = ocamlopt
TARGET = army_test
SOURCES = people.ml doctor.ml dalek.ml army.ml main.ml

all: $(TARGET)

$(TARGET): $(SOURCES)
	$(OCAML) -o $(TARGET) $(SOURCES)

clean:
	rm -f *.cmi *.cmx *.o

fclean: clean
	rm -f $(TARGET)

re: fclean all

test: $(TARGET)
	./$(TARGET)

interpret:
	rlwrap ocaml
