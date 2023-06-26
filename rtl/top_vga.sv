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
 wire [4:0] button_index_x, button_index_y;

 wire enable_game;
 wire explode, mark_flag;
 wire bomb, flag, left, right;
 wire random_data;

 wire array_easy [7:0] [7:0];
 wire array_medium [9:0] [9:0];
 wire array_hard [15:0] [15:0];
 


 //VGA interfaces
 vga_if tim_bg_if();
 vga_if bg_rect_if();
 vga_if board_out_if();
 vga_if board_button_if();
 vga_if draw_mouse_if();
 vga_if redraw_board_if();

 
 game_set_if game_enable_if();
 
 
 /**
  * Signals assignments
  */
 
 assign vs = draw_mouse_if.vsync;
 assign hs = draw_mouse_if.hsync;
 assign {r,g,b} = draw_mouse_if.rgb;

 assign enable_game = btnS[2] || btnS[1] || btnS[0];

 assign b0 = btnS [2] || btnS [0];
 assign b1 = btnS [1] || btnS [0];
 assign level = {b1, b0};
 
 
 /**
  * Submodules instances
  */

 top_draw_board u_top_draw_board (
     .clk,
     .rst,
     .enable_game(enable_game),
     .gin(game_enable_if.in),
     .out(board_out_if.out)
 );
 
 top_redraw_board u_redraw_board(
  .clk,
  .rst,
  .flag_ind_x(),
  .flag_ind_y(),
  .gin(game_enable_if.in),
  .in(board_out_if.in),
  .out(redraw_board_if.out)
 );

 top_game_setup u_top_game_setup(
    .clk,
    .rst,
    .level(level),
    .mines_out(mines_latch),
    .level_out(game_level_latch),
    .out(game_enable_if.out)
 );

 draw_mouse u_draw_mouse(
    .in(redraw_board_if.in),
    .out(draw_mouse_if.out),
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
    .setx(),
    .sety(),
    .setmax_x(),
    .setmax_y()
 );

detect_index u_detect_index(
   .clk,
   .rst,
   .mouse_xpos(mouse_xpos),
   .mouse_ypos(mouse_ypos),
   .left(left),
   .right(right),
   .button_index_x(button_index_x),
   .button_index_y(button_index_y),
   .bomb(bomb),
   .flag(flag),
   .in(game_enable_if.in)

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
   .level(game_level_latch),
   .mines(mines_latch),
   .dimension_size(game_enable_if.button_num),
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
   .level(game_level_latch),
   .array_easy_in(array_easy),
   .array_medium_in(array_medium),
   .array_hard_in(array_hard),
   .explode(explode),
   .mark_flag(mark_flag)
 );
 
 disp_hex_mux u_disp(
    .clk(clk), 
    .reset(rst),
    .hex3(button_index_x[3:0]), 
    .hex2(button_index_y[3:0]), 
    .hex1(explode), 
    .hex0(mark_flag),
    .dp_in(4'b1011), 
    .an(an), 
    .sseg(sseg)
);


 endmodule