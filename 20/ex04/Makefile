# Makefile - Day 20 Exercise 04
# Compilation: ocamlopt
# Files: people.ml, doctor.ml, dalek.ml, army.ml, galifrey.ml, main.ml

.PHONY: all test clean fclean re

OCAML = ocamlopt
TARGET = time_war
SOURCES = people.ml doctor.ml dalek.ml army.ml galifrey.ml main.ml

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
