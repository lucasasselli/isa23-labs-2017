#Clear old 
sh rm -rf work
remove_design -designs

# Load project
analyze -library WORK -format vhdl {../hdl/filter_top.vhd}

# Preserve RTL name in power consumtpion estimation
set power_preserve_rtl_hier_names true

# Analyze HDL
elaborate filter_top -architecture behavioral -library WORK

# Set constraints
create_clock -name MY_CLK -period 0 CLK
set_dont_touch_network MY_CLK
set_clock_uncertainty 0.07 [get_clocks MY_CLK]
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

# Compile
compile

# Report optimized results
report_timing > report/free_time_filter_top.txt
report_area > report/free_area_filter_top.txt

# Exit simulation
quit
