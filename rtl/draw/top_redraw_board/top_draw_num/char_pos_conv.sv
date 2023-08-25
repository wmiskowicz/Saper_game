`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   char_pos_conv
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-20
 Description:  Returns char index based on cur_xpos and board parameters
 */
//////////////////////////////////////////////////////////////////////////////
module char_pos_conv
    (
    input wire clk,
    input wire rst,
    input wire [10:0] cur_pos,
    input wire [9:0] board_size,
    input wire [6:0] button_size,
    input wire [4:0] button_num,
    output reg [4:0] char_pos
    );
    
    logic [4:0] char_pos_nxt;
    //logic [10:0] char_cur_pos, char_cur_pos_nxt;
    logic [5:0] loc_button_size;

    assign loc_button_size = button_size[5:0];
    
    always_ff @(posedge clk) begin
        if (rst) begin
            char_pos <= '0;
        end
        else begin
            char_pos <= char_pos_nxt;
        end
    end
    
    always_comb begin
        if(cur_pos < button_size)begin
            char_pos_nxt = '0;
        end
        else if(cur_pos[5:0] == loc_button_size && cur_pos <= board_size) begin
            char_pos_nxt = char_pos == button_num-1 ? '0 : char_pos + 1;
        end
        else begin
            char_pos_nxt = char_pos;  
        end
    end
 
 endmodule
    
