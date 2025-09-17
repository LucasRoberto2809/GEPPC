EXECUTAVEL = gerador

SRC_FLEX = gerador.l
SRC_BISON = gerador.y
SRC_UTILS = utilitarios/utilitarios.c

OBJ_FILES = gerador.tab.o lex.yy.o utilitarios.o

ALL_FILES = $(OBJ_FILES) gerador.tab.c gerador.tab.h lex.yy.c gerador.output

# Cria executável e limpar arquivos temporários
all: $(EXECUTAVEL) clean
	@echo "Executável compilador com sucesso !"

$(EXECUTAVEL): $(OBJ_FILES)
	@gcc $(OBJ_FILES) -o $(EXECUTAVEL)

gerador.tab.o: $(SRC_BISON)
	@bison -d $(SRC_BISON)
	@gcc -c gerador.tab.c -Iutilitarios

lex.yy.o: $(SRC_FLEX)
	@flex $(SRC_FLEX)
	@gcc -c lex.yy.c -Iutilitarios

utilitarios.o: $(SRC_UTILS)
	@gcc -c $(SRC_UTILS)

clean:
	@if [ -n "$(wildcard $(ALL_FILES))" ]; then \
		rm $(wildcard $(ALL_FILES)); \
	else \
		@echo "Nada para fazer..."; \
	fi
