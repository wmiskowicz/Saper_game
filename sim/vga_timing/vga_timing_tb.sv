/**
 *  Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Testbench for vga_timing module.
 */

`timescale 1 ns / 1 ps

module vga_timing_tb;

import vga_pkg::*;


/**
 *  Local parameters
 */

localparam CLK_PERIOD = 25;     // 40 MHz


/**
 * Local variables and signals
 */

logic clk;
logic rst;

wire [10:0] vcount, hcount;
wire        vsync,  hsync;
wire        vblnk,  hblnk;



/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end


/**
 * Reset generation
 */

initial begin
                       rst = 1'b0;
    #(1.25*CLK_PERIOD) rst = 1'b1;
                       rst = 1'b1;
    #(2.00*CLK_PERIOD) rst = 1'b0;
end


/**
 * Dut placement
 */

vga_timing dut(
    .clk,
    .rst,
    .out()
);

/**
 * Tasks and functions
 */

 // Here you can declare tasks with immediate assertions (assert).


//Assertions


// Here you can declare concurrent assertions (assert property).


/**
 * Main test
 */

 always_comb begin
    assert (vcount < VER_PIXELS) else $error("vcount too big");
    assert (hcount < HOR_PIXELS) else $error("hcount too big");
 end

initial begin
    @(posedge rst);
    @(negedge rst);

    wait (vsync == 1'b0);
    @(negedge vsync)
    @(negedge vsync)

    $finish;
end

endmodule
