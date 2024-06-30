onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc"  -L lib_pkg_v1_0_3 -L lib_cdc_v1_0_2 -L axi_lite_ipif_v3_0_4 -L interrupt_control_v3_1_5 -L axi_iic_v2_1_5 -L xil_defaultlib -L secureip -lib xil_defaultlib xil_defaultlib.axi_iic_0

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {axi_iic_0.udo}

run 1000ns

quit -force
