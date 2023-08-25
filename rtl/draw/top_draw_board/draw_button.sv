`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw button
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-17
 Coding style: safe with FPGA sync reset
 Description:  Draws singular button
 */
//////////////////////////////////////////////////////////////////////////////
 module draw_button
    (
        input  wire  clk,  
        input  wire  rst,   
        input  wire  [6:0] button_size, 
        input  wire [10:0] rect_xpos,
        input  wire [10:0] rect_ypos,
        input  wire draw_button,
        output logic done_x,
        output logic done_y,
        vga_if.in in,
        vga_if.out out
    );

    import colour_pkg::*;
    //------------------------------------------------------------------------------
    // local parameters
    //------------------------------------------------------------------------------
    localparam STATE_BITS = 2; // number of bits used for state register
    localparam MARGIN = 5; 
    
    //------------------------------------------------------------------------------
    // local variables
    //------------------------------------------------------------------------------
    logic [10:0] cur_xpos, cur_ypos;
    logic done_x_nxt, done_y_nxt;
    logic [11:0]  rgb_nxt;

    assign cur_xpos = in.hcount - rect_xpos;
    assign cur_ypos = in.vcount - rect_ypos;
    
    enum logic [STATE_BITS-1 :0] {
        IDLE = 2'b00,
        DRAW = 2'b01
    } state, state_nxt;
    
    //------------------------------------------------------------------------------
    // state sequential with synchronous reset
    //------------------------------------------------------------------------------
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
            IDLE: state_nxt    = draw_button ? DRAW : IDLE;
            DRAW: state_nxt    =  DRAW;
            default: state_nxt = IDLE;
        endcase
    end
    //------------------------------------------------------------------------------
    // output register
    //------------------------------------------------------------------------------
    always_ff @(posedge clk) begin : out_reg_blk
        if(rst) begin : out_reg_rst_blk
            out.vcount <= '0;
            out.vsync <= '0;
            out.vblnk <= '0;
            out.hcount <= '0;
            out.hsync <= '0;
            out.hblnk <= '0;
            out.rgb <= '0;
            done_x <= '0;
            done_y <= '0;
        end else begin
            out.vcount <= in.vcount;
            out.vsync  <= in.vsync;
            out.vblnk  <= in.vblnk;
            out.hcount <= in.hcount;
            out.hsync  <= in.hsync;
            out.hblnk  <= in.hblnk;
            out.rgb <= rgb_nxt;
            done_x <= done_x_nxt;
            done_y <= done_y_nxt;
        end
    end
    //------------------------------------------------------------------------------
    // output logic
    //------------------------------------------------------------------------------
    always_comb begin : out_comb_blk
        case(state_nxt)
            IDLE: begin
                rgb_nxt = in.rgb;
                done_x_nxt = '0;
                done_y_nxt = '0;
            end
            DRAW: begin
                if ((in.hcount >=(1+MARGIN+rect_xpos)) && (in.hcount < (1+rect_xpos+button_size-MARGIN)) && (in.vcount >= (MARGIN+rect_ypos)) && (in.vcount<(rect_ypos-MARGIN+button_size))) begin
                    rgb_nxt = BUTTON_BACK;
                end
                else if ((in.hcount >=(1+rect_xpos)) && (in.hcount < (1+rect_xpos+button_size)) && (in.vcount >=rect_ypos) && (in.vcount<(rect_ypos+button_size))) begin
                    if(cur_xpos >= cur_ypos) begin
                        rgb_nxt = BUTTON_WHITE;
                    end
                    else begin
                        rgb_nxt = BUTTON_GRAY;
                    end
                end
                else begin                                 
                    rgb_nxt = in.rgb;
                end

                
                if(cur_xpos == button_size) begin
                    done_x_nxt = '1;
                end
                else begin
                    done_x_nxt = '0;
                end

                if(cur_ypos == button_size)begin
                    done_y_nxt = '1;
                end
                else begin
                    done_y_nxt = '0;
                end
                
            end
            default: begin 
                rgb_nxt = in.rgb; 
                done_x_nxt = '0;
                done_y_nxt = '0;
            end
        endcase
    end
    

    endmodule