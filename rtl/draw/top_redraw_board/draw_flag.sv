`timescale 1 ns / 1 ps

module draw_flag (
    input wire clk,
    input wire rst,
    input wire  [7:0] [7:0] flag_arr_easy,
    input wire  [9:0] [9:0] flag_arr_medium,
    input wire  [15:0] [15:0] flag_arr_hard,
    game_set_if.in gin,
    output reg [9:0] board_size,
    vga_if.in in,
    vga_if.out out
);

import colour_pkg::*;

logic [11:0] rgb_nxt;
logic [10:0] mid_x;
logic [10:0] cur_xpos, cur_ypos;
logic [10:0] rect_xpos, rect_ypos;

logic done_x, done_y, done_x_nxt, done_y_nxt;
logic [4:0] array_vcount, array_hcount;
logic [4:0] array_vcount_nxt, array_hcount_nxt;

//************LOCAL PARAMETERS*****************
assign rect_xpos = gin.board_xpos + (array_hcount) * gin.button_size;
assign rect_ypos = gin.board_ypos + (array_vcount) * gin.button_size;


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
        done_x <= '0;
        done_y <= '0;
        array_vcount <= '0;
        array_hcount <= '0;
        board_size <= '0;
    end else begin
        out.vcount <= in.vcount;
        out.vsync <= in.vsync;
        out.vblnk <= in.vblnk;
        out.hcount <= in.hcount;
        out.hsync <= in.hsync;
        out.hblnk <= in.hblnk;
        out.rgb <= rgb_nxt;
        done_x <= done_x_nxt;
        done_y <= done_y_nxt;
        array_vcount <= array_vcount_nxt;
        array_hcount <= array_hcount_nxt;
        board_size <= gin.board_size;
    end
 end

 always_comb begin : flag_comb_blk
    if(flag_arr_easy[array_hcount][array_vcount] || flag_arr_medium[array_hcount][array_vcount] ||flag_arr_hard[array_hcount][array_vcount]) begin
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
    else begin
        rgb_nxt = in.rgb;
    end

    if(cur_xpos == gin.button_size) begin
        done_x_nxt = '1;
    end
    else begin
        done_x_nxt = '0;
    end

    if(cur_ypos == gin.button_size)begin
        done_y_nxt = '1;
    end
    else begin
        done_y_nxt = '0;
    end
 end

 edge_ctr y_counter(
    .clk,
    .rst,
    .max(gin.button_num),
    .ctr_out(array_vcount_nxt),
    .signal(done_y)
 );
 edge_ctr x_counter(
    .clk,
    .rst,
    .max(gin.button_num),
    .ctr_out(array_hcount_nxt),
    .signal(done_x)
 );

endmodule