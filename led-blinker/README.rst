LedBlinker
==========

This VHDL project makes LEDs on a test board blink in various 
patterns.


Architecture
---------------
The project consists of a state machine (FirstTry.vhd) that is 
operated using push buttons on the test board. The state machine
selects which of the blinker modules may drive the LEDs.


Blinker modules
---------------
* Counter: Binary count from 0 to 2^8-1 using LEDs 
* Shift: Shift one glowing LED from left to right and back
* Random: Display pseudo-random sequence of LED pattern


Work in progress
----------------
* Testbench
* RTL Simulation using ModelSim

