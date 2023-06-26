//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   top_redraw_board
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-25
 Description:  Top module for drawing symbols and numbers during minesweeping
 */
//////////////////////////////////////////////////////////////////////////////

 `timescale 1 ns / 1 ps

 module top_redraw_board (
     input  wire clk,
     input  logic rst,
     input wire [1:0] level,
     input wire [4:0] flag_ind_x,
     input wire [4:0] flag_ind_y,
     input wire  explode, mark_flag,
     game_set_if.in gin,
     vga_if.in in,
     vga_if.out out
 );


 draw_flag u_draw_flag(
  .clk,
  .rst,
  .mark_flag(mark_flag),
  .flag_ind_x(flag_ind_x),
  .flag_ind_y(flag_ind_y),
  .gin(gin),
  .in(in),
  .out(out)
 );

 endmodule