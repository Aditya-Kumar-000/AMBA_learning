#!/usr/bin/env bash
set -euo pipefail

rm -rf obj_dir wave.vcd

verilator --sv --binary --timing --trace \
  apb_pkg.sv \
  apb_if.sv \
  apb_slave_empty.sv \
  tb_apb_basic.sv \
  --top-module tb_apb_basic

./obj_dir/Vtb_apb_basic
