`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   mine_check
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-23
 Description:  Checks if selected board cell is bomb or not and sends results
 */
//////////////////////////////////////////////////////////////////////////////
module mine_check
    (
    input wire clk,
    input wire rst,
    input wire [4:0] button_ind_x_in,
    input wire [4:0] button_ind_y_in,
    input wire [7:0] [7:0] array_easy_in,
    input wire [9:0] [9:0] array_medium_in,
    input wire [15:0] [15:0] array_hard_in,
    input wire flag, bomb,
    input wire [1:0] level, 


    output reg explode, mark_flag, defuse
    );


    //Local variables
    logic explode_nxt, mark_flag_nxt, defuse_nxt;


    


    
    always_ff @(posedge clk) begin
        if (rst) begin
            explode <= '0;
            mark_flag <= '0;
            defuse <= '0;
        end
        else begin
            explode <= explode_nxt;
            mark_flag <= mark_flag_nxt;
            defuse <= defuse_nxt;
        end
    end
    
    always_comb begin
        if(flag) begin        
            mark_flag_nxt = '1;
            explode_nxt = '0;
            defuse_nxt = '0;
        end
        else if(bomb) begin
            mark_flag_nxt = '0;
            if(level == 3) begin
                if(array_hard_in[button_ind_y_in] [button_ind_x_in] == '1)begin
                    explode_nxt = '1;
                    defuse_nxt = '0;
                end
                else begin
                    explode_nxt = '0;
                    defuse_nxt = '1;
                end
            end
            else if(level == 2) begin
                if(array_medium_in[button_ind_y_in] [button_ind_x_in] == '1)begin
                    explode_nxt = '1;
                    defuse_nxt = '0;
                end
                else begin
                    explode_nxt = '0;
                    defuse_nxt = '1;
                end
            end
            else begin
                if(array_easy_in[button_ind_y_in] [button_ind_x_in] == '1)begin
                    explode_nxt = '1;
                    defuse_nxt = '0;
                end
                else begin
                    explode_nxt = '0;
                    defuse_nxt = '1;
                end
            end
        end
        else begin
            mark_flag_nxt = '0;
            explode_nxt = '0;
            defuse_nxt = '0;
        end
    end
 
 endmodule
    
