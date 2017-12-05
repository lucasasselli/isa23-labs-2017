all: filter

filter: booth_mul filter_pkg.vhd ff_gen.vhd ff_pipe_gen.vhd fir_stage.vhd filter_top.vhd tb_filter.v
	vcom filter_pkg.vhd
	vcom ff_gen.vhd
	vcom ff_pipe_gen.vhd
	vcom fir_stage.vhd
	vcom filter_top.vhd
	vlog tb_filter.v

booth_mul: fa.vhd ha.vhd rca.vhd booth_mult_pkg.vhd booth_encoder.vhd dadda_plane.vhd booth_mult.vhd
	vcom fa.vhd 
	vcom ha.vhd 
	vcom rca.vhd 
	vcom booth_mult_pkg.vhd 
	vcom booth_encoder.vhd 
	vcom dadda_plane.vhd 
	vcom booth_mult.vhd

# Deletes the work folder
clean:
	rm -rf work transcript *.wlf

# Creates the work folder
init:
	vlib work 
