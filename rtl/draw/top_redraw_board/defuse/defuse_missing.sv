`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   defuse_missing
 Author:        Wojciech Miskowicz
 Last modified: 2023-07-29
 Coding style: simple with FPGA sync reset
 Description:  Defuses field if it's neighbour has been defused
 */
//////////////////////////////////////////////////////////////////////////////
module defuse_missing
    (
    input wire clk,
    input wire rst,
    input wire [1:0] level,
    input wire [4:0] arr_x_refresh, arr_y_refresh,
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
  
 
   
   
   always_ff @(posedge clk) begin : out_reg_blk
       if(rst) begin : out_reg_rst_blk
           defuse_arr_easy_out <= '0;
           defuse_arr_medium_out <= '0;
           defuse_arr_hard_out <= '0;
       end
       else begin 
           if(defuse_arr_easy_in[arr_x_refresh][arr_y_refresh] && level == 1) begin
                if(~mine_arr_easy [arr_x_refresh-1] [arr_y_refresh-1] == '1) defuse_arr_easy_out [arr_x_refresh-1] [arr_y_refresh-1] <= '1;
                //else defuse_arr_easy_out [arr_x_refresh-1] [arr_y_refresh-1] <= '0;

                if(~mine_arr_easy [arr_x_refresh] [arr_y_refresh-1] == '1) defuse_arr_easy_out [arr_x_refresh] [arr_y_refresh-1] <= '1;
                //else defuse_arr_easy_out [arr_x_refresh] [arr_y_refresh-1] <= '0;

                if(~mine_arr_easy [arr_x_refresh+1] [arr_y_refresh-1] == '1) defuse_arr_easy_out [arr_x_refresh+1] [arr_y_refresh-1] <= '1;
                //else defuse_arr_easy_out [arr_x_refresh+1] [arr_y_refresh-1] <= '0;

                if(~mine_arr_easy [arr_x_refresh-1] [arr_y_refresh] == '1) defuse_arr_easy_out [arr_x_refresh-1] [arr_y_refresh] <= '1;
                //else defuse_arr_easy_out [arr_x_refresh+1] [arr_y_refresh] <= '0;

                if(~mine_arr_easy [arr_x_refresh+1] [arr_y_refresh] == '1) defuse_arr_easy_out [arr_x_refresh+1] [arr_y_refresh] <= '1;
                //else defuse_arr_easy_out [arr_x_refresh-1] [arr_y_refresh-1] <= '0;

                if(~mine_arr_easy [arr_x_refresh-1] [arr_y_refresh+1] == '1) defuse_arr_easy_out [arr_x_refresh-1] [arr_y_refresh+1] <= '1;
                //else defuse_arr_easy_out [arr_x_refresh-1] [arr_y_refresh-1] <= '0;

                if(~mine_arr_easy [arr_x_refresh] [arr_y_refresh+1] == '1) defuse_arr_easy_out [arr_x_refresh] [arr_y_refresh+1] <= '1;
                //else defuse_arr_easy_out [arr_x_refresh-1] [arr_y_refresh-1] <= '0;

                if(~mine_arr_easy [arr_x_refresh+1] [arr_y_refresh+1] == '1) defuse_arr_easy_out [arr_x_refresh+1] [arr_y_refresh+1] <= '1;
                //else defuse_arr_easy_out [arr_x_refresh-1] [arr_y_refresh-1] <= '0;

                defuse_arr_easy_out [arr_x_refresh][arr_y_refresh] <= defuse_arr_easy_in[arr_x_refresh][arr_y_refresh];
           end

           else if(defuse_arr_medium_in[arr_x_refresh][arr_y_refresh] && level == 2) begin
                if(~mine_arr_medium [arr_x_refresh-1] [arr_y_refresh-1] == '1) defuse_arr_medium_out [arr_x_refresh-1] [arr_y_refresh-1] <= '1;
                else defuse_arr_medium_out [arr_x_refresh-1] [arr_y_refresh-1] <= defuse_arr_medium_in [arr_x_refresh-1] [arr_y_refresh-1];

                if(~mine_arr_medium [arr_x_refresh] [arr_y_refresh-1] == '1) defuse_arr_medium_out [arr_x_refresh] [arr_y_refresh-1] <= '1;
                else defuse_arr_medium_out [arr_x_refresh] [arr_y_refresh-1] <= defuse_arr_medium_in [arr_x_refresh] [arr_y_refresh-1];

                if(~mine_arr_medium [arr_x_refresh+1] [arr_y_refresh-1] == '1) defuse_arr_medium_out [arr_x_refresh+1] [arr_y_refresh-1] <= '1;
                else defuse_arr_medium_out [arr_x_refresh+1] [arr_y_refresh-1] <= defuse_arr_medium_in [arr_x_refresh+1] [arr_y_refresh-1];

                if(~mine_arr_medium [arr_x_refresh-1] [arr_y_refresh] == '1) defuse_arr_medium_out [arr_x_refresh-1] [arr_y_refresh] <= '1;
                else defuse_arr_medium_out [arr_x_refresh+1] [arr_y_refresh] <= defuse_arr_medium_in [arr_x_refresh+1] [arr_y_refresh];

                if(~mine_arr_medium [arr_x_refresh+1] [arr_y_refresh] == '1) defuse_arr_medium_out [arr_x_refresh+1] [arr_y_refresh] <= '1;
                else defuse_arr_medium_out [arr_x_refresh-1] [arr_y_refresh-1] <= defuse_arr_medium_in [arr_x_refresh-1] [arr_y_refresh-1];

                if(~mine_arr_medium [arr_x_refresh-1] [arr_y_refresh+1] == '1) defuse_arr_medium_out [arr_x_refresh-1] [arr_y_refresh+1] <= '1;
                else defuse_arr_medium_out [arr_x_refresh-1] [arr_y_refresh-1] <= defuse_arr_medium_in [arr_x_refresh-1] [arr_y_refresh-1];

                if(~mine_arr_medium [arr_x_refresh] [arr_y_refresh+1] == '1) defuse_arr_medium_out [arr_x_refresh] [arr_y_refresh+1] <= '1;
                else defuse_arr_medium_out [arr_x_refresh-1] [arr_y_refresh-1] <= defuse_arr_medium_in [arr_x_refresh-1] [arr_y_refresh-1];

                if(~mine_arr_medium [arr_x_refresh+1] [arr_y_refresh+1] == '1) defuse_arr_medium_out [arr_x_refresh+1] [arr_y_refresh+1] <= '1;
                else defuse_arr_medium_out [arr_x_refresh-1] [arr_y_refresh-1] <= defuse_arr_medium_in [arr_x_refresh-1] [arr_y_refresh-1];

                defuse_arr_medium_out [arr_x_refresh][arr_y_refresh] <= defuse_arr_medium_in[arr_x_refresh][arr_y_refresh];
           end

           else if(defuse_arr_hard_in[arr_x_refresh][arr_y_refresh] && level == 3) begin
                if(~mine_arr_hard [arr_x_refresh-1] [arr_y_refresh-1] == '1) defuse_arr_hard_out [arr_x_refresh-1] [arr_y_refresh-1] <= '1;
                //else defuse_arr_hard_out [arr_x_refresh-1] [arr_y_refresh-1] <= '0;

                if(~mine_arr_hard [arr_x_refresh] [arr_y_refresh-1] == '1) defuse_arr_hard_out [arr_x_refresh] [arr_y_refresh-1] <= '1;
                //else defuse_arr_hard_out [arr_x_refresh] [arr_y_refresh-1] <= '0;

                if(~mine_arr_hard [arr_x_refresh+1] [arr_y_refresh-1] == '1) defuse_arr_hard_out [arr_x_refresh+1] [arr_y_refresh-1] <= '1;
                //else defuse_arr_hard_out [arr_x_refresh+1] [arr_y_refresh-1] <= '0;

                if(~mine_arr_hard [arr_x_refresh-1] [arr_y_refresh] == '1) defuse_arr_hard_out [arr_x_refresh-1] [arr_y_refresh] <= '1;
                //else defuse_arr_hard_out [arr_x_refresh+1] [arr_y_refresh] <= '0;

                if(~mine_arr_hard [arr_x_refresh+1] [arr_y_refresh] == '1) defuse_arr_hard_out [arr_x_refresh+1] [arr_y_refresh] <= '1;
                //else defuse_arr_hard_out [arr_x_refresh-1] [arr_y_refresh-1] <= '0;

                if(~mine_arr_hard [arr_x_refresh-1] [arr_y_refresh+1] == '1) defuse_arr_hard_out [arr_x_refresh-1] [arr_y_refresh+1] <= '1;
                //else defuse_arr_hard_out [arr_x_refresh-1] [arr_y_refresh-1] <= '0;

                if(~mine_arr_hard [arr_x_refresh] [arr_y_refresh+1] == '1) defuse_arr_hard_out [arr_x_refresh] [arr_y_refresh+1] <= '1;
                //else defuse_arr_hard_out [arr_x_refresh-1] [arr_y_refresh-1] <= '0;

                if(~mine_arr_hard [arr_x_refresh+1] [arr_y_refresh+1] == '1) defuse_arr_hard_out [arr_x_refresh+1] [arr_y_refresh+1] <= '1;
                //else defuse_arr_hard_out [arr_x_refresh-1] [arr_y_refresh-1] <= '0;

                defuse_arr_hard_out [arr_x_refresh][arr_y_refresh] <= defuse_arr_hard_in[arr_x_refresh][arr_y_refresh];
           
           end
       end
   end
 
 endmodule
    