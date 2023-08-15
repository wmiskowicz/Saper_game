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
    logic [4:0] arr_hcount_r, arr_hcount_l;
    logic [4:0] arr_x_refresh, arr_y_refresh;
    logic [4:0] arr_x_refresh_nxt, arr_y_refresh_nxt;

    wire [4:0] ind_x_trans, ind_y_trans;

    assign ind_x_trans = defuse_ind_x - 1;
    assign ind_y_trans = defuse_ind_y - 1;
   

    //Module logic
    
    always_ff @(posedge clk) begin: gen_def_array_blk
        if (rst) begin
            arr_hcount_r <= '0;
            arr_hcount_l <= '0;
            arr_x_refresh <= '0;
            arr_y_refresh <= '0;
            defuse_arr_easy <= '0;
            defuse_arr_medium <= '0;
            defuse_arr_hard <= '0;
        end
        else begin
            arr_x_refresh <= arr_x_refresh_nxt;
            arr_y_refresh <= arr_y_refresh_nxt;
            if(defuse && level > 0)begin
                
                if((~mine_arr_easy[ind_x_trans - arr_hcount_l][ind_y_trans] || ~mine_arr_medium[ind_x_trans - arr_hcount_l][ind_y_trans] 
                    || ~mine_arr_hard[ind_x_trans - arr_hcount_l][ind_y_trans]) && (ind_x_trans >= arr_hcount_l))begin

                    defuse_arr_easy[ind_x_trans - arr_hcount_l][ind_y_trans] <= '1;
                    defuse_arr_medium[ind_x_trans - arr_hcount_l][ind_y_trans] <= '1;
                    defuse_arr_hard[ind_x_trans - arr_hcount_l][ind_y_trans] <= '1;
                    arr_hcount_l <= ind_x_trans == arr_hcount_l ? 0 : arr_hcount_l + 1;
                end
                    

                if((~mine_arr_easy[ind_x_trans + arr_hcount_r][ind_y_trans] || ~mine_arr_medium[ind_x_trans + arr_hcount_r][ind_y_trans] 
                || ~mine_arr_hard[ind_x_trans + arr_hcount_r][ind_y_trans]) && ind_x_trans + arr_hcount_r < button_num)begin

                    defuse_arr_easy[ind_x_trans + arr_hcount_r][ind_y_trans] <= '1;
                    defuse_arr_medium[ind_x_trans + arr_hcount_r][ind_y_trans] <= '1;
                    defuse_arr_hard[ind_x_trans + arr_hcount_r][ind_y_trans] <= '1;
                    arr_hcount_r <= ind_x_trans + arr_hcount_r == button_num - 1 ? 0 : arr_hcount_r + 1;
                end
                
            end
            else begin
                arr_hcount_r <= '0;
                defuse_arr_hard [arr_x_refresh] [arr_y_refresh] <= defuse_arr_hard [arr_x_refresh] [arr_y_refresh];
                defuse_arr_medium [arr_x_refresh] [arr_y_refresh] <= defuse_arr_medium [arr_x_refresh] [arr_y_refresh];
                defuse_arr_easy [arr_x_refresh] [arr_y_refresh] <= defuse_arr_easy [arr_x_refresh] [arr_y_refresh];
            end

        end
    end

    

    always_comb begin: refresh_ctr_comb_blk
        if(arr_x_refresh == button_num && level > 0)begin
            arr_x_refresh_nxt = '0;
        end
        else begin
            arr_x_refresh_nxt = arr_x_refresh + 1;
        end

        if(arr_x_refresh == button_num && level > 0) begin
            if (arr_y_refresh==button_num)begin
                arr_y_refresh_nxt = '0;
            end
            else begin
                arr_y_refresh_nxt = arr_y_refresh + 1;
            end
          end
        else begin
            arr_y_refresh_nxt = arr_y_refresh;
        end
    end
 
 endmodule
    