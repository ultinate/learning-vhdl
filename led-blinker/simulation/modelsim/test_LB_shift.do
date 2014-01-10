vcom -work work -O0 ../../LB_Shift.vhd
vcom -work work -O0 ./txt_util.vhd
vcom -work work -O0 ./test_LB_shift.vhd
do test_LB_shift.wave.do
restart -f
run -all