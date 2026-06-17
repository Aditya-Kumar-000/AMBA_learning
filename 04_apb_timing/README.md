# Day 5: APB Transfer Timing

This project is a beginner-friendly SystemVerilog exercise for learning APB
SETUP and ACCESS timing. It is intentionally not a complete solution: the
project structure is ready, but you fill in the important APB logic yourself.

## APB Timing Basics

APB is unpipelined. Every transfer takes at least two clock cycles:

1. SETUP phase
   - `PSEL=1`
   - `PENABLE=0`
   - Address, direction, and write data are driven here.

2. ACCESS phase
   - `PSEL=1`
   - `PENABLE=1`
   - The transfer completes when `PSEL && PENABLE && PREADY` is true.

IDLE means:

- `PSEL=0`
- `PENABLE=0`

During ACCESS wait states, address/control/write data must remain stable until
the transfer completes. In this starter project, the slave keeps `PREADY=1`, so
there are no wait states yet.

## Files

- `apb_pkg.sv`: APB widths and typedefs. Fully implemented.
- `apb_if.sv`: APB interface and modports. Fully implemented.
- `apb_slave_empty.sv`: Simple APB peripheral stub with TODOs.
- `tb_apb_basic.sv`: Testbench with TODOs in the APB write/read tasks.
- `run.sh`: Verilator build/run script.

## TODOs To Fill

In `apb_slave_empty.sv`:

- Complete the transfer detection condition: `PSEL && PENABLE && PREADY`.
- Print write transactions when a completed transfer has `PWRITE=1`.
- Print read transactions when a completed transfer has `PWRITE=0`.
- Assign a fixed read value to `PRDATA`, such as `32'hDEAD_BEEF`.

In `tb_apb_basic.sv`:

- In `apb_write`, drive SETUP, wait one clock, drive ACCESS, wait for `PREADY`,
  then return to IDLE.
- In `apb_read`, drive SETUP, wait one clock, drive ACCESS, wait for `PREADY`,
  capture `PRDATA`, then return to IDLE.

## How To Run

After filling the TODOs:

```sh
chmod +x run.sh
./run.sh
```

The script removes old build output, builds with Verilator, runs the simulation,
and writes `wave.vcd`.

## Waveform Signals To Inspect

Open `wave.vcd` and inspect:

- `PSEL`
- `PENABLE`
- `PADDR`
- `PWRITE`
- `PWDATA`
- `PRDATA`
- `PREADY`
- `PSLVERR`

For each transfer, confirm that:

- SETUP has `PSEL=1` and `PENABLE=0`.
- ACCESS has `PSEL=1` and `PENABLE=1`.
- Completion happens when `PSEL && PENABLE && PREADY` is true.
- Signals stay stable through ACCESS.
