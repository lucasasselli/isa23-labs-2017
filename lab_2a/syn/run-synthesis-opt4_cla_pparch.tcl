#Clear old 
remove_design -designs

# Load project
analyze -library WORK -format vhdl {../hdl/ff_gen.vhd}
analyze -library WORK -format vhdl {../hdl/ff_pipe_gen.vhd}
analyze -library WORK -format vhdl {../hdl/fir_stage.vhd}
analyze -library WORK -format vhdl {../hdl/filter_pkg.vhd}
analyze -library WORK -format vhdl {../hdl/filter_top.vhd}

# Preserve RTL name in power consumtpion estimation
set power_preserve_rtl_hier_names true

# Analyze HDL
elaborate filter_top -architecture behavioral -library WORK

# Set constraints
create_clock -name MY_CLK -period 7.92 CLK
set_dont_touch_network MY_CLK
set_clock_uncertainty 0.07 [get_clocks MY_CLK]
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

set_implementation DW01_add/cla [find cell *add_*]
set_implementation DW02_mult/pparch [find cell *mult_*]

# Smart compilation


# compile -map_effort high
compile

# Export optimized netlist
ungroup -all -flatten

change_names -hierarchy -rules verilog
write_sdf netlist/filter_top.sdf
write_sdc netlist/filter_top.sdc
write -hierarchy -format vhdl -output netlist/filter_top.vhdl
write -hierarchy -format verilog -output netlist/filter_top.v

# Report optimized results
report_timing > report4/opt_time_filter_top.txt
report_area > report4/opt_area_filter_top.txt
report_resources > report4/opt_resource_report.txt




# Exit simulation
quit
