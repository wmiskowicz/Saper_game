`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   defuse_field
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-27
 Coding style: simple with FPGA sync reset
 Description:  Defuses field of given xy index
 */
//////////////////////////////////////////////////////////////////////////////
module defuse_field 
    (
    input wire clk,
    input wire rst,
    input wire defuse,
    input wire [1:0] level,
    input wire [4:0] ind_x_trans,
    input wire [4:0] ind_y_trans,
    input wire [4:0] arr_x_refresh,
    input wire [4:0] arr_y_refresh,
    input wire [7:0] [7:0]   defuse_arr_easy_in,
    input wire [9:0] [9:0]   defuse_arr_medium_in,
    input wire [15:0] [15:0] defuse_arr_hard_in,
    output reg [7:0] [7:0]   defuse_arr_easy,
    output reg [9:0] [9:0]   defuse_arr_medium,
    output reg [15:0] [15:0] defuse_arr_hard 
    );
   

    //Local variables


    //Module logic
    
 always_ff @(posedge clk) begin: gen_def_array_blk
    if (rst) begin
            defuse_arr_hard <= '0;
            defuse_arr_medium <= '0;
            defuse_arr_easy <= '0;
    end
    else begin

        if(defuse)begin
            if(level == 3) begin
                defuse_arr_hard [ind_x_trans][ind_y_trans]<= '1;
            end
            else if(level == 2) begin
                defuse_arr_medium [ind_x_trans][ind_y_trans]<= '1;
            end
            else begin
                defuse_arr_easy [ind_x_trans][ind_y_trans]<= '1;
            end
        end  
        
        if(level == 3) begin
            defuse_arr_hard [arr_x_refresh] [arr_y_refresh] <= defuse_arr_hard_in [arr_x_refresh] [arr_y_refresh];
        end
        else if(level == 2) begin
            defuse_arr_medium [arr_x_refresh] [arr_y_refresh] <= defuse_arr_medium_in [arr_x_refresh] [arr_y_refresh];
        end
        else begin
            defuse_arr_easy [arr_x_refresh] [arr_y_refresh] <= defuse_arr_easy_in [arr_x_refresh] [arr_y_refresh];
        end
        
    end
 end

    
 
 endmodule
    