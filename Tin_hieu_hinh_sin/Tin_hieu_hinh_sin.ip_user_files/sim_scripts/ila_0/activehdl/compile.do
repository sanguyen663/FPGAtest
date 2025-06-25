vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../Tin_hieu_hinh_sin.srcs/sources_1/ip/ila_0/hdl/verilog" \
"../../../../Tin_hieu_hinh_sin.srcs/sources_1/ip/ila_0/sim/ila_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

