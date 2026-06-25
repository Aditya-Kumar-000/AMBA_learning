# Day 8: AXI-Lite Manual Waveform Stimulus

This day is only about seeing the five independent AXI-Lite channels move in a waveform. There is no real slave, no driver, no monitor, no scoreboard, and no UVM. The testbench manually wiggles both the master-side and slave-side pins so the handshakes are easy to inspect.

## Files

- `axi_lite_pkg.sv` defines the basic AXI response constants.
- `axi_lite_if.sv` defines a small AXI-Lite interface with master, slave, and monitor modports.
- `tb_axi_lite_waveform.sv` creates manual write and read timing examples.
- `run.sh` compiles and runs the testbench with Verilator.

## AXI-Lite Channels

| Channel | Signals | Direction |
| --- | --- | --- |
| Write address | `AWADDR`, `AWVALID`, `AWREADY` | Master to slave address, slave backpressure |
| Write data | `WDATA`, `WSTRB`, `WVALID`, `WREADY` | Master to slave data, slave backpressure |
| Write response | `BRESP`, `BVALID`, `BREADY` | Slave to master response, master backpressure |
| Read address | `ARADDR`, `ARVALID`, `ARREADY` | Master to slave address, slave backpressure |
| Read data | `RDATA`, `RRESP`, `RVALID`, `RREADY` | Slave to master data, master backpressure |

## Key Rule

Each channel transfers when `VALID && READY` is true at the rising edge of `ACLK`.

The five channels are independent. For example, the write address channel can handshake before, after, or in the same cycle as the write data channel.

## Write Completion Rule

For a write, `AW` and `W` must both be accepted before the slave can complete the write with a `B` response. The write transaction completes when `BVALID && BREADY` handshakes at the rising edge of `ACLK`.

## Run

```sh
./run.sh
```

The simulation writes:

```text
axi_lite_day8.vcd
```

Open the VCD in a waveform viewer such as GTKWave or Surfer.

## TODO Checklist

- [ ] Change the write addresses in each write example.
- [ ] Change `WDATA` values and observe the write data channel.
- [ ] Try partial `WSTRB` values such as `4'h1`, `4'h3`, or `4'hC`.
- [ ] Add extra stall cycles before `AWREADY`, `WREADY`, `BREADY`, `ARREADY`, or `RREADY`.
- [ ] Confirm that no channel transfers until both `VALID` and `READY` are high at a rising clock edge.
- [ ] Confirm that `BVALID` appears only after both write address and write data have been accepted.
- [ ] Confirm that stalled read data stays stable while `RVALID` is high and `RREADY` is low.
