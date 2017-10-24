all: std switching

std: filter_rtl tb

switch: filter_syn tb_special

filter_rtl:
	vcom filter_top.vhd

filter_syn:
	vlog ../syn/netlist/opt_filter_top.v

tb:
	vlog tb_filter.v

tb_switch:
	vlog tb_filter_switch.v

# Deletes the work folder
clean:
	rm -rf work transcript

# Creates the work folder
init:
	vlib work
