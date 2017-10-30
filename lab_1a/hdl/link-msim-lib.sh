#!/bin/bash
vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_filter/DUT=../syn/netlist/filter.sdf -pli /software/synopsys/syn_current/auxx/syn/power/vpower/lib-linux/libvpower.so work.tb_filter
