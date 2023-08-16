`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   generate_defuse_array
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-27
 Description:  Fills 2D array with '0 and '1, where '1 means there is a defused field
 */
//////////////////////////////////////////////////////////////////////////////
module defuse_missing
    (
    input wire clk,
    input wire rst,
    input wire defuse,
    input wire [1:0] level,
    input wire [4:0] button_num,
    input wire [4:0] ind_x_trans,
    input wire [4:0] ind_y_trans,
    input wire [7:0] [7:0] mine_arr_easy,
    input wire [9:0] [9:0] mine_arr_medium,
    input wire [15:0] [15:0] mine_arr_hard,
    input wire [7:0] [7:0] defuse_arr_easy_in,
    input wire [9:0] [9:0] defuse_arr_medium_in,
    input wire [15:0] [15:0] defuse_arr_hard_in,
    output logic [7:0] [7:0] defuse_arr_easy_out,
    output logic [9:0] [9:0] defuse_arr_medium_out,
    output logic [15:0] [15:0] defuse_arr_hard_out
    );
   

    //Local variables
    logic [4:0] arr_hcount, arr_vcount;
    wire [4:0] arr_x_refresh, arr_y_refresh;
    logic increment_x, increment_y, counting;

    //Module logic
    
    always_ff @(posedge clk) begin: gen_def_array_blk
        if (rst) begin
            defuse_arr_easy_out <= '0;
            defuse_arr_medium_out <= '0;
            defuse_arr_hard_out <= '0;
            arr_hcount <= '0;
            arr_vcount <= '0;
            increment_x <= '0;
            increment_y <= '0;
            counting <= '0;
        end
        else begin

            if(defuse)begin
                defuse_arr_easy_out [ind_x_trans][ind_y_trans]<= '1;
                defuse_arr_medium_out [ind_x_trans][ind_y_trans]<= '1;
                defuse_arr_hard_out [ind_x_trans][ind_y_trans]<= '1;
            end
                
            if(defuse_arr_easy_in[arr_x_refresh][arr_y_refresh]/* || defuse_arr_medium_in[arr_x_refresh][arr_y_refresh] 
                || defuse_arr_hard_in[arr_x_refresh][arr_y_refresh]*/)begin
                    
                    if(arr_hcount <= 2)begin
                        increment_x <= '0;
                        increment_y <= '0;
                        counting <= '0;
                        if(arr_vcount <= 2)begin

                            if(~mine_arr_easy[arr_x_refresh-1+arr_hcount][arr_y_refresh-1+arr_vcount] 
                            || ~mine_arr_medium[arr_x_refresh-1+arr_hcount][arr_y_refresh-1+arr_vcount] 
                            || ~mine_arr_hard[arr_x_refresh-1+arr_hcount][arr_y_refresh-1+arr_vcount])begin

                                defuse_arr_easy_out [arr_x_refresh-1+arr_hcount][arr_y_refresh-1+arr_vcount]<= '1;
                                defuse_arr_medium_out [arr_x_refresh-1+arr_hcount][arr_y_refresh-1+arr_vcount]<= '1;
                                defuse_arr_hard_out [arr_x_refresh-1+arr_hcount][arr_y_refresh-1+arr_vcount]<= '1;
                             end
                             

                        arr_vcount <= arr_vcount + 1;
                        end
                        else begin
                            arr_vcount <= '0;
                            arr_hcount <= arr_hcount + 1;
                        end
                    end
                    else begin
                        counting <= '1;
                        increment_x <= '1;
                        increment_y <= '1;
                        arr_hcount <= '0;
                        arr_vcount <= '0;
                    end
            end
            else begin
                defuse_arr_easy_out [arr_x_refresh][arr_y_refresh]<= defuse_arr_easy_in [arr_x_refresh][arr_y_refresh];
                defuse_arr_medium_out [arr_x_refresh][arr_y_refresh]<= defuse_arr_medium_in [arr_x_refresh][arr_y_refresh];
                defuse_arr_hard_out [arr_x_refresh][arr_y_refresh]<= defuse_arr_hard_in [arr_x_refresh][arr_y_refresh];

                arr_vcount <= '0;
                arr_hcount <= '0;
                counting <= defuse_arr_easy_out[arr_x_refresh+1][arr_y_refresh] ? '0 : '1;
                increment_x <= '1;
                increment_y <= '1;   
            end

            
            
        end
    end

    array_timing u_arr_tim_2 (
        .clk,
        .rst,
        .level,
        .counting,
        .button_num,
        .arr_x_refresh,
        .arr_y_refresh
    );
 
 endmodule
    