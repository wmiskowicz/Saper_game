//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   top_mouse
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-25
 Description:  Top module for mouse signals
 */
//////////////////////////////////////////////////////////////////////////////

 `timescale 1 ns / 1 ps

 module top_mouse (
     input  wire clk,
     input  wire clk100MHz,
     input  wire rst,
     inout  ps2_clk,
     inout  ps2_data,
     output logic right,
     output logic left,
     output logic [11:0] mouse_xpos,
     output logic [11:0] mouse_ypos,
     vga_if.in in,
     vga_if.out out
 );

 draw_mouse u_draw_mouse(
    .in(in),
    .out(out),
    .mouse_x_pos(mouse_xpos),
    .mouse_y_pos(mouse_ypos),
    .clk,
    .rst
 );


 MouseCtl u_MouseCtl(
    .clk(clk100MHz),
    .rst(rst),
    .xpos(mouse_xpos),
    .ypos(mouse_ypos),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .zpos(),
    .left(left),
    .middle(),
    .right(right),
    .new_event(),
    .value(),
    .setx('0),
    .sety('0),
    .setmax_x('0),
    .setmax_y('0)
 );

 endmodule