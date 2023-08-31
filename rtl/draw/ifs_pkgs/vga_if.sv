 /**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2 Projekt
 * Author: Wojciech Miskowicz
 * 
 * Description:
 * Interface with vga signals
 */
 
 interface vga_if();
   
     logic [10:0] vcount;
     logic        vsync;
     logic        vblnk;
     logic [10:0] hcount;
     logic        hsync;
     logic        hblnk;
     logic [11:0] rgb;
     
     modport in (
         input vcount,
         input vsync,
         input vblnk,
         input hcount,
         input hsync,
         input hblnk,
         input rgb
     );
     
     modport out (
         output vcount,
         output vsync,
         output vblnk,
         output hcount,
         output hsync,
         output hblnk,
         output rgb
     );
     
 endinterface
 