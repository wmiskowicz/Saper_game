//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   top_draw_board
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-25
 Description:  Top module for drawing symbols and numbers during minesweeping
 */
//////////////////////////////////////////////////////////////////////////////

 `timescale 1 ns / 1 ps

 module top_game_setup (
     input  wire clk,
     input  logic rst,
     input wire [1:0] level,
     output logic [5:0] mines_out,
     output logic [1:0] level_out,
     game_set_if.out out
  
 );

 wire [5:0] mines;
 wire level_enable;
 

 game_set_if game_settings_if();

 select_level u_select_level(
    .clk,
    .rst,
    .level(level),
    .mines_out(mines),
    .level_enable(level_enable),
    .out(game_settings_if.out)
 );

 latch #(
   .DATA_SIZE(2)
 )
 u_level_latch(
   .clk,
   .rst,
   .Data_in(level),
   .Data_out(level_out),
   .enable(level_enable)
 );

 latch #(
   .DATA_SIZE(6)
 )u_mines_latch(
   .clk,
   .rst,
   .Data_in(mines),
   .Data_out(mines_out),
   .enable(level_enable)
 );

 settings_latch u_settings_latch(
    .clk,
    .rst,
    .in(game_settings_if.in),
    .out(out),
    .enable(level_enable)
 );


 endmodule