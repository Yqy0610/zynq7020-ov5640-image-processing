`timescale 1ns / 1ps
// =====================================================================
// image_process_video_top : 原生视频域插入壳
//   串在 ov5640_capture_data_0 与 v_vid_in_axi4s_0 之间，
//   只处理原生视频信号，不碰 AXIS。
//   关键：vid_data / vid_ce / vid_active_video / vid_vsync 四路
//        必须同延迟（本设计固定 1 拍）。
// =====================================================================
module image_process_video_top #(
    parameter [7:0] THRESH    = 8'd100,
    parameter [1:0] MODE_INIT = 2'd0
)(
    input  wire        clk,                  // vid_clk = cam_pclk (72MHz)
    input  wire        rst_n,                // 与采集模块 rst_n 同源 (clk_wiz_0/locked)
    input  wire [23:0] vid_data_in,          // 采集模块 vid_data
    input  wire        vid_active_video_in,  // 采集模块 vid_active_video
    input  wire        vid_vsync_in,         // 采集模块 vid_vsync
    input  wire        vid_ce_in,            // 采集模块 vid_ce
    input  wire        key,                  // 按键（低有效）
    output wire [23:0] vid_data_out,
    output wire        vid_active_video_out,
    output wire        vid_vsync_out,
    output wire        vid_ce_out
);

    // 像素处理（1 拍）
    image_process #(
        .THRESH    (THRESH),
        .MODE_INIT (MODE_INIT)
    ) u_image_process (
        .clk     (clk),
        .rst_n   (rst_n),
        .rgb_in  (vid_data_in),
        .de_in   (vid_ce_in),
        .key     (key),
        .rgb_out (vid_data_out),
        .de_out  (vid_ce_out)
    );

    // 行/场同步与像素同延迟：1 拍
    reg av_d1, vsync_d1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            av_d1    <= 1'b0;
            vsync_d1 <= 1'b0;
        end else begin
            av_d1    <= vid_active_video_in;
            vsync_d1 <= vid_vsync_in;
        end
    end

    assign vid_active_video_out = av_d1;
    assign vid_vsync_out        = vsync_d1;

endmodule
