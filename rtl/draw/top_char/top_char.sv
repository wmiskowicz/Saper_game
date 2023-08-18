

module top_char(
    input wire clk, rst,
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

char_rom16x16 u_char_rom16x16(
    .clk,
    .rst,
    .char_xy,
    .char_code
); 

font_rom u_font_rom(
    .clk,
    .addr,
    .char_line_pixels
);


 draw_rect_char u_draw_rect_char(
    .clk,
    .rst,
    .char_pixels(char_line_pixels),
    .char_xy,
    .char_line,
    .in(in),
    .out(out)
 );

endmodule