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