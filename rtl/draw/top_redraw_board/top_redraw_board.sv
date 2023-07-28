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

 wire flag_arr_easy [7:0] [7:0];
 wire flag_arr_medium [9:0] [9:0];
 wire flag_arr_hard [15:0] [15:0];
 wire mark_flag_pulse;

 edge_detector u_mark_flag_detector(
    .clk,
    .rst,
    .signal(mark_flag),
    .detected(mark_flag_pulse)
 );

 draw_flag u_draw_flag(
    .clk,
    .rst,
    .flag_arr_easy(flag_arr_easy),
    .flag_arr_medium(flag_arr_medium),
    .flag_arr_hard(flag_arr_hard),
    .gin(gin),
    .in(in),
    .out(out)
 );

 generate_flag_array u_generate_flag_array(
    .clk,
    .rst,
    .mark_flag(mark_flag_pulse),
    .level(level),
    .flag_ind_x(flag_ind_x),
    .flag_ind_y(flag_ind_y),
    .flag_arr_easy(flag_arr_easy),
    .flag_arr_medium(flag_arr_medium),
    .flag_arr_hard(flag_arr_hard)
 );

 


 endmodule