`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   edge counter
 Author:        Wojciech Miskowicz
 Last modified: 2023-07-10
 Description:  top module that counts rising edges
 */
//////////////////////////////////////////////////////////////////////////////
module edge_ctr#(
    parameter DATA_SIZE = 5
    )
    (
      input wire clk,
      input wire rst,
      input wire signal,
      input wire [DATA_SIZE-1:0] max,
      output reg [DATA_SIZE-1:0] ctr_out
    );

 wire detected;

  edge_detector u_edge_detector(
    .clk,
    .rst,
    .signal,
    .detected(detected)
  );

 ts_counter #(
    .DATA_SIZE(DATA_SIZE)
 )
 u_ts_counter(
   .clk,
   .rst,
   .counting(detected),
   .max,
   .ctr_out
 );
 

endmodule