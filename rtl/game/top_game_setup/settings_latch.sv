 `timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   latch
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-11
 Description:  Passes settings when enabled
 */
//////////////////////////////////////////////////////////////////////////////
 module settings_latch
       (
           input wire clk,
           input wire rst,
           input  wire  enable,  
           game_set_if in,
           game_set_if out
       );
   
   
       always_ff @(posedge clk or posedge rst) begin
           if(rst)begin
                out.button_num <= 5'b0;
                out.board_size <= 10'b0;
                out.board_xpos <= 11'b0;
                out.board_ypos <= 11'b0;
                out.button_size <= 7'b0;
           end
           else begin
               if(enable) begin
                    out.button_num <= in.button_num;
                    out.board_size <= in.board_size;
                    out.board_xpos <= in.board_xpos;
                    out.board_ypos <= in.board_ypos;
                    out.button_size <= in.button_size;
               end
           end
       end
   
       
   
   
   
    endmodule