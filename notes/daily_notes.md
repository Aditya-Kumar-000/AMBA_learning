# Day 1 — VALID/READY Handshake

## Concept
A transfer happens only on a rising clock edge when VALID and READY are both high.

VALID means the source has real data available.
READY means the sink can accept data.
DATA is the payload being transferred.

## RTL Built
- `valid_ready_if.sv`: interface containing clk, rst_n, valid, ready, and data.
- `source.sv`: drives valid and data. Data increments only after an accepted transfer.
- `sink.sv`: drives ready, creates periodic stalls, and counts accepted transfers.
- `tb_valid_ready.sv`: testbench generating clock/reset and VCD waveform.

## Waveform Evidence
Reset releases at 20 ns.
VALID becomes high around 25 ns.
A stall occurs around 55–65 ns when READY is low.
During this stall, DATA holds at 3 and transfer_count does not change.

## Key Rule Proven
When VALID=1 and READY=0, no transfer happens and DATA must remain stable.
When VALID=1 and READY=1 at a rising clock edge, a transfer happens.

## What breaks if VALID drops early?
If VALID drops before READY becomes high, the sink may never accept the data. The transaction can be lost because the source stopped presenting the payload before the handshake completed.

## Internship Reflection
In AXI-style protocols, every channel uses the same VALID/READY idea. To debug a transaction, inspect the rising clock edge where VALID and READY are both high, then check whether payload and counters update correctly.


# Day 2 — One-Entry Skid Buffer

## Concept
A skid buffer is a one-entry valid-ready buffer placed between a source and a sink.

It allows data to pass through when the sink is ready, but stores one item when the sink stalls. If the buffer is already full and the sink is still not ready, the buffer lowers input READY to apply backpressure upstream.

## RTL Built
- `valid_ready_if.sv`: valid-ready interface with source, sink, and monitor modports.
- `skid_buffer.sv`: one-entry skid buffer using `full` and `buffer_data`.
- `tb_skid_buffer.sv`: testbench with no-stall, one-cycle-stall, and multi-cycle-stall scenarios.

## Key Signals
- `in_fire = in_valid && in_ready`: input beat accepted by the buffer.
- `out_fire = out_valid && out_ready`: output beat accepted by the sink.
- `full`: buffer currently stores one valid item.
- `buffer_data`: stored payload inside the buffer.

## Core Logic
When `full=0`, output data comes directly from input data.
When `full=1`, output data comes from `buffer_data`.

The key READY equation is:

`in_ready = !full || out_ready`

This means the buffer can accept input if it is empty, or if the sink is accepting the current output in the same cycle.

## Waveform Evidence
During a stall, `out_ready` goes low. When the buffer becomes full, `in_ready` follows `out_ready`. If `out_ready=0` while `full=1`, then `in_ready=0`, which proves backpressure reaches the source.

In the inspected region, `full` was high around 115–145 ns. `buffer_data` changed from `0x0b` to `0x0c`, showing same-cycle pop + push: the old item left while the new item was stored.

## Important Case: 2'b11
`2'b11` means input and output fire in the same cycle.

If the buffer is full, the old stored item leaves and the new input item must replace it. This keeps `full=1` and avoids data loss.

If the buffer is empty, the data passes straight through, so `full` remains 0.

## What Would Break?
If the `2'b11` case was not handled while full, the design could lose incoming data during same-cycle pop + push. The sink would accept the old item, but the new item might not be stored.

## Internship Reflection
Skid buffers are small but important pipeline elements. They help valid-ready channels tolerate stalls, preserve ordering, and propagate backpressure safely. This is directly relevant to AXI-style channels, interconnects, and waveform debug.