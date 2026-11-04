# 把 image_process_video_top 的 key 从常量 1 改成外部引脚 key
# 在 Vivado 打开工程后：Tools -> Run Tcl Script... -> 选择本文件
open_bd_design [get_files system.bd]

# 删掉之前接的常量 1
if {[get_bd_cells -quiet key_const] ne ""} {
    delete_bd_objs [get_bd_cells key_const]
}

# 把 key 做成外部输入端口
if {[get_bd_ports -quiet key] eq ""} {
    create_bd_port -dir I key
}
connect_bd_net [get_bd_pins image_process_video_top_0/key] [get_bd_ports key]

save_bd_design
puts "key 端口已创建。请重新生成 wrapper，并确认 XDC 已加 L20 约束。"
