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


module char_rom16x16(
    input wire clk,
    input wire rst,
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
    case (char_xy)
        8'h1_0: char_code_nxt = "A";
        8'h2_0: char_code_nxt = "U";
        8'h3_0: char_code_nxt = "T";
        8'h4_0: char_code_nxt = "H";
        8'h5_0: char_code_nxt = "O";
        8'h6_0: char_code_nxt = "R";

        8'h1_1: char_code_nxt = "W";
        8'h2_1: char_code_nxt = "O";
        8'h3_1: char_code_nxt = "J";
        8'h4_1: char_code_nxt = "C";
        8'h5_1: char_code_nxt = "I";
        8'h6_1: char_code_nxt = "E";
        8'h7_1: char_code_nxt = "C";
        8'h8_1: char_code_nxt = "H";

        8'h1_2: char_code_nxt = "M";
        8'h2_2: char_code_nxt = "I";
        8'h3_2: char_code_nxt = "S";
        8'h4_2: char_code_nxt = "K";
        8'h5_2: char_code_nxt = "O";
        8'h6_2: char_code_nxt = "W";
        8'h7_2: char_code_nxt = "I";
        8'h8_2: char_code_nxt = "C";
        8'h9_2: char_code_nxt = "Z";

        8'h1_5: char_code_nxt = "L";
        8'h2_5: char_code_nxt = "E";
        8'h3_5: char_code_nxt = "V";
        8'h4_5: char_code_nxt = "E";
        8'h5_5: char_code_nxt = "L";

        8'h1_6: char_code_nxt = "B";
        8'h2_6: char_code_nxt = "T";
        8'h3_6: char_code_nxt = "N";
        8'h4_6: char_code_nxt = "L";
        8'h5_6: char_code_nxt = "-";
        8'h6_6: char_code_nxt = "E";
        8'h7_6: char_code_nxt = "A";
        8'h8_6: char_code_nxt = "S";
        8'h9_6: char_code_nxt = "Y";

        8'h1_7: char_code_nxt = "B";
        8'h2_7: char_code_nxt = "T";
        8'h3_7: char_code_nxt = "N";
        8'h4_7: char_code_nxt = "C";
        8'h5_7: char_code_nxt = "-";
        8'h6_7: char_code_nxt = "M";
        8'h7_7: char_code_nxt = "E";
        8'h8_7: char_code_nxt = "D";
        8'h9_7: char_code_nxt = "I";
        8'ha_7: char_code_nxt = "U";
        8'hb_7: char_code_nxt = "M";

        8'h1_8: char_code_nxt = "B";
        8'h2_8: char_code_nxt = "T";
        8'h3_8: char_code_nxt = "N";
        8'h4_8: char_code_nxt = "R";
        8'h5_8: char_code_nxt = "-";
        8'h6_8: char_code_nxt = "H";
        8'h7_8: char_code_nxt = "A";
        8'h8_8: char_code_nxt = "R";
        8'h9_8: char_code_nxt = "D";

        


        default: char_code_nxt = 7'h0;
    endcase

end




endmodule
