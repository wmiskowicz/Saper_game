//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   top_mine
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-25
 Description:  Top module for mining board
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
     output logic explode, mark_flag, defuse,
     output logic [4:0] button_ind_x_out,
     output logic [4:0] button_ind_y_out,
     output reg [7:0] [7:0] mine_arr_easy,
     output reg [9:0] [9:0] mine_arr_medium,
     output reg [15:0] [15:0] mine_arr_hard,
     game_set_if.in gin
 );

 wire [7:0] [7:0] array_easy;
 wire [9:0] [9:0] array_medium;
 wire [15:0] [15:0] array_hard;

 wire [4:0] button_index_x, button_index_y;
 
 
 wire bomb, flag, random_data;


 assign button_ind_x_out = button_index_x;
 assign button_ind_y_out = button_index_y;

 assign mine_arr_easy = array_easy;
 assign mine_arr_medium = array_medium;
 assign mine_arr_hard = array_hard;

 detect_index u_detect_index(
   .clk,
   .rst,
   .mouse_xpos,
   .mouse_ypos,
   .left,
   .right,
   .button_index_x,
   .button_index_y,
   .bomb,
   .flag,
   .in(gin)

);

 random_gen u_random_gen(
   .clk,
   .rst,
   .random_data
 );

 mine_board u_mine_board(
   .clk,
   .rst,
   .random_data,
   .level,
   .mines,
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
   .flag,
   .bomb,
   .level,
   .array_easy_in(array_easy),
   .array_medium_in(array_medium),
   .array_hard_in(array_hard),
   .explode,
   .defuse,
   .mark_flag
 );

 endmodule