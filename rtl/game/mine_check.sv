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
    input wire array_easy [7:0] [7:0],
    input wire array_medium [9:0] [9:0],
    input wire array_hard [15:0] [15:0],
    input wire flag, bomb,
    input wire [1:0] level, 

    output reg [4:0] button_ind_x_out,
    output reg [4:0] button_ind_y_out,
    output reg explode, mark_flag
    );
    //Local parameters

    //Local variables
    logic [4:0] button_ind_x_nxt, button_ind_y_nxt;
    logic explode_nxt, mark_flag_nxt;


    


    
    always_ff @(posedge clk) begin
        if (rst) begin
            button_ind_x_out <= '0;
            button_ind_y_out <= '0;
            explode <= '0;
            mark_flag <= '0;
        end
        else begin
            button_ind_x_out <= button_ind_x_nxt;
            button_ind_y_out <= button_ind_y_nxt;
            explode <= explode_nxt;
            mark_flag <= mark_flag_nxt;
        end
    end
    
    always_comb begin
        


        if(flag) begin
            button_ind_x_nxt = button_ind_x_in;
            button_ind_y_nxt = button_ind_y_in;
            mark_flag_nxt = '1;
            explode_nxt = '0;
        end
        else if(bomb) begin
            button_ind_x_nxt = button_ind_x_in;
            button_ind_y_nxt = button_ind_y_in;
            mark_flag_nxt = '0;
            if(level == 3) begin
                if(array_hard[button_ind_y_nxt] [button_ind_x_nxt] == '1)begin
                    explode_nxt = '1;
                end
                else begin
                    explode_nxt = '0;
                end
            end
            else if(level == 2) begin
                if(array_medium[button_ind_y_nxt] [button_ind_x_nxt] == '1)begin
                    explode_nxt = '1;
                end
                else begin
                    explode_nxt = '0;
                end
            end
            else begin
                if(array_easy[button_ind_y_nxt] [button_ind_x_nxt] == '1)begin
                    explode_nxt = '1;
                end
                else begin
                    explode_nxt = '0;
                end
            end
        end
        else begin
            button_ind_x_nxt = '0;
            button_ind_y_nxt = '0;
            mark_flag_nxt = '0;
            explode_nxt = '0;
        end
    end
 
 endmodule
    
