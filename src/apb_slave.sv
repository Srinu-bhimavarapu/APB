`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2026 23:02:50
// Design Name: 
// Module Name: apb_slave
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module apb_slave#(
parameter ADDR_WIDTH=32,
parameter DATA_WIDTH=32
)(
input logic PCLK,
input logic PRESETn,
input logic PSEL,
input logic PENABLE,
input logic PWRITE,
input logic[ADDR_WIDTH-1:0] PADDR,
input logic[DATA_WIDTH-1:0] PWDATA,
output logic[DATA_WIDTH-1:0] PRDATA,
output logic PREADY,
output logic PSLVERR
);
//fsm declaration
typedef enum logic[1:0] {
IDLE,
SETUP,
ACCESS
}apb_state_t;
apb_state_t state,next_state;

// internal registers
logic[DATA_WIDTH-1:0] reg0;

//fsm sequential block 
always_ff@(posedge PCLK or negedge PRESETn)
begin
if(!PRESETn)
state<=IDLE;
else
state<= next_state;
end
//fsm combinational block
always_comb begin
next_state=state;
case(state)
IDLE : begin
if(PSEL)
next_state=SETUP;
end 
SETUP : begin
next_state=ACCESS;
end
ACCESS : begin 
if(PREADY) begin
if(PSEL)
next_state=SETUP;
else
next_state=IDLE;
end 
end 
default: next_state= IDLE;
endcase
end 
//apb output logic
always_ff@(posedge PCLK or negedge PRESETn)
begin
if(!PRESETn) 
begin
reg0<='0;
PRDATA<='0;
PREADY<=1'b0;
PSLVERR<=1'b0;
end 
else 
begin
PREADY<=1'b1;
PSLVERR<=1'b0;
if(state==ACCESS && PSEL && PENABLE) begin
if(PWRITE) begin
reg0 <= PWDATA;
end
else 
begin
PRDATA<=reg0;
end 
end 
end
end
endmodule




















