
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