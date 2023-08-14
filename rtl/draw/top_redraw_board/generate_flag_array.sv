`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   generate_flag_array
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-27
 Description:  Fills 2D array with '0 and '1, where '1 means there is a flag
 */
//////////////////////////////////////////////////////////////////////////////
module generate_flag_array
    (
    input wire clk,
    input wire rst,
    input wire [1:0] level,
    input wire mark_flag,
    input wire [4:0] flag_ind_x,
    input wire [4:0] flag_ind_y,
    output logic [7:0] [7:0] flag_arr_easy,
    output logic [9:0] [9:0] flag_arr_medium,
    output logic [15:0] [15:0] flag_arr_hard
    );
   

    //Local variables


    //Module logic
    
    always_ff @(posedge clk) begin
        if (rst) begin
            flag_arr_easy <= '0;
            flag_arr_medium <= '0;
            flag_arr_hard <= '0;
        end
        else if(mark_flag && level > 0)begin
            flag_arr_hard [flag_ind_x] [flag_ind_y] <= ~flag_arr_hard [flag_ind_x] [flag_ind_y];
            flag_arr_medium [flag_ind_x] [flag_ind_y] <= ~flag_arr_medium [flag_ind_x] [flag_ind_y];
            flag_arr_easy [flag_ind_x] [flag_ind_y] <= ~flag_arr_easy [flag_ind_x] [flag_ind_y];
        end
        else begin
            flag_arr_hard [flag_ind_x] [flag_ind_y] <= flag_arr_hard [flag_ind_x] [flag_ind_y];
            flag_arr_medium [flag_ind_x] [flag_ind_y] <= flag_arr_medium [flag_ind_x] [flag_ind_y];
            flag_arr_easy [flag_ind_x] [flag_ind_y] <= flag_arr_easy [flag_ind_x] [flag_ind_y];
        end
    end
 
 endmodule
    