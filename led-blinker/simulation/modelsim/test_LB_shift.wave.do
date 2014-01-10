onerror {resume}
quietly WaveActivateNextPane {} 0
delete wave *
add wave -noupdate /test_lb_shift/clk
add wave -noupdate /test_lb_shift/sys_reset
add wave -noupdate -expand /test_lb_shift/led
add wave -position end -expand sim:/test_lb_shift/dut/led_temp
add wave -position end  sim:/test_lb_shift/dut/direction
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 223
configure wave -valuecolwidth 122
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {9107 ps}
