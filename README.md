# 基于 ZYNQ7020 的 OV5640 实时图像处理与显示系统

## 项目简介
本项目基于正点原子**领航者 ZYNQ-7020** 开发板，实现 OV5640 摄像头**实时视频采集、图像处理与 HDMI 显示**。
图像处理部分采用**纯 Verilog RTL** 实现，包含 **RGB 转灰度、二值化、按键切换** 三种模式。

## 功能特性
- OV5640 摄像头 1280×720@60fps 实时采集
- HDMI（TMDS）实时显示
- RGB 转灰度：加权公式 `Y = (77R + 150G + 29B) / 256`
- 二值化：阈值可调（默认 100）
- PL 按键（PL_KEY0，引脚 L14）循环切换：**原图 → 灰度 → 二值化 → 原图**

## 技术要点
- ZYNQ **PS+PL** 协同架构，AXI VDMA 视频 DMA 搬运
- 图像处理模块采用**原生视频域插入**方案：置于 `v_vid_in_axi4s` 之前，只处理
  `vid_data / vid_ce / vid_active_video / vid_vsync` 四路原生视频信号，
  **不触碰 AXI4-Stream 的 tvalid/tready/tuser/tlast 握手**，从根本上避免 AXIS 时序错位导致的黑屏
- 处理流水线**固定一拍延迟**，四路视频信号严格同延迟，保证帧/行同步不失真
- 模块化设计：像素核心（image_process_comb）、按键与模式管理（image_process）、
  视频时序包装（image_process_video_top）三层分离

## 硬件平台
- 开发板：正点原子领航者 ZYNQ-7020（xc7z020）
- 摄像头：OV5640
- 显示：HDMI（TMDS 差分输出）
- 按键：PL_KEY0（L14，低电平有效）

## 软件环境
- Vivado 2020.2
- Vitis 2020.2

## 目录结构
```
repo/
├── vivado/                      # Vivado 工程
│   ├── ov5640_hdmi.xpr          # 工程文件
│   ├── ov5640_hdmi.srcs/        # 源文件
│   │   ├── sources_1/
│   │   │   ├── new/             # 自定义 Verilog
│   │   │   │   ├── image_process_comb.v       # 像素核心（原图/灰度/二值化）
│   │   │   │   ├── image_process.v           # 按键消抖 + 模式切换
│   │   │   │   └── image_process_video_top.v # 原生视频插入壳
│   │   │   └── bd/system/system.bd  # Block Design
│   │   └── constrs_1/new/ov5640_lcd.xdc      # 引脚约束
│   ├── ip_repo/                 # 自定义 IP（ov5640_capture_data、DVI_TX）
│   └── bd_*.tcl                 # BD 设置脚本
├── vitis/                       # Vitis 工程
│   ├── my_app/                  # 应用工程（PS 端 C 代码）
│   │   └── src/
│   │       ├── main.c
│   │       ├── vdma_api/        # VDMA 配置
│   │       ├── ov5640/          # 摄像头初始化
│   │       ├── display_ctrl_hdmi/  # HDMI 显示时序
│   │       └── emio_sccb_cfg/   # SCCB 配置
│   ├── my_platform/             # 硬件平台（platform.tcl / platform.spr）
│   └── my_app_system/           # 系统工程
├── README.md
└── .gitignore
```

## 数据流
```
OV5640 → ov5640_capture_data(RGB565→RGB888)
       → image_process(灰度/二值化/按键)
       → v_vid_in_axi4s(视频转AXIS)
       → VDMA → DDR内存
       → v_axi4s_vid_out → v_tc → DVI/HDMI
```

## 使用说明
1. 用 Vivado 2020.2 打开 `vivado/ov5640_hdmi.xpr`；
2. 若 `.gen/.runs` 被忽略，需 `Generate Output Products` 重新生成；
3. `Export Hardware`（勾选 Include bitstream）导出 XSA；
4. 在 Vitis 中导入 XSA、编译 `vitis/my_app` 的 C 代码、烧录运行。
