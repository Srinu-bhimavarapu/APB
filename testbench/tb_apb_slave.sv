`timescale 1ns/1ps

module tb_apb_slave;

  // --------------------------------
  // Parameters
  // --------------------------------
  localparam ADDR_WIDTH = 32;
  localparam DATA_WIDTH = 32;

  // --------------------------------
  // APB Signals
  // --------------------------------
  logic                  PCLK;
  logic                  PRESETn;
  logic                  PSEL;
  logic                  PENABLE;
  logic                  PWRITE;
  logic [ADDR_WIDTH-1:0] PADDR;
  logic [DATA_WIDTH-1:0] PWDATA;
  logic [DATA_WIDTH-1:0] PRDATA;
  logic                  PREADY;
  logic                  PSLVERR;
   logic [31:0] rdata;
  // --------------------------------
  // DUT Instantiation
  // --------------------------------
  apb_slave dut (
    .PCLK    (PCLK),
    .PRESETn (PRESETn),
    .PSEL    (PSEL),
    .PENABLE (PENABLE),
    .PWRITE  (PWRITE),
    .PADDR   (PADDR),
    .PWDATA  (PWDATA),
    .PRDATA  (PRDATA),
    .PREADY  (PREADY),
    .PSLVERR (PSLVERR)
  );

  // --------------------------------
  // Clock Generation (10ns period)
  // --------------------------------
  always #5 PCLK = ~PCLK;

  // --------------------------------
  // APB WRITE TASK
  // --------------------------------
  task apb_write(input [ADDR_WIDTH-1:0] addr,
                 input [DATA_WIDTH-1:0] data);
    begin
      // SETUP phase
      @(posedge PCLK);
      PSEL    <= 1'b1;
      PENABLE <= 1'b0;
      PWRITE  <= 1'b1;
      PADDR   <= addr;
      PWDATA  <= data;

      // ACCESS phase
      @(posedge PCLK);
      PENABLE <= 1'b1;

      // Wait for ready
      while (!PREADY)
        @(posedge PCLK);

      // End transfer
      @(posedge PCLK);
      PSEL    <= 1'b0;
      PENABLE <= 1'b0;
      PWRITE  <= 1'b0;
    end
  endtask

  // --------------------------------
  // APB READ TASK
  // --------------------------------
  task apb_read(input  [ADDR_WIDTH-1:0] addr,
                output [DATA_WIDTH-1:0] data);
    begin
      // SETUP phase
      @(posedge PCLK);
      PSEL    <= 1'b1;
      PENABLE <= 1'b0;
      PWRITE  <= 1'b0;
      PADDR   <= addr;

      // ACCESS phase
      @(posedge PCLK);
      PENABLE <= 1'b1;

      // Wait for ready
      while (!PREADY)
        @(posedge PCLK);

      data = PRDATA;

      // End transfer
      @(posedge PCLK);
      PSEL    <= 1'b0;
      PENABLE <= 1'b0;
    end
  endtask

  // --------------------------------
  // Test Sequence
  // --------------------------------
  initial begin
    // Initialize signals
    PCLK    = 0;
    PRESETn = 0;
    PSEL    = 0;
    PENABLE = 0;
    PWRITE  = 0;
    PADDR   = 0;
    PWDATA  = 0;

    // Reset
    #20;
    PRESETn = 1;
 

    // WRITE
    $display("APB WRITE...");
    apb_write(32'h0000_0000, 32'hDEADBEEF);

    // READ
    
    $display("APB READ...");
    apb_read(32'h0000_0000, rdata);

    $display("READ DATA = %h", rdata);

    // Finish
    #20000;
    $finish;
  end

endmodule
