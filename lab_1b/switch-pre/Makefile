all: filter

filter:
	vlog ../syn/netlist/filter_top.v
	vlog tb_filter.v

# Deletes the work folder
clean:
	rm -rf work transcript

# Creates the work folder
init:
	vlib work
