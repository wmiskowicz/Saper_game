`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   generate_defuse_array
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-27
 Description:  Fills 2D array with '0 and '1, where '1 means there is a defused field
 */
//////////////////////////////////////////////////////////////////////////////
module defuse_column
    (
    input wire clk,
    input wire rst,
    input wire defuse, done_row,
    input wire [4:0] button_num,
    input wire [4:0] ind_y_trans,
    input wire [4:0] arr_x_refresh,
    input wire [4:0] arr_y_refresh,
    input wire [7:0] [7:0] mine_arr_easy,
    input wire [9:0] [9:0] mine_arr_medium,
    input wire [15:0] [15:0] mine_arr_hard,
    output logic reset_ctr,
    output reg [4:0] arr_vcount   
    );
   

    //Local variables
   logic [4:0] arr_vcount_up, arr_vcount_dn;
   logic done_up;

   assign arr_vcount = done_up ? arr_vcount_dn : arr_vcount_up;

    edge_detector u_reset_ctr_detector(
    .clk,
    .rst,
    .signal(done_row),
    .detected(reset_ctr)
 );
    //Module logic
    
    always_ff @(posedge clk) begin: gen_def_array_blk
        if (rst) begin
            arr_vcount_up <= '0;
            arr_vcount_dn <= '0;
        end
        else begin
           

        end
    end

    
 
 endmodule
    