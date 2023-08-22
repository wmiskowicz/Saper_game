`timescale 1 ns / 1 ps

module check_char_board(
    input wire clk,
    input wire rst,
    input wire [1:0] level,
    input wire [7:0] [7:0] [2:0] num_arr_easy,
    input wire [9:0] [9:0] [2:0] num_arr_medium,
    input wire [15:0] [15:0] [2:0] num_arr_hard,
    input wire [4:0] char_x,
    input wire [4:0] char_y,
    output logic [6:0] char_code
);

logic [6:0] char_code_nxt;


always_ff @(posedge clk) begin: check_char_board_blk 
    if(rst)begin
        char_code <= 7'bx;
    end
    else begin
        char_code <= char_code_nxt;
    end
end

always_comb begin: check_char_board_comb_blk
    if(level == 3)begin
        case (num_arr_hard[char_x][char_y])
            3'd0: char_code_nxt = '0;
            3'd1: char_code_nxt = "1";
            3'd2: char_code_nxt = "2";
            3'd3: char_code_nxt = "3";
            3'd4: char_code_nxt = "4";
            3'd5: char_code_nxt = "5";
            3'd6: char_code_nxt = "6";
            3'd7: char_code_nxt = "7";
            3'd8: char_code_nxt = "8";
            default: char_code_nxt = '0;
        endcase
    end
    else if(level == 2)begin
        case (num_arr_medium[char_x][char_y])
            3'd0: char_code_nxt = '0;
            3'd1: char_code_nxt = "1";
            3'd2: char_code_nxt = "2";
            3'd3: char_code_nxt = "3";
            3'd4: char_code_nxt = "4";
            3'd5: char_code_nxt = "5";
            3'd6: char_code_nxt = "6";
            3'd7: char_code_nxt = "7";
            3'd8: char_code_nxt = "8";
            default: char_code_nxt = '0;
        endcase
    end
    else if(level == 1)begin
        case (num_arr_easy[char_x][char_y])
            3'd0: char_code_nxt = '0;
            3'd1: char_code_nxt = "1";
            3'd2: char_code_nxt = "2";
            3'd3: char_code_nxt = "3";
            3'd4: char_code_nxt = "4";
            3'd5: char_code_nxt = "5";
            3'd6: char_code_nxt = "6";
            3'd7: char_code_nxt = "7";
            3'd8: char_code_nxt = "8";
            default: char_code_nxt = '0;
        endcase
    end
    else begin
        char_code_nxt = '0;
    end

end




endmodule
