/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2 Projekt
 * Author: Wojciech Miskowicz
 * 
 * Description:
 * Package with color constants.
 */

 package colour_pkg;

    // Parameters for drawing board, and button elements
    localparam [11:0] RED = 12'hf_0_0; 
    localparam [11:0] BLACK = 12'h1_1_1;
    
    localparam [11:0] BUTTON_BACK = 12'hd_d_d;
    localparam [11:0] BUTTON_WHITE = 12'hf_f_f;
    localparam [11:0] BUTTON_GRAY = 12'h5_5_5;

    localparam [11:0] NUM_1 = 12'h1_1_b;
    localparam [11:0] NUM_2 = 12'h0_a_6;
    localparam [11:0] NUM_3 = 12'h5_5_5;
    localparam [11:0] NUM_4 = 12'h4_1_3;
    localparam [11:0] NUM_5 = 12'h0_2_3;
    localparam [11:0] NUM_6 = 12'h9_9_9;
    localparam [11:0] NUM_7 = 12'ha_5_1;
    localparam [11:0] NUM_DEFAULT = 12'h0;
    
    endpackage
    