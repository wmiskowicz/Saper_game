`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   detect index // added branch1
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-20
 Coding style: safe with FPGA sync reset
 Description:  Returns button index based on mouse position
 */
//////////////////////////////////////////////////////////////////////////////
module detect_index (
    input  logic clk,
    input  logic rst,
    input wire [11:0] mouse_xpos,
    input wire [11:0] mouse_ypos,
    input wire left,
    input wire right,
    output reg bomb,
    output reg flag,
    output reg [4:0] button_index_x,
    output reg [4:0] button_index_y,
    game_set_if.in in
);

//Local variables
logic [4:0] button_index_x_nxt, button_index_y_nxt;
logic [11:0] cur_xpos, cur_ypos;
logic bomb_nxt, flag_nxt;

//Signal assignments
assign cur_xpos = mouse_xpos-in.board_xpos;
assign cur_ypos = mouse_ypos-in.board_ypos;




always_ff @(posedge clk) begin : detect_ff_blk
    if (rst) begin
        button_index_x <= '0;
        button_index_y <= '0;
        bomb <= '0;
        flag <= '0;
    end else begin
        button_index_x <= button_index_x_nxt;
        button_index_y <= button_index_y_nxt;
        bomb <= bomb_nxt;
        flag <= flag_nxt;
    end
end

always_comb begin : detect_comb
    if ((in.button_num > 0) && (cur_xpos >= 0) && (cur_xpos <= in.board_size) && (cur_ypos >= 0) && (cur_ypos <= in.board_size)) begin

        button_index_x_nxt = (cur_xpos/in.button_size)+1;
        button_index_y_nxt = (cur_ypos/in.button_size)+1;
        if(left) begin
            flag_nxt = '0;
            bomb_nxt = '1;
        end
        else if(right) begin
            flag_nxt = '1;
            bomb_nxt = '0;
        end
        else begin
            flag_nxt = '0;
            bomb_nxt = '0;
        end
    end
    else begin                               
        button_index_x_nxt = '0; 
        button_index_y_nxt = '0;
        flag_nxt = '0;
        bomb_nxt = '0;
    end             
end


endmodule