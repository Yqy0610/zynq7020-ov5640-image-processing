`timescale 1ns / 1ps
// =====================================================================
// image_process_comb : 像素处理组合逻辑核心（无时钟，纯组合）
//   mode = 2'd0 : 原图直通
//   mode = 2'd1 : 灰度
//   mode = 2'd2 : 二值化
// =====================================================================
module image_process_comb #(
    parameter [7:0] THRESH = 8'd100    // 二值化阈值
)(
    input  wire [23:0] rgb_in,         // RGB888
    input  wire [1:0]  mode,
    output reg  [23:0] rgb_out
);

    wire [7:0] r, g, b;
    assign r = rgb_in[23:16];
    assign g = rgb_in[15:8];
    assign b = rgb_in[7:0];

    // 灰度：Y = (77*R + 150*G + 29*B) >> 8  （0.299R + 0.587G + 0.114B 的整数近似）
    wire [15:0] y_sum;
    assign y_sum = r * 16'd77 + g * 16'd150 + b * 16'd29;
    wire [7:0] gray;
    assign gray = y_sum[15:8];

    wire bin;
    assign bin = (gray >= THRESH);     // 大于等于阈值判白

    always @(*) begin
        case (mode)
            2'd1:    rgb_out = {gray, gray, gray};
            2'd2:    rgb_out = bin ? 24'hFFFFFF : 24'h000000;
            default: rgb_out = rgb_in; // mode=0 或非法值，原图直通
        endcase
    end

endmodule
