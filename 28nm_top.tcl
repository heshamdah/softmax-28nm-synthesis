#!/usr/bin/env tclsh 		







#Samsung 28n Library
set_app_var search_path  "$search_path \
/stdcell_rvt/db_nldm \
/stdcell_lvt/db_nldm \
/stdcell_hvt/db_nldm \
/lib/sram/db_nldm
"
set target_library "saed32rvt_ss0p75v125c.db saed32hvt_ss0p75v125c.db saed32sram_ss0p95v125c.db"
set_app_var target_library $target_library
set_app_var synthetic_library dw_foundation.sldb
set_app_var link_path $target_library
set_app_var link_library "* $target_library $synthetic_library"

#


define_design_lib WORK -path ./WORK

set my_list [list e_1_28nm.gate e_2_28nm.gate e_3_28nm.gate e_4_28nm.gate e_5_28nm.gate e_6_28nm.gate e_7_28nm.gate e_8_28nm.gate e_9_28nm.gate e_10_28nm.gate]



foreach item $my_list {

        set syn_db $item.v
        read_verilog $syn_db

}



set TOP_NAME top

set src_dir /core/files_verilog
set srcs [glob -nocomplain -types f -directory $src_dir *.v]
analyze -format verilog -library WORK $srcs

elaborate $TOP_NAME -library WORK
current_design $TOP_NAME
link


list_designs -show_file         







source -e -v /constraint_28nm.sdc

check_design -summary > ${TOP_NAME}_28nm.check_design.rpt

set ports_clock_root [filter_collection [get_attribute [get_clocks] sources] object_class==port]
group_path -name REGOUT -to [all_outputs] -weight 25
group_path -name REGIN -from [remove_from_collection [all_inputs] ${ports_clock_root}]  -weight 25
group_path -name FEEDTHROUGH -from [remove_from_collection [all_inputs] ${ports_clock_root}] -to [all_outputs] -weight 15
# Prevent assignment statements in the Verilog netlist.
set_fix_multiple_port_nets -all -buffer_constants

set_app_var compile_enhanced_tns_optimization true
      
compile_ultra -gate 

write -hierarchy -output ${TOP_NAME}.db
write_file -format verilog -hierarchy -output ${TOP_NAME}_28nm.gate.v
report_qor > ${TOP_NAME}_28nm_qor.txt
report_area > ${TOP_NAME}_28nm_area.txt
report_timing > ${TOP_NAME}_28nm_timing.txt
