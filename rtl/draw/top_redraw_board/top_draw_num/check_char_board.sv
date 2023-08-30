`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   check_char_board
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-20
 Description:  Converts given number to char
 */
//////////////////////////////////////////////////////////////////////////////

module check_char_board(
    input wire clk,
    input wire rst,
    input wire [1:0] level,
    input wire [7:0] [7:0] [2:0] num_arr_easy,
    input wire [9:0] [9:0] [2:0] num_arr_medium,
    input wire [15:0] [15:0] [2:0] num_arr_hard,
    input wire [3:0] char_x,
    input wire [3:0] char_y,
    output logic [5:0] char_code
);

logic [5:0] char_code_nxt;


always_ff @(posedge clk) begin: check_char_board_blk 
    if(rst)begin
        char_code <= 6'bx;
    end
    else begin
        char_code <= char_code_nxt;
    end
end

always_comb begin: check_char_board_comb_blk
    if(level == 3)begin
        if (num_arr_hard[char_x][char_y] == '0) begin
            char_code_nxt = '0;
        end
        else begin
            char_code_nxt = 48 + num_arr_hard[char_x][char_y];
        end
    end
    else if(level == 2)begin
        if (num_arr_medium[char_x][char_y] == '0) begin
            char_code_nxt = '0;
        end
        else begin
            char_code_nxt = 48 + num_arr_medium[char_x][char_y];
        end
    end
    else if(level == 1)begin
        if (num_arr_easy[char_x][char_y] == '0) begin
            char_code_nxt = '0;
        end
        else begin
            char_code_nxt = 48 + num_arr_easy[char_x][char_y];
        end
    end
    else begin
        char_code_nxt = '0;
    end

end




endmodule
