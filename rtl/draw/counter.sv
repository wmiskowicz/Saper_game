`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   Counter
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-17
 Description:  Counts to wanted value when posedge on 'counting' detected
 */
//////////////////////////////////////////////////////////////////////////////
module counter#(
    parameter DATA_SIZE = 5
)
    (
    input wire clk,
    input wire rst,
    input wire counting,
    input wire [DATA_SIZE-1:0] max,
    output reg [DATA_SIZE-1:0] ctr_out
    //output wire done
    );
    
    logic [DATA_SIZE-1:0] ctr_nxt;
    //assign done = (ctr_out >= max);
    
    always_ff @(posedge clk) begin
        if (rst) begin
            ctr_out <= '0;
        end
        else begin
            ctr_out <= ctr_nxt;
        end
    end
    
    always_ff @(posedge counting) begin
        if (counting) begin
            if(ctr_out < max-1) begin
                ctr_nxt <= ctr_out + 1;
            end
            else begin
                ctr_nxt <= 0;    
            end
        end
    end
 
 endmodule
    
