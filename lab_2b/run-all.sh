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
source /software/scripts/init_synopsys
dc_shell-xg-t -f run-synthesis-free.tcl
dc_shell-xg-t -f run-synthesis-opt.tcl
dc_shell-xg-t -f prepare-saif.tcl

# Compute pre place-and-route switching activity
cd ../switch-pre
source /software/scripts/init_msim6.2g
make clean
make init
make all
vsim -c -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_filter/DUT=../syn/netlist/filter_top.sdf -pli /software/synopsys/syn_current/auxx/syn/power/vpower/lib-linux/libvpower.so work.tb_filter -do "run -all"

# Estimate power consumption
cd ../syn
source /software/scripts/init_synopsys
dc_shell-xg-t -f run-power.tcl

# Run place and route
cd ../soce
source /software/scripts/init_edi13
encounter -nowin -init run-placeroute.tcl

# Compute pre place-and-route switching activity
cd ../switch-post
source /software/scripts/init_msim6.2g
make clean
make init
make all
vsim -c -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_filter/DUT=../soce/filter_top.sdf work.tb_filter -do "vcd filter_top.vcd; vcd add /tb_filter/DUT/*; run -all"

# Run power analysis
cd ../soce
source /software/scripts/init_edi13
encounter -nowin -init run-power.tcl
