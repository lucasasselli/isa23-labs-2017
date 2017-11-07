#!/bin/bash

set -e

# Compile HDL for initial simulation
cd hdl
source /software/scripts/init_msim6.2g
make clean
make init
make all
vsim -c work.tb_filter -do "run -all"


# Synthesize circuit
cd ../syn
source /software/scripts/init_synopsys
dc_shell-xg-t -f run-synthesis-free.tcl
dc_shell-xg-t -f run-synthesis-opt.tcl
dc_shell-xg-t -f prepare-saif.tcl

# Compute switching activity
cd ../sim
source /software/scripts/init_msim6.2g
make clean
make init
make all
vsim -c -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_filter/DUT=../syn/netlist/filter_top.sdf -pli /software/synopsys/syn_current/auxx/syn/power/vpower/lib-linux/libvpower.so work.tb_filter -do "run -all"

# Estimate power consumption
cd ../syn
source /software/scripts/init_synopsys
dc_shell-xg-t -f run-power.tcl

# Run physical synthesis
cd ../soce
source /software/scripts/init_edi13
encounter -nowin -init run-encounter.tcl






