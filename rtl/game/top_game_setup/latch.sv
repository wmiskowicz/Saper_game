//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   latch
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-11
 Description:  Passes data when enabled
 */
//////////////////////////////////////////////////////////////////////////////
 module latch
 #(parameter
    DATA_SIZE = 5
 )
    (
        input wire clk,
        input wire rst,
        input  wire  enable,  
        input  wire  [DATA_SIZE-1:0] Data_in,  
        output reg [DATA_SIZE-1:0] Data_out 
    );


    always_ff @(posedge clk) begin
        if(rst)begin
            Data_out <= '0;
        end
        else begin
            if(enable) begin
                Data_out <= Data_in;
            end
        end
    end

    



 endmodule