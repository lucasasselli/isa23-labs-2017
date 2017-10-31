set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
source design.globals
set init_design_netlisttype verilog
set init_design_settop 1
set init_top_cell filter_top
set init_verilog ../syn/netlist/filter_top.v
set init_lef_file /software/dk/nangate45/lef/NangateOpenCellLibrary.lef
set init_gnd_net VSS
set init_pwr_net VDD
set init_mmmc_file mmm_design.tcl
init_design
# getIoFlowFlag
# setIoFlowFlag 0
floorPlan -coreMarginsBy die -site FreePDK45_38x28_10R_NP_162NW_34O -r 1.0 0.6 4.0 4.0 4.0 4.0
# uiSetTool select
# getIoFlowFlag
fit
set sprCreateIeRingNets {}
set sprCreateIeRingLayers {}
set sprCreateIeRingWidth 1.0
set sprCreateIeRingSpacing 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
addRing -center 1 -stacked_via_top_layer metal10 -around core -jog_distance 0.095 -threshold 0.095 -nets {VDD VSS} -stacked_via_bottom_layer metal1 -layer {bottom metal1 top metal1 right metal2 left metal2} -width 0.8 -spacing 0.8 -offset 0.095
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst * -module {}
globalNetConnect VSS -type pgpin -pin VSS -inst * -module {}
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst * -module {}
globalNetConnect VSS -type pgpin -pin VSS -inst * -module {}
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { metal1 metal10 } -blockPinTarget { nearestRingStripe nearestTarget } -padPinPortConnect { allPort oneGeom } -stripeSCpinTarget { blockring padring ring stripe ringpin blockpin } -checkAlignedSecondaryPin 1 -blockPin useLef -allowJogging 1 -crossoverViaBottomLayer metal1 -allowLayerChange 1 -targetViaTopLayer metal10 -crossoverViaTopLayer metal10 -targetViaBottomLayer metal1 -nets { VDD VSS }
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { metal1 metal10 } -blockPinTarget { nearestRingStripe nearestTarget } -padPinPortConnect { allPort oneGeom } -stripeSCpinTarget { blockring padring ring stripe ringpin blockpin } -checkAlignedSecondaryPin 1 -blockPin useLef -allowJogging 1 -crossoverViaBottomLayer metal1 -allowLayerChange 1 -targetViaTopLayer metal10 -crossoverViaTopLayer metal10 -targetViaBottomLayer metal1 -nets { VDD VSS }
setPlaceMode -fp false
placeDesign -inPlaceOpt -prePlaceOpt
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -preCTS
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -preCTS
createClockTreeSpec -bufferList {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3} -file Clock.ctstch
createClockTreeSpec -bufferList {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3} -file Clock.ctstch
clockDesign -specFile Clock.ctstch -outDir clock_report -fixedInstBeforeCTS
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postCTS
optDesign -postCTS -hold
getFillerMode -quiet
addFiller -cell FILLCELL_X8 FILLCELL_X4 FILLCELL_X32 FILLCELL_X2 FILLCELL_X16 FILLCELL_X1 -prefix FILLER
trialRoute -maxRouteLayer 10
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithSiPostRouteFix 0
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven false
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail
setAnalysisMode -analysisType onChipVariation
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postRoute
optDesign -postRoute -hold
saveDesign filter_top.enc
saveDesign filter_top.enc
createSnapshot -dir . -name chip_snap
rcOut -setload filter_top.setload -rc_corner my_rc
rcOut -setres filter_top.setres -rc_corner my_rc
rcOut -spf filter_top.spf -rc_corner my_rc
rcOut -spef filter_top.spef -rc_corner my_rc
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 50 -prefix filter_top_postRoute -outDir timingReports
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -hold -pathReports -slackReports -numPaths 50 -prefix filter_top_postRoute -outDir timingReports
verifyConnectivity -type all -error 1000 -warning 50
setVerifyGeometryMode -area { 0 0 0 0 } -minWidth true -minSpacing true -minArea true -sameNet true -short true -overlap true -offRGrid false -offMGrid true -mergedMGridCheck true -minHole true -implantCheck true -minimumCut true -minStep true -viaEnclosure true -antenna false -insuffMetalOverlap true -pinInBlkg false -diffCellViol true -sameCellViol false -padFillerCellsOverlap true -routingBlkgPinOverlap true -routingCellBlkgOverlap true -regRoutingOnly false -stackedViasOnRegNet false -wireExt true -useNonDefaultSpacing false -maxWidth true -maxNonPrefLength -1 -error 1000 -warning 50
verifyGeometry
setVerifyGeometryMode -area { 0 0 0 0 }
reportGateCount -level 5 -limit 100 -outfile filter_top.gateCount
saveNetlist filter_top.v
all_hold_analysis_views 
all_setup_analysis_views 
write_sdf  -ideal_clock_network filter_top.sdf
exit
