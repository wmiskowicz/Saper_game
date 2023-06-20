`timescale 1 ns / 1 ps

module synchr(
    input logic [11:0] rect_x_pos_in,
    input logic [11:0] rect_y_pos_in,
    input logic  clk,
    input logic rst,
    output logic [11:0] rect_x_pos_out,
    output logic [11:0] rect_y_pos_out
);

always_ff@(posedge clk)begin
    if(rst)begin
        rect_x_pos_out <= 12'b0;
        rect_y_pos_out <= 12'b0;
    end
    else begin
        rect_x_pos_out <= rect_x_pos_in;
        rect_y_pos_out <= rect_y_pos_in;
    end
end
endmodule