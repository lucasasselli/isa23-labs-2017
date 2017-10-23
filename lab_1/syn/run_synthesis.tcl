#Clear old 
remove_design -designs

# Load project
define design lib WORK -path ./work
set search path [list . /software/synopsys/syn current/libraries/syn/software/dk/nangate45/synopsys ]
set link library [list "*" "NangateOpenCellLibrary typical ecsm.db" "dw foundation.sldb" ]
set target library [list "NangateOpenCellLibrary typical ecsm.db" ]
set synthetic library [list "dw foundation.sldb" ]

analyze -library WORK -format vhdl {../hdl/filter_top.v}

# Preserve RTL name in power consumtpion estimation
set_power_preserve_rtl_hier_names true

# Analyze HDL
elaborate filter_top -architecture behavioral -library WORK

# Dumb compilation
compile -exact_map

# Export preliminary netlist
write -hierarchy -format vhdl -output netlist/free_synth_filter_top.vhdl
write -hierarchy -format verilog -output netlist/free_synth_filter_top.v

# Report preliminary results
report_timing > report/free_time_filter_top.txt
report_area > report/free_area_filter_top.txt

# set constraints
create_clock -name MY_CLK -period 2 CLK
set_dont_touch_network MY_CLK
set_clock_uncertainty 0.07 [get_clocks MY_CLK]
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

# Smart compilation
compile -map_effort high

# Export optimized netlist
ungroup -all -flatten
change names -hierarchy -rules verilog
write_sdf ../netlist/filter.sdf
write sdc ../netlist/filter.sdc
write -hierarchy -format vhdl -output netlist/opt_synth_filter_top.vhdl
write -hierarchy -format verilog -output netlist/opt_time_filter_top.v

# Report optimized results
report_timing > report/opt_time_filter_top.txt
report_area > report/opt_area_filter_top.txt


