vcom -work work -O0 D:/nws/Projekte/CycloneII/learning-vhdl/led-blinker/LB_Shift.vhd
vcom -work work -O0 D:/nws/Projekte/CycloneII/learning-vhdl/led-blinker/simulation/modelsim/test_LB_shift.vhd
do test_LB_shift.wave.do
restart -f
run -all