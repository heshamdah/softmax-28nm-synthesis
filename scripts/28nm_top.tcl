#!/usr/bin/env tclsh 		





set search_path  "$search_path \
/home/slaguduv/ucsc_pd_dc_flow/rm_utilities \
/home/slaguduv/ucsc_pd_dc_flow/rm_dc_scripts \
"

source procs_global.tcl 
source procs_dc.tcl 

#Samsung 28n Library
#########################################################
set_app_var search_path  "$search_path \
/usr/synopsys/SAED_EDK32_28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm \
/usr/synopsys/SAED_EDK32_28nm/SAED32_EDK/lib/stdcell_lvt/db_nldm \
/usr/synopsys/SAED_EDK32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm \
/usr/synopsys/SAED_EDK32_28nm/SAED32_EDK/lib/sram/db_nldm
"
set target_library "saed32rvt_ss0p75v125c.db saed32hvt_ss0p75v125c.db saed32sram_ss0p95v125c.db"
set_app_var target_library $target_library
set_app_var synthetic_library dw_foundation.sldb
set_app_var link_path $target_library
set_app_var link_library "* $target_library $synthetic_library"

########################################################


define_design_lib WORK -path ./WORK

set my_list [list e_1_28nm.gate e_2_28nm.gate e_3_28nm.gate e_4_28nm.gate e_5_28nm.gate e_6_28nm.gate e_7_28nm.gate e_8_28nm.gate e_9_28nm.gate e_10_28nm.gate]



foreach item $my_list {

        set syn_db $item.v
        read_verilog $syn_db

}



set TOP_NAME top

set src_dir /home/pd08146/lab2_core/files_verilog
set srcs [glob -nocomplain -types f -directory $src_dir *.v]
analyze -format verilog -library WORK $srcs

elaborate $TOP_NAME -library WORK
current_design $TOP_NAME
link


list_designs -show_file            ;# you should





#############################################
#source /usr/openroad/OpenROAD-flow-scripts/flow/designs/sky130hd/riscv32i/constraint.sdc
source -e -v /home/slaguduv/ucsc_pd_dc_flow/riscv_top/constraint_28nm.sdc

check_design -summary > ${TOP_NAME}_28nm.check_design.rpt

set ports_clock_root [filter_collection [get_attribute [get_clocks] sources] object_class==port]
group_path -name REGOUT -to [all_outputs] -weight 20
group_path -name REGIN -from [remove_from_collection [all_inputs] ${ports_clock_root}]  -weight 20
group_path -name FEEDTHROUGH -from [remove_from_collection [all_inputs] ${ports_clock_root}] -to [all_outputs] -weight 15
# Prevent assignment statements in the Verilog netlist.
set_fix_multiple_port_nets -all -buffer_constants

#The following variable, when set to true, runs additional optimizations to improve the timing of  the design at the cost of additional run time.
set_app_var compile_enhanced_tns_optimization true
      

#
# Use -gate_clock to insert clock-gating logic during optimization.  This
# is now the recommended methodology for clock gating.
#
# Use -self_gating option in addition to -gate_clock for potentially saving 
# additional dynamic power, in topographical mode only. For registers 
# that are already clock gated, the inserted self-gate will be collapsed 
# with the existing clock gate. This behavior can be controlled 
# using the s:1et_self_gating_options command
# XOR self gating should be performed along with clock gating, using -gate_clock
# and -self_gating options. XOR self gates will be inserted only if there is 
# potential power saving without degrading the timing.
# An accurate switching activity annotation either by reading in a saif 
# file or through set_switching_activity command is recommended.
# You can use "set_self_gating_options" command to specify self-gating 
# options.
#
# Use the -spg option to enable Design Compiler Graphical physical guidance flow.
# The physical guidance flow improves QoR, area and timing correlation, and congestion.
# It also improves place_opt runtime in IC Compiler.
#
# You can selectively enable or disable the congestion optimization on parts of 
# the design by using the set_congestion_optimization command.
# This option requires a license for Design Compiler Graphical.
#
# The constant propagation is enabled when boundary optimization is disabled. In 
# order to stop constant propagation you can do the following
#
# set_compile_directives -constant_propagation false <object_list>
#
# Note: Layer optimization is on by default in Design Compiler Graphical, to 
#       improve the the accuracy of certain net delay during optimization.
#       To disable the the automatic layer optimization you can use the 
#       -no_auto_layer_optimization option.
#
#################################################################################
compile_ultra -gate 

write -hierarchy -output ${TOP_NAME}.db
write_file -format verilog -hierarchy -output ${TOP_NAME}_28nm.gate.v
report_qor > ${TOP_NAME}_28nm_qor.txt
report_area > ${TOP_NAME}_28nm_area.txt
report_timing > ${TOP_NAME}_28nm_timing.txt
