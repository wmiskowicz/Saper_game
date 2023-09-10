`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   Counter
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-25
 Coding style: safe with FPGA sync reset
 Description:  Counts to wanted value when 'counting' = '1
 When ctr == max, ctr = 0
 */
//////////////////////////////////////////////////////////////////////////////
module ts_counter#(
    parameter DATA_SIZE = 4
)
    (
    input wire clk,
    input wire rst,
    input wire counting,
    input wire [DATA_SIZE-1:0] max,
    output reg [DATA_SIZE-1:0] ctr_out
    );
    
    logic [DATA_SIZE-1:0] ctr_nxt;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            ctr_out <= '0;
        end
        else begin
            ctr_out <= ctr_nxt;
        end
    end
    
    always_comb begin
        if (counting) begin
            if(ctr_out < max-1) begin
                ctr_nxt = ctr_out + 1;
            end
            else begin
                ctr_nxt = 0;    
            end
        end
        else begin
            ctr_nxt = ctr_out;
        end
    end
 
 endmodule
    
