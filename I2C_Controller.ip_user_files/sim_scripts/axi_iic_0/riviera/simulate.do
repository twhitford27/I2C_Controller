transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+axi_iic_0  -L lib_pkg_v1_0_3 -L lib_cdc_v1_0_2 -L axi_lite_ipif_v3_0_4 -L interrupt_control_v3_1_5 -L axi_iic_v2_1_5 -L xil_defaultlib -L secureip -O5 xil_defaultlib.axi_iic_0

do {axi_iic_0.udo}

run 1000ns

endsim

quit -force
