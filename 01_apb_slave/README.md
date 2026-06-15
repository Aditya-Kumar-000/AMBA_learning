# Day 2: Valid-Ready Skid Buffer

This project is a small SystemVerilog exercise for a one-entry valid-ready skid buffer.

The important RTL in `skid_buffer.sv` is intentionally left as a TODO. The student should fill in the transfer logic, output/input combinational logic, and the one-entry state update.

## What Is A Skid Buffer?

A skid buffer is a tiny one-entry buffer between a valid-ready source and sink.

It lets data pass straight through when the downstream side is ready. If the downstream side stalls for a cycle while the input side is sending data, the skid buffer captures that data so it is not lost.

## Key Signals

`full` means the internal one-entry buffer currently holds saved data.

`buffer_data` is the saved data value when `full` is high.

`in_fire` means the input side transferred one beat:

```systemverilog
in_bus.valid && in_bus.ready
```

`out_fire` means the output side transferred one beat:

```systemverilog
out_bus.valid && out_bus.ready
```

## What To Look For In Surfer

Open `skid_buffer.vcd` and inspect these signals:

- `clk`
- `rst_n`
- `in_valid_dbg`
- `in_ready_dbg`
- `in_data_dbg`
- `out_valid_dbg`
- `out_ready_dbg`
- `out_data_dbg`
- `full_dbg`
- `buffer_data_dbg`
- `in_fire_dbg`
- `out_fire_dbg`

During no-stall cycles, data should pass from input to output.

During a stall, `out_valid_dbg` and `out_data_dbg` should stay stable while `out_ready_dbg` is low.

When the downstream side becomes ready again, saved data should leave in the original order.

## Files

- `valid_ready_if.sv`: valid-ready SystemVerilog interface.
- `skid_buffer.sv`: student RTL exercise with TODO section.
- `tb_skid_buffer.sv`: simple Verilator testbench.
- `run.sh`: compile and run script.

## Commands

First, fill in the TODO in `skid_buffer.sv`.

Then run:

```sh
chmod +x run.sh
./run.sh
```

To view the waveform:

```sh
surfer skid_buffer.vcd
```

The run script does not open Surfer automatically.
