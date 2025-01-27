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

wire M_end_of_file1;
wire M_end_of_file2;
//wire M_end_of_file3;
//wire M_end_of_file4;
wire M_end_of_file;

wire S_end_of_file1;
wire S_end_of_file2;
//wire S_end_of_file3;
//wire S_end_of_file4;
wire S_end_of_file;

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

reg [15:0] cycle_count;
integer M_tx0_byte_count ;
integer M_tx1_byte_count ;
integer M_rx0_byte_count ;
integer M_rx1_byte_count ;
integer S_tx0_byte_count ;
integer S_tx1_byte_count ;
integer S_rx0_byte_count ;
integer S_rx1_byte_count ;

always @(posedge clk or negedge resetn)
  if (!resetn)
    cycle_count <= 0;
  else
    cycle_count <= cycle_count +1;

// allow up to 32 cycles per transaction
// up to 4 competing transactions per slot
// test synchronized modulo 128

wire start_reqs = !(|cycle_count[8:0]);     // 0-31
wire [3:0] M_chan_ack;
reg  [3:0] M_chan_req_en;
always @(posedge clk or negedge resetn)
  if (!resetn) begin
      M_chan_req_en <= 4'b0000;
    end
  else begin
    if (start_reqs)
      M_chan_req_en <= (cycle_count[12:9] & ~M_chan_ack);
    else if (M_chan_req_en[0] & M_chan_ack[0])
      M_chan_req_en[0] <= 1'b0;
    else if (M_chan_req_en[1] & M_chan_ack[1])
      M_chan_req_en[1] <= 1'b0;
    else if (M_chan_req_en[2] & M_chan_ack[2])
      M_chan_req_en[2] <= 1'b0;
    else if (M_chan_req_en[3] & M_chan_ack[3])
      M_chan_req_en[3] <= 1'b0;
  end

wire [3:0] S_chan_ack;
reg  [3:0] S_chan_req_en;
always @(posedge clk or negedge resetn)
  if (!resetn)
    S_chan_req_en <= 4'b0000;
  else begin
    S_chan_req_en <= ~S_chan_ack;
/*
    if (start_reqs)
      S_chan_req_en <=  (cycle_count[12:9] & ~S_chan_ack);
    else if (S_chan_req_en[0] & S_chan_ack[0])
      S_chan_req_en[0] <= 1'b0;
    else if (S_chan_req_en[1] & S_chan_ack[1])
      S_chan_req_en[1] <= 1'b0;
    else if (S_chan_req_en[2] & S_chan_ack[2])
      S_chan_req_en[2] <= 1'b0;
    else if (S_chan_req_en[3] & S_chan_ack[3])
      S_chan_req_en[3] <= 1'b0;
*/
  end

// transfer byte counters
always @(posedge clk or negedge resetn)
  if (!resetn)
    M_tx0_byte_count = 0;
  else if (M_axis_tx0_tready & M_axis_tx0_tvalid)
    M_tx0_byte_count = M_tx0_byte_count + 1;

always @(posedge clk or negedge resetn)
  if (!resetn)
    M_tx1_byte_count = 0;
  else if (M_axis_tx1_tready & M_axis_tx1_tvalid)
    M_tx1_byte_count = M_tx1_byte_count + 1;

always @(posedge clk or negedge resetn)
  if (!resetn)
    M_rx0_byte_count = 0;
  else if (M_axis_rx0_tready & M_axis_rx0_tvalid)
    M_rx0_byte_count = M_rx0_byte_count + 1;

always @(posedge clk or negedge resetn)
  if (!resetn)
    M_rx1_byte_count = 0;
  else if (M_axis_rx1_tready & M_axis_rx1_tvalid)
    M_rx1_byte_count = M_rx1_byte_count + 1;

always @(posedge clk or negedge resetn)
  if (!resetn)
    S_tx0_byte_count = 0;
  else if (S_axis_tx0_tready & S_axis_tx0_tvalid)
    S_tx0_byte_count = S_tx0_byte_count + 1;

always @(posedge clk or negedge resetn)
  if (!resetn)
    S_tx1_byte_count = 0;
  else if (S_axis_tx1_tready & S_axis_tx1_tvalid)
    S_tx1_byte_count = S_tx1_byte_count + 1;

always @(posedge clk or negedge resetn)
  if (!resetn)
    S_rx0_byte_count = 0;
  else if (S_axis_rx0_tready & S_axis_rx0_tvalid)
    S_rx0_byte_count = S_rx0_byte_count + 1;

