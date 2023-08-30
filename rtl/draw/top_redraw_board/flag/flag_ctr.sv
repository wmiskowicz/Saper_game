`timescale 1 ns / 1 ps

 module flag_ctr (
     input  wire clk,
     input  logic rst,
     input wire [1:0] level,
     input wire [4:0] button_num,
     input wire [7:0] [7:0] flag_arr_easy,
     input wire [9:0] [9:0] flag_arr_medium,
     input wire [15:0] [15:0] flag_arr_hard,
     output reg [5:0] flag_num
 );

 logic [5:0] flag_ctr;
 wire [4:0] arr_x_refresh, arr_y_refresh;

always_ff@(posedge clk) begin
    if(rst)begin
        flag_num <= '0;
        flag_ctr <= '0;
    end
    else begin
        if(arr_x_refresh == 0 && arr_y_refresh == 0) begin
            flag_num <= flag_ctr;
            flag_ctr <= '0;
        end
        else if(flag_arr_easy [arr_x_refresh][arr_x_refresh] && flag_arr_medium [arr_x_refresh][arr_x_refresh] && flag_arr_hard [arr_x_refresh][arr_x_refresh])begin
            flag_num <= flag_num;
            flag_ctr <= flag_ctr + 1;
        end
        else begin
            flag_num <= flag_num;
            flag_ctr <= flag_ctr;
        end
    end
end

array_timing u_arr_timing (
        .clk,
        .rst,
        .level,
        .counting('1),
        .button_num,
        .arr_x_refresh_prev(),
        .arr_y_refresh_prev(),        
        .arr_x_refresh,
        .arr_y_refresh
    );

 endmodule