//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   top_redraw_board
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-25
 Description:  Top module for drawing symbols and numbers during minesweeping
 */
//////////////////////////////////////////////////////////////////////////////

 `timescale 1 ns / 1 ps

 module top_mine (
     input  wire clk,
     input  logic rst,
     input wire [1:0] level,
     input wire [11:0] mouse_xpos,
     input wire [11:0] mouse_ypos,
     input wire [5:0] mines,
     input wire left, right,
     input wire [4:0] button_num,
     output logic explode, mark_flag,
     output logic [4:0] button_ind_x_out,
     output logic [4:0] button_ind_y_out,
     game_set_if.in gin
 );

 wire array_easy [7:0] [7:0];
 wire array_medium [9:0] [9:0];
 wire array_hard [15:0] [15:0];

 wire [4:0] button_index_x, button_index_y;
 wire bomb, flag, random_data;


 detect_index u_detect_index(
   .clk,
   .rst,
   .mouse_xpos(mouse_xpos),
   .mouse_ypos(mouse_ypos),
   .left(left),
   .right(right),
   .button_index_x(button_ind_x_out),
   .button_index_y(button_ind_y_out),
   .bomb(bomb),
   .flag(flag),
   .in(gin)

);

 random_gen u_random_gen(
   .clk,
   .rst,
   .random_data(random_data)
 );

 mine_board u_mine_board(
   .clk,
   .rst,
   .random_data(random_data),
   .level(level),
   .mines(mines),
   .dimension_size(button_num),
   .array_easy_out(array_easy),
   .array_medium_out(array_medium),
   .array_hard_out(array_hard)
 );

 mine_check u_mine_check(
   .clk,
   .rst,
   .button_ind_x_in(button_index_x),
   .button_ind_y_in(button_index_y),
   .flag(flag),
   .bomb(bomb),
   .level(level),
   .array_easy_in(array_easy),
   .array_medium_in(array_medium),
   .array_hard_in(array_hard),
   .explode(explode),
   .mark_flag(mark_flag),
   .button_ind_x_out(),
   .button_ind_y_out()
 );

 endmodule