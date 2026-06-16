# SystemVerilog Day 3: Interfaces, Modports, and Packages

This project builds a small valid-ready system:

```text
source -> skid_buffer -> sink
```

There are also two passive monitors:

```text
source -> input monitor -> skid_buffer -> output monitor -> sink
```

## Main Ideas

An `interface` is a bundle of related signals. Here, `valid_ready_if` groups `valid`, `ready`, and `data` so modules do not need three separate ports every time they connect to a valid-ready channel.

A `modport` describes the role a module has when it connects to an interface. It gives each module the correct signal directions.

- `source_mp` is for a module that sends data.
- `sink_mp` is for a module that receives data.
- `monitor_mp` is read-only, so a monitor can observe traffic without driving the bus.

A `package` holds shared definitions. Here, `vr_pkg` defines `DATA_W` and `data_t` so every file uses the same data width and type.

A `monitor` is a passive observer. The monitors in this project print transfers and stalls, but they never drive `valid`, `ready`, or `data`.

## Why The Skid Buffer Uses Two Modports

The skid buffer receives data on its input side, so that port uses `sink_mp`.

The skid buffer sends data on its output side, so that port uses `source_mp`.

This makes the direction of each side clear when reading the module header.

## What To Inspect In Surfer

Run:

```sh
./run.sh
surfer interfaces_day3.vcd
```

Useful signals to inspect:

- `in_valid_dbg`, `in_ready_dbg`, `in_data_dbg`
- `out_valid_dbg`, `out_ready_dbg`, `out_data_dbg`
- `full_dbg`
- `buffer_data_dbg`
- `in_fire_dbg`
- `out_fire_dbg`
- `transfer_count_dbg`
- `stall_counter_dbg`

Look for these patterns:

- The source keeps `valid` high after reset.
- The sink occasionally drops `ready`.
- `in_fire_dbg` and `out_fire_dbg` show accepted transfers.
- `full_dbg` shows when the skid buffer is holding one item.
- `buffer_data_dbg` shows the stored item while the buffer is full.
