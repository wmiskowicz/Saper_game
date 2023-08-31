`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   char_pos_conv
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-20
 Description:  Returns char index based on cur_pos and board parameters
 */
//////////////////////////////////////////////////////////////////////////////
module char_pos_conv
    (
    input wire clk,
    input wire rst,
    input wire [10:0] cur_pos,
    input wire [6:0] button_size,
    input wire [4:0] button_num,
    output reg [3:0] char_pos,
    output reg [5:0] char_line 
    );
    
    logic [3:0] char_pos_nxt;
    logic [10:0] cur_pos_ctr, cur_pos_ctr_nxt, cur_pos_prev;
    logic [5:0] loc_button_size;

    assign loc_button_size = button_size[5:0];
    assign char_line = cur_pos_ctr[5:0];
    
    always_ff @(posedge clk) begin
        if (rst) begin
            char_pos <= '0;
            cur_pos_ctr <= '0;
            cur_pos_prev <= '0;
        end
        else begin
            char_pos <= char_pos_nxt;
            cur_pos_ctr <= cur_pos_ctr_nxt;
            cur_pos_prev <= cur_pos;
        end
    end
    
    always_comb begin
        if(cur_pos == 11'h7_f_f) begin
            char_pos_nxt = 'x;
            cur_pos_ctr_nxt = 'x;
            
        end
        else if(cur_pos <= button_size)begin
            char_pos_nxt = '0;
            cur_pos_ctr_nxt = cur_pos;

        end
        else if(cur_pos_ctr[5:0] == loc_button_size) begin
            cur_pos_ctr_nxt = '0;
            char_pos_nxt = char_pos == button_num-1 ? '0 : char_pos + 1;
        end
        else if(cur_pos != cur_pos_prev)begin
            cur_pos_ctr_nxt = cur_pos_ctr + 1;
            char_pos_nxt = char_pos;  
        end
        else begin
            cur_pos_ctr_nxt = cur_pos_ctr;
            char_pos_nxt = char_pos;
        end
    end
 
 endmodule
    
