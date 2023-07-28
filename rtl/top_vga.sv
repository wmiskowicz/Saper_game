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
 wire [4:0] button_ind_x_out, button_ind_y_out;


 wire enable_game;
 wire explode, mark_flag;
 wire left, right;
 wire detected;
 wire [3:0] ctr_test;

 


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
  .level(game_level_latch),
  .explode(explode),
  .mark_flag(mark_flag),
  .flag_ind_x(button_ind_x_out),
  .flag_ind_y(button_ind_y_out),
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

 top_mouse u_top_mouse(
    .clk,
    .clk100MHz,
    .rst,
    .in(redraw_board_if.in),
    .out(draw_mouse_if.out),
    .mouse_xpos(mouse_xpos),
    .mouse_ypos(mouse_ypos),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .right(right),
    .left(left)
 );

top_mine u_top_mine(
   .clk,
   .rst,
   .mouse_xpos(mouse_xpos),
   .mouse_ypos(mouse_ypos),
   .level(game_level_latch),
   .left(left),
   .right(right),
   .mines(mines_latch),
   .button_num(game_enable_if.button_num),
   .explode(explode),
   .mark_flag(mark_flag),
   .button_ind_x_out(button_ind_x_out),
   .button_ind_y_out(button_ind_y_out),
   .gin(game_enable_if.in)

);

edge_detector u_edge_detector(
    .clk,
    .rst,
    .signal(mark_flag),
    .detected(detected)
 );

 ts_counter u_ts_counter(
   .clk,
   .rst,
   .counting(detected),
   .max(4'd6),
   .ctr_out(ctr_test)
 );
 
 disp_hex_mux u_disp(
    .clk(clk), 
    .reset(rst),
    .hex3(button_ind_x_out[3:0]), 
    .hex2(button_ind_y_out[3:0]), 
    .hex1(ctr_test), 
    .hex0(mark_flag),
    .dp_in(4'b1011), 
    .an(an), 
    .sseg(sseg)
);


 endmodule