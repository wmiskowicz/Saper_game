`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   generate_num_array
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-17
 Description:  Counts mines around given field
 */
//////////////////////////////////////////////////////////////////////////////
module generate_num_array
    (
    input wire clk,
    input wire rst,
    input wire [1:0] level,
    input wire [4:0] button_num,
    input wire [7:0] [7:0] mine_arr_easy,
    input wire [9:0] [9:0] mine_arr_medium,
    input wire [15:0] [15:0] mine_arr_hard,
    input wire [7:0] [7:0] defuse_arr_easy,
    input wire [9:0] [9:0] defuse_arr_medium,
    input wire [15:0] [15:0] defuse_arr_hard,
    output logic [7:0] [7:0] [2:0] num_arr_easy,
    output logic [9:0] [9:0] [2:0] num_arr_medium,
    output logic [15:0] [15:0] [2:0] num_arr_hard
    );
   

    //Local variables
 wire [4:0] arr_x_refresh_prev, arr_y_refresh_prev;
  

 logic ul, um, ur;
 logic ml,     mr;
 logic ll, lm, lr;

 //wire [4:0] arr_x_refresh_prev_prev, arr_y_refresh_prev_prev;
 logic [2:0] mine_ctr;



always_ff @(posedge clk) begin : out_reg_blk
    if(rst) begin : out_reg_rst_blk
        num_arr_easy <= '0;
        num_arr_medium <= '0;
        num_arr_hard <= '0;
        mine_ctr <= '0;
        {ul, um, ur, ml, mr, ll, lm, lr} <= '0;
    end
    else begin 
        if(defuse_arr_easy[arr_x_refresh_prev][arr_y_refresh_prev] && level == 1) begin
            if(mine_arr_easy [arr_x_refresh_prev-1] [arr_y_refresh_prev-1] == '1) ul <= '1;
            else ul <= '0;
            if(mine_arr_easy [arr_x_refresh_prev]   [arr_y_refresh_prev-1] == '1) um <= '1;
            else um <= '0;
            if(mine_arr_easy [arr_x_refresh_prev+1] [arr_y_refresh_prev-1] == '1) ur <= '1;
            else ur <= '0;
            if(mine_arr_easy [arr_x_refresh_prev-1] [arr_y_refresh_prev]   == '1) ml <= '1;
            else ml <= '0;
            if(mine_arr_easy [arr_x_refresh_prev+1] [arr_y_refresh_prev]   == '1) mr <= '1;
            else mr <= '0;
            if(mine_arr_easy [arr_x_refresh_prev-1] [arr_y_refresh_prev+1] == '1) ll <= '1;
            else ll <= '0;
            if(mine_arr_easy [arr_x_refresh_prev]   [arr_y_refresh_prev+1] == '1) lm <= '1;
            else lm <= '0;
            if(mine_arr_easy [arr_x_refresh_prev+1] [arr_y_refresh_prev+1] == '1) lr <= '1;
            else lr <= '0;
        end
        else if(defuse_arr_medium[arr_x_refresh_prev][arr_y_refresh_prev] && level == 2) begin
            if(mine_arr_medium [arr_x_refresh_prev-1] [arr_y_refresh_prev-1] == '1) ul <= '1;
            else ul <= '0;
            if(mine_arr_medium [arr_x_refresh_prev]   [arr_y_refresh_prev-1] == '1) um <= '1;
            else um <= '0;
            if(mine_arr_medium [arr_x_refresh_prev+1] [arr_y_refresh_prev-1] == '1) ur <= '1;
            else ur <= '0;
            if(mine_arr_medium [arr_x_refresh_prev-1] [arr_y_refresh_prev]   == '1) ml <= '1;
            else ml <= '0;
            if(mine_arr_medium [arr_x_refresh_prev+1] [arr_y_refresh_prev]   == '1) mr <= '1;
            else mr <= '0;
            if(mine_arr_medium [arr_x_refresh_prev-1] [arr_y_refresh_prev+1] == '1) ll <= '1;
            else ll <= '0;
            if(mine_arr_medium [arr_x_refresh_prev]   [arr_y_refresh_prev+1] == '1) lm <= '1;
            else lm <= '0;
            if(mine_arr_medium [arr_x_refresh_prev+1] [arr_y_refresh_prev+1] == '1) lr <= '1;
            else lr <= '0;
        end
        else if(defuse_arr_hard[arr_x_refresh_prev][arr_y_refresh_prev] && level == 3) begin
            if(mine_arr_hard [arr_x_refresh_prev-1] [arr_y_refresh_prev-1] == '1) ul <= '1;
            else ul <= '0;
            if(mine_arr_hard [arr_x_refresh_prev]   [arr_y_refresh_prev-1] == '1) um <= '1;
            else um <= '0;
            if(mine_arr_hard [arr_x_refresh_prev+1] [arr_y_refresh_prev-1] == '1) ur <= '1;
            else ur <= '0;
            if(mine_arr_hard [arr_x_refresh_prev-1] [arr_y_refresh_prev]   == '1) ml <= '1;
            else ml <= '0;
            if(mine_arr_hard [arr_x_refresh_prev+1] [arr_y_refresh_prev]   == '1) mr <= '1;
            else mr <= '0;
            if(mine_arr_hard [arr_x_refresh_prev-1] [arr_y_refresh_prev+1] == '1) ll <= '1;
            else ll <= '0;
            if(mine_arr_hard [arr_x_refresh_prev]   [arr_y_refresh_prev+1] == '1) lm <= '1;
            else lm <= '0;
            if(mine_arr_hard [arr_x_refresh_prev+1] [arr_y_refresh_prev+1] == '1) lr <= '1;
            else lr <= '0;
        end
        else begin
            {ul, um, ur, ml, mr, ll, lm, lr} <= '0;
        end
        mine_ctr <= ul + um + ur + ml + mr + ll + lm + lr;
        if(level == 1 && ~mine_arr_easy[arr_x_refresh_prev][arr_y_refresh_prev]) num_arr_easy [arr_x_refresh_prev][arr_y_refresh_prev] <= mine_ctr;
        else if (level == 2 && ~mine_arr_easy[arr_x_refresh_prev][arr_y_refresh_prev]) num_arr_medium [arr_x_refresh_prev][arr_y_refresh_prev] <= mine_ctr;
        else if (level == 3 && ~mine_arr_easy[arr_x_refresh_prev][arr_y_refresh_prev]) num_arr_hard [arr_x_refresh_prev][arr_y_refresh_prev] <= mine_ctr;
        else begin
            num_arr_easy [arr_x_refresh_prev][arr_y_refresh_prev] <= '0;
            num_arr_medium [arr_x_refresh_prev][arr_y_refresh_prev] <= '0;
            num_arr_hard [arr_x_refresh_prev][arr_y_refresh_prev] <= '0;
        end
    end
end

    array_timing u_arr_tim_num (
        .clk,
        .rst,
        .level,
        .counting('1),
        .button_num,
        .arr_x_refresh_prev,
        .arr_y_refresh_prev,        
        .arr_x_refresh(),
        .arr_y_refresh()
    );
 
 endmodule
    