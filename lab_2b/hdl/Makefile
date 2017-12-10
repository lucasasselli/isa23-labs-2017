all: filter

filter:  booth
	vcom filter_pkg.vhd
	vcom ff_gen.vhd
	vcom ff_pipe_gen.vhd
	vcom fir_stage.vhd
	vcom filter_top.vhd
	vlog tb_filter.v
	
booth: 
	vcom booth_mult_pkg.vhd
	vcom ha.vhd
	vcom fa.vhd
	vcom rca.vhd
	vcom booth_encoder.vhd
	vcom dadda_plane.vhd
	vcom booth_mult.vhd

# Deletes the work folder
clean:
	rm -rf work transcript *.wlf

# Creates the work folder
init:
	vlib work 
