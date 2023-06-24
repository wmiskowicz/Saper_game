//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   select level
 Author:        Wojciech Miskowicz
 Last modified: 2023-06-12
 Coding style: safe with FPGA sync reset
 Description:  Selects difficulty level
 */
//////////////////////////////////////////////////////////////////////////////
 module select_level
    (
        input  wire  clk,  
        input  wire  rst,  
        input  logic [1:0] level,
        output reg [5:0] mines_out,
        output reg level_enable,
        game_set_if.out out
    );
    
    //------------------------------------------------------------------------------
    // local parameters
    //------------------------------------------------------------------------------
    localparam STATE_BITS = 2; 

    //------------------------------------------------------------------------------
    // local variables
    //------------------------------------------------------------------------------
    logic [4:0] button_num_nxt;
    logic [5:0] mines_nxt;
    logic [9:0] board_size_nxt;
    logic [10:0] board_xpos_nxt, board_ypos_nxt;
    logic [6:0] button_size_nxt;
    logic level_enable_nxt;


    


    enum logic [STATE_BITS-1 :0] {
        IDLE = 2'b00, 
        CHOSE_LEVEL = 2'b01,
        DISABLE = 2'b11
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
            IDLE: state_nxt = level > 0 ? CHOSE_LEVEL : IDLE;
            CHOSE_LEVEL: state_nxt = DISABLE;
            DISABLE: state_nxt = DISABLE;
            default: state_nxt = IDLE;
        endcase
    end
    //------------------------------------------------------------------------------
    // output register
    //------------------------------------------------------------------------------
    always_ff @(posedge clk) begin : out_reg_blk
        if(rst) begin : out_reg_rst_blk
            mines_out <= 6'b0;
            out.button_num <= 5'b0;
            out.board_size <= 10'b0;
            out.board_xpos <= 11'b0;
            out.board_ypos <= 11'b0;
            out.button_size <= 7'b0;
            level_enable <= '0;
        end
        else begin : out_reg_run_blk
            mines_out <= mines_nxt;
            out.button_num <= button_num_nxt;
            out.board_size <= board_size_nxt;
            out.board_xpos <= board_xpos_nxt;
            out.board_ypos <= board_ypos_nxt;
            out.button_size <= button_size_nxt;
            level_enable <= level_enable_nxt;
        end
    end
    //------------------------------------------------------------------------------
    // output logic
    //------------------------------------------------------------------------------
    always_comb begin : out_comb_blk
        case(state_nxt)
            IDLE: begin
                mines_nxt = 6'b0;
                button_num_nxt = 5'b0;
                board_size_nxt = 10'b0;
                board_xpos_nxt = 11'b0;
                board_ypos_nxt = 11'b0;
                button_size_nxt = 7'b0;
                if(level > 0) begin
                    level_enable_nxt = '1;
                end
                else begin
                    level_enable_nxt = '0;
                end
            end 
            CHOSE_LEVEL: begin
                
                if(level == 3)begin
                    mines_nxt    = 6'd50;
                    button_num_nxt = 5'd16;
                    board_size_nxt = 10'd640;
                    board_xpos_nxt = 11'd400;
                    board_ypos_nxt = 11'd130;
                    button_size_nxt = 7'd40;
                end
                else if(level == 2)begin
                    mines_nxt    = 6'd20;
                    button_num_nxt = 5'd10;
                    board_size_nxt = 10'd500;
                    board_xpos_nxt = 11'd470;
                    board_ypos_nxt = 11'd200;
                    button_size_nxt = 7'd50;
                end
                else if(level == 1) begin
                    mines_nxt    = 6'd8;
                    button_num_nxt = 5'd8;
                    board_size_nxt = 10'd400;
                    board_xpos_nxt = 11'd520;
                    board_ypos_nxt = 11'd250;
                    button_size_nxt = 7'd50;
                end
                else begin
                    mines_nxt = '0;
                    button_num_nxt = '0;
                    board_size_nxt = '0;
                    board_xpos_nxt = 11'b0;
                    board_ypos_nxt = 11'b0;
                    button_size_nxt = 7'b0;
                end
                level_enable_nxt = '1;
            end
            DISABLE: begin //bypasess following signals
                level_enable_nxt = '0;
                mines_nxt = 6'b0;
                button_num_nxt = 5'b0;
                board_size_nxt = 10'b0;
                board_xpos_nxt = 11'b0;
                board_ypos_nxt = 11'b0;
                button_size_nxt = 7'b0;
            end
            default: begin 
                level_enable_nxt = '0;
                mines_nxt = 6'b0;
                button_num_nxt = 5'b0;
                board_size_nxt = 10'b0;
                board_xpos_nxt = 11'b0;
                board_ypos_nxt = 11'b0;
                button_size_nxt = 7'b0;
            end
        endcase        
    end
    
    endmodule