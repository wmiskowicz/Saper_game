`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   win_check
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-27
 Description:  Checks if user won the game
 */
//////////////////////////////////////////////////////////////////////////////
module win_check
    (
    input wire clk,
    input wire rst,
    input wire [1:0] level,
    input wire [7:0] [7:0] mine_arr_easy,
    input wire [9:0] [9:0] mine_arr_medium,
    input wire [15:0] [15:0] mine_arr_hard,
    input wire [7:0] [7:0] flag_arr_easy,
    input wire [9:0] [9:0] flag_arr_medium,
    input wire [15:0] [15:0] flag_arr_hard,
    output reg game_won
    );

    always_ff@(posedge clk) begin
       if(rst)begin
        game_won <= '0;
       end
       else begin
        if(level == 3)begin
            game_won <= mine_arr_hard == flag_arr_hard ? '1 : '0;
        end
        else if(level == 2)begin
            game_won <= mine_arr_medium == flag_arr_medium ? '1 : '0;
        end
        else if(level == 1)begin
            game_won <= mine_arr_easy == flag_arr_easy ? '1 : '0;
        end
        else begin
            game_won <= '0;
        end
       end
    end

endmodule