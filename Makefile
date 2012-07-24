CC=				ocamlc
IDIR=			include
LDIRS=			
LFLAGS=			$(LDIRS)
CFLAGS=			
RM=				rm -f
CP=				cp -f

NAME=			search

SRC=			src/main.ml \

OBJ=			$(SRC:.ml=.cmo)

all: $(NAME)

$(NAME):	$(OBJ)
	$(CC) $(OBJ) -o $(NAME) $(CFLAGS) $(LFLAGS)

%.cmo: %.ml
	$(CC) -c $< -o $@ $(CFLAGS)

clean:
	$(RM) $(OBJ)

fclean: clean
	$(RM) $(NAME)

re: fclean all

.PHONY: clean fclean re
