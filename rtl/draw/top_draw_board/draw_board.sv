`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   Draw board
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-17
 Coding style: safe with FPGA sync reset
 Description:  Draws game board
 */
//////////////////////////////////////////////////////////////////////////////
 module draw_board
    (
        input  wire  clk,  
        input  wire  rst,  
        input  wire draw_board,
        game_set_if.in gin,
        vga_if.in in,
        vga_if.out out
    );
    
    //------------------------------------------------------------------------------
    // local parameters
    //------------------------------------------------------------------------------
    
    localparam STATE_BITS = 2;
    localparam MARGIN = 5;
    //------------------------------------------------------------------------------
    // local variables
    import colour_pkg::*;

    logic [11:0] rgb_nxt;
    logic [10:0] cur_xpos, cur_ypos;

    logic [5:0] but_xpos, but_ypos;


//************LOCAL PARAMETERS*****************


assign cur_ypos = in.vcount >= gin.board_ypos && in.vcount <= gin.board_ypos + gin.board_size ? in.vcount - gin.board_ypos : 11'h7_f_f;
assign cur_xpos = cur_ypos != 11'h7_f_f && in.hcount >= gin.board_xpos && in.hcount <= gin.board_xpos + gin.board_size + gin.button_num ? in.hcount - gin.board_xpos :  11'h7_f_f;

    enum logic [STATE_BITS-1 :0] {
        IDLE = 2'b00, // idle state
        DRAW = 2'b01,
        DONE = 2'b11
    } state, state_nxt;

    char_pos_conv ind_xpos(
    .clk,
    .rst,
    .cur_pos(cur_xpos),
    .button_size(gin.button_size),
    .button_num(gin.button_num),
    .char_line(but_xpos),
    .char_pos()
);

char_pos_conv ind_ypos(
    .clk,
    .rst,
    .cur_pos(cur_ypos),
    .button_size(gin.button_size),
    .button_num(gin.button_num),
    .char_line(but_ypos),
    .char_pos()
);
     
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
            IDLE: state_nxt = draw_board ? DRAW : IDLE;
            DRAW: state_nxt = DRAW;
            default: state_nxt = IDLE;
        endcase
    end
    //------------------------------------------------------------------------------
    // output register
    //------------------------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (rst) begin
            out.vcount <= '0;
            out.vsync <= '0;
            out.vblnk <= '0;
            out.hcount <= '0;
            out.hsync <= '0;
            out.hblnk <= '0;
            out.rgb <= '0;
        end else begin
            out.vcount <= in.vcount;
            out.vsync <= in.vsync;
            out.vblnk <= in.vblnk;
            out.hcount <= in.hcount;
            out.hsync <= in.hsync;
            out.hblnk <= in.hblnk;
            out.rgb <= rgb_nxt;
        end
    end
    //------------------------------------------------------------------------------
    // output logic
    //------------------------------------------------------------------------------
    always_comb begin : out_comb_blk
        case(state_nxt)
            IDLE: rgb_nxt = in.rgb;
            DRAW: begin
                if (but_xpos >= MARGIN && but_xpos <= gin.button_size-MARGIN && but_ypos >= MARGIN && but_ypos <= gin.button_size-MARGIN &&
                cur_xpos != 11'h7_f_f && cur_ypos != 11'h7_f_f) begin
                    rgb_nxt = BUTTON_BACK;
                end
                else if (cur_xpos != 11'h7_f_f && cur_ypos != 11'h7_f_f)begin//(but_xpos >= 0 && but_xpos < gin.button_size && but_ypos >= 0 && but_ypos < gin.button_size) begin
                    if(but_xpos >= but_ypos) begin
                        rgb_nxt = BUTTON_WHITE;
                    end
                    else begin
                        rgb_nxt = BUTTON_GRAY;
                    end
                end
                else begin                                 
                    rgb_nxt = in.rgb;
                end
            end
            default: rgb_nxt = in.rgb;
        endcase

    end
    
    endmodule