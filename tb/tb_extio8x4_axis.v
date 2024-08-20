//-----------------------------------------------------------------------------
// EXTIO8x4-axis Testbench
// A joint work commissioned on behalf of SoC Labs, under Arm Academic Access license.
//
// Contributors
//
// David Flynn (d.w.flynn@soton.ac.uk)
//
// Copyright (C) 2024, SoC Labs (www.soclabs.org)
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module tb_extio8x4_axis( );

  //-----------------------------------------
  // System options

localparam CLOCK_PHASE = 5;

`define MEM_INIT 1;

`ifdef ADP_FILE
  localparam ASC_FILENAME=`ADP_FILE;
`else
  localparam ASC_FILENAME="src/soclabs_nanosoc_extio8x4_1.0.0/tb/asc-test.txt";
`endif

`ifdef VCD_SIM
initial begin
  $dumpfile("waves.vcd");
  $dumpvars(6,u_extio8x4_axis_initiator);
  end                 
`endif // VCD_SIM

// IO's defined from target-side
  wire       clk;
  wire       resetn;
  wire       testmode;
// 4-channel AXIS interface - Manager side
  wire       M_axis_rx0_tready; 
  wire       M_axis_rx0_tvalid;
  wire [7:0] M_axis_rx0_tdata8;
  wire       M_axis_rx1_tready; 
  wire       M_axis_rx1_tvalid;
  wire [7:0] M_axis_rx1_tdata8;
  wire       M_axis_tx0_tready; 
  wire       M_axis_tx0_tvalid;
  wire [7:0] M_axis_tx0_tdata8;
  wire       M_axis_tx1_tready; 
  wire       M_axis_tx1_tvalid;
  wire [7:0] M_axis_tx1_tdata8;
// 4-channel AXIS interface - Subordinate side
  wire       S_axis_rx0_tready; 
  wire       S_axis_rx0_tvalid;
  wire [7:0] S_axis_rx0_tdata8;
  wire       S_axis_rx1_tready; 
  wire       S_axis_rx1_tvalid;
  wire [7:0] S_axis_rx1_tdata8;
  wire       S_axis_tx0_tready; 
  wire       S_axis_tx0_tvalid;
  wire [7:0] S_axis_tx0_tdata8;
  wire       S_axis_tx1_tready; 
  wire       S_axis_tx1_tvalid;
  wire [7:0] S_axis_tx1_tdata8;
// external io interface
  tri  [3:0] iodata4;
  wire [3:0] M_iodata4_i;
  wire [3:0] M_iodata4_o;
  wire [3:0] M_iodata4_e;
  wire [3:0] M_iodata4_t;
  wire [3:0] S_iodata4_i;
  wire [3:0] S_iodata4_o;
  wire [3:0] S_iodata4_e;
  wire [3:0] S_iodata4_t;
  wire       ioreq1;
  wire       ioreq2;
  wire       ioack;

wire end_of_file1;
wire end_of_file2;
wire end_of_file3;
wire end_of_file4;
wire end_of_file;

assign testmode = 1'b0;

extio8x4_axis_initiator u_extio8x4_axis_initiator
  (
  .clk             ( clk               ),
  .resetn          ( resetn            ),
  .testmode        ( testmode          ),
// RX 4-channel M_axis interface
  .axis_rx0_tready ( M_axis_rx0_tready ), 
  .axis_rx0_tvalid ( M_axis_rx0_tvalid ),
  .axis_rx0_tdata8 ( M_axis_rx0_tdata8 ),
  .axis_rx1_tready ( M_axis_rx1_tready ), 
  .axis_rx1_tvalid ( M_axis_rx1_tvalid ),
  .axis_rx1_tdata8 ( M_axis_rx1_tdata8 ),
  .axis_tx0_tready ( M_axis_tx0_tready ), 
  .axis_tx0_tvalid ( M_axis_tx0_tvalid ),
  .axis_tx0_tdata8 ( M_axis_tx0_tdata8 ),
  .axis_tx1_tready ( M_axis_tx1_tready ), 
  .axis_tx1_tvalid ( M_axis_tx1_tvalid ),
  .axis_tx1_tdata8 ( M_axis_tx1_tdata8 ),
// external io interface
  .iodata4_a       ( M_iodata4_i       ),
  .iodata4_o       ( M_iodata4_o       ),
  .iodata4_e       ( M_iodata4_e       ),
  .iodata4_t       ( M_iodata4_t       ),
  .ioreq1_o        ( ioreq1            ),
  .ioreq2_o        ( ioreq2            ),
  .ioack_a         ( ioack             )
  );

// tristate buffer emulation
   bufif0 #1 (iodata4[3], M_iodata4_o[3], M_iodata4_t[3]);
   bufif0 #1 (iodata4[2], M_iodata4_o[2], M_iodata4_t[2]);
   bufif0 #1 (iodata4[1], M_iodata4_o[1], M_iodata4_t[1]);
   bufif0 #1 (iodata4[0], M_iodata4_o[0], M_iodata4_t[0]);
   assign M_iodata4_i = iodata4;


extio8x4_axis_target u_extio8x4_axis_target
  (
  .clk             ( !clk              ),
  .resetn          ( resetn            ),
  .testmode        ( testmode          ),
// RX 4-channel AXIS interface
  .axis_rx0_tready ( S_axis_rx0_tready ), 
  .axis_rx0_tvalid ( S_axis_rx0_tvalid ),
  .axis_rx0_tdata8 ( S_axis_rx0_tdata8 ),
  .axis_rx1_tready ( S_axis_rx1_tready ), 
  .axis_rx1_tvalid ( S_axis_rx1_tvalid ),
  .axis_rx1_tdata8 ( S_axis_rx1_tdata8 ),
  .axis_tx0_tready ( S_axis_tx0_tready ), 
  .axis_tx0_tvalid ( S_axis_tx0_tvalid ),
  .axis_tx0_tdata8 ( S_axis_tx0_tdata8 ),
  .axis_tx1_tready ( S_axis_tx1_tready ), 
  .axis_tx1_tvalid ( S_axis_tx1_tvalid ),
  .axis_tx1_tdata8 ( S_axis_tx1_tdata8 ),
// external io interface
  .iodata4_i       ( S_iodata4_i       ),
  .iodata4_o       ( S_iodata4_o       ),
  .iodata4_e       ( S_iodata4_e       ),
  .iodata4_t       ( S_iodata4_t       ),
  .ioreq1_a        ( ioreq1            ),
  .ioreq2_a        ( ioreq2            ),
  .ioack_o         ( ioack             )
  );

// tristate buffer emulation
   bufif0 #1 (iodata4[3], S_iodata4_o[3], S_iodata4_t[3]);
   bufif0 #1 (iodata4[2], S_iodata4_o[2], S_iodata4_t[2]);
   bufif0 #1 (iodata4[1], S_iodata4_o[1], S_iodata4_t[1]);
   bufif0 #1 (iodata4[0], S_iodata4_o[0], S_iodata4_t[0]);
   assign S_iodata4_i = iodata4;

// bidirectional/HiZ pullups to suppress X-inputs
  pullup(iodata4[ 0]);
  pullup(iodata4[ 1]);
  pullup(iodata4[ 2]);
  pullup(iodata4[ 3]);

integer cycle_count;
integer tx0_byte_count ;
integer tx1_byte_count ;
integer rx0_byte_count ;
integer rx1_byte_count ;

always @(posedge clk or negedge resetn)
  if (!resetn)
    cycle_count = 0;
  else
    cycle_count = cycle_count +1;

always @(posedge clk or negedge resetn)
  if (!resetn)
    tx0_byte_count = 0;
  else if (M_axis_tx0_tready & M_axis_tx0_tvalid)
    tx0_byte_count = tx0_byte_count + 1;
    
always @(posedge clk or negedge resetn)
  if (!resetn)
    tx1_byte_count = 0;
  else if (M_axis_tx1_tready & M_axis_tx1_tvalid)
    tx1_byte_count = tx1_byte_count + 1;
    
always @(posedge clk or negedge resetn)
  if (!resetn)
    rx0_byte_count = 0;
  else if (M_axis_rx0_tready & M_axis_rx0_tvalid)
    rx0_byte_count = rx0_byte_count + 1;
    
always @(posedge clk or negedge resetn)
  if (!resetn)
    rx1_byte_count = 0;
  else if (M_axis_rx1_tready & M_axis_rx1_tvalid)
    rx1_byte_count = rx1_byte_count + 1;
    
    
// Manager side testbench stream stinulus
  tb_axi_stream_io8_txd_from_file #(
    .TXDFILENAME(ASC_FILENAME)
  ) u_tb_axi_stream_io_8_txd_from_file_chan0 (
    .aclk       (clk),
    .aresetn    (resetn),
    .txd8_ready (M_axis_rx0_tready),
    .txd8_valid (M_axis_rx0_tvalid),
    .txd8_data  (M_axis_rx0_tdata8)
  );
  tb_axi_stream_io8_rxd_to_file#(
    .RXDFILENAME("M_rxd0_out.log")
  ) u_tb_axi_stream_io_8_rxd_to_file_chan0 (
    .aclk         (clk),
    .aresetn      (resetn),
    .end_of_file  (end_of_file1),
    .rxd8_ready   (M_axis_tx0_tready),
    .rxd8_valid   (M_axis_tx0_tvalid),
    .rxd8_data    (M_axis_tx0_tdata8)
  );

// Manager side testbench stream stinulus
  tb_axi_stream_io8_txd_from_file #(
    .TXDFILENAME(ASC_FILENAME)
  ) u_tb_axi_stream_io_8_txd_from_file_chan1 (
    .aclk       (clk),
    .aresetn    (resetn),
    .txd8_ready (M_axis_rx1_tready),
    .txd8_valid (M_axis_rx1_tvalid),
    .txd8_data  (M_axis_rx1_tdata8)
  );
  tb_axi_stream_io8_rxd_to_file#(
    .RXDFILENAME("M_rxd1_out.log")
  ) u_tb_axi_stream_io_8_rxd_to_file_chan1 (
    .aclk         (clk),
    .aresetn      (resetn),
    .end_of_file  (end_of_file2),
    .rxd8_ready   (M_axis_tx1_tready),
    .rxd8_valid   (M_axis_tx1_tvalid),
    .rxd8_data    (M_axis_tx1_tdata8)
  );

//assign end_of_file = end_of_file1 & end_of_file2 & end_of_file3 & end_of_file4;
assign end_of_file = end_of_file3 & end_of_file4;

// Subordinate side echo

/*
  assign S_axis_tx0_tready = S_axis_rx0_tready;
  assign S_axis_rx0_tvalid = S_axis_tx0_tvalid;
  assign S_axis_rx0_tdata8 = S_axis_tx0_tdata8;
  assign S_axis_tx1_tready = S_axis_rx1_tready;
  assign S_axis_rx1_tvalid = S_axis_tx1_tvalid;
  assign S_axis_rx1_tdata8 = S_axis_tx1_tdata8;
*/
 // COMIO out buffer
  tb_axi_stream_io8_buffer
    u_tb_xi_stream_loop0 (
    .aclk       (clk),
    .aresetn    (resetn),
    .rxd8_ready (S_axis_tx0_tready),
    .rxd8_valid (S_axis_tx0_tvalid),
    .rxd8_data  (S_axis_tx0_tdata8),
    .txd8_ready (S_axis_rx0_tready),
    .txd8_valid (S_axis_rx0_tvalid),
    .txd8_data  (S_axis_rx0_tdata8)
  );

// COMIO out buffer
  tb_axi_stream_io8_buffer
    u_tb_xi_stream_loop1 (
    .aclk       (clk),
    .aresetn    (resetn),
    .rxd8_ready (S_axis_tx1_tready),
    .rxd8_valid (S_axis_tx1_tvalid),
    .rxd8_data  (S_axis_tx1_tdata8),
    .txd8_ready (S_axis_rx1_tready),
    .txd8_valid (S_axis_rx1_tvalid),
    .txd8_data  (S_axis_rx1_tdata8)
  );

  tb_axi_stream_io8_rxd_to_file#(
    .RXDFILENAME("S_rxd0_out.log")
  ) u_tb_axi_stream_io_8_rxd_to_file_tx0 (
    .aclk         (clk),
    .aresetn      (resetn),
    .end_of_file  (end_of_file3),
    .rxd8_ready   ( ), //S_axis_tx0_tready),
    .rxd8_valid   (S_axis_tx0_tvalid & S_axis_tx0_tready),
    .rxd8_data    (S_axis_tx0_tdata8)
  );

  tb_axi_stream_io8_rxd_to_file#(
    .RXDFILENAME("S_rxd1_out.log")
  ) u_tb_axi_stream_io_8_rxd_to_file_tx1 (
    .aclk         (clk),
    .aresetn      (resetn),
    .end_of_file  (end_of_file4),
    .rxd8_ready   ( ), //S_axis_tx1_tready),
    .rxd8_valid   (S_axis_tx1_tvalid & S_axis_tx1_tready),
    .rxd8_data    (S_axis_tx1_tdata8)
  );

  tb_axi_stream_io8_rxd_check_file#(
    .FILENAME(ASC_FILENAME)
  ) u_tb_axi_stream_io8_rxd0_check_file (
    .aclk       (clk),
    .aresetn    (resetn),
    .rxd8_ready ( ), //S_axis_tx0_tready), 
    .rxd8_valid (S_axis_tx0_tvalid & S_axis_tx0_tready),
    .rxd8_data  (S_axis_tx0_tdata8)
  );

  tb_axi_stream_io8_rxd_check_file#(
    .FILENAME(ASC_FILENAME)
  ) u_tb_axi_stream_io8_rxd1_check_file (
    .aclk       (clk),
    .aresetn    (resetn),
    .rxd8_ready ( ), //S_axis_tx1_tready), 
    .rxd8_valid (S_axis_tx1_tvalid & S_axis_tx1_tready),
    .rxd8_data  (S_axis_tx1_tdata8)
  );


//-----------------------------------------------------------------------------
// Abstract : Simple clock and power on reset generator
//-----------------------------------------------------------------------------

  reg osc_q;
  reg poreset;
  initial
    begin
      osc_q     <= 1'b1;
      poreset     <= 1'b1;
      #(3 * CLOCK_PHASE) osc_q <= 1'b0;
      #(2 * CLOCK_PHASE) poreset <= 1'b0;
    end

  always @(osc_q)
   #CLOCK_PHASE
       osc_q <= !osc_q;


  assign clk = osc_q;

  assign resetn = !poreset;

  always @(posedge clk)
    begin // : eof_terminate
      if (end_of_file) begin
        #10000
        $display("EXTIO8x4 cycle count     = %d", cycle_count);
        $display("EXTIO8x4 rx0 byte count  = %d", rx0_byte_count);
        $display("EXTIO8x4 tx0 byte count  = %d", tx0_byte_count);
        $display("EXTIO8x4 rx1 byte count  = %d", rx1_byte_count);
        $display("EXTIO8x4 tx1 byte count  = %d", tx1_byte_count);
        $display("clocks per byte (approx) = %f",
              (cycle_count/(rx0_byte_count+ rx1_byte_count + tx0_byte_count+tx1_byte_count)));
        $finish();
        end
    end //

endmodule
