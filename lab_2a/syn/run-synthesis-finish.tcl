compile

# Export optimized netlist
ungroup -all -flatten
write -hierarchy -format verilog -output netlist/${REPORTPREF}_filter_top.vhdl

# Report optimized results
report_area > report/${REPORTPREF}_area.txt
report_timing > report/${REPORTPREF}_timing.txt
report_resources -hierarchy > report/${REPORTPREF}_resources.txt
