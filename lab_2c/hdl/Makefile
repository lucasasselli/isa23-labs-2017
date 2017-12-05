all: filter

filter:  filter_pkg.vhd ff_gen.vhd ff_pipe_gen.vhd fir_stage.vhd filter_top.vhd tb_filter.v
	vcom filter_pkg.vhd
	vcom ff_gen.vhd
	vcom ff_pipe_gen.vhd
	vcom fir_stage.vhd
	vcom filter_top.vhd
	vlog tb_filter.v

# Deletes the work folder
clean:
	rm -rf work transcript *.wlf

# Creates the work folder
init:
	vlib work 
