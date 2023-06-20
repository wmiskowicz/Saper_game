/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2 Projekt
 * Author: Wojciech Miskowicz
 * 
 * Description:
 * Package with vga related constants.
 */

package vga_pkg;

// Parameters for VGA Display 1440 x 900 @ 60fps using a 88.75 MHz clock;
localparam HOR_PIXELS = 1440;
localparam VER_PIXELS = 900;

localparam HCOUNT_MAX = 1599;
localparam VCOUNT_MAX = 925;



localparam HBLNK_START_FRONT = 1439;
localparam HBLNK_STOP_FRONT = 1599;

localparam HBLNK_START_BACK = 0;
localparam HBLNK_STOP_BACK = 0;

localparam HSYNC_START = 1487;
localparam HSYNC_STOP = 1518;



localparam VBLNK_START_BACK = 0;
localparam VBLNK_STOP_BACK = 16;

localparam VBLNK_START_FRONT = 900;
localparam VBLNK_STOP_FRONT = 925;


localparam VSYNC_START = 902;
localparam VSYNC_STOP = 907;



// Add VGA timing parameters here and refer to them in other modules.

endpackage
