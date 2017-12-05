# rpl csa
source run-synthesis-setup.tcl
set REPORTPREF "rpl-csa"
set_implementation DW01_add/rpl [find cell *add_*]
set_implementation DW02_mult/csa [find cell *mult_*]
source run-synthesis-finish.tcl

# rpl pparch
source run-synthesis-setup.tcl
set REPORTPREF "rpl-pparch"
set_implementation DW01_add/rpl [find cell *add_*]
set_implementation DW02_mult/pparch [find cell *mult_*]
source run-synthesis-finish.tcl

# cla csa
source run-synthesis-setup.tcl
set REPORTPREF "cla-csa"
set_implementation DW01_add/cla [find cell *add_*]
set_implementation DW02_mult/csa [find cell *mult_*]
source run-synthesis-finish.tcl

# cla pparch
source run-synthesis-setup.tcl
set REPORTPREF "cla-pparch"
set_implementation DW01_add/cla [find cell *add_*]
set_implementation DW02_mult/pparch [find cell *mult_*]
source run-synthesis-finish.tcl

# pparch csa
source run-synthesis-setup.tcl
set REPORTPREF "pparch-csa"
set_implementation DW01_add/pparch [find cell *add_*]
set_implementation DW02_mult/csa [find cell *mult_*]
source run-synthesis-finish.tcl

# pparch csa
source run-synthesis-setup.tcl
set REPORTPREF "pparch-pparch"
set_implementation DW01_add/pparch [find cell *add_*]
set_implementation DW02_mult/pparch [find cell *mult_*]
source run-synthesis-finish.tcl
