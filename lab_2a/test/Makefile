all: filter

filter:  	
	vlog filter_top.v
	vlog tb_filter.v

# Deletes the work folder
clean:
	rm -rf work transcript *.wlf filter_top.v

# Creates the work folder
init: clean
	vlib work 
