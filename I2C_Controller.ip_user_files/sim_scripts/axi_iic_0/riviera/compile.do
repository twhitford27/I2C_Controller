transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/lib_pkg_v1_0_3
vlib riviera/lib_cdc_v1_0_2
vlib riviera/axi_lite_ipif_v3_0_4
vlib riviera/interrupt_control_v3_1_5
vlib riviera/axi_iic_v2_1_5
vlib riviera/xil_defaultlib

vmap lib_pkg_v1_0_3 riviera/lib_pkg_v1_0_3
vmap lib_cdc_v1_0_2 riviera/lib_cdc_v1_0_2
vmap axi_lite_ipif_v3_0_4 riviera/axi_lite_ipif_v3_0_4
vmap interrupt_control_v3_1_5 riviera/interrupt_control_v3_1_5
vmap axi_iic_v2_1_5 riviera/axi_iic_v2_1_5
vmap xil_defaultlib riviera/xil_defaultlib

vcom -work lib_pkg_v1_0_3 -93  -incr \
"../../../ipstatic/hdl/lib_pkg_v1_0_rfs.vhd" \

vcom -work lib_cdc_v1_0_2 -93  -incr \
"../../../ipstatic/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work axi_lite_ipif_v3_0_4 -93  -incr \
"../../../ipstatic/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work interrupt_control_v3_1_5 -93  -incr \
"../../../ipstatic/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_iic_v2_1_5 -93  -incr \
"../../../ipstatic/hdl/axi_iic_v2_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../../I2C_Controller.gen/sources_1/ip/axi_iic_0/sim/axi_iic_0.vhd" \


