# rpl csa
set CLK_CONS "2.59"
source run-synthesis-setup_fmax.tcl
set REPORTPREF "rpl-csa"
set_implementation DW01_add/rpl [find cell *add_*]
set_implementation DW02_mult/csa [find cell *mult_*]
source run-synthesis-finish_fmax.tcl

# rpl pparch
set CLK_CONS "2.14"
source run-synthesis-setup_fmax.tcl
set REPORTPREF "rpl-pparch"
set_implementation DW01_add/rpl [find cell *add_*]
set_implementation DW02_mult/pparch [find cell *mult_*]
source run-synthesis-finish_fmax.tcl

# cla csa
set CLK_CONS "2.46"
source run-synthesis-setup_fmax.tcl
set REPORTPREF "cla-csa"
set_implementation DW01_add/cla [find cell *add_*]
set_implementation DW02_mult/csa [find cell *mult_*]
source run-synthesis-finish_fmax.tcl

# cla pparch
set CLK_CONS "2.01"
source run-synthesis-setup_fmax.tcl
set REPORTPREF "cla-pparch"
set_implementation DW01_add/cla [find cell *add_*]
set_implementation DW02_mult/pparch [find cell *mult_*]
source run-synthesis-finish_fmax.tcl

# pparch csa
set CLK_CONS "2.48"
source run-synthesis-setup_fmax.tcl
set REPORTPREF "pparch-csa"
set_implementation DW01_add/pparch [find cell *add_*]
set_implementation DW02_mult/csa [find cell *mult_*]
source run-synthesis-finish_fmax.tcl

# pparch pparch
set CLK_CONS "1.97"
source run-synthesis-setup_fmax.tcl
set REPORTPREF "pparch-pparch"
set_implementation DW01_add/pparch [find cell *add_*]
set_implementation DW02_mult/pparch [find cell *mult_*]
source run-synthesis-finish_fmax.tcl
