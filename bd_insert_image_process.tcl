# =====================================================================
# 在 ov5640_hdmi 工程的 system BD 里插入 image_process_video_top
# 【自愈版】可重复运行：先清掉旧的残留，再重建，避免"already connected"报错
# =====================================================================
open_bd_design [get_files system.bd]

# ---- 0) 清场：删掉可能残留的模块、常量和旧网线 ----
delete_bd_objs [get_bd_cells -quiet image_process_video_top_0]
delete_bd_objs [get_bd_cells -quiet key_const]

delete_bd_objs [get_bd_intf_nets -quiet ov5640_capture_data_1_vid_rgb]
delete_bd_objs [get_bd_nets -quiet ov5640_capture_data_1_vid_ce]

# 动态断开采集侧和 v_vid_in 侧残留的视频网线（不依赖网名）
foreach p {vid_data vid_active_video vid_vsync} {
    set n1 [get_bd_nets -quiet -of_objects [get_bd_pins ov5640_capture_data_0/${p}]]
    if {$n1 ne ""} { delete_bd_objs $n1 }
    set n2 [get_bd_nets -quiet -of_objects [get_bd_pins v_vid_in_axi4s_0/${p}]]
    if {$n2 ne ""} { delete_bd_objs $n2 }
}

# ---- 1) 例化模块 ----
create_bd_cell -type module -reference image_process_video_top image_process_video_top_0

# ---- 2) 采集 -> 模块 ----
connect_bd_net [get_bd_pins ov5640_capture_data_0/vid_data]         [get_bd_pins image_process_video_top_0/vid_data_in]
connect_bd_net [get_bd_pins ov5640_capture_data_0/vid_active_video] [get_bd_pins image_process_video_top_0/vid_active_video_in]
connect_bd_net [get_bd_pins ov5640_capture_data_0/vid_vsync]        [get_bd_pins image_process_video_top_0/vid_vsync_in]
connect_bd_net [get_bd_pins ov5640_capture_data_0/vid_ce]           [get_bd_pins image_process_video_top_0/vid_ce_in]
connect_bd_net [get_bd_pins ov5640_capture_data_0/vid_clk]          [get_bd_pins image_process_video_top_0/clk]

# ---- 3) 模块 -> v_vid_in ----
connect_bd_net [get_bd_pins image_process_video_top_0/vid_data_out]         [get_bd_pins v_vid_in_axi4s_0/vid_data]
connect_bd_net [get_bd_pins image_process_video_top_0/vid_active_video_out] [get_bd_pins v_vid_in_axi4s_0/vid_active_video]
connect_bd_net [get_bd_pins image_process_video_top_0/vid_vsync_out]        [get_bd_pins v_vid_in_axi4s_0/vid_vsync]
connect_bd_net [get_bd_pins image_process_video_top_0/vid_ce_out]           [get_bd_pins v_vid_in_axi4s_0/vid_io_in_ce]

# ---- 4) 复位：接采集模块的 rst_n 那根线（clk_wiz_0/locked） ----
connect_bd_net [get_bd_pins ov5640_capture_data_0/rst_n] [get_bd_pins image_process_video_top_0/rst_n]

# ---- 5) key 先接常量 1'b1 ----
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 key_const
set_property -dict [list CONFIG.CONST_WIDTH {1} CONFIG.CONST_VAL {1}] [get_bd_cells key_const]
connect_bd_net [get_bd_pins key_const/dout] [get_bd_pins image_process_video_top_0/key]

# ---- 6) 校验并保存 ----
validate_bd_design
save_bd_design

puts "==== 完成：模块已插入并连线，BD 已保存 ===="
