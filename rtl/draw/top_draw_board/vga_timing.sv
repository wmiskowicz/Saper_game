/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2 Projekt
 * Author: Piotr Kaczmarczyk
 * Modified: Wojciech Mskowicz
 * Description:
 * Vga timing controller.
 */

 `timescale 1 ns / 1 ps

 module vga_timing (
     input  logic clk,
     input  logic rst,
     vga_if.out out
 );
 
 import vga_pkg::*;
 
 logic [10:0] hcount_nxt= 11'b0;
 logic [10:0] vcount_nxt= 11'b0;
 logic hblnk_nxt = '0;
 logic hsync_nxt = '0;
 logic vblnk_nxt = '0;
 logic vsync_nxt = '0;
 
 
 always_ff @(posedge clk) begin: ctr_blk
    if(rst) begin
        out.hblnk <= '0;
        out.hsync <= '0;
        out.vblnk <= '0;
        out.vsync <= '0;
    end
    else begin
        out.hblnk <= hblnk_nxt;
        out.hsync <= hsync_nxt;
        out.vblnk <= vblnk_nxt;
        out.vsync <= vsync_nxt;
    end
end


 
 always_ff @(posedge clk) begin: hcount_blk
    if(rst) begin
        out.hcount <= 11'b0;
    end 
    else begin 
        out.hcount <= hcount_nxt;
    end
 end
  
 always_comb begin
    if(out.hcount==HCOUNT_MAX)begin
        hcount_nxt = 11'b0;
    end
    else begin
        hcount_nxt = out.hcount + 1;
    end
 end
  


 always_ff @(posedge clk) begin: vcount_blk
    if(rst)begin
        out.vcount <= 11'b0;
    end
    else begin
        out.vcount <= vcount_nxt;
    end
 end
 
 always_comb begin
   if(out.hcount==HCOUNT_MAX) begin
       if (out.vcount==VCOUNT_MAX)begin
            vcount_nxt = 11'b0;
       end
       else begin
            vcount_nxt = out.vcount + 1;
       end
     end
   else begin
        vcount_nxt = out.vcount;
   end
 end 
 
 
 
 always_comb begin
    out.rgb = 0;
    
    if(out.hcount >= HSYNC_START && out.hcount <= HSYNC_STOP) begin
       hsync_nxt = '1;
    end
    else begin
       hsync_nxt = '0;
    end

    if(out.hcount >= HBLNK_START_FRONT && out.hcount <= HBLNK_STOP_FRONT) begin
       hblnk_nxt = '1;
    end
    else if (out.hcount >= HBLNK_START_BACK && out.hcount <= HBLNK_STOP_BACK)begin
        hblnk_nxt = '1;
    end
    else begin
        hblnk_nxt = '0;
    end

    if(out.vcount >= VBLNK_START_FRONT && out.vcount <= VBLNK_STOP_FRONT) begin
        vblnk_nxt = '1;
    end
    else if(out.vcount >= VBLNK_START_BACK && out.vcount <= VBLNK_STOP_BACK) begin
        vblnk_nxt = '1;
    end
    else begin
        vblnk_nxt = '0;
    end

    if(out.vcount >= VSYNC_START && out.vcount <= VSYNC_STOP) begin
        vsync_nxt = '1;
    end
    else begin
        vsync_nxt = '0;
    end
 end
 
 endmodule