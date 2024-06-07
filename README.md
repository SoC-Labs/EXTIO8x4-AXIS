extio8x4
========

Verilog implementation of soclabs EXTIO interface - 4 virtual channels, byte wide transport, 7-pin interface


## Status ##
The core is in protoype stage, ready to validate with RP2040 PIO driver


## Introduction ##

A 'bare-metal' hardware debugger IP component that supports memory-mapped read, write, and file upload services before any microprocessor or systems IP and software are integrated and functional. Fully deterministic timing also supports using the interface for test vectors for both verification and SoC testing.

The component presents a bidirectional communications interface off-chip, using AMBA AXI-stream receive and transmit channels, an AMBA AHB-lite bus controller to the SoC memory mapped interconnect, and also provides AMBA AXI-stream STDOUT and STDIN channels to host processor or cluster.

A set of eight general purpose input and output ports can be used for system-specific signal monitoring and control. (the nanosoc design uses this to allow reset assertion to the CPU subsystem so that new code can be downloaded and the MCU rebooted.


This implementation supports 32-bit Address-space and 32-bit Data width AHB systems.
As a bus manager this drives on-chip read and write access for bare-metal SoC debug.
The communication interfaces are kept generic with 8-bit AXI-Stream protocol:
  * COMIO rxd and txd ports for communicating off-chip
  * STDIO rxd and txd interfaces to support MCU std-in and std-out channels

At reset a banner is broadcast ('0x50c1ab04') and the controller then simply echos
comio rxd data to stdin and stdout to comio txd.

If an 'ESC' (0x1b) character is sent then the controller enters ASCII Debug Protocol
mode and supports a basic set of commands to  be parsed and actioned

## ADP functionality

The ASCII Debug Protocol engine allows a standard full-duplex communication channel (for STDIO etc) to support a diagnostic mode of operation (entered with an "escape" sequence) that provides:

- A version banner (2023 release: "50c1abs04")
- A user prompt (default ']' character)
  - Echoed after an "ESC" char (0x1B) triggers entry to ADP monitor
- responds to a basic set of commands, the most basic being:
  - "A <hex string parameter>" to set address base pointer
  - "R <hex string parameter>" to read N 32-bit data values from current address pointer (autoincrementing word address +4)
  - "H <hex string parameter>" to read N 16-bit data values from current address pointer (autoincrementing half-word address +2)
  - "B <hex string parameter>" to read N 8-bit data values from current address pointer (autoincrementing byte address +1)
  - "W <8-nibble hex string parameter>" to write a 32-bit data value to current address pointer (and autoincrement word address +4)
  - "W <4-nibble string parameter>" to write a 16-bit data value to current address pointer (and autoincrement half-word address +2)
  - "W <2-nibblehex string parameter>" to write an 8-bit data value to current address pointer (and autoincrement byte address +1)
  - "Q" (or <Ctrl-D>) exit debug monitor mode (revert to standard input/output channels)
- plus some more advanced features:
  - "V <hex string parameter>" to set a 32-bit Value (for fill or poll commands)
  - "M <hex string parameter>" to set a 32-bit Mask value (for poll commands)
  - "F <hex string parameter>" to fill a block of memory on N words (autoincrementing the address pointer) with Value V
  - "P <hex string parameter>" to poll address up to N times (no address increment) (location and Mask == Value)
  - "C <hex string parameter>" set user-GPO control flags (SoC specific)
  - "S <hex string parameter>" send 8-bit char to SoC 'stdin' channel
  - "U <hex string parameter>" Upload N-bytes of binary character stream and write to memory (incrementing byte address)
- Any std-output traffic from the system on chip is transmitted and quoted  ('<' & '>') between ADP commands while in debug mode

A simple Python "terminal program" provides full-duplex interaction interface (with an example developed with the Xilinx 'PYNQ' development environment as Jupyter notebook).

Success/Failure signalling
- ADP reports the command executed or the results, 
  - and adds a " " space prefix if successful
  - or a "!" prefix if failed to complete. For example:

- A bus read or write operation that gets a bus fault signals an error on the read or write response
- A poll operation either reports the number of polled operations until the masked value matches with the value set
- or reports a failure (time-out) if the poll count is reached and no match detected
- A Send character to std-input channel that cannot be posted (buffer or FIFO full or CPU not running) reports an error 


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

