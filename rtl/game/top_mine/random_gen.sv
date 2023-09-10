`timescale 1 ns / 1ps

//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   random_gen
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-23
 Coding style: safe with FPGA sync reset
 Description:  Generates a random value
 */
//////////////////////////////////////////////////////////////////////////////

module random_gen(
    input wire clk,
    input wire rst,
    output reg [1:0] y_inc,
    output logic random_data
    );
    
    reg [31:0] ctr, ctr_nxt;
    reg [7:0] incr;
    localparam MAX = 32'hf_f_f_f_f_f_f_f;

    assign random_data = ctr[5:5];
    assign y_inc = ctr[7:6];
    assign incr = ctr[9:2];
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            ctr <= 32'b0;
        end
        else begin
            ctr <= ctr_nxt;
        end
    end
    
    always_comb begin
        if(ctr < MAX) begin
            ctr_nxt = ctr + 1 + incr;
        end
        else begin
            ctr_nxt = '0;    
        end
    end
    
 
    
endmodule