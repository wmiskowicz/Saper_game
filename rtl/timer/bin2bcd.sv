//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   bin2bcd
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-30
 Description:  Bin to bcd encoder
 */
//////////////////////////////////////////////////////////////////////////////


 module bin2bcd(
    input wire [7:0] bin,
    output reg [7:0] bcd
 );
 
 reg [3:0] i;

 always_comb begin
    
    bcd = '0;
    for(i=0; i<8; i++)begin
        bcd = {bcd[6:0], bin[7-i]};
        if(i < 7 && bcd[3:0] > 4) bcd[3:0] = bcd[3:0] + 3; 
        if(i < 7 && bcd[7:4] > 4) bcd[7:4] = bcd[7:4] + 3;
    end
    
 end
endmodule