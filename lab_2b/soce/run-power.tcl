set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
restoreDesign filter_top.enc.dat filter_top
set_power_analysis_mode -reset
set_power_analysis_mode -method static -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true
set_power_output_dir -reset
set_power_output_dir ./
set_default_switching_activity -reset
set_default_switching_activity -input_activity 0.2 -period 10.0
read_activity_file -reset
read_activity_file -format VCD -vcd_scope tb_filter/DUT -start {} -end {} -vcd_block {} ../switch-post/filter_top.vcd
set_power -reset
set_powerup_analysis -reset
set_powerup_analysis -mode accurate -ultrasim_simulation_mode ms
set_dynamic_power_simulation -reset
report_power -rail_analysis_format VS -outfile ./filter_top.rpt
exit
