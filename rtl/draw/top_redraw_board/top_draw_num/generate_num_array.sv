`timescale 1 ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   generate_num_array
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-17
 Description:  Counts mines around given field
 */
//////////////////////////////////////////////////////////////////////////////
module generate_num_array
    (
    input wire clk,
    input wire rst,
    input wire explode,
    input wire [1:0] level,
    input wire [4:0] button_num,
    input wire [7:0] [7:0] mine_arr_easy,
    input wire [9:0] [9:0] mine_arr_medium,
    input wire [15:0] [15:0] mine_arr_hard,
    input wire [7:0] [7:0] defuse_arr_easy,
    input wire [9:0] [9:0] defuse_arr_medium,
    input wire [15:0] [15:0] defuse_arr_hard,
    output logic [7:0] [7:0] [2:0] num_arr_easy,
    output logic [9:0] [9:0] [2:0] num_arr_medium,
    output logic [15:0] [15:0] [2:0] num_arr_hard
    );
   

    //Local variables
    logic [4:0] arr_hcount, arr_vcount;
    wire [4:0] arr_x_refresh, arr_y_refresh;
    logic counting;

    //------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------
localparam STATE_BITS = 3; // number of bits used for state register

//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------

wire [4:0] arr_x_refresh_prev, arr_y_refresh_prev;
logic [2:0] mine_ctr;
logic done_check;

enum logic [STATE_BITS-1 :0] {
    IDLE = 3'b000,
    COUNT = 3'b001,
    WAIT_ES = 3'b011,
    WAIT_MID = 3'b010,
    WAIT_HD = 3'b110,
    ST_5 = 3'b111,
    ST_6 = 3'b101,
    ST_7 = 3'b100
} state, state_nxt;

    //Module logic

always_ff @(posedge clk) begin : state_seq_blk
    if(rst)begin : state_seq_rst_blk
        state <= IDLE;
    end
    else begin : state_seq_run_blk
        state <= state_nxt;
    end
end
//------------------------------------------------------------------------------
// next state logic
//------------------------------------------------------------------------------
always_comb begin : state_comb_blk
    case(state)
        IDLE: state_nxt    = level > 0 ? COUNT : IDLE;
        COUNT: begin 
            if(defuse_arr_easy[arr_x_refresh_prev][arr_y_refresh_prev] && level == 1) begin
                state_nxt    = explode ? IDLE : WAIT_ES;
            end
            else if(defuse_arr_medium[arr_x_refresh][arr_y_refresh] && level == 2) begin
                state_nxt    = explode ? IDLE : WAIT_MID;
            end
            else if(defuse_arr_hard[arr_x_refresh_prev][arr_y_refresh_prev] && level == 3) begin
                state_nxt    = explode ? IDLE : WAIT_HD;
            end
            else begin
                state_nxt = explode ? IDLE : COUNT;
            end
        end
        WAIT_ES: state_nxt    = done_check ? COUNT : WAIT_ES;
        WAIT_MID: state_nxt    = done_check ? COUNT : WAIT_MID;
        WAIT_HD: state_nxt    = done_check ? COUNT : WAIT_HD;
        default: state_nxt = IDLE;
    endcase
end



//------------------------------------------------------------------------------
// output register
//------------------------------------------------------------------------------
always_ff @(posedge clk) begin : out_reg_blk
    if(rst) begin : out_reg_rst_blk
        num_arr_easy <= '0;
        num_arr_medium <= '0;
        num_arr_hard <= '0;
        arr_hcount <= '0;
        arr_vcount <= '0;
        counting <= '0;
        done_check <= '0;
        mine_ctr <= '0;
    end
    else begin : out_reg_run_blk
        case(state_nxt)
            IDLE: begin 
                num_arr_easy <= '0;
                num_arr_medium <= '0;
                num_arr_hard <= '0;
                arr_hcount <= '0;
                arr_vcount <= '0;
                counting <= '0;
                done_check <= '0;
                mine_ctr <= '0;
            end
            COUNT: begin
                arr_hcount <= '0;
                arr_vcount <= '0;
                counting <= '1;
                done_check <= '0;
                mine_ctr <= '0;
                if(level == 3) begin
                    num_arr_hard [arr_x_refresh] [arr_y_refresh] <= num_arr_hard [arr_x_refresh] [arr_y_refresh];
                    num_arr_medium [arr_x_refresh] [arr_y_refresh] <= '0;
                    num_arr_easy [arr_x_refresh] [arr_y_refresh] <= '0;
                end
                else if(level == 2) begin
                    num_arr_hard [arr_x_refresh] [arr_y_refresh] <= '0;
                    num_arr_medium [arr_x_refresh] [arr_y_refresh] <= num_arr_medium [arr_x_refresh] [arr_y_refresh];
                    num_arr_easy [arr_x_refresh] [arr_y_refresh] <= '0;
                end
                else begin
                    num_arr_hard [arr_x_refresh] [arr_y_refresh] <= '0;
                    num_arr_medium [arr_x_refresh] [arr_y_refresh] <= '0;
                    num_arr_easy [arr_x_refresh] [arr_y_refresh] <= num_arr_easy [arr_x_refresh] [arr_y_refresh];
                end
            end
            WAIT_ES: begin
                    counting <= '0;
                    if(arr_hcount <= 2)begin
    
                        if(arr_vcount <= 2)begin  
                            if(mine_arr_easy[arr_x_refresh-1+arr_hcount][arr_y_refresh-1+arr_vcount]) begin   
                                mine_ctr <= mine_ctr + 1;
                            end 
                            else begin
                                mine_ctr <= mine_ctr;
                            end
                            arr_vcount <=  arr_vcount + 1;
                            arr_hcount <= arr_hcount;
                        end
                        else begin
                            arr_vcount <= '0;
                            arr_hcount <= arr_hcount + 1; 
                        end
                        done_check <= '0;
                    end
                    else begin
                        arr_hcount <= '0;
                        arr_vcount <= '0;
                        done_check <= '1;
                        num_arr_easy [arr_x_refresh] [arr_y_refresh] <= mine_ctr;
                        mine_ctr <= '0;
                    end
                    
    
            end
            WAIT_MID: begin
                    
                counting <= '0;
                if(arr_hcount <= 2)begin
                    if(arr_vcount <= 2)begin  
                        if(mine_arr_medium[arr_x_refresh-1+arr_hcount][arr_y_refresh-1+arr_vcount]) begin   
                            mine_ctr <= mine_ctr + 1;
                        end 
                        else begin
                            mine_ctr <= mine_ctr;
                        end
                        arr_vcount <=  arr_vcount + 1;
                        arr_hcount <= arr_hcount;
                    end
                        else begin
                        arr_vcount <= '0;
                        arr_hcount <= arr_hcount + 1; 
                    end
                    done_check <= '0;
                    
                end
                else begin
                    arr_hcount <= '0;
                    arr_vcount <= '0;
                    done_check <= '1;
                    num_arr_medium [arr_x_refresh] [arr_y_refresh] <= defuse_arr_medium [arr_x_refresh] [arr_y_refresh] ? mine_ctr : '0;
                    mine_ctr <= '0;
                end
                
    
            end
            WAIT_HD: begin
                    
                counting <= '0;
                if(arr_hcount <= 2)begin
                    done_check <= '0;
    
                    if(arr_vcount <= 2)begin  
                        if(mine_arr_hard[arr_x_refresh-1+arr_hcount][arr_y_refresh-1+arr_vcount]) begin   
                            mine_ctr <= mine_ctr + 1;
                        end 
                        else begin
                            mine_ctr <= mine_ctr;
                        end
                        arr_vcount <=  arr_vcount + 1;
                        arr_hcount <= arr_hcount;
                    end
                        else begin
                        arr_vcount <= '0;
                        arr_hcount <= arr_hcount + 1; 
                    end
                    done_check <= arr_hcount == 2 ? '1 : '0;
    
                end
                else begin
                    arr_hcount <= '0;
                    arr_vcount <= '0;
                    done_check <= '1;  
                    mine_ctr <= '0;
                end
                num_arr_hard [arr_x_refresh] [arr_y_refresh] <= mine_ctr;

            end
            default: begin 
                num_arr_easy <= '0;
                num_arr_medium <= '0;
                num_arr_hard <= '0;
                mine_ctr <= '0;
                arr_hcount <= '0;
                arr_vcount <= '0;
                counting <= '0;
                done_check <= '0;
            end
        endcase
    end
end
//------------------------------------------------------------------------------
// output logic
//------------------------------------------------------------------------------
always_comb begin : out_comb_blk
    
end






    array_timing u_arr_tim_2 (
        .clk,
        .rst,
        .level,
        .counting,
        .button_num,
        .arr_x_refresh_prev,
        .arr_y_refresh_prev,        
        .arr_x_refresh,
        .arr_y_refresh
    );
 
 endmodule
    