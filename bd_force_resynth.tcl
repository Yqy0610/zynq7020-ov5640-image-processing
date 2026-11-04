# =====================================================================
# 强制重新综合：让修改后的 image_process.v 真正生效，并重新生成比特流
# 原因：模块引用的 OOC 综合是旧缓存，改动没被编进去
# 运行后请耐心等待（约 15~30 分钟），Tcl 控制台出现 "DONE" 即完成
# =====================================================================
reset_run system_image_process_video_top_0_1_synth_1
reset_run synth_1
reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
puts "==== DONE: bitstream regenerated ===="
