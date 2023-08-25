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
        input  wire  done_x,
        input  wire  done_y,
        input  wire draw_board,
        output logic draw_button,
        output logic [6:0] button_size,
        output logic [10:0] button_xpos,
        output logic [10:0] button_ypos,
        game_set_if.in in
    );
    
    //------------------------------------------------------------------------------
    // local parameters
    //------------------------------------------------------------------------------
    
    localparam STATE_BITS = 2;
    //------------------------------------------------------------------------------
    // local variables
    logic [10:0] button_xpos_nxt, button_ypos_nxt;
    logic [6:0] button_size_nxt;
    logic [4:0] button_hcount_nxt, button_vcount_nxt;
    logic draw_button_nxt;

    enum logic [STATE_BITS-1 :0] {
        IDLE = 2'b00, // idle state
        DRAW = 2'b01,
        DONE = 2'b11
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
            IDLE: state_nxt = draw_board ? DRAW : IDLE;
            DRAW: state_nxt = DRAW;
            default: state_nxt = IDLE;
        endcase
    end
    //------------------------------------------------------------------------------
    // output register
    //------------------------------------------------------------------------------
    always_ff @(posedge clk) begin
        if(rst)begin
            button_size <= '0;
            button_xpos <= '0;
            button_ypos <= '0;
            draw_button <= '0;
        end
        else begin
            button_size <= button_size_nxt;
            button_xpos <= button_xpos_nxt;
            button_ypos <= button_ypos_nxt;
            draw_button <= draw_button_nxt;
        end
    end
    //------------------------------------------------------------------------------
    // output logic
    //------------------------------------------------------------------------------
    always_comb begin : out_comb_blk
        case(state_nxt)
            IDLE: begin
                if(draw_board)begin
                    draw_button_nxt = '1;
                    button_size_nxt = in.button_size;
                    button_xpos_nxt = in.board_xpos;
                    button_ypos_nxt = in.board_ypos;
                end
                else begin
                    button_size_nxt = '0;
                    button_xpos_nxt = '0;
                    button_ypos_nxt = '0;
                    draw_button_nxt = '0;   
                    if(in.board_size) begin //warning removal
                        button_xpos_nxt = '1;
                    end
                end
            end
            DRAW: begin
                draw_button_nxt = '1;
                button_size_nxt = in.button_size;
                button_xpos_nxt = in.board_xpos + button_hcount_nxt * in.button_size;
                button_ypos_nxt = in.board_ypos + button_vcount_nxt * in.button_size;
            end
            default: begin 
                button_size_nxt = '0;
                button_xpos_nxt = '0;
                button_ypos_nxt = '0;
                draw_button_nxt = '0;

            end
        endcase

    end

    edge_ctr y_counter(
    .clk,
    .rst,
    .max(in.button_num),
    .ctr_out(button_vcount_nxt),
    .signal(done_y)
 );
    edge_ctr x_counter(
    .clk,
    .rst,
    .max(in.button_num),
    .ctr_out(button_hcount_nxt),
    .signal(done_x)
 );



    
    endmodule