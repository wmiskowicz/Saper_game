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
    output reg array_easy_out [7:0] [7:0],
    output reg array_medium_out [9:0] [9:0],
    output reg array_hard_out [15:0] [15:0]
    );
   

    //Local variables
    int x_rst, y_rst;
    logic [5:0] x_out, y_out;
    wire done_counting;
    reg data_nxt, data_prev, random_data;
    reg [5:0] mines_ctr, mines_ctr_nxt, mines_left;

    //Signal assignments
    assign mines_left = mines - mines_ctr;
    assign random_data = x_out % 2;

    //Module logic
    
    always_ff @(posedge clk) begin
        if (rst) begin
            for(x_rst = 0; x_rst < 8; x_rst++) begin
                for (y_rst = 0; y_rst < 8; y_rst++) begin
                    array_easy_out [x_rst] [y_rst] <= '0;
                end
            end
            for(x_rst = 0; x_rst < 10; x_rst++) begin
                for (y_rst = 0; y_rst < 10; y_rst++) begin
                    array_medium_out [x_rst] [y_rst] <= '0;
                end
            end
            for(x_rst = 0; x_rst < 16; x_rst++) begin
                for (y_rst = 0; y_rst < 16; y_rst++) begin
                    array_hard_out [x_rst] [y_rst] <= '0;
                end
            end
            mines_ctr <= '0;
        end
        else if(~done_counting) begin
            if(level == 3)begin
                array_hard_out [x_out] [y_out] <= data_nxt;
            end
            else if(level == 2)begin
                array_medium_out [x_out] [y_out] <= data_nxt;
            end
            else begin
                array_easy_out [x_out] [y_out] <= data_nxt;
            end
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
    
