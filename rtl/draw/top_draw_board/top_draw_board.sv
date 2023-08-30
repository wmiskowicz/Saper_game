 `timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   top_draw_board
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-25
 Description:  Top module for drawing symbols and numbers during minesweeping
 */
//////////////////////////////////////////////////////////////////////////////



 module top_draw_board (
     input  wire clk,
     input  logic rst,
     input wire enable_game,
     game_set_if.in gin,
     vga_if.out out
 );



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
   .draw_board(enable_game),
   .gin,
   .in(bg_rect_if.in),
   .out(out)
);



 endmodule