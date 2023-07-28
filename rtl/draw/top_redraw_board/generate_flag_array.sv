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
    output logic flag_arr_easy [7:0] [7:0],
    output logic flag_arr_medium [9:0] [9:0],
    output logic flag_arr_hard [15:0] [15:0]
    );
   

    //Local variables
    int x_rst, y_rst;


    //Module logic
    
    always_ff @(posedge clk) begin
        if (rst) begin
            for(x_rst = 0; x_rst < 8; x_rst++) begin
                for (y_rst = 0; y_rst < 8; y_rst++) begin
                    flag_arr_easy [x_rst] [y_rst] <= '0;
                end
            end
            for(x_rst = 0; x_rst < 10; x_rst++) begin
                for (y_rst = 0; y_rst < 10; y_rst++) begin
                    flag_arr_medium [x_rst] [y_rst] <= '0;
                end
            end
            for(x_rst = 0; x_rst < 16; x_rst++) begin
                for (y_rst = 0; y_rst < 16; y_rst++) begin
                    flag_arr_hard [x_rst] [y_rst] <= '0;
                end
            end
        end
        else if(mark_flag)begin
            if(level == 3)begin
                flag_arr_hard [flag_ind_x] [flag_ind_y] <= ~flag_arr_hard [flag_ind_x] [flag_ind_y];
            end
            else if(level == 2)begin
                flag_arr_medium [flag_ind_x] [flag_ind_y] <= ~flag_arr_medium [flag_ind_x] [flag_ind_y];
            end
            else begin
                flag_arr_easy [flag_ind_x] [flag_ind_y] <= ~flag_arr_easy [flag_ind_x] [flag_ind_y];
            end
            
        end
        else begin
            flag_arr_hard [flag_ind_x] [flag_ind_y] <= flag_arr_hard [flag_ind_x] [flag_ind_y];
            flag_arr_medium [flag_ind_x] [flag_ind_y] <= flag_arr_medium [flag_ind_x] [flag_ind_y];
            flag_arr_easy [flag_ind_x] [flag_ind_y] <= flag_arr_easy [flag_ind_x] [flag_ind_y];
        end
    end
 
 endmodule
    