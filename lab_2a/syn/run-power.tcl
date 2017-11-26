# Read netlist
read_verilog -netlist netlist/filter_top.v
read_saif -input ../saif/filter.saif -instance tb_filter/DUT -unit ns -scale 1
create_clock -name MY_CLK CLK
report_power > report/opt_power.txt

quit
