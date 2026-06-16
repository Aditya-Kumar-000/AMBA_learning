# Day 4: SystemVerilog Valid-Ready Assertions

This project is a beginner-friendly valid-ready assertion exercise for Arm front-end emulation internship prep. It uses a small source, a deterministic stalling sink, a valid-ready interface, and a checker module.

## Files

- `vr_pkg.sv` defines `DATA_W` and `data_t`.
- `valid_ready_if.sv` defines `valid`, `ready`, `data`, and the source/sink/monitor modports.
- `source.sv` generates incrementing data and includes optional intentional bugs.
- `sink.sv` creates deterministic stalls with a counter pattern.
- `vr_assertions.sv` contains two complete example assertions and three TODO assertions.
- `tb_vr_assertions.sv` connects the design, checker, clock/reset, and waveform dump.
- `run.sh` builds and runs the selected mode with Verilator.

## Run

```sh
chmod +x run.sh
./run.sh pass
```

Expected result: the clean test compiles and finishes without assertion failures.

```sh
./run.sh bug_drop_valid
```

Expected result after you complete `p_valid_held_when_stalled`: this test should fail because the source drops `valid` during a stall.

```sh
./run.sh bug_change_data
```

Expected result: this test should fail because the source changes `data` while `valid` is high and `ready` is low. The implemented example assertion `p_data_stable_when_stalled` is intended to catch it.

## Implemented Assertions

- `p_data_stable_when_stalled`: checks that `data` stays stable while `valid` is high and `ready` is low.
- `p_no_x_valid_ready_after_reset`: checks that `valid` and `ready` are not X after reset.

## TODO Assertions

Fill these in inside `vr_assertions.sv`:

- `p_valid_held_when_stalled`: once stalled with `valid` high, keep `valid` high until transfer.
- `p_no_x_data_when_valid`: when `valid` is high, `data` must not be X.
- `p_transfer_count_only_on_fire`: `transfer_count` should only increment when `valid && ready`.

The TODO blocks are comments, so the project compiles before you complete them.
