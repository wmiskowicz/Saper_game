//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   top_timer
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-30
 Description:  Top module for timer
 */
//////////////////////////////////////////////////////////////////////////////

 `timescale 1 ns / 1 ps

 module top_timer (
    input  wire  clk,  
    input  wire  rst, 
    input  wire left, right,
    input  wire start, stop,
    input  wire  [7:0] sec_to_count,   
    output logic [7:0] seconds_left,
    output reg left_st, right_st,
    output reg time_elapsed
 );

 assign left_st = stop ? '0 : left;
 assign right_st = stop ? '0 : right;

 wire [7:0] seconds_out;


 time_controller u_time_controller(
    .clk,
    .rst,
    .start,
    .stop,
    .time_elapsed,
    .sec_to_count,
    .seconds_out
 );

 bin2bcd u_bin2bcd(
    .bin(seconds_out),
    .bcd(seconds_left)
 );
 
 endmodule