always @(posedge clk or negedge resetn)
  if (!resetn)
    S_rx1_byte_count = 0;
  else if (S_axis_rx1_tready & S_axis_rx1_tvalid)
    S_rx1_byte_count = S_rx1_byte_count + 1;

wire M_axis_rx0_tready1;
wire M_axis_rx0_valid1;

// Manager side testbench stream stinulus
  tb_axi_stream_io8_txd_from_file #(
    .TXDFILENAME(ASC_FILENAME)
  ) u_tb_axi_stream_io_8_txd_from_file_M_chan0 (
    .aclk       (clk),
    .aresetn    (resetn),
    .txd8_ready (M_axis_rx0_tready1),
    .txd8_valid (M_axis_rx0_tvalid1),
    .txd8_data  (M_axis_rx0_tdata8)
  );

  assign M_axis_rx0_tready1 = M_axis_rx0_tready & M_chan_req_en[0];
  assign M_axis_rx0_tvalid  = M_axis_rx0_tvalid1 & M_chan_req_en[0];
  assign M_chan_ack[0]      = (M_axis_rx0_tready & M_axis_rx0_tvalid);

wire M_axis_tx0_tready1;
wire M_axis_tx0_tvalid1;

  tb_axi_stream_io8_rxd_to_file#(
    .RXDFILENAME("M_rxd0_out.log")
  ) u_tb_axi_stream_io_8_rxd_to_file_M_chan0 (
    .aclk         (clk),
    .aresetn      (resetn),
    .end_of_file  (M_end_of_file1),
    .rxd8_ready   (M_axis_tx0_tready1),
    .rxd8_valid   (M_axis_tx0_tvalid1),
    .rxd8_data    (M_axis_tx0_tdata8)
  );
  assign M_axis_tx0_tvalid1 = M_axis_tx0_tvalid & M_chan_req_en[1];
  assign M_axis_tx0_tready  = M_axis_tx0_tready1 & M_chan_req_en[1];
  assign M_chan_ack[1] = (M_axis_tx0_tready & M_axis_tx0_tvalid);

wire M_axis_rx1_tready1;
wire M_axis_rx1_tvalid1;

// Manager side testbench stream stinulus
  tb_axi_stream_io8_txd_from_file #(
    .TXDFILENAME(ASC_FILENAME)
  ) u_tb_axi_stream_io_8_txd_from_file_M_chan1 (
    .aclk       (clk),
    .aresetn    (resetn),
    .txd8_ready (M_axis_rx1_tready1),
    .txd8_valid (M_axis_rx1_tvalid1),
    .txd8_data  (M_axis_rx1_tdata8)
  );

  assign M_axis_rx1_tready1 = M_axis_rx1_tready & M_chan_req_en[2];
  assign M_axis_rx1_tvalid  = M_axis_rx1_tvalid1 & M_chan_req_en[2];
  assign M_chan_ack[2]      = (M_axis_rx1_tready & M_axis_rx1_tvalid);

wire M_axis_tx1_tready1;
wire M_axis_tx1_tvalid1;

  tb_axi_stream_io8_rxd_to_file#(
    .RXDFILENAME("M_rxd1_out.log")
  ) u_tb_axi_stream_io_8_rxd_to_file_M_chan1 (
    .aclk         (clk),
    .aresetn      (resetn),
    .end_of_file  (M_end_of_file2),
    .rxd8_ready   (M_axis_tx1_tready1),
    .rxd8_valid   (M_axis_tx1_tvalid1),
    .rxd8_data    (M_axis_tx1_tdata8)
  );
  assign M_axis_tx1_tvalid1 = M_axis_tx1_tvalid & M_chan_req_en[3];
  assign M_axis_tx1_tready  = M_axis_tx1_tready1 & M_chan_req_en[3];
  assign M_chan_ack[3] = (M_axis_tx1_tready & M_axis_tx1_tvalid);

//assign end_of_file = end_of_file1 & end_of_file2 & end_of_file3 & end_of_file4;
assign M_end_of_file = M_end_of_file1 & M_end_of_file2;


// Subordinate side back-pressure tester

wire S_axis_rx0_tready1;
wire S_axis_rx0_tvalid1;

