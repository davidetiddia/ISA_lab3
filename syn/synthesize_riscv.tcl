
analyze -f vhdl -lib WORK  ../src/DECODE/op_types.vhd
analyze -f vhdl -lib WORK  ../src/WRITEBACK/jump_mux.vhd
analyze -f vhdl -lib WORK  ../src/WRITEBACK/mem_wb_mux.vhd
analyze -f vhdl -lib WORK  ../src/WRITEBACK/wb_stage.vhd
analyze -f vhdl -lib WORK  ../src/MEMORY/MEM_WB_reg.vhd
analyze -f vhdl -lib WORK  ../src/MEMORY/mem_forwarding.vhd
analyze -f vhdl -lib WORK  ../src/MEMORY/write_data_mux.vhd
analyze -f vhdl -lib WORK  ../src/MEMORY/mem_stage.vhd
analyze -f vhdl -lib WORK  ../src/EXECUTE/EX_MEM_reg.vhd
analyze -f vhdl -lib WORK  ../src/EXECUTE/ALU.vhd
analyze -f vhdl -lib WORK  ../src/EXECUTE/ALU_control.vhd
analyze -f vhdl -lib WORK  ../src/EXECUTE/forwarding_unit.vhd
analyze -f vhdl -lib WORK  ../src/EXECUTE/branch_mux.vhd
analyze -f vhdl -lib WORK  ../src/EXECUTE/exe_fwd_mux.vhd
analyze -f vhdl -lib WORK  ../src/EXECUTE/exe_imm_mux.vhd
analyze -f vhdl -lib WORK  ../src/EXECUTE/execute_stage.vhd
analyze -f vhdl -lib WORK  ../src/DECODE/ID_EXE_reg.vhd
analyze -f vhdl -lib WORK  ../src/DECODE/branch_evaluator.vhd
analyze -f vhdl -lib WORK  ../src/DECODE/branch_fwd_mux.vhd
analyze -f vhdl -lib WORK  ../src/DECODE/branch_forward_unit.vhd
analyze -f vhdl -lib WORK  ../src/DECODE/control_unit.vhd
analyze -f vhdl -lib WORK  ../src/DECODE/hazard_unit.vhd
analyze -f vhdl -lib WORK  ../src/DECODE/decode_hazard_mux.vhd
analyze -f vhdl -lib WORK  ../src/DECODE/mux_32_1.vhd
analyze -f vhdl -lib WORK  ../src/DECODE/regfile_nolatch.vhd
analyze -f vhdl -lib WORK  ../src/DECODE/imm_gen.vhd
analyze -f vhdl -lib WORK  ../src/DECODE/adder.vhd
analyze -f vhdl -lib WORK  ../src/DECODE/decode_stage.vhd
analyze -f vhdl -lib WORK  ../src/FETCH/IF_ID_reg.vhd
analyze -f vhdl -lib WORK  ../src/FETCH/PCadder.vhd
analyze -f vhdl -lib WORK  ../src/FETCH/PCreg.vhdl
analyze -f vhdl -lib WORK  ../src/FETCH/MUX21_32b.vhd
analyze -f vhdl -lib WORK  ../src/FETCH/fetch_stage.vhd
analyze -f vhdl -lib WORK  ../src/RISC_V.vhd

set power_preserve_rtl_hier_names true

elaborate RISC_V -arch pipeline -lib WORK > ./elaborate_max_f.txt

link
#1.1723
create_clock -name MY_CLK -period 1.168 CLK
set_dont_touch_network MY_CLK
set_clock_uncertainty 0.07 [get_clocks MY_CLK]
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

ungroup -all -flatten

compile

report_resources > resources_max_f.txt
report_timing > timing_max_f.txt
report_area > area_max_f.txt

change_names -hierarchy -rules verilog

write -f verilog -hierarchy -output ../RISC_V_max_f.v

write_sdf ../netlist/RISC_V_max_f.sdf

write_sdc ../netlist/RISC_V_max_f.sdc

