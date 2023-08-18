`timescale 1 ns / 1 ps

module draw_char_board (
    input  logic clk,
    input  logic rst,
    input wire [10:0] board_xpos,
    input wire [10:0] board_ypos,    
    input wire [9:0] board_size,
    input logic [7:0] char_pixels,
    output  logic [9:0] char_xy,
    output  logic [3:0] char_line,
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


wire [10:0] char_ypos, char_xpos, char_ypos_delay, char_xpos_delay, char_mask;


//************ASSIGNMENTS*****************
assign char_ypos = in.vcount - board_ypos;
assign char_xpos = in.hcount - board_xpos;

assign char_ypos_delay = vcount_nxt - board_ypos;
assign char_xpos_delay = hcount_nxt - board_xpos;
assign char_mask = hcount_nxt1 - board_xpos;

assign char_line = char_ypos[3:0];
assign char_xy = {char_xpos[7:3], char_ypos[8:4]};


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
    if ((char_pixels & (8'b10000000 >> char_mask[2:0])) && (hcount_nxt >= board_xpos) && (char_xpos_delay < board_size)
    && (vcount_nxt >= board_ypos) && (char_ypos_delay < board_size)) begin
        rgb_nxt = 12'h2_0_a;
    end
    else begin                             
       rgb_nxt = rgb_local;   
    end           
end


endmodule