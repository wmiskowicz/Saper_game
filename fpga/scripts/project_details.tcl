# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# Project detiles required for generate_bitstream.tcl
# Make sure that project_name, top_module and target are correct.
# Provide paths to all the files required for synthesis and implementation.
# Depending on the file type, it should be added in the corresponding section.
# If the project does not use files of some type, leave the corresponding section commented out.

#-----------------------------------------------------#
#                   Project details                   #
#-----------------------------------------------------#
# Project name                                  -- EDIT
set project_name Saper_game

# Top module name                               -- EDIT
set top_module top_vga_basys3

# FPGA device
set target xc7a35tcpg236-1

#-----------------------------------------------------#
#                    Design sources                   #
#-----------------------------------------------------#
# Specify .xdc files location                   -- EDIT
set xdc_files {
    constraints/top_vga_basys3.xdc
    constraints/clk_wiz_0.xdc
}

# Specify SystemVerilog design files location   -- EDIT
set sv_files {
    ../rtl/draw/ifs_pkgs/vga_pkg.sv
    ../rtl/draw/ifs_pkgs/colour_pkg.sv
    ../rtl/draw/ifs_pkgs/vga_if.sv
    ../rtl/draw/top_draw_board/top_draw_board.sv
    ../rtl/draw/top_draw_board/vga_timing.sv
    ../rtl/draw/top_draw_board/draw_bg.sv
    ../rtl/draw/top_draw_board/draw_board.sv
    ../rtl/draw/top_redraw_board/top_redraw_board.sv
    ../rtl/draw/top_redraw_board/mine/draw_mine.sv
    ../rtl/draw/top_redraw_board/mine/multiplier.sv
    ../rtl/draw/top_redraw_board/flag/draw_flag.sv
    ../rtl/draw/top_redraw_board/flag/generate_flag_array.sv
    ../rtl/draw/top_redraw_board/defuse/draw_defused.sv
    ../rtl/draw/top_redraw_board/defuse/generate_defuse_array.sv
    ../rtl/draw/top_redraw_board/defuse/defuse_field.sv
    ../rtl/draw/top_redraw_board/defuse/defuse_missing.sv
    ../rtl/draw/top_redraw_board/array_timing.sv
    ../rtl/draw/top_redraw_board/top_draw_num/top_draw_num.sv 
    ../rtl/draw/top_redraw_board/top_draw_num/check_char_board.sv 
    ../rtl/draw/top_redraw_board/top_draw_num/draw_char_board.sv 
    ../rtl/draw/top_redraw_board/top_draw_num/generate_num_array.sv 
    ../rtl/draw/top_redraw_board/top_draw_num/char_pos_conv.sv 
    ../rtl/draw/top_redraw_board/top_draw_num/num_font_rom.sv
    ../rtl/draw/edge_ctr/edge_detector.sv
    ../rtl/draw/edge_ctr/edge_ctr.sv
    ../rtl/draw/edge_ctr/ts_counter.sv
    ../rtl/draw/top_char/game_over16x16.sv
    ../rtl/draw/top_char/char_rom16x16.sv
    ../rtl/draw/top_char/draw_rect_char.sv
    ../rtl/draw/top_char/game_over_disp.sv
    ../rtl/draw/top_char/top_char.sv
    ../rtl/top_vga.sv
    ../rtl/game/top_game_setup/top_game_setup.sv
    ../rtl/game/top_game_setup/select_level.sv
    ../rtl/game/top_game_setup/latch.sv
    ../rtl/game/top_game_setup/settings_latch.sv
    ../rtl/game/top_mine/top_mine.sv
    ../rtl/game/game_set_if.sv
    ../rtl/game/win_check.sv
    ../rtl/game/top_mine/detect_index.sv
    ../rtl/game/top_mine/mine_board.sv
    ../rtl/game/top_mine/mine_check.sv
    ../rtl/game/top_mine/dim_counter.sv
    ../rtl/game/top_mine/random_gen.sv
    ../rtl/game/top_mine/mouse_pos_conv.sv
    ../rtl/mouse/top_mouse.sv
    ../rtl/mouse/draw_mouse.sv
    ../rtl/timer/top_timer.sv 
    ../rtl/timer/bin2bcd.sv 
    ../rtl/timer/time_controller.sv 
    rtl/top_vga_basys3.sv
}

# Specify Verilog design files location         -- EDIT
 set verilog_files {
    rtl/clk_wiz_0_clk_wiz.v
    rtl/clk_wiz_0.v
    ../rtl/import/list_ch04_15_disp_hex_mux.v
    ../rtl/import/delay.v
    ../rtl/draw/top_char/font_rom.v
     
 }

# Specify VHDL design files location            -- EDIT
 set vhdl_files {
    ../rtl/mouse/MouseCtl.vhd
    ../rtl/mouse/MouseDisplay.vhd
    ../rtl/mouse/Ps2Interface.vhd
 }

# Specify files for a memory initialization     -- EDIT
# set mem_files {
#    path/to/file.data
# }
