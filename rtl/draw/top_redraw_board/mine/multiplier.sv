`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   multiplier
 Author:        Wojciech Miskowicz
 Last modified: 2023-08-29
 Description:  multiplies two numbers
 */
//////////////////////////////////////////////////////////////////////////////

module multiplier (
  input wire clk,
  input wire rst,
  input wire execute,
  input wire [6:0] a_in,
  input wire [6:0] b_in,
  output logic [13:0] result,
  output logic done
);

logic [6:0] a_p;
logic [6:0] b_p;
logic [3:0] count;
logic busy;

always_ff@(posedge clk)begin
  if(rst)begin
    result <= '0;
    busy <= '0;
    a_p <= '0;
    b_p <= '0;
    count <= '0;
    done <= '0;
  end
  else begin
    if(!busy) begin
      result <= result;
      busy <= execute;
      count <= '0;
      a_p <= a_in;
      b_p <= b_in;
    end
    else begin/*
      if(b_p[0]) begin
        result <= result + a_p;
      end

      a_p <= (a_p << 1);
      b_p <= (b_p >> 1);*/
      b_p <= (b_p >> 1);
      result[13:0] <= {1'b0, result[13:1]};
      if(b_p[0] && ~done) begin
        result[13:6] <= {1'b0, result[13:7]} + a_p;
      end
      count <= count < 4'd7 ? count + 1 : count;
      busy <= count < 4'd6;
      done <= ~(count < 4'd6);
    end
  end
end



endmodule