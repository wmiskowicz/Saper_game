`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   generate_defuse_array
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-27
 Description:  Fills 2D array with '0 and '1, where '1 means there is a defused field
 */
//////////////////////////////////////////////////////////////////////////////
module defuse_row
    (
    input wire clk,
    input wire rst,
    input wire defuse, reset_ctr,
    input wire [4:0] button_num,
    input wire [4:0] ind_x_trans,
    input wire [4:0] ind_y_trans,
    input wire [4:0] arr_x_refresh,
    input wire [4:0] arr_y_refresh,
    input wire [7:0] [7:0] mine_arr_easy,
    input wire [9:0] [9:0] mine_arr_medium,
    input wire [15:0] [15:0] mine_arr_hard,
    output logic [7:0] [7:0] defuse_arr_easy,
    output logic [9:0] [9:0] defuse_arr_medium,
    output logic [15:0] [15:0] defuse_arr_hard,
    output reg done_row
    );
   

    //Local variables
    logic [4:0] arr_hcount_r, arr_hcount_l;
    logic done_r, done_l;

    assign done_row = done_r && done_l;
   

    //Module logic
    
    always_ff @(posedge clk) begin: gen_def_array_blk
        if (rst) begin
            arr_hcount_r <= '0;
            arr_hcount_l <= '0;
            defuse_arr_easy <= '0;
            defuse_arr_medium <= '0;
            defuse_arr_hard <= '0;
            done_l <= '0;
            done_r <= '0;
        end
        else begin
            if(defuse)begin
                
                if((~mine_arr_easy[ind_x_trans - arr_hcount_l][ind_y_trans] || ~mine_arr_medium[ind_x_trans - arr_hcount_l][ind_y_trans] 
                    || ~mine_arr_hard[ind_x_trans - arr_hcount_l][ind_y_trans]) && (ind_x_trans >= arr_hcount_l))begin

                    defuse_arr_easy[ind_x_trans - arr_hcount_l][ind_y_trans] <= '1;
                    defuse_arr_medium[ind_x_trans - arr_hcount_l][ind_y_trans] <= '1;
                    defuse_arr_hard[ind_x_trans - arr_hcount_l][ind_y_trans] <= '1;
                    arr_hcount_l <= arr_hcount_l + 1;
                    done_l <= '0;
                end
                else begin
                    done_l <= '1;
                    arr_hcount_l <= reset_ctr ? 0 : arr_hcount_l;
                end
                    

                if((~mine_arr_easy[ind_x_trans + arr_hcount_r][ind_y_trans] || ~mine_arr_medium[ind_x_trans + arr_hcount_r][ind_y_trans] 
                || ~mine_arr_hard[ind_x_trans + arr_hcount_r][ind_y_trans]) && ind_x_trans + arr_hcount_r < button_num)begin

                    defuse_arr_easy[ind_x_trans + arr_hcount_r][ind_y_trans] <= '1;
                    defuse_arr_medium[ind_x_trans + arr_hcount_r][ind_y_trans] <= '1;
                    defuse_arr_hard[ind_x_trans + arr_hcount_r][ind_y_trans] <= '1;
                    arr_hcount_r <= arr_hcount_r + 1;
                    done_r <= '0;
                end
                else begin
                    done_r <= '1;
                    arr_hcount_r <= reset_ctr ? 0 : arr_hcount_r;
                end
                
            end
            else begin
                done_l <= '0;
                done_r <= '0;
                arr_hcount_r <= '0;
                arr_hcount_l <= '0;
                defuse_arr_hard [arr_x_refresh] [arr_y_refresh] <= defuse_arr_hard [arr_x_refresh] [arr_y_refresh];
                defuse_arr_medium [arr_x_refresh] [arr_y_refresh] <= defuse_arr_medium [arr_x_refresh] [arr_y_refresh];
                defuse_arr_easy [arr_x_refresh] [arr_y_refresh] <= defuse_arr_easy [arr_x_refresh] [arr_y_refresh];
            end

        end
    end

    
 
 endmodule
    