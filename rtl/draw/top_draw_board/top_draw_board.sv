//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   top_draw_board
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-25
 Description:  Top module for drawing symbols and numbers during minesweeping
 */
//////////////////////////////////////////////////////////////////////////////

 `timescale 1 ns / 1 ps

 module top_draw_board (
     input  wire clk,
     input  logic rst,
     input wire enable_game,
     game_set_if.in gin,
     vga_if.out out
 );

 wire draw_button, done_x, done_y;
 wire [10:0] button_xpos, button_ypos;
 wire [6:0] button_size;


 vga_if tim_bg_if();
 vga_if bg_rect_if();
 



 vga_timing u_vga_timing (
    .clk,
    .rst,
    .out(tim_bg_if.out)
);

draw_bg u_draw_bg (
    .clk,
    .rst,
    .in(tim_bg_if.in),
    .out(bg_rect_if.out)
);

draw_board u_draw_board(
   .clk,
   .rst,
   .in(gin),
   .done_x(done_x),
   .done_y(done_y),
   .draw_board(enable_game),
   .draw_button(draw_button),
   .button_size(button_size),
   .button_xpos(button_xpos),
   .button_ypos(button_ypos)
);

draw_button u_draw_button (
    .clk,
    .rst,
    .done_x(done_x),
    .done_y(done_y),
    .draw_button(draw_button),
    .button_size(button_size),
    .rect_xpos(button_xpos),
    .rect_ypos(button_ypos),
    .in(bg_rect_if.in),
    .out(out)
);

 endmodule