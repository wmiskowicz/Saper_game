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

module top_vga_tb;


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
//logic [2:0] btnS;


/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end


/**
 * Submodules instances
 */

top_vga dut (
    .btnS(3'b100),
    .clk(clk),
    .rst(rst),
    .vs(vs),
    .hs(hs),
    .r(r),
    .g(g),
    .b(b)
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
    # 30 rst = 1'b1;
    # 30 rst = 1'b0;
    //# 3 btnS = 3'b0;
    //# 3 btnS = 3'b001;

    $display("If simulation ends before the testbench");
    $display("completes, use the menu option to run all.");
    $display("Prepare to wait a long time...");
#30
    //wait (vs == 1'b0);
    //@(negedge vs) $display("Info: negedge VS at %t",$time);
    //@(negedge vs) $display("Info: negedge VS at %t",$time);

    // End the simulation.
    $display("Simulation is over, check the waveforms.");
    $finish;
end

endmodule
