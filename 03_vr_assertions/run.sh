#!/usr/bin/env bash
set -euo pipefail

mode="${1:-pass}"

case "${mode}" in
  pass)
    params=()
    ;;
  bug_drop_valid)
    params=(-GBUG_DROP_VALID=1)
    ;;
  bug_change_data)
    params=(-GBUG_CHANGE_DATA=1)
    ;;
  *)
    echo "Usage: ./run.sh {pass|bug_drop_valid|bug_change_data}"
    exit 1
    ;;
esac

rm -rf obj_dir wave.vcd

verilator --binary --assert --timing --trace -Wall -Wno-DECLFILENAME \
  --top-module tb_vr_assertions \
  ${params+"${params[@]}"} \
  vr_pkg.sv \
  valid_ready_if.sv \
  source.sv \
  sink.sv \
  vr_assertions.sv \
  tb_vr_assertions.sv

./obj_dir/Vtb_vr_assertions
