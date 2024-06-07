extio8x4
========

Verilog implementation of soclabs EXTIO interface - 4 virtual channels, byte wide transport, 7-pin interface


## Status ##
The core is in protoype stage, ready to validate with RP2040 PIO driver


## Introduction ##



#### Xilinx
- Tool: Vivado 2019.2
- Device: Kintex-7 (7k70tfbv676-1)
- master:
  - LUTs: -
  - FFs: -
  - Fmax: - MHz


## Core Usage


## FuseSoC
This core is supported by the
[FuseSoC](https://github.com/olofk/fusesoc) core package manager and
build system. Some quick  FuseSoC instructions:

install FuseSoC
~~~
pip install fusesoc
~~~

Create and enter a new workspace
~~~
mkdir workspace && cd workspace
~~~

Register extio8x4 as a library in the workspace
~~~
fusesoc library add extio8x4 https://git.soton.ac.uk/soclabs/extio8x4.git
~~~
fusesoc library list
~~~
fusesoc core list
~~~

To run lint (assuming Synopsys SpyGlass in this example)
~~~
fusesoc run --target=lint soclabs:nanosoc:extio8x4:1
~~~

Run tb_extio8x4_axis testbench with vcs
~~~
fusesoc run --target=sim --tool=vcs soclabs:nanosoc:extio8x4:1
~~~
OR, if other python vesrions or libraries installed:

/usr/bin/python3.8 /usr/local/bin/fusesoc --verbose run --target=sim --tool=vcs soclabs:nanosoc:extio8x4:1


Run with modelsim instead of default tool (vcs)
~~~
fusesoc run --target=sim --tool=modelsim soclabs:nanosoc:extio8x4:1
~~~

Run tb_extio8x4_axis testbench with vcs and Verdi GUI
~~~
fusesoc run --target=sim_gui --tool=vcs soclabs:nanosoc:extio8x4:1
~~~

List all targets
~~~
fusesoc core show soclabs:nanosoc:extio8x4:1
~~~


## Implementation results - ASIC ##

TBC

### TSMC 180 nm ###
Target frequency: 20 MHz
Complete flow from RTL to placed gates. Automatic clock gating and scan
insertion.


## Implementation results - FPGA ##

The core has been implemented in Xilinx FPGA devices.

### Xilinx Artix 7 200T-3 ###
- x slices
- x regs
- x MHz

