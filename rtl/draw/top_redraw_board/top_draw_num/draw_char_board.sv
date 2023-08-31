`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_char_board
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-20
 Description:  Draws mine index of every field of board
 */
//////////////////////////////////////////////////////////////////////////////

module draw_char_board (
    input wire clk,
    input wire rst,
    input logic [49:0] char_pixels,
    output logic [3:0] char_y,
    output logic [3:0] char_x,
    output logic [5:0] char_line,
    vga_if.in in,
    vga_if.out out,
    game_set_if.in gin
);


//************LOCAL PARAMETERS*****************


logic [10:0] vcount_nxt;
logic         vsync_nxt;
logic         vblnk_nxt;
logic [10:0] hcount_nxt;
logic         hsync_nxt;
logic         hblnk_nxt;
logic [11:0]  rgb_nxt, rgb_local;
logic [49:0]  mask_one;


wire [10:0] cur_ypos, cur_xpos;
wire [5:0] char_line_ctr;
wire [5:0] char_mask;


//************ASSIGNMENTS*****************
assign cur_ypos = in.vcount >= gin.board_ypos && in.vcount <= gin.board_ypos + gin.board_size ? in.vcount - gin.board_ypos : 11'h7_f_f;
assign cur_xpos = cur_ypos != 11'h7_f_f && in.hcount >= gin.board_xpos && in.hcount <= gin.board_xpos + gin.board_size ? in.hcount - gin.board_xpos :  11'h7_f_f;

//assign char_mask = cur_xpos[5:0] <= 6'd49 ? cur_xpos[5:0] : '0;

assign mask_one = {1'b1, 49'b0};
assign char_line = cur_xpos != 11'h7_f_f ? char_line_ctr : 'x;


char_pos_conv char_xpos_conv(
    .clk,
    .rst,
    .cur_pos(cur_xpos),
    .button_size(gin.button_size),
    .button_num(gin.button_num),
    .char_line(char_mask),
    .char_pos(char_x)
);

char_pos_conv char_ypos_conv(
    .clk,
    .rst,
    .cur_pos(cur_ypos),
    .button_size(gin.button_size),
    .button_num(gin.button_num),
    .char_line(char_line_ctr),
    .char_pos(char_y)
);


delay_upel #(
    .WIDTH(38),
    .CLK_DEL(1)  
)
u_delay_upel (
    .clk,
    .rst,
    .din({in.vcount, in.vsync, in.vblnk, in.hcount, in.hsync, in.hblnk, in.rgb}),
    .dout({vcount_nxt, vsync_nxt, vblnk_nxt, hcount_nxt, hsync_nxt, hblnk_nxt, rgb_local})
);


always_ff @(posedge clk) begin : rect_blk
    if (rst) begin
        out.vcount <= '0;
        out.vsync <= '0;
        out.vblnk <= '0;
        out.hcount <= '0;
        out.hsync <= '0;
        out.hblnk <= '0;
        out.rgb <= '0;
    end else begin
        out.vcount <= vcount_nxt;
        out.vsync  <= vsync_nxt;
        out.vblnk  <= vblnk_nxt;
        out.hcount <= hcount_nxt;
        out.hsync  <= hsync_nxt;
        out.hblnk  <= hblnk_nxt;
        out.rgb <= rgb_nxt;
    end
end


always_comb begin : char_comb
    if ((char_pixels & (mask_one >> char_mask[5:0])) && cur_ypos != 11'h7_f_f && cur_xpos != 11'h7_f_f /*&& (hcount_nxt >= gin.board_xpos) && (cur_xpos < gin.board_size)
    && (vcount_nxt >= gin.board_ypos) && (cur_ypos < gin.board_size)*/) begin
        rgb_nxt = 12'h2_0_a;
    end
    else begin                             
       rgb_nxt = rgb_local;   
    end 
end


endmodule