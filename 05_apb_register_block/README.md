# Day 6 APB Register Block

This project extends the Day 5 APB timing exercise into a small memory-mapped
register block. The APB requester tasks still perform SETUP, ACCESS, wait for
`PREADY`, and return to IDLE, but the design focus is now address decode,
write enables, and read mux behavior.

## Files

- `apb_pkg.sv` defines common address/data widths, typedefs, and register addresses.
- `apb_if.sv` defines the APB interface and requester/completer/monitor modports.
- `apb_reg_block.sv` is the register block under test.
- `tb_apb_reg_block.sv` drives deterministic APB reads and writes.
- `run.sh` builds and runs the test with Verilator.

## Register Map

| Address | Name     | Access     | Reset Value  | Notes |
| ------- | -------- | ---------- | ------------ | ----- |
| `0x00`  | `CTRL`   | read/write | `0x00000000` | Software-owned control register |
| `0x04`  | `STATUS` | read-only  | `0x00000001` | Hardware-owned status register |
| `0x08`  | `DATA_IN` | read/write | `0x00000000` | Software-written input data |
| `0x0C`  | `DATA_OUT` | read-only | `0x00000000` | Hardware/datapath output data |

## What To Implement

The project intentionally leaves the key register-block logic as TODOs in
`apb_reg_block.sv`.

Complete the TODOs in this order:

1. `transfer_complete = PSEL && PENABLE && PREADY`
2. `write_transfer = transfer_complete && PWRITE`
3. `read_transfer = transfer_complete && !PWRITE`
4. Address hit wires for `CTRL`, `STATUS`, `DATA_IN`, and `DATA_OUT`
5. `ctrl_we` and `data_in_we`
6. Sequential write decode:
   - `CTRL` updates only on `ctrl_we`
   - `DATA_IN` updates only on `data_in_we`
   - `DATA_OUT` updates to `PWDATA + 1` when `DATA_IN` is written
   - `STATUS` is not APB-writable
7. Combinational read mux:
   - `CTRL_ADDR` returns `ctrl_reg`
   - `STATUS_ADDR` returns `status_reg`
   - `DATA_IN_ADDR` returns `data_in_reg`
   - `DATA_OUT_ADDR` returns `data_out_reg`
   - default returns `32'hBAD0_ADD0`
8. Optional invalid-address warning display. Keep `PSLVERR = 0` for now.

## Read/Write Vs Read-Only

Read/write registers can be changed by APB writes and observed by APB reads.
Read-only registers can be observed by APB reads, but APB writes must not
modify them. In this exercise, `STATUS` and `DATA_OUT` are read-only from the
APB side.

## Write Decode

Write decode converts an APB write transfer and an address hit into a register
write enable. For example, `ctrl_we` should only be true during a completed APB
write to `CTRL_ADDR`.

## Read Mux

The read mux returns the selected register value based on `PADDR`. For an
unmapped address, return `32'hBAD0_ADD0` so invalid reads are easy to spot in
the waveform and console output.

## Run

```sh
chmod +x run.sh
./run.sh
```

The script removes `obj_dir` and `wave.vcd`, builds with:

```sh
verilator --sv --binary --timing --trace tb_apb_reg_block.sv
```

Then it runs the generated simulation binary.
