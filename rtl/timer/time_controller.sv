//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   time_controller
 Author:        Wojciech Miskowicz
 Last modified: 29-09-2023
 Coding style: safe with FPGA sync reset
 Description:  Controlls timer
 */
//////////////////////////////////////////////////////////////////////////////
 module time_controller
    (
        input  wire  clk,  
        input  wire  rst, 
        input  wire start, stop,
        input  wire  [7:0] sec_to_count,   
        output logic [7:0] seconds_out,
        output reg  time_elapsed
    );
    
    //------------------------------------------------------------------------------
    // local parameters
    //------------------------------------------------------------------------------
    localparam STATE_BITS = 3; // number of bits used for state register
    
    //------------------------------------------------------------------------------
    // local variables
    //------------------------------------------------------------------------------
    logic [27:0] sec_ctr, sec_ctr_nxt;
    logic done_ctn, done_ctn_nxt, time_elapsed_nxt;
    logic [7:0] seconds_nxt;
    
    enum logic [STATE_BITS-1 :0] {
        IDLE = 3'b000, // idle state
        COUNT = 3'b001,
        DONE = 3'b011,
        STOP = 3'b010,
        ELAPSED = 3'b110
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
            IDLE: state_nxt    = (start && sec_ctr>0 && seconds_out > 0) ? COUNT : IDLE;
            COUNT: begin 
                if(stop)begin
                    state_nxt = STOP;
                end
                else begin
                    state_nxt = sec_ctr == '0 ? DONE : COUNT;
                end
            end
            DONE: state_nxt = done_ctn ? ELAPSED : COUNT;
            STOP: state_nxt = stop ? STOP : COUNT;
            ELAPSED: state_nxt = ELAPSED;
            default: state_nxt = IDLE;
        endcase
    end
    //------------------------------------------------------------------------------
    // output register
    //------------------------------------------------------------------------------
    always_ff @(posedge clk) begin : out_reg_blk
        if(rst) begin : out_reg_rst_blk
            seconds_out <= '0;
            sec_ctr <= '0;
            done_ctn <= '0;
            time_elapsed <= '0;
        end
        else begin : out_reg_run_blk
            seconds_out <= seconds_nxt;
            sec_ctr <= sec_ctr_nxt;
            done_ctn <= done_ctn_nxt;
            time_elapsed <= time_elapsed_nxt;
        end
    end
    //------------------------------------------------------------------------------
    // output logic
    //------------------------------------------------------------------------------
    always_comb begin : out_comb_blk
        case(state_nxt)
            IDLE: begin
                sec_ctr_nxt = 28'd100000000;
                seconds_nxt = sec_to_count;
                done_ctn_nxt = '0;
                time_elapsed_nxt = '0;
            end
            COUNT: begin
                sec_ctr_nxt = sec_ctr > 0 ? sec_ctr - 1 : '0;
                seconds_nxt = seconds_out;
                done_ctn_nxt = '0;
                time_elapsed_nxt = '0;
            end
            DONE: begin
                if(seconds_out > 0)begin
                    sec_ctr_nxt = 28'd100000000;
                    seconds_nxt = seconds_out - 1;
                    done_ctn_nxt = '0;
                end 
                else begin
                    sec_ctr_nxt = '0;
                    seconds_nxt = '0;
                    done_ctn_nxt = '1;
                end
                time_elapsed_nxt = '0;
            end
            STOP: begin
                sec_ctr_nxt = sec_ctr;
                seconds_nxt = seconds_out;
                done_ctn_nxt = done_ctn;
                time_elapsed_nxt = '0;
            end
            ELAPSED: begin
                sec_ctr_nxt = '0;
                seconds_nxt = '0;
                done_ctn_nxt = '0;
                time_elapsed_nxt = '1;
            end
            default: begin
                sec_ctr_nxt = '0;
                seconds_nxt = '0;
                done_ctn_nxt = '0;
                time_elapsed_nxt = '0;
            end
        endcase
    end
    
    endmodule