`timescale 1 ns / 1 ps

module draw_flag (
    input wire clk,
    input wire rst,
    input wire mark_flag,
    input wire [1:0] level,
    input wire [4:0] flag_ind_x,
    input wire [4:0] flag_ind_y,
    game_set_if.in gin,
    vga_if.in in,
    vga_if.out out
);

import colour_pkg::*;

logic [11:0] rgb_nxt;
logic [10:0] mid_x;
logic [10:0] cur_xpos, cur_ypos;
logic [10:0] rect_xpos, rect_ypos;

//************LOCAL PARAMETERS*****************
assign rect_xpos = gin.board_xpos + (flag_ind_x-1) * gin.button_size;
assign rect_ypos = gin.board_ypos + (flag_ind_y-1) * gin.button_size;


assign mid_x = gin.button_size/2;
assign cur_xpos = in.hcount - rect_xpos;
assign cur_ypos = in.vcount - rect_ypos;


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
 
    if((cur_xpos < mid_x) && (cur_ypos < cur_xpos + 5) && (cur_ypos > (-cur_xpos+gin.button_size/2)))begin
        rgb_nxt = RED;
    end
    else if(((cur_xpos >= mid_x) && (cur_xpos < mid_x+2) && (cur_ypos > 8) && (cur_ypos < gin.button_size-14)) || 
    ((cur_xpos >= mid_x-4) && (cur_xpos < mid_x+6) && (cur_ypos >= gin.button_size-14) && (cur_ypos < gin.button_size-11)) ||
    ((cur_xpos >= mid_x-8) && (cur_xpos < mid_x+10) && (cur_ypos >= gin.button_size-11) && (cur_ypos < gin.button_size-8))
    ) begin
        rgb_nxt = BLACK;
    end
    else begin
        rgb_nxt = in.rgb;
    end
 end

endmodule