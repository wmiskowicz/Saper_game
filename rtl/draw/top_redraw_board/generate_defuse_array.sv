`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   generate_defuse_array
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-27
 Description:  Fills 2D array with '0 and '1, where '1 means there is a defused field
 */
//////////////////////////////////////////////////////////////////////////////
module generate_defuse_array
    (
    input wire clk,
    input wire rst,
    input wire [1:0] level,
    input wire defuse,
    input wire [4:0] button_num,
    input wire [4:0] defuse_ind_x,
    input wire [4:0] defuse_ind_y,
    input wire [7:0] [7:0] mine_arr_easy,
    input wire [9:0] [9:0] mine_arr_medium,
    input wire [15:0] [15:0] mine_arr_hard,
    output logic [7:0] [7:0] defuse_arr_easy,
    output logic [9:0] [9:0] defuse_arr_medium,
    output logic [15:0] [15:0] defuse_arr_hard
    );
   

    //Local variables
    logic [4:0] arr_hcount_r, arr_vcount_up;
    logic [4:0] arr_hcount_l;
    wire [4:0] arr_x_refresh, arr_y_refresh;
    logic [7:0] [7:0] defuse_arr_easy_mid;
    logic [9:0] [9:0] defuse_arr_medium_mid;
    logic [15:0] [15:0] defuse_arr_hard_mid;

    wire [4:0] ind_x_trans, ind_y_trans;

    assign ind_x_trans = defuse_ind_x - 1;
    assign ind_y_trans = defuse_ind_y - 1;

    assign defuse_arr_easy_mid = defuse_arr_easy;
    assign defuse_arr_medium_mid = defuse_arr_medium;
    assign defuse_arr_hard_mid = defuse_arr_hard;    
   

    //Module logic

   defuse_missing u_defuse_missing(
    .clk,
    .rst,
    .level,
    .defuse,
    .button_num,
    .ind_x_trans,
    .ind_y_trans,
    .mine_arr_easy,
    .mine_arr_medium,
    .mine_arr_hard,
    .defuse_arr_easy_in(defuse_arr_easy_mid),
    .defuse_arr_medium_in(defuse_arr_medium_mid),
    .defuse_arr_hard_in(defuse_arr_hard_mid),
    .defuse_arr_easy_out(defuse_arr_easy),
    .defuse_arr_medium_out(defuse_arr_medium),
    .defuse_arr_hard_out(defuse_arr_hard)
   );


 
 endmodule
    