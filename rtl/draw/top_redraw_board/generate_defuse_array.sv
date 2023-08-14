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
    input wire [4:0] defuse_ind_x,
    input wire [4:0] defuse_ind_y,
    input wire [7:0] [7:0] mine_arr_easy,
    input wire [9:0] [9:0] mine_arr_medium,
    input wire [15:0] [15:0] mine_arr_hard,
    output logic [7:0] [7:0] defuse_arr_easy,
    output logic [9:0] [9:0] defuse_arr_medium,
    output logic [15:0] [15:0] defuse_arr_hard,
    game_set_if gin
    );
   

    //Local variables
    int x_rst, y_rst;
    logic [4:0] arr_hcount_r, arr_hcount_r_nxt, arr_vcount, arr_vcount_nxt;
    logic [4:0] arr_hcount_l, arr_hcount_l_nxt;
    logic [4:0] arr_x_refresh, arr_y_refresh;
    logic [4:0] arr_x_refresh_nxt, arr_y_refresh_nxt;

    logic [7:0] [7:0] defuse_arr_easy_nxt;
    logic [9:0] [9:0] defuse_arr_medium_nxt;
    logic [15:0] [15:0] defuse_arr_hard_nxt;


    //Module logic
    
    always_ff @(posedge clk) begin: gen_def_array_blk
        if (rst) begin
            arr_hcount_r <= '0;
            arr_hcount_l <= '0;
            arr_x_refresh <= '0;
            arr_y_refresh <= '0;
            arr_vcount <= '0;
            defuse_arr_easy <= '0;
            defuse_arr_medium  <= '0;
            defuse_arr_hard <= '0;
        end
        else begin
            arr_hcount_r <= arr_hcount_r_nxt;
            arr_hcount_l <= arr_hcount_l_nxt;
            arr_x_refresh <= arr_x_refresh_nxt;
            arr_y_refresh <= arr_y_refresh_nxt;
            arr_vcount <= arr_vcount_nxt;
            if (defuse_arr_easy_nxt[arr_x_refresh][arr_y_refresh] || defuse_arr_medium_nxt[arr_x_refresh][arr_y_refresh] 
                || defuse_arr_hard_nxt[arr_x_refresh][arr_y_refresh])begin
                 defuse_arr_hard [arr_x_refresh] [arr_y_refresh] <= defuse_arr_hard_nxt [arr_x_refresh] [arr_y_refresh];
                 defuse_arr_medium [arr_x_refresh] [arr_y_refresh] <= defuse_arr_medium_nxt [arr_x_refresh] [arr_y_refresh];
                 defuse_arr_easy [arr_x_refresh] [arr_y_refresh] <= defuse_arr_easy_nxt [arr_x_refresh] [arr_y_refresh];
            end 
            else begin
                defuse_arr_hard [arr_x_refresh] [arr_y_refresh] <= defuse_arr_hard [arr_x_refresh] [arr_y_refresh];
                 defuse_arr_medium [arr_x_refresh] [arr_y_refresh] <= defuse_arr_medium [arr_x_refresh] [arr_y_refresh];
                 defuse_arr_easy [arr_x_refresh] [arr_y_refresh] <= defuse_arr_easy [arr_x_refresh] [arr_y_refresh];
            end
        end
    end

    always_comb begin: gen_def_array_comb_blk
        if(defuse && level > 0)begin
            if(defuse_ind_x + arr_hcount_r <= gin.button_num)begin

                if(~mine_arr_easy[defuse_ind_x + arr_hcount_r][defuse_ind_y] || ~mine_arr_medium[defuse_ind_x + arr_hcount_r][defuse_ind_y] 
                || ~mine_arr_hard[defuse_ind_x + arr_hcount_r][defuse_ind_y])begin
                    defuse_arr_hard_nxt[defuse_ind_x + arr_hcount_r][defuse_ind_y] = '1;
                    defuse_arr_medium_nxt[defuse_ind_x + arr_hcount_r][defuse_ind_y] = '1;
                    defuse_arr_easy_nxt[defuse_ind_x + arr_hcount_r][defuse_ind_y] = '1;
                end
                else begin
                    defuse_arr_easy_nxt[defuse_ind_x + arr_hcount_r][defuse_ind_y] = '0;
                    defuse_arr_medium_nxt[defuse_ind_x + arr_hcount_r][defuse_ind_y] = '0;
                    defuse_arr_hard_nxt[defuse_ind_x + arr_hcount_r][defuse_ind_y] = '0;
                end
                    arr_hcount_r_nxt = defuse_ind_x + arr_hcount_r == gin.button_num ? 0 : arr_hcount_r+1;
            end
            else begin
                arr_hcount_r_nxt = '0;
            end
        end
        else begin
            arr_hcount_r_nxt = '0;
        end

            /*
            if(defuse_ind_x >= arr_hcount_l) begin
                if(~mine_arr_easy[defuse_ind_x - arr_hcount_l][defuse_ind_y] || ~mine_arr_medium[defuse_ind_x - arr_hcount_l][defuse_ind_y] 
                || ~mine_arr_hard[defuse_ind_x - arr_hcount_l][defuse_ind_y])begin
                    if(level == 3)begin
                        defuse_arr_hard_nxt[defuse_ind_x - arr_hcount_l][defuse_ind_y] = '1;
                    end
                    else if(level == 2)begin
                        defuse_arr_medium_nxt[defuse_ind_x - arr_hcount_l][defuse_ind_y] = '1;
                    end
                    else if (level == 1)begin
                        defuse_arr_easy_nxt[defuse_ind_x - arr_hcount_l][defuse_ind_y] = '1;
                    end
                    else begin
                        defuse_arr_easy_nxt[defuse_ind_x - arr_hcount_l][defuse_ind_y] = '0;
                        defuse_arr_medium_nxt[defuse_ind_x - arr_hcount_l][defuse_ind_y] = '0;
                        defuse_arr_hard_nxt[defuse_ind_x - arr_hcount_l][defuse_ind_y] = '0;
                    end
                    arr_hcount_l_nxt = defuse_ind_x - arr_hcount_l == 0 ? 0 : arr_hcount_l+1;
                end
                else begin
                    arr_hcount_l_nxt = '0;
                end
            end
            else begin
                arr_hcount_l_nxt = '0;
            end*/
              
    end

    always_comb begin: refresh_ctr_comb_blk
        if(arr_x_refresh == gin.button_num && level > 0)begin
            arr_x_refresh_nxt = '0;
        end
        else begin
            arr_x_refresh_nxt = arr_x_refresh + 1;
        end

        if(arr_x_refresh == gin.button_num && level > 0) begin
            if (arr_y_refresh==gin.button_num)begin
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
    