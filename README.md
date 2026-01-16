# FPGA-Based IMU Signal Pipeline with Host Control

This repository contains a **FPGA-based real-time IMU-style signal processing pipeline** with a **UART host interface** and **automated verification**. The goal is to model how real systems handle accelerometer (IMU) data in robotics, automotive, and embedded applications:

- Simulate accelerometer/IMU data on FPGA
- Pre-process and filter the signal in real time
- Detect motion/impact events using threshold logic
- Stream data and status to a host PC over UART
- Control thresholds and modes from the host at runtime
- Verify behavior through HDL testbenches and Python tooling

> This is a personal System Engineer–oriented project to showcase **RTL design**, **signal processing**, **hardware–software integration**, and **verification discipline**.
---
## High-Level Architecture

**Phase 1 (V1 – Minimal Pipeline)**

- Simple synthetic “IMU” signal generator (single-axis)
- Threshold-based event detector
- UART transmitter to stream data and flags to the host
- Basic unit testbenches (e.g., threshold detector)

**Phase 2 (V2 – IMU-Style Pipeline)**

- 3-axis IMU simulator (ax, ay, az)
- Moving-average / low-pass filtering
- Magnitude calculation (|a|)
- Configurable threshold via UART
- Python host script for logging and plotting

**Phase 3 (V3 – Advanced / Polished)**

- More advanced event detection (e.g., motion/impact patterns)
- Optional replay of real IMU logs
- Stronger verification (SystemVerilog / cocotb / CI)
- Documentation on design decisions and limitations

---

## Repository Structure

```text
fpga-imu-signal-pipeline/
│
├─ rtl/                      # Verilog RTL modules
│   ├─ threshold_detector.v
│   ├─ counter_imu.v         # (V1 synthetic source)
│   ├─ uart_tx.v
│   ├─ top_v1.v
│   ├─ imu_sim.v             # (V2 3-axis IMU)
│   ├─ moving_average.v
│   └─ magnitude_calc.v
│
├─ tb/                       # Testbenches
│   ├─ tb_threshold_detector.v
│   ├─ tb_counter_imu.v
│   ├─ tb_imu_pipeline_v1.v
│   └─ tb_imu_pipeline_v2.v
│
├─ host/                     # Host-side tools (Python)
│   ├─ read_uart_v1.py
│   └─ imu_visualizer_v2.py
│
├─ docs/                     # Documentation & diagrams
│   ├─ overview.md
│   ├─ architecture_v1.png
│   ├─ architecture_v2.png
│   ├─ imu_pipeline_explained.md
│   └─ verification_strategy.md
│
├─ scripts/                  # Helper scripts (build/run)
│   └─ run_sims.sh
│
├─ constraints/              # Board-specific pin constraints 
│   └─ top_v1.xdc
│
└─ README.md
