`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   detect index // added branch1
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-20
 Coding style: safe with FPGA sync reset
 Description:  Returns button index based on mouse position
 */
//////////////////////////////////////////////////////////////////////////////
module detect_index (
    input  logic clk,
    input  logic rst,
    input wire [11:0] mouse_xpos,
    input wire [11:0] mouse_ypos,
    input wire left,
    input wire right,
    output reg bomb,
    output reg flag,
    output logic [4:0] button_index_x,
    output logic [4:0] button_index_y,
    game_set_if.in in
);

//Local variables
//logic [4:0] button_index_x_nxt, button_index_y_nxt;
logic [10:0] cur_xpos, cur_ypos, cur_xpos_nxt, cur_ypos_nxt;
logic bomb_nxt, flag_nxt;


mouse_ind_conv indx_pos(
    .clk,
    .rst,
    .cur_pos(cur_xpos),
    .button_size(in.button_size),
    .mouse_ind(button_index_x)
);

mouse_ind_conv indy_pos(
    .clk,
    .rst,
    .cur_pos(cur_ypos),
    .button_size(in.button_size),
    .mouse_ind(button_index_y)
);


always_ff @(posedge clk) begin : detect_ff_blk
    if (rst) begin
        bomb <= '0;
        flag <= '0;
        cur_ypos <= '0;
        cur_xpos <= '0;
    end else begin
        bomb <= bomb_nxt;
        flag <= flag_nxt;
        cur_ypos <= cur_ypos_nxt;
        cur_xpos <= cur_xpos_nxt;
    end
end

always_comb begin : detect_comb_blk
    cur_ypos_nxt = mouse_ypos >= in.board_ypos && mouse_ypos <= in.board_ypos + in.board_size ? mouse_ypos - in.board_ypos : 11'h7_f_f;
    cur_xpos_nxt = cur_ypos != 11'h7_f_f && mouse_xpos >= in.board_xpos && mouse_xpos <= in.board_xpos + in.board_size ? mouse_xpos - in.board_xpos :  11'h7_f_f;

    
    if(cur_xpos != 11'h7ff && cur_ypos != 11'h7ff && button_index_x <= in.button_num) begin
        

        if(left) begin
            flag_nxt = 1'b0;
            bomb_nxt = 1'b1;
        end
        else if(right) begin
            flag_nxt = 1'b1;
            bomb_nxt = 1'b0;
        end
        else begin
            flag_nxt = 1'b0;
            bomb_nxt = 1'b0;
        end  
    end
    else begin
        flag_nxt = 1'b0;
        bomb_nxt = 1'b0;
    end         
end


endmodule
