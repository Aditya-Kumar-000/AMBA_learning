#!/usr/bin/env bash
set -euo pipefail

rm -rf obj_dir skid_buffer.vcd

verilator --sv --binary --timing --trace \
    --top-module tb_skid_buffer \
    valid_ready_if.sv skid_buffer.sv tb_skid_buffer.sv

./obj_dir/Vtb_skid_buffer

ls -lh skid_buffer.vcd

echo "To view the waveform, run:"
echo "surfer skid_buffer.vcd"
