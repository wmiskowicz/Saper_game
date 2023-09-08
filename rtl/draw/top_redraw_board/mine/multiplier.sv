`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_mine
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-27
 Description:  Draws a mine when explode is high
 */
//////////////////////////////////////////////////////////////////////////////

module multiplier 
#(
  parameter WIDTH = 24)
(
  input wire clk,
  input wire rst,
  input wire [WIDTH-1:0] a,
  input wire [WIDTH-1:0] b,
  output logic [(WIDTH*2) -1:0] mul
);

logic [WIDTH-1:0] a1_i;
logic [WIDTH-1:0] b1_i;
logic [WIDTH-1:0] a2_i;
logic [WIDTH-1:0] b2_i;
logic [(WIDTH*2) -1:0] mul1_i;
logic [(WIDTH*2) -1:0] mul2_i;

logic state;
always @(posedge clk, negedge rst) begin
  if (~rst) begin
    state <= 'b0;
  end
  else begin
    state <= ~state;
  end
end



always_ff @(posedge clk) begin
  if (rst) begin
    a1_i <= '0;
    b1_i <= '0;
    a2_i <= '0;
    b2_i <= '0;
    mul  <= '0;
  end
  else begin
    if (state) begin
      a1_i <= a;
      b1_i <= b;
      mul  <= mul2_i;
    end
    else begin
      a2_i <= a;
      b2_i <= b;
      mul  <= mul1_i;
    end 
  end
end

always_comb begin
  mul1_i = a1_i * b1_i;
  mul2_i = a2_i * b2_i;
 end

endmodule