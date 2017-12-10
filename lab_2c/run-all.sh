#!/bin/bash

set -e

# Compile HDL for initial simulation
cd hdl
source /software/scripts/init_msim6.2g
make init
make all
vsim -c work.tb_filter -do "run -all"


# Synthesize circuit
cd ../syn
source /software/scripts/init_synopsys_64
dc_shell-xg-t -f run-synthesis-ultra_registers.tcl
