`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   edge detector
 Author:        Wojciech Miskowicz
 Last modified: 2023-07-10
 Coding style: simple with FPGA sync reset
 Description:  detects rising edge and returns '1 on one clock cycle
 */
//////////////////////////////////////////////////////////////////////////////


module edge_detector(
    input wire clk, rst,
    input wire signal,
    output reg detected
);

reg signal_delayed;

always_ff@(posedge clk) begin: edge_det_blk
    signal_delayed <= signal;
end

assign detected = rst ? '0 : signal && ~signal_delayed;

endmodule