all: filter

filter:  filter_top.vhd tb_filter.v
	vcom filter_top.vhd
	vlog tb_filter.v

# Deletes the work folder
clean:
	rm -rf work transcript *.wlf

# Creates the work folder
init: clean
	vlib work 
