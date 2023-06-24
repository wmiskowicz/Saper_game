`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   Counter
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-17
 Description:  Counts to wanted value when posedge on 'counting' detected
 */
//////////////////////////////////////////////////////////////////////////////
module dim_counter#(
    parameter DATA_SIZE = 5
)
    (
    input wire clk,
    input wire rst,
    input wire [4:0] dimension_size,
    
    output reg [DATA_SIZE-1:0] x_out, y_out,
    output reg done_counting
    );

    logic [4:0] y_nxt, x_nxt;
  
    
    always_ff @(posedge clk) begin
        if (rst) begin
            x_out <= '0;
            y_out <= '0;
            
        end
        else begin
            x_out <= x_nxt;
            y_out <= y_nxt;
        end
    end

    always_comb begin
        if(dimension_size > 0) begin
            if(x_out == dimension_size) begin
                if (y_out == dimension_size)begin
                    x_nxt = x_out;
                    y_nxt = y_out;
                    done_counting = '1;
                end
                else begin
                    y_nxt = y_out + 1;
                    x_nxt = '0;
                    done_counting = '0;
                end
            end
            else begin
                x_nxt = x_out + 1;
                y_nxt = y_out;
                done_counting = '0;
            end
        end
        else begin
            x_nxt = '0;
            y_nxt = '0;
            done_counting = '1;
        end

    end
 
 endmodule
    
