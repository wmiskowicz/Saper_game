`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   top_draw_num
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-17
 Description:  Top module for displaying numbers on board
 */
//////////////////////////////////////////////////////////////////////////////

module top_draw_num(
    input wire clk, rst,
    input wire [1:0] level,
    input wire [7:0] [7:0] [2:0] num_arr_easy,
    input wire [9:0] [9:0] [2:0] num_arr_medium,
    input wire [15:0] [15:0] [2:0] num_arr_hard,
    vga_if.in in,
    vga_if.out out,
    game_set_if.in gin
);

//Local variables

 wire [11:0] addr;
 logic [49:0] char_line_pixels;
 wire [3:0] char_x, char_y;
 wire [5:0] char_code;
 wire [5:0] char_line;

 wire [11:0] num_color;


 assign addr = {char_code, char_line};


 check_char_board u_check_char_board(
    .clk,
    .rst,
    .level,
    .num_arr_easy,
    .num_arr_medium,
    .num_arr_hard,
    .char_x,
    .char_y,
    .char_code
); 

num_font_rom u_num_font_rom(
    .clk,
    .addr,
    .num_color,
    .char_line_pixels
);


draw_char_board u_draw_char_board(
    .clk,
    .rst,
    .char_pixels(char_line_pixels),
    .char_x,
    .char_y,
    .char_line,
    .num_color,
    .in,
    .out,
    .gin
 );

endmodule