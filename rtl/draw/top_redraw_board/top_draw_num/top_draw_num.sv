

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

 wire [12:0] addr;
 wire [7:0] char_line_pixels;
 wire [9:0] char_xy;
 wire [6:0] char_code;
 wire [5:0] char_line;

 assign addr = {char_code, char_line};

 check_char_board u_check_char_board(
    .clk,
    .rst,
    .level,
    .num_arr_easy,
    .num_arr_medium,
    .num_arr_hard,
    .char_xy,
    .char_code
); 

num_font_rom u_num_font_rom(
    .clk,
    .addr,
    .char_line_pixels
);


draw_char_board u_draw_char_board(
    .clk,
    .rst,
    .board_xpos(gin.board_xpos),
    .board_ypos(gin.board_ypos),
    .board_size(gin.board_size),
    .char_pixels(char_line_pixels),
    .char_xy,
    .char_line,
    .in,
    .out
 );

endmodule