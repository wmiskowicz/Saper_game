`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_rect_char
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-05
 Coding style: safe with FPGA sync reset
 Description:  displays char line
 */
//////////////////////////////////////////////////////////////////////////////

module draw_rect_char #( parameter
    WIDTH = 16,
    XPOS = 48,
    YPOS = 64 
    )   
    (
    input  logic clk,
    input  logic rst,
    input logic [7:0] char_pixels,
    output  logic [7:0] char_xy,
    output  logic [3:0] char_line,
    vga_if.in in,
    vga_if.out out
);

import vga_pkg::*;


//************LOCAL PARAMETERS*****************


logic [10:0] vcount_nxt;
logic         vsync_nxt;
logic         vblnk_nxt;
logic [10:0] hcount_nxt, hcount_nxt1;
logic         hsync_nxt;
logic         hblnk_nxt;
logic [11:0]  rgb_nxt, rgb_local;


localparam REAL_WIDTH = WIDTH << 3;
localparam REAL_HEIGHT = WIDTH << 4;

wire [10:0] char_ypos, char_xpos, char_ypos_delay, char_xpos_delay, char_mask;


//************ASSIGNS*****************
assign char_ypos = in.vcount - YPOS;
assign char_xpos = in.hcount - XPOS;

assign char_ypos_delay = vcount_nxt - YPOS;
assign char_xpos_delay = hcount_nxt - XPOS;
assign char_mask = hcount_nxt1 - XPOS;

assign char_line = char_ypos[3:0];
assign char_xy = {char_xpos[6:3], char_ypos[7:4]};


delay_upel #(
    .WIDTH(38),
    .CLK_DEL(1)  
)
u_delay_upel (
    .clk,
    .rst,
    .din({in.vcount, in.vsync, in.vblnk, in.hcount, in.hsync, in.hblnk, in.rgb}),
    .dout({vcount_nxt, vsync_nxt, vblnk_nxt, hcount_nxt, hsync_nxt, hblnk_nxt, rgb_local})
);

delay_upel #(
    .WIDTH(11),
    .CLK_DEL(2)  
)
u_delay_upel2 (
    .clk,
    .rst,
    .din({in.hcount}),
    .dout({hcount_nxt1})
);


always_ff @(posedge clk) begin : rect_blk
    if (rst) begin
        out.vcount <= '0;
        out.vsync <= '0;
        out.vblnk <= '0;
        out.hcount <= '0;
        out.hsync <= '0;
        out.hblnk <= '0;
        out.rgb <= '0;
    end else begin
        out.vcount <= vcount_nxt;
        out.vsync  <= vsync_nxt;
        out.vblnk  <= vblnk_nxt;
        out.hcount <= hcount_nxt;
        out.hsync  <= hsync_nxt;
        out.hblnk  <= hblnk_nxt;
        out.rgb <= rgb_nxt;
    end
end


always_comb begin : char_comb
    if ((char_pixels & (8'b10000000 >> char_mask[2:0])) && (hcount_nxt >= XPOS) && (char_xpos_delay < REAL_WIDTH)
    && (vcount_nxt >= YPOS) && (char_ypos_delay < REAL_HEIGHT)) begin
        rgb_nxt = 12'h0_0_0;
    end
    else begin                             
       rgb_nxt = rgb_local;   
    end           
end


endmodule