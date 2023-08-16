/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2 Projekt
 * Author: Piotr Kaczmarczyk
 * Modified: Wojciech Mskowicz
 * Description:
 * Vga timing controller.
 */

 `timescale 1 ns / 1 ps

 module array_timing (
     input  wire clk,
     input  wire rst,
     input  wire [1:0] level,
     input  wire [4:0] button_num, 
     input wire counting,    
     output logic [4:0] arr_x_refresh, 
     output logic [4:0] arr_y_refresh
 );


 logic [4:0] arr_x_refresh_nxt, arr_y_refresh_nxt;


 always_ff@(posedge clk) begin: array_timing_blk
    if(rst)begin
        arr_x_refresh <= '0;
        arr_y_refresh <= '0;
    end
    else begin
        arr_x_refresh <= arr_x_refresh_nxt;
        arr_y_refresh <= arr_y_refresh_nxt;
    end
 end

 always_comb begin: array_timing_comb_blk

    if(counting)begin

        if(arr_x_refresh == button_num-1 && level > 0)begin
            arr_x_refresh_nxt = '0;
        end
        else begin
            arr_x_refresh_nxt = arr_x_refresh + 1;
        end

        if(arr_x_refresh == button_num-1 && level > 0) begin
            if (arr_y_refresh==button_num-1)begin
                arr_y_refresh_nxt = '0;
            end
            else begin
                arr_y_refresh_nxt = arr_y_refresh + 1;
            end
        end
        else begin
            arr_y_refresh_nxt = arr_y_refresh;
        end

    end
    else begin
        arr_x_refresh_nxt = arr_x_refresh;
        arr_y_refresh_nxt = arr_y_refresh;
    end
end
 
 endmodule