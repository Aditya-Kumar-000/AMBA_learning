#!/usr/bin/env bash
set -euo pipefail

rm -rf obj_dir wave.vcd

verilator --sv --binary --timing --trace tb_apb_reg_block.sv
./obj_dir/Vtb_apb_reg_block
