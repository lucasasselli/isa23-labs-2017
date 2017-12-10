#!/bin/bash

set -e

# Synthesize circuit
cd ../syn
source /software/scripts/init_synopsys_64
dc_shell-xg-t -f run-synthesis.tcl

# Test all circuits
cd ../test
source /software/scripts/init_msim6.2g
FILES=../syn/netlist/*
for f in $FILES
do
    echo "Testing $f file..."
    make init
    cp $f filter_top.v 
    make all
    vsim -c work.tb_filter -do "run -all"
done
