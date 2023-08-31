/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 * Wojciech Miskowicz
 * Description:
 * The project top module.
 */

 `timescale 1 ns / 1 ps

 module top_vga (
     input  logic clk,
     input  wire clk100MHz,
     input  wire [2:0] btnS,
     input  wire tim_stop, 
     input  logic rst,
     output logic vs,
     output logic hs,
     output logic [3:0] r,
     output logic [3:0] g,
     output logic [3:0] b,
     output wire [3:0] an,
     output wire [6:0] sseg,

     inout ps2_clk,
     inout ps2_data 
 );

 
 
 /**
  * Local variables and signals
  */
 wire b0, b1;
 wire [1:0] level, game_level_latch; 
 wire [11:0] mouse_xpos, mouse_ypos;
 wire [5:0] mines_latch;
 wire [4:0] button_ind_x_out, button_ind_y_out;

 wire [7:0] [7:0] mine_arr_easy;
 wire [9:0] [9:0] mine_arr_medium;
 wire [15:0] [15:0] mine_arr_hard;


 wire enable_game;
 wire explode, explode_latched, mark_flag, defuse;
 wire left, right, left_st, right_st;
 wire game_over, game_won, time_elapsed;
 
 wire [7:0] seconds_left, timer_val;
 wire [5:0] mines_left;

 


 //VGA interfaces
 vga_if tim_bg_if();
 vga_if bg_rect_if();
 vga_if board_out_if();
 vga_if board_button_if();
 vga_if draw_mouse_if();
 vga_if redraw_board_if();
 vga_if draw_char_if();
 vga_if game_over_if();
 
 game_set_if game_enable_if();
 
 
 /**
  * Signals assignments
  */
 
 assign vs = draw_mouse_if.vsync;
 assign hs = draw_mouse_if.hsync;
 assign {r,g,b} = draw_mouse_if.rgb;

 assign enable_game = btnS[2] || btnS[1] || btnS[0];
 assign game_over = (time_elapsed || explode_latched) && ~game_won;
 
 

 assign b0 = btnS [2] || btnS [0];
 assign b1 = btnS [1] || btnS [0];
 assign level = {b1, b0};
 
 
 /**
  * Submodules instances
  */
 top_char u_top_char(
   .clk,
   .rst,
   .in(redraw_board_if.in),
   .out(draw_char_if.out)
 );


 game_over_disp u_game_over_disp(
   .clk,
   .rst,
   .game_over,
   .game_won,
   .in(draw_char_if.in),
   .out(game_over_if.out)
 );


 top_draw_board u_top_draw_board (
     .clk,
     .rst,
     .enable_game,
     .gin(game_enable_if.in),
     .out(board_out_if.out)
 );
 
 top_redraw_board u_top_redraw_board(
  .clk,
  .rst,
  .level(game_level_latch),
  .explode,
  .mark_flag,
  .defuse,
  .symbol_ind_x(button_ind_x_out),
  .symbol_ind_y(button_ind_y_out),
  .mine_arr_easy,
  .mine_arr_medium,
  .mine_arr_hard,
  .mines(mines_latch),
  .mines_left,
  .game_won,
  .explode_latched(explode_latched),
  .gin(game_enable_if.in),
  .in(board_out_if.in),
  .out(redraw_board_if.out)
 );

 top_game_setup u_top_game_setup(
    .clk,
    .rst,
    .level(level),
    .timer_val,
    .mines_out(mines_latch),
    .level_out(game_level_latch),
    .out(game_enable_if.out)
 );

 top_mouse u_top_mouse(
    .clk,
    .clk100MHz,
    .rst,
    .in(game_over_if.in),
    .out(draw_mouse_if.out),
    .mouse_xpos,
    .mouse_ypos,
    .ps2_clk,
    .ps2_data,
    .right,
    .left
 );

top_mine u_top_mine(
   .clk,
   .rst,
   .mouse_xpos,
   .mouse_ypos,
   .level(game_level_latch),
   .left(left_st),
   .right(right_st),
   .mines(mines_latch),
   .button_num(game_enable_if.button_num),
   .explode,
   .mark_flag,
   .defuse,
   .button_ind_x_out,
   .button_ind_y_out,
   .mine_arr_easy,
   .mine_arr_medium,
   .mine_arr_hard,
   .gin(game_enable_if.in)

);


top_timer u_top_timer(
    .clk,
    .rst,
    .start(enable_game),
    .stop(tim_stop),
    .left,
    .right,
    .left_st,
    .right_st,
    .time_elapsed,
    .sec_to_count(timer_val),
    .seconds_left
 );
 
 disp_hex_mux u_disp(
    .clk(clk), 
    .reset(rst),
    .hex3({3'b0, mines_left[4]}), 
    .hex2(mines_left[3:0]), 
    .hex1(seconds_left[7:4]), 
    .hex0(seconds_left[3:0]),
    .an(an), 
    .sseg(sseg)
);


 endmodule