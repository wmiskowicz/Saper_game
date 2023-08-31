`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   top_redraw_board
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-25
 Description:  Top module for redrawing symbols and numbers during minesweeping
 */
//////////////////////////////////////////////////////////////////////////////

 

 module top_redraw_board (
     input  wire clk,
     input  logic rst,
     input wire [1:0] level,
     input wire [4:0] symbol_ind_x,
     input wire [4:0] symbol_ind_y,
     input wire [7:0] [7:0] mine_arr_easy,
     input wire [9:0] [9:0] mine_arr_medium,
     input wire [15:0] [15:0] mine_arr_hard,
     input wire  explode, mark_flag, defuse,
     input wire [5:0] mines,
     output logic [5:0] mines_left,
     output logic explode_latched, game_won,
     game_set_if.in gin,
     vga_if.in in,
     vga_if.out out
 );

 vga_if flag_out();
 vga_if defuse_out();
 vga_if num_out();

 wire  [7:0] [7:0] flag_arr_easy, defuse_arr_easy;
 wire  [9:0] [9:0] flag_arr_medium, defuse_arr_medium;
 wire  [15:0] [15:0] flag_arr_hard, defuse_arr_hard;

 wire [7:0] [7:0] [2:0] num_arr_easy;
 wire [9:0] [9:0] [2:0] num_arr_medium;
 wire [15:0] [15:0] [2:0] num_arr_hard;

 wire mark_flag_pulse;
 wire [4:0] flag_num;
 wire [5:0] mines_hex;
 wire defuse_latched, mark_flag_latched;

 wire [4:0] mine_ind_x, mine_ind_y;

 assign mines_hex = mines > flag_num ? mines - flag_num : '0;

bin2bcd u_mine_bin2bcd(
   .bin({2'b0, mines_hex}),
   .bcd({2'b0, mines_left})
);

win_check u_win_check(
    .clk,
    .rst,
    .level,
    .mine_arr_easy,
    .mine_arr_medium,
    .mine_arr_hard,
    .flag_arr_easy,
    .flag_arr_medium,
    .flag_arr_hard,
    .game_won
    );


 edge_detector u_mark_flag_detector(
    .clk,
    .rst,
    .signal(mark_flag_latched),
    .detected(mark_flag_pulse)
 );

 draw_flag u_draw_flag(
    .clk,
    .rst,
    .level,
    .flag_arr_easy,
    .flag_arr_medium,
    .flag_arr_hard,
    .gin,
    .in(in),
    .out(flag_out)
 );

 draw_defused u_draw_defused(
    .clk,
    .rst,
    .level,
    .defuse_arr_easy,
    .defuse_arr_medium,
    .defuse_arr_hard,
    .gin,
    .in(flag_out),
    .out(defuse_out)
 );

 latch #(
   .DATA_SIZE(1)
 )
 explode_latch(
    .clk,
    .rst,
    .enable(explode),
    .Data_in(explode),
    .Data_out(explode_latched)
);

 latch ind_x_latch(
    .clk,
    .rst,
    .enable(~explode_latched),
    .Data_in(symbol_ind_x),
    .Data_out(mine_ind_x)
);

latch ind_y_latch(
    .clk,
    .rst,
    .enable(~explode_latched),
    .Data_in(symbol_ind_y),
    .Data_out(mine_ind_y)
);

latch #(
   .DATA_SIZE(1)
 )
 mark_flag_latch(
    .clk,
    .rst,
    .enable(~explode_latched),
    .Data_in(mark_flag),
    .Data_out(mark_flag_latched)
);

latch #(
   .DATA_SIZE(1)
 )
 defuse_latch(
    .clk,
    .rst,
    .enable(~explode_latched),
    .Data_in(defuse),
    .Data_out(defuse_latched)
);


 draw_mine u_draw_mine(
    .clk,
    .rst,
    .mine_ind_x,
    .mine_ind_y,
    .level,
    .explode(explode_latched),
    .button_size(gin.button_size),
    .board_xpos(gin.board_xpos),
    .board_ypos(gin.board_ypos),
    .in(num_out),
    .out(out)
 );

 top_draw_num u_top_draw_num(
    .clk, 
    .rst,
    .level,
    .num_arr_easy,
    .num_arr_medium,
    .num_arr_hard,
    .in(defuse_out),
    .out(num_out),
    .gin
);

 generate_flag_array u_generate_flag_array(
    .clk,
    .rst,
    .mark_flag(mark_flag_pulse),
    .level,
    .flag_num,
    .flag_ind_x(symbol_ind_x),
    .flag_ind_y(symbol_ind_y),
    .flag_arr_easy,
    .flag_arr_medium,
    .flag_arr_hard
 );

 generate_defuse_array u_generate_defuse_array(
    .clk,
    .rst,
    .defuse(defuse_latched),
    .level,
    .defuse_ind_x(symbol_ind_x),
    .defuse_ind_y(symbol_ind_y),
    .mine_arr_easy,
    .mine_arr_medium,
    .mine_arr_hard,
    .defuse_arr_easy,
    .defuse_arr_medium,
    .defuse_arr_hard,
    .button_num(gin.button_num)
 );

 generate_num_array u_generate_num_array(
    .clk,
    .rst,
    .level,
    .button_num(gin.button_num),
    .mine_arr_easy,
    .mine_arr_medium,
    .mine_arr_hard,
    .defuse_arr_easy,
    .defuse_arr_medium,
    .defuse_arr_hard,
    .num_arr_easy,
    .num_arr_medium,
    .num_arr_hard
   );

/*
  edge_ctr u_edge_ctr(
   .clk,
   .rst,
   .signal(mark_flag),
   .ctr_out(flag_num),
   .max(5'h1_f)
  );
*/


 endmodule