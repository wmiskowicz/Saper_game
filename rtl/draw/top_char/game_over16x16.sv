`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   char_rom16x16
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-05
 Coding style: safe with FPGA sync reset
 Description:  sends char codes depending on x-y position
 */
//////////////////////////////////////////////////////////////////////////////


module game_over16x16(
    input wire clk,
    input wire rst,
    input wire game_over, game_won,
    input wire [7:0] char_xy,
    output logic [6:0] char_code
);

logic [6:0] char_code_nxt;


always_ff @(posedge clk) begin: char_16x16_blk 
    if(rst)begin
        char_code <= '0;
    end
    else begin
        char_code <= char_code_nxt;
    end
end

always_comb begin
    if(game_over)begin
    case (char_xy)
            8'h1_0: char_code_nxt = "G";
            8'h2_0: char_code_nxt = "A";
            8'h3_0: char_code_nxt = "M";
            8'h4_0: char_code_nxt = "E";

            8'h1_1: char_code_nxt = "O";
            8'h2_1: char_code_nxt = "V";
            8'h3_1: char_code_nxt = "E";
            8'h4_1: char_code_nxt = "R";


            default: char_code_nxt = 7'h0;
        endcase
    end
    else if(game_won)begin
        case (char_xy)
            8'h1_0: char_code_nxt = "G";
            8'h2_0: char_code_nxt = "A";
            8'h3_0: char_code_nxt = "M";
            8'h4_0: char_code_nxt = "E";

            8'h1_1: char_code_nxt = "W";
            8'h2_1: char_code_nxt = "O";
            8'h3_1: char_code_nxt = "N";
            default: char_code_nxt = 7'h0;
        endcase
    end
    else char_code_nxt = 7'h0;

end




endmodule
