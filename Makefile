OCC=			ocamlc
CXX=			g++
IDIR=			include
LDIRS=			
LFLAGS=			$(LDIRS)
CFLAGS=			-std=c++11	
RM=				rm -f
CP=				cp -f

NAME=			search
ONAME=			search-ocaml
CNAME=			search-cpp

OSRC=			src/main.ml
CSRC=			src/main.cpp
OOBJ=			$(OSRC:.ml=.cmo)
COBJ=			$(CSRC:.cpp=.o)

all: $(NAME)

$(NAME): $(ONAME) $(CNAME)

$(ONAME): $(OOBJ)
	$(OCC) $(OOBJ) -o $(ONAME)

$(CNAME): $(COBJ)
	$(CXX) $(COBJ) -o $(CNAME) $(CFLAGS) $(LFLAGS)

%.cmo: %.ml
	$(OCC) -c $< -o $@

%.o: %.cpp
	$(CXX) -c $< -o $@ $(CFLAGS)

clean:
	$(RM) $(OOBJ) $(COBJ)

fclean: clean
	$(RM) $(ONAME) $(CNAME)

re: fclean all

.PHONY: clean fclean re
