`timescale 1 ns / 1 ps

module draw_char_board (
    input wire clk,
    input wire rst,
    input wire [10:0] board_xpos,
    input wire [10:0] board_ypos,    
    input wire [9:0] board_size,
    input wire [6:0] button_size,
    input wire [4:0] button_num,
    input logic [15:0] char_pixels,
    output logic [4:0] char_y,
    output logic [4:0] char_x,
    output logic [4:0] char_line,
    vga_if.in in,
    vga_if.out out
);


//************LOCAL PARAMETERS*****************


logic [10:0] vcount_nxt;
logic         vsync_nxt;
logic         vblnk_nxt;
logic [10:0] hcount_nxt, hcount_nxt1;
logic         hsync_nxt;
logic         hblnk_nxt;
logic [11:0]  rgb_nxt, rgb_local;


wire [10:0] cur_ypos, cur_xpos, cur_ypos_delay, cur_xpos_delay, char_mask;


//************ASSIGNMENTS*****************
assign cur_ypos = in.vcount - board_ypos;
assign cur_xpos = in.hcount - board_xpos;

assign cur_ypos_delay = vcount_nxt - board_ypos;
assign cur_xpos_delay = hcount_nxt - board_xpos;
assign char_mask = hcount_nxt1 - board_xpos;

assign char_line = cur_ypos[4:0];


char_pos_conv char_xpos_conv(
    .clk,
    .rst,
    .cur_pos(cur_xpos),
    .button_size,
    .board_size,
    .button_num,
    .char_pos(char_x)
);

char_pos_conv char_ypos_conv(
    .clk,
    .rst,
    .cur_pos(cur_ypos),
    .button_size,
    .board_size,
    .button_num,
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

delay_upel #(
    .WIDTH(11),
    .CLK_DEL(2)  
)
u_delay_upel2 (
    .clk,
    .rst,
    .din({in.hcount}),
    .dout({hcount_nxt1})
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
    if ((char_pixels & (16'h8000 >> char_mask[3:0])) && (hcount_nxt >= board_xpos) && (cur_xpos_delay < board_size)
    && (vcount_nxt >= board_ypos) && (cur_ypos_delay < board_size)) begin
        rgb_nxt = 12'h2_0_a;
    end
    else begin                             
       rgb_nxt = rgb_local;   
    end 
end


endmodule