`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   mine_board
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-23
 Description:  Fills 2D array with '0 and '1, where '1 means there is a mine
 */
//////////////////////////////////////////////////////////////////////////////
module mine_board
    (
    input wire clk,
    input wire rst,
    input wire [1:0] level,
    input wire [5:0] mines,
    input wire [4:0] dimension_size,
    input wire random_data,
    output logic [7:0] [7:0] array_easy_out,
    output logic [9:0] [9:0] array_medium_out,
    output logic [15:0] [15:0] array_hard_out
    );
   

    //Local variables
    logic [5:0] x_out, y_out;
    wire done_counting;
    reg data_nxt, data_prev;
    reg [5:0] mines_ctr, mines_ctr_nxt, mines_left;

    //Signal assignments
    assign mines_left = mines - mines_ctr;

    //Module logic
    
    always_ff @(posedge clk) begin
        if (rst) begin
            array_easy_out <= '0;
            array_medium_out <= '0;
            array_hard_out <= '0;    
            mines_ctr <= '0;
        end
        else if(~done_counting && level > 0) begin
            array_hard_out [x_out] [y_out] <= data_nxt;
            array_medium_out [x_out] [y_out] <= data_nxt;
            array_easy_out [x_out] [y_out] <= data_nxt;
            mines_ctr <= mines_ctr_nxt;
        end
    end
    
    always_comb begin
        data_prev = data_nxt; 
        if(mines_left > 0)begin
            if(data_prev) begin
                mines_ctr_nxt = mines_ctr + 1;
            end
            else begin
                mines_ctr_nxt = mines_ctr;
            end
            data_nxt = random_data;
        end
        else begin
            mines_ctr_nxt = mines_ctr;
            data_nxt = '0;
        end
               
    end
    
    dim_counter array_dim_ctr(
        .clk,
        .rst,
        .dimension_size(dimension_size),
        .x_out(x_out),
        .y_out(y_out),
        .done_counting(done_counting)  
    );
 
 endmodule
    
