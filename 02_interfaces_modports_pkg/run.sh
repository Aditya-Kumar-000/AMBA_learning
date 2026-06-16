#!/usr/bin/env bash
set -euo pipefail

rm -rf obj_dir interfaces_day3.vcd

verilator --sv --binary --timing --trace \
  --top-module tb_interfaces \
  vr_pkg.sv valid_ready_if.sv source.sv sink.sv skid_buffer.sv vr_monitor.sv tb_interfaces.sv

./obj_dir/Vtb_interfaces

ls -lh interfaces_day3.vcd

echo "surfer interfaces_day3.vcd"
