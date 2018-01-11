#!/bin/bash

set -e

# Synthesize?
while true; do
    read -p "Do you wish to synthesize again the netlist? [y/n]" yn
    case $yn in
        [Yy]* ) SYNTH=true;break;;
        [Nn]* ) SYNTH=false;break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Synthesize circuit
cd syn
if [ "$SYNTH" = true ]; then
    rm -rf report* netlist
    mkdir report report_ultra report_fmax netlist
    source /software/scripts/init_synopsys_64
    dc_shell-xg-t -f run-synthesis.tcl
    dc_shell-xg-t -f run-synthesis-ultra_registers.tlc
    dc_shell-xg-t -f run-synthesis_fmax.tcl
fi

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
    vsim -c -L /software/dk/nangate45/verilog/msim6.2g work.tb_filter -do "run -all"
done
