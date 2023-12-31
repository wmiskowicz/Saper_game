`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   mine_board
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-23
 Coding style: safe with FPGA sync reset
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
    input wire [1:0] y_inc,
    output logic [5:0] mines_ctr,
    output logic [7:0] [7:0] array_easy_out,
    output logic [9:0] [9:0] array_medium_out,
    output logic [15:0] [15:0] array_hard_out
    );
   

    //Local variables
    logic [3:0] x_out, y_out;
    logic [4:0] dimension_size_trans;
    logic [3:0] y_trans;
    wire done_counting;
    reg data_nxt, data_prev;
    reg [5:0] mines_ctr_nxt, mines_left;

    //Signal assignments
    assign mines_left = mines - mines_ctr;
    assign dimension_size_trans = dimension_size-1;

    assign y_trans = (y_out+y_inc>=0 && y_out+y_inc < dimension_size) ? y_out+y_inc : y_out;
    //Module logic
    
    always_ff @(posedge clk) begin
        if (rst) begin
            array_easy_out <= '0;
            array_medium_out <= '0;
            array_hard_out <= '0;    
            mines_ctr <= '0;
        end
        else if(~done_counting && level > 0) begin

            if(level == 3)begin
                array_hard_out [x_out] [y_trans] <= data_nxt;
            end
            else if (level == 2) begin
                array_medium_out [x_out] [y_trans] <= data_nxt;
            end
            else begin
                array_easy_out [x_out] [y_trans] <= data_nxt;
            end
            mines_ctr <= mines_ctr_nxt;
        end
    end
    
    always_comb begin
        data_prev = data_nxt; 
        if(mines_left > 0 && ~done_counting)begin
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
        .dimension_size(dimension_size_trans),
        .x_out,
        .y_out,
        .done_counting  
    );
 
 endmodule
    
