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
    input wire [5:0] mines,
    input wire [4:0] dimension_size,
    output reg array [7:0] [7:0]
    );
    //Local parameters
    

    //Local variables
    int x_dim, y_dim;
    logic [4:0] x_out, y_out;
    wire done_counting;
    reg data_nxt, data_prev, random_data;
    reg [5:0] mines_ctr, mines_ctr_nxt, mines_left;

    assign mines_left = mines - mines_ctr;
    assign random_data = x_out % 2;

    

    
    always_ff @(posedge clk) begin
        if (rst) begin
            for(x_dim = 0; x_dim < 5; x_dim++) begin
                for (y_dim = 0; y_dim < 5; y_dim++) begin
                    array [x_dim] [y_dim] <= '0;
                end
            end
            mines_ctr <= '0;
        end
        else if(~done_counting) begin
            array [x_out] [y_out] <= data_nxt;
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
    
    dim_counter u_xdim_ctr(
        .clk,
        .rst,
        .dimension_size(dimension_size),
        .x_out(x_out),
        .y_out(y_out),
        .done_counting(done_counting)  
    );

    
/*
    counter u_counter(
        .clk,
        .rst,
        .counting(),
        .max(),
        .ctr_out()
    );*/

 
 endmodule
    
