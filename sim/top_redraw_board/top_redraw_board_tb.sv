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
 * Testbench for top_vga.
 * Thanks to the tiff_writer module, an expected image
 * produced by the project is exported to a tif file.
 * Since the vs signal is connected to the go input of
 * the tiff_writer, the first (top-left) pixel of the tif
 * will not correspond to the vga project (0,0) pixel.
 * The active image (not blanked space) in the tif file
 * will be shifted down by the number of lines equal to
 * the difference between VER_SYNC_START and VER_TOTAL_TIME.
 */

`timescale 1 ns / 1 ps

module top_redraw_board_tb;


/**
 *  Local parameters
 */

localparam CLK_PERIOD = 11;     // 40 MHz


/**
 * Local variables and signals
 */

logic clk, rst;
wire vs, hs;
wire [3:0] r, g, b;
int i, k;

logic [7:0] [7:0] mine_arr_easy;
logic [9:0] [9:0] mine_arr_medium;
logic [15:0] [15:0] mine_arr_hard;


initial begin
    for(i=0;i<10;i=i+2)begin
        mine_arr_medium[i] = 10'h3ff;
        mine_arr_medium[i+1] = 10'h0;
    end

    for(k=1;k<8;k++)begin
        mine_arr_easy[k] = 8'h0;
    end
    mine_arr_easy[0] = 8'hff;
    //mine_arr_easy[7] = 8'hff;
end

logic [1:0] level = 2'b01;
logic explode;

vga_if out_if();
vga_if in_if();
game_set_if tb_game_set_if();



/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

assign {r,g,b} = out_if.rgb;

/**
 * Submodules instances
 */

top_redraw_board dut (
     .clk,
     .rst,
     .level,
     .symbol_ind_x(5'd2),
     .symbol_ind_y(5'd2),
     .mine_arr_easy,
     .mine_arr_medium,
     .mine_arr_hard,
     .explode, 
     .mark_flag('0), 
     .defuse('1),
     .gin(tb_game_set_if),
     .in(in_if),
     .out(out_if)
);

top_draw_board u_top_draw_board (
    .clk,
    .rst,
    .enable_game('1),
    .gin(tb_game_set_if),
    .out(in_if)
);


top_game_setup u_top_game_setup(
    .clk,
    .rst,
    .level,
    .out(tb_game_set_if)
);

tiff_writer #(
    .XDIM(16'd1600),
    .YDIM(16'd926),
    .FILE_DIR("../../results")
) u_tiff_writer (
    .clk(clk),
    .r({r,r}), // fabricate an 8-bit value
    .g({g,g}), // fabricate an 8-bit value
    .b({b,b}), // fabricate an 8-bit value
    .go(vs)
);


//Main test
//task vcount_max


//assert (vcount < VER_PIXELS) else $error("vcount too big");
//endtask

initial begin
    rst = 1'b0;
    explode = 1'b0;
    # 30 rst = 1'b1;
    # 30 rst = 1'b0;
    # 50 explode = 1'b1;
    //# 3 btnS = 3'b001;

    $display("If simulation ends before the testbench");
    $display("completes, use the menu option to run all.");
    $display("Prepare to wait a long time...");

    # 300000 //wait (clk == 1'b1);
    @(negedge clk) $display("Info: negedge VS at %t",$time);
    @(negedge clk) $display("Info: negedge VS at %t",$time);

    // End the simulation.
    $display("Simulation is over, check the waveforms.");
    $finish;
end

endmodule
