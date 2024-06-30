vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/lib_pkg_v1_0_3
vlib modelsim_lib/msim/lib_cdc_v1_0_2
vlib modelsim_lib/msim/axi_lite_ipif_v3_0_4
vlib modelsim_lib/msim/interrupt_control_v3_1_5
vlib modelsim_lib/msim/axi_iic_v2_1_5
vlib modelsim_lib/msim/xil_defaultlib

vmap lib_pkg_v1_0_3 modelsim_lib/msim/lib_pkg_v1_0_3
vmap lib_cdc_v1_0_2 modelsim_lib/msim/lib_cdc_v1_0_2
vmap axi_lite_ipif_v3_0_4 modelsim_lib/msim/axi_lite_ipif_v3_0_4
vmap interrupt_control_v3_1_5 modelsim_lib/msim/interrupt_control_v3_1_5
vmap axi_iic_v2_1_5 modelsim_lib/msim/axi_iic_v2_1_5
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vcom -work lib_pkg_v1_0_3  -93  \
"../../../ipstatic/hdl/lib_pkg_v1_0_rfs.vhd" \

vcom -work lib_cdc_v1_0_2  -93  \
"../../../ipstatic/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work axi_lite_ipif_v3_0_4  -93  \
"../../../ipstatic/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work interrupt_control_v3_1_5  -93  \
"../../../ipstatic/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_iic_v2_1_5  -93  \
"../../../ipstatic/hdl/axi_iic_v2_1_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../../I2C_Controller.gen/sources_1/ip/axi_iic_0/sim/axi_iic_0.vhd" \