// Manager side testbench stream stinulus
  tb_axi_stream_io8_txd_from_file #(
    .TXDFILENAME(ASC_FILENAME)
  ) u_tb_axi_stream_io_8_txd_from_file_S_chan0 (
    .aclk       (clk),
    .aresetn    (resetn),
    .txd8_ready (S_axis_rx0_tready1),
    .txd8_valid (S_axis_rx0_tvalid1),
    .txd8_data  (S_axis_rx0_tdata8)
  );

  assign S_axis_rx0_tready1 = S_axis_rx0_tready & S_chan_req_en[0];
  assign S_axis_rx0_tvalid  = S_axis_rx0_tvalid1 & S_chan_req_en[0];
  assign S_chan_ack[0]      = (S_axis_rx0_tready & S_axis_rx0_tvalid);

wire S_axis_tx0_tready1;
wire S_axis_tx0_tvalid1;

  tb_axi_stream_io8_rxd_to_file#(
    .RXDFILENAME("S_rxd0_out.log")
  ) u_tb_axi_stream_io_8_rxd_to_file_S_chan0 (
    .aclk         (clk),
    .aresetn      (resetn),
    .end_of_file  (S_end_of_file1),
    .rxd8_ready   (S_axis_tx0_tready1),
    .rxd8_valid   (S_axis_tx0_tvalid1), // & S_chan_req_en[1]),
    .rxd8_data    (S_axis_tx0_tdata8)
  );
  assign S_axis_tx0_tvalid1 = S_axis_tx0_tvalid & S_chan_req_en[1];
  assign S_axis_tx0_tready  = S_axis_tx0_tready1 & S_chan_req_en[1];
  assign S_chan_ack[1] = (S_axis_tx0_tready & S_axis_tx0_tvalid);

wire S_axis_rx1_tready1;
wire S_axis_rx1_tvalid1;

// Manager side testbench stream stinulus
  tb_axi_stream_io8_txd_from_file #(
    .TXDFILENAME(ASC_FILENAME)
  ) u_tb_axi_stream_io_8_txd_from_file_S_chan1 (
    .aclk       (clk),
    .aresetn    (resetn),
    .txd8_ready (S_axis_rx1_tready1),
    .txd8_valid (S_axis_rx1_tvalid1),
    .txd8_data  (S_axis_rx1_tdata8)
  );

  assign S_axis_rx1_tready1 = S_axis_rx1_tready & S_chan_req_en[2];
  assign S_axis_rx1_tvalid  = S_axis_rx1_tvalid1 & S_chan_req_en[2];
  assign S_chan_ack[2]      = (S_axis_rx1_tready & S_axis_rx1_tvalid);

wire S_axis_tx1_tready1;
wire S_axis_tx1_tvalid1;

  tb_axi_stream_io8_rxd_to_file#(
    .RXDFILENAME("S_rxd1_out.log")
  ) u_tb_axi_stream_io_8_rxd_to_file_S_chan1 (
    .aclk         (clk),
    .aresetn      (resetn),
    .end_of_file  (S_end_of_file2),
    .rxd8_ready   (S_axis_tx1_tready1),
    .rxd8_valid   (S_axis_tx1_tvalid1), //  & S_chan_req_en[3]),
    .rxd8_data    (S_axis_tx1_tdata8)
  );
  assign S_axis_tx1_tready  = S_axis_tx1_tready1 & S_chan_req_en[3];
  assign S_axis_tx1_tvalid1 = S_axis_tx1_tvalid & S_chan_req_en[3];
  assign S_chan_ack[3] = (S_axis_tx1_tready & S_axis_tx1_tvalid);

//assign end_of_file = end_of_file1 & end_of_file2 & end_of_file3 & end_of_file4;
assign S_end_of_file = S_end_of_file1 & S_end_of_file2;



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
      if (M_end_of_file & S_end_of_file) begin
        #10000
        $display("EXTIO8x4 cycle count     = %d", cycle_count);
        $display("EXTIO8x4 M rx0 byte count  = %d", M_rx0_byte_count);
        $display("EXTIO8x4 M tx0 byte count  = %d", M_tx0_byte_count);
        $display("EXTIO8x4 M rx1 byte count  = %d", M_rx1_byte_count);
        $display("EXTIO8x4 M tx1 byte count  = %d", M_tx1_byte_count);
        $display("EXTIO8x4 S rx0 byte count  = %d", S_rx0_byte_count);
        $display("EXTIO8x4 S tx0 byte count  = %d", S_tx0_byte_count);
        $display("EXTIO8x4 S rx1 byte count  = %d", S_rx1_byte_count);
        $display("EXTIO8x4 S tx1 byte count  = %d", S_tx1_byte_count);
        $display("clocks per byte (approx) = %f",
              (cycle_count/(M_rx0_byte_count+ M_rx1_byte_count + M_tx0_byte_count+M_tx1_byte_count)));
        $finish();
        end
    end //

endmodule
