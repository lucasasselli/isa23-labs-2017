NAME=dct_3_bus_1_ALU
CPATH=../../c

all: ${NAME}.tpef proge bits

${NAME}.tpef: ${NAME}.adf ${CPATH}/main.c ${CPATH}/dct.c
	tcecc -O3 -a ${NAME}.adf -o ${NAME}.tpef -k x -k y ${CPATH}/main.c ${CPATH}/dct.c

bits: ${NAME}.tpef
	generatebits -d -w 4 -p ${NAME}.tpef -x proge-output ${NAME}.adf

proge: 
	generateprocessor -t -i ${NAME}.idf -o proge-output ${NAME}.adf
	cp ../../../common/modsim_simulate.sh proge-output/.

clean:
	rm -rf proge-output ${NAME}.tpef


