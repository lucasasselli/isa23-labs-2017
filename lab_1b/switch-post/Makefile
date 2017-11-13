all: filter

filter:
	vlog ../soce/filter_top.v
	vlog ../hdl/tb_filter.v

# Deletes the work folder
clean:
	rm -rf work transcript *.wlf

# Creates the work folder
init:
	vlib work
