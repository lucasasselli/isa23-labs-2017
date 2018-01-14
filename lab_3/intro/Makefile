all: main dct.tpef dct_custom_op.tpef

main: main.c dct.c dct.h
	gcc -O3 -o main main.c dct.c -DDEBUG

dct.tpef: start.adf main.c dct.c dct.h
	tcecc -O3 -a start.adf -o dct.tpef -k x -k y main.c dct.c

dct_custom_op.tpef: custom.adf main.c dct_custom_op.c dct.h
	tcecc -O3 -a custom.adf -o dct_custom_op.tpef -k x -k y main.c dct_custom_op.c

bits: dct_custom_op.tpef
	generatebits -d -w 4 -p dct_custom_op.tpef -x auto custom.adf


clean:
	rm -f main dct.tpef


