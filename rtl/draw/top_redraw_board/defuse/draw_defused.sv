`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_defused
 Author:        Wojciech Miskowicz
 Last modified: 2023-030-08
 Description:  Draws a defused field
 */
//////////////////////////////////////////////////////////////////////////////


module draw_defused (
    input wire clk,
    input wire rst,
    input wire [1:0] level,
    input wire [7:0] [7:0] defuse_arr_easy,
    input wire [9:0] [9:0] defuse_arr_medium,
    input wire [15:0] [15:0] defuse_arr_hard,
    game_set_if.in gin,
    vga_if.in in,
    vga_if.out out
);

import colour_pkg::*;

logic [11:0] rgb_nxt;
logic [10:0] cur_xpos, cur_ypos;
logic [3:0] ind_x, ind_y;

logic [5:0] but_xpos, but_ypos;


//************LOCAL PARAMETERS*****************

assign cur_ypos = in.vcount >= gin.board_ypos && in.vcount <= gin.board_ypos + gin.board_size ? in.vcount - gin.board_ypos : 11'h7_f_f;
assign cur_xpos = cur_ypos != 11'h7_f_f && in.hcount >= gin.board_xpos && in.hcount <= gin.board_xpos + gin.board_size  + gin.button_num ? in.hcount - gin.board_xpos :  11'h7_f_f;

char_pos_conv ind_xpos(
    .clk,
    .rst,
    .cur_pos(cur_xpos),
    .button_size(gin.button_size),
    .button_num(gin.button_num),
    .char_line(but_xpos),
    .char_pos(ind_x)
);

char_pos_conv ind_ypos(
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
    if((level == 1 && defuse_arr_easy[ind_x][ind_y]) ||
    (level == 2 && defuse_arr_medium[ind_x][ind_y]) ||
    (level == 3 && defuse_arr_hard[ind_x][ind_y])) begin
        if(but_xpos < gin.button_size && but_ypos < gin.button_size && 
        but_xpos > 0 && but_ypos > 0 &&
        (cur_xpos != 11'h7_f_f) && (cur_ypos != 11'h7_f_f))begin
            rgb_nxt = BUTTON_BACK;
        end
        else if((cur_xpos != 11'h7_f_f) && (cur_ypos != 11'h7_f_f)) begin
            rgb_nxt = BUTTON_GRAY;
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