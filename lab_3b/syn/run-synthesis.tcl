#Clear old 
sh rm -rf work
remove_design -designs

# Load project
analyze -library WORK -format vhdl {../tce/proge-output/vhdl/add_and_eq_gt_gtu_ior_shl_shr_shru_sub_sxhw_sxqw_xor.vhdl}
analyze -library WORK -format vhdl {../tce/proge-output/vhdl/ldh_ldhu_ldq_ldqu_ldw_sth_stq_stw.vhdl}
analyze -library WORK -format vhdl {../tce/proge-output/vhdl/lift.vhd}
analyze -library WORK -format vhdl {../tce/proge-output/vhdl/rf_1wr_1rd_always_1_guarded_0.vhd}
analyze -library WORK -format vhdl {../tce/proge-output/vhdl/sramrf_1wr_1rd_always_1.vhd}
analyze -library WORK -format vhdl {../tce/proge-output/vhdl/tce_util_pkg.vhdl}
analyze -library WORK -format vhdl {../tce/proge-output/vhdl/tta0.vhdl}
analyze -library WORK -format vhdl {../tce/proge-output/vhdl/tta0_globals_pkg.vhdl}
analyze -library WORK -format vhdl {../tce/proge-output/vhdl/tta0_imem_mau_pkg.vhdl}
analyze -library WORK -format vhdl {../tce/proge-output/vhdl/tta0_params_pkg.vhdl}
analyze -library WORK -format vhdl {../tce/proge-output/vhdl/util_pkg.vhdl}
analyze -library WORK -format vhdl {../tce/proge-output/vhdl/xilinx_rams_14.vhd}

analyze -library WORK -format vhdl {../tce/proge-output/gcu_ic/decoder.vhdl}
analyze -library WORK -format vhdl {../tce/proge-output/gcu_ic/gcu_opcodes_pkg.vhdl}
analyze -library WORK -format vhdl {../tce/proge-output/gcu_ic/ic.vhdl}
analyze -library WORK -format vhdl {../tce/proge-output/gcu_ic/idecompressor.vhdl}
analyze -library WORK -format vhdl {../tce/proge-output/gcu_ic/ifetch.vhdl}
analyze -library WORK -format vhdl {../tce/proge-output/gcu_ic/input_socket_1.vhdl}
analyze -library WORK -format vhdl {../tce/proge-output/gcu_ic/output_socket_1_1.vhdl}

# Preserve RTL name in power consumtpion estimation
set power_preserve_rtl_hier_names true

# Analyze HDL
elaborate tta0 -architecture behavioral -library WORK

# Set constraints
create_clock -name MY_CLK -period 10 CLK
set_dont_touch_network MY_CLK
set_clock_uncertainty 0.07 [get_clocks MY_CLK]
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

# Compile
compile

# Export optimized netlist
ungroup -all -flatten
change_names -hierarchy -rules verilog
write -hierarchy -format verilog -output netlist/tta_custom_op.v

# Report optimized results
report_timing > report/opt_time_filter_top.txt
report_area > report/opt_area_filter_top.txt

# Exit simulation
quit
