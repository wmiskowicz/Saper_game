`timescale 1 ns / 1 ps

module draw_mine (
    input wire clk,
    input wire rst,
    input logic [4:0] mine_ind_x,
    input logic [4:0] mine_ind_y,
    input wire [6:0] button_size,
    input wire [10:0] board_xpos,
    input wire [10:0] board_ypos,
    input wire explode,
    vga_if.in in,
    vga_if.out out
);

import colour_pkg::*;

logic [11:0] rgb_nxt;
logic [10:0] rect_mid;
logic [10:0] cur_xpos, cur_ypos;
logic [10:0] rect_xpos, rect_ypos;
logic [4:0] ind_x_trans, ind_y_trans;


//************LOCAL PARAMETERS*****************
assign ind_x_trans = mine_ind_x - 1;
assign ind_y_trans = mine_ind_y - 1;

assign rect_xpos = board_xpos + ind_x_trans * button_size;
assign rect_ypos = board_ypos + ind_y_trans * button_size;


assign rect_mid = button_size/2;
assign cur_xpos = in.hcount >= rect_xpos ? in.hcount - rect_xpos : -1;
assign cur_ypos = in.vcount >= rect_ypos ? in.vcount - rect_ypos : -1;




 always_ff @(posedge clk) begin : mine_ff_blk
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

 always_comb begin : mine_comb_blk
    if(explode) begin
        if((cur_xpos < button_size) && (cur_ypos < button_size) && (cur_xpos < button_size) && (cur_ypos < button_size))begin
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