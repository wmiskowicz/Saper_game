`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_flag
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-25
 Description:  Draws a flag
 */
//////////////////////////////////////////////////////////////////////////////

module draw_flag (
    input wire clk,
    input wire rst,
    input wire [1:0] level,
    input wire  [7:0] [7:0] flag_arr_easy,
    input wire  [9:0] [9:0] flag_arr_medium,
    input wire  [15:0] [15:0] flag_arr_hard,
    game_set_if.in gin,
    vga_if.in in,
    vga_if.out out
);

import colour_pkg::*;

logic [11:0] rgb_nxt;
logic [10:0] mid_x;
logic [10:0] cur_xpos, cur_ypos;

//************LOCAL PARAMETERS*****************
logic [3:0] ind_x, ind_y;

logic [5:0] but_xpos, but_ypos;

assign mid_x = gin.button_size/2;
assign cur_ypos = in.vcount >= gin.board_ypos && in.vcount <= gin.board_ypos + gin.board_size ? in.vcount - gin.board_ypos : 11'h7_f_f;
assign cur_xpos = cur_ypos != 11'h7_f_f && in.hcount >= gin.board_xpos && in.hcount <= gin.board_xpos + gin.board_size ? in.hcount - gin.board_xpos :  11'h7_f_f;

char_pos_conv ind_xpos_conv(
    .clk,
    .rst,
    .cur_pos(cur_xpos),
    .button_size(gin.button_size),
    .button_num(gin.button_num),
    .char_line(but_xpos),
    .char_pos(ind_x)
);

char_pos_conv ind_ypos_conv(
    .clk,
    .rst,
    .cur_pos(cur_ypos),
    .button_size(gin.button_size),
    .button_num(gin.button_num),
    .char_line(but_ypos),
    .char_pos(ind_y)
);


 always_ff @(posedge clk) begin : flag_ff_blk
    if (rst) begin
        out.vcount <= '0;
        out.vsync <= '0;
        out.vblnk <= '0;
        out.hcount <= '0;
        out.hsync <= '0;
        out.hblnk <= '0;
        out.rgb <= '0;
    end else begin
        out.vcount <= in.vcount;
        out.vsync <= in.vsync;
        out.vblnk <= in.vblnk;
        out.hcount <= in.hcount;
        out.hsync <= in.hsync;
        out.hblnk <= in.hblnk;
        out.rgb <= rgb_nxt;
    end
 end

 always_comb begin : flag_comb_blk
    if((level == 1 && flag_arr_easy[ind_x][ind_y]) || 
    (level == 2 && flag_arr_medium[ind_x][ind_y]) ||
    (level == 3 && flag_arr_hard[ind_x][ind_y])) begin
        if((but_xpos < mid_x) && (but_ypos < but_xpos + 5) && (but_ypos > (-but_xpos+gin.button_size/3)))begin
            rgb_nxt = RED;
        end
        else if(((but_xpos >= mid_x) && (but_xpos < mid_x+2) && (but_ypos > 8) && (but_ypos < gin.button_size-14)) || 
        ((but_xpos >= mid_x-4) && (but_xpos < mid_x+6) && (but_ypos >= gin.button_size-14) && (but_ypos < gin.button_size-11)) ||
        ((but_xpos >= mid_x-8) && (but_xpos < mid_x+10) && (but_ypos >= gin.button_size-11) && (but_ypos < gin.button_size-8))
        ) begin
            rgb_nxt = BLACK;
        end
        else begin
            rgb_nxt = in.rgb;
        end
    end
    else begin
        rgb_nxt = in.rgb;
    end
 end

endmodule