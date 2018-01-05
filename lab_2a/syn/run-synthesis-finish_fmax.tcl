compile


# Report optimized results
report_area > report_fmax/${REPORTPREF}_area.txt
report_timing > report_fmax/${REPORTPREF}_timing.txt
report_resources -hierarchy > report_fmax/${REPORTPREF}_resources.txt



# Export optimized netlist
ungroup -all -flatten
write -hierarchy -format verilog -output netlist/${REPORTPREF}_filter_top.vhdl
