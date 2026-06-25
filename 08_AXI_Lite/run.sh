#!/usr/bin/env zsh
set -euo pipefail

rm -rf obj_dir axi_lite_day8.vcd

verilator \
  -Wall \
  --binary \
  --timing \
  --trace \
  axi_lite_pkg.sv \
  axi_lite_if.sv \
  tb_axi_lite_waveform.sv \
  --top-module tb_axi_lite_waveform

./obj_dir/Vtb_axi_lite_waveform

echo "Wrote waveform: axi_lite_day8.vcd"
