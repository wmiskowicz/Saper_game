`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   mouse_ind_conv
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-20
 Coding style: safe with FPGA sync reset
 Description:  Returns char index based on cur_pos and board parameters
 */
//////////////////////////////////////////////////////////////////////////////
module mouse_ind_conv
    (
    input wire clk,
    input wire rst,
    input wire [10:0] cur_pos,
    input wire [6:0] button_size,
    output reg [4:0] mouse_ind
    );
    
    logic [4:0] mouse_ind_nxt;
    logic [9:0] but_s2, but_s3, but_s4, but_s5, but_s6, but_s7, but_s8;
    logic [9:0] but_s9, but_s10, but_s11, but_s12, but_s13, but_s14, but_s15;

    
    always_ff @(posedge clk) begin
        if (rst) begin
            mouse_ind <= '0;
            but_s2 <= '0;
            but_s3 <= '0;
            but_s4 <= '0;
            but_s5 <= '0; 
            but_s6 <= '0;
            but_s7 <= '0; 
            but_s8 <= '0;
            but_s9 <= '0;
            but_s10 <= '0;
            but_s11 <= '0;
            but_s12 <= '0;
            but_s13 <= '0;
            but_s14 <= '0;
            but_s15 <= '0;
        end
        else begin
            mouse_ind <= mouse_ind_nxt;
            but_s2 <=  (button_size << 1);
            but_s3 <=  (button_size << 1) + button_size;
            but_s4 <=  (button_size << 2);
            but_s5 <=  (button_size << 2) + button_size; 
            but_s6 <=  (button_size << 2) + (button_size << 1); 
            but_s7 <=  (button_size << 2) + (button_size << 1) + button_size; 
            but_s8 <=  (button_size << 3);
            but_s9 <=  (button_size << 3) + button_size; 
            but_s10 <= (button_size << 3) + (button_size << 1);
            but_s11 <= (button_size << 3) + (button_size << 1) + button_size; 
            but_s12 <= (button_size << 3) + (button_size << 2);
            but_s13 <= (button_size << 3) + (button_size << 2) + button_size;
            but_s14 <= (button_size << 3) + (button_size << 2) +  + (button_size << 1);
            but_s15 <= (button_size << 3) + (button_size << 2) +  + (button_size << 1) + button_size; 
        end
    end
    
    always_comb begin
        if(cur_pos == 11'h7_f_f) begin
            mouse_ind_nxt = '0;
        end
        else if(cur_pos <= button_size)begin
            mouse_ind_nxt = 5'h1;
        end
        else if((cur_pos <= but_s2))begin
            mouse_ind_nxt = 5'h2;
        end
        else if((cur_pos <= but_s3))begin
            mouse_ind_nxt = 5'h3;
        end
        else if((cur_pos <= but_s4))begin
            mouse_ind_nxt = 5'h4;
        end
        else if((cur_pos <= but_s5))begin
            mouse_ind_nxt = 5'h5;
        end
        else if((cur_pos <= but_s6))begin
            mouse_ind_nxt = 5'h6;
        end
        else if((cur_pos <= but_s7))begin
            mouse_ind_nxt = 5'h7;
        end
        else if((cur_pos <= but_s8))begin
            mouse_ind_nxt = 5'h8;
        end
        else if((cur_pos <= but_s9))begin
            mouse_ind_nxt = 5'h9;
        end
        else if((cur_pos <= but_s10))begin
            mouse_ind_nxt = 5'ha;
        end
        else if(cur_pos <= but_s11)begin
            mouse_ind_nxt = 5'hb;
        end
        else if(cur_pos <= but_s12)begin
            mouse_ind_nxt = 5'hc;
        end
        else if(cur_pos <= but_s13)begin
            mouse_ind_nxt = 5'hd;
        end
        else if(cur_pos <= but_s14)begin
            mouse_ind_nxt = 5'he;
        end
        else if(cur_pos <= but_s15)begin
            mouse_ind_nxt = 5'hf;
        end
        else begin
            mouse_ind_nxt = 5'h10;
        end
      end

 
 endmodule
    
