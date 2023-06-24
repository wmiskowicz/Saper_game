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
 wire [10:0] button_xpos, button_ypos;
 wire [6:0] button_size;
 wire draw_button, done_x, done_y, enable_game, level_enable;

 wire [11:0] mouse_xpos, mouse_ypos;

 wire [4:0] button_index_x, button_index_y;
 wire bomb, flag, left, right;
 wire array [7:0] [7:0];
 wire explode, mark_flag;


 //VGA interfaces
 vga_if tim_bg_if();
 vga_if bg_rect_if();
 vga_if board_out_if();
 vga_if board_button_if();
 vga_if draw_mouse_if();

 game_set_if game_set_if();
 game_set_if game_enable_if();
 
 
 /**
  * Signals assignments
  */
 
 assign vs = draw_mouse_if.vsync;
 assign hs = draw_mouse_if.hsync;
 assign {r,g,b} = draw_mouse_if.rgb;

 assign enable_game = btnS[2] || btnS[1] || btnS[0];
 
 
 /**
  * Submodules instances
  */
 

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
    .in(game_enable_if.in),
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
     .out(board_out_if.out)
 );
 

 select_level u_select_level(
    .clk,
    .rst,
    .btnS(btnS),
    .level_enable(level_enable),
    .out(game_set_if.out)
 );

 settings_latch u_settings_latch(
    .clk,
    .rst,
    .in(game_set_if.in),
    .out(game_enable_if.out),
    .enable(level_enable)
 );

 draw_mouse u_draw_mouse(
    .in(board_out_if.in),
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

 mine_board u_mine_board(
   .clk,
   .rst,
   .mines(6'd28),
   .dimension_size(5'd8),
   .array(array)
 );

 mine_check u_mine_check(
   .clk,
   .rst,
   .button_ind_x_in(button_index_x),
   .button_ind_y_in(button_index_y),
   .flag(flag),
   .bomb(bomb),
   .array(array),
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