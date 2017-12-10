all: filter

filter:  	
	vcom ../../lab_1b/hdl/filter_pkg.vhd
	vcom ../../lab_1b/hdl/ff_gen.vhd
	vcom ../../lab_1b/hdl/ff_pipe_gen.vhd
	vcom ../../lab_1b/hdl/mul.vhd
	vcom ../../lab_1b/hdl/fir_stage.vhd
	vlog filter_top.v
	vlog ../../lab_1b/hdl/tb_filter.v

# Deletes the work folder
clean:
	rm -rf work transcript *.wlf filter_top.v

# Creates the work folder
init: clean
	vlib work 
