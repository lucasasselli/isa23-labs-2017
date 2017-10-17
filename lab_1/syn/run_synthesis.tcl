#Clear old 
remove_design -designs

# Load project
analyze -library WORK -format vhdl {../hdl/filter_top.v}

elaborate filter_top -architecture behavioral -library WORK

compile -exact_map

create_clock -name "CLK" -period 2 CLK

# Export preliminary netlist
write -hierarchy -format vhdl -output netlist/free_synth_filter_top.vhdl
write -hierarchy -format verilog -output netlist/free_synth_filter_top.v

# Report preliminary results
report_timing > report/free_time_filter_top.txt
report_area > report/free_area_filter_top.txt

# set constraints
set_max_delay 2 -from [all_inputs] -to [all_outputs]

compile -map_effort high

# Export optimized netlist
write -hierarchy -format vhdl -output netlist/opt_synth_filter_top.vhdl
write -hierarchy -format verilog -output netlist/opt_time_filter_top.v

# Report optimized results
report_timing > report/opt_time_filter_top.txt
report_area > report/opt_area_filter_top.txt


