`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   game_over_disp
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-05
 Coding style: safe with FPGA sync reset
 Description:  displays "Game over" when game_over is high
 */
//////////////////////////////////////////////////////////////////////////////

module game_over_disp(
    input wire clk, 
    input wire rst,
    input wire game_over, game_won,
    vga_if.in in,
    vga_if.out out
);

//Local variables

 wire [10:0] addr;
 wire [7:0] char_line_pixels;
 wire [7:0] char_xy;
 wire [6:0] char_code;
 wire [3:0] char_line;

 assign addr = {char_code, char_line};

 


 game_over16x16 u_game_over16x16(
    .clk,
    .rst,
    .game_over,
    .game_won,
    .char_xy,
    .char_code
); 

font_rom u_font_rom(
    .clk,
    .addr,
    .char_line_pixels
);


 draw_rect_char#(
    .XPOS(720),
    .YPOS(450),
    .WIDTH(16)
 ) u_draw_rect_char(
    .clk,
    .rst,
    .char_pixels(char_line_pixels),
    .char_xy,
    .char_line,
    .in(in),
    .out(out)
 );

endmodule