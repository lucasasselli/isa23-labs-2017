all: filter tb

filter:
	vcom filter_top.vhd

tb:
	vlog tb_filter.v

# Deletes the work folder
clean:
	rm -rf work transcript

# Creates the work folder
init:
	vlib work
