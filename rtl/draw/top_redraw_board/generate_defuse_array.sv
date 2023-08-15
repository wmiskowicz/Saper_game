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

    wire [4:0] ind_x_trans, ind_y_trans;

    assign ind_x_trans = defuse_ind_x - 1;
    assign ind_y_trans = defuse_ind_y - 1;
   

    //Module logic
    
    always_ff @(posedge clk) begin: gen_def_array_blk
        if (rst) begin
            arr_hcount_r <= '0;
            arr_hcount_l <= '0;
            arr_vcount_up <= '0;
            defuse_arr_easy <= '0;
            defuse_arr_medium <= '0;
            defuse_arr_hard <= '0;
        end
        else begin
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
    

    array_timing u_array_timing (
        .clk,
        .rst,
        .level,
        .button_num,
        .arr_x_refresh,
        .arr_y_refresh
    );
 
 endmodule
    