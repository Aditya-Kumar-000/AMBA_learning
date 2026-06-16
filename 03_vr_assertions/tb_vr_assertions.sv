// Testbench: instantiates the interface, source, sink, and assertion checker.
`timescale 1ns/1ps

module tb_vr_assertions #(
  parameter bit BUG_DROP_VALID  = 1'b0,
  parameter bit BUG_CHANGE_DATA = 1'b0
);
  import vr_pkg::*;

  logic clk;
  logic rst_n;
  logic [31:0] source_transfer_count;
  logic [31:0] sink_received_count;

  valid_ready_if vr_if (
    .clk   (clk),
    .rst_n (rst_n)
  );

  source #(
    .BUG_DROP_VALID  (BUG_DROP_VALID),
    .BUG_CHANGE_DATA (BUG_CHANGE_DATA)
  ) u_source (
    .vr             (vr_if.source_mp),
    .transfer_count (source_transfer_count)
  );

  sink u_sink (
    .vr             (vr_if.sink_mp),
    .received_count (sink_received_count)
  );

  vr_assertions u_vr_assertions (
    .vr             (vr_if.monitor_mp),
    .transfer_count (source_transfer_count)
  );

  // 100 MHz-style clock: 10 ns period.
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  // Reset and fixed-length simulation.
  initial begin
    rst_n = 1'b0;
    repeat (4) @(posedge clk);
    rst_n = 1'b1;

    repeat (40) @(posedge clk);

    $display("PASS: simulation completed. source transfers=%0d sink receives=%0d",
             source_transfer_count, sink_received_count);
    $finish;
  end

  // Waveform dump for debugging with GTKWave or another VCD viewer.
  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_vr_assertions);
  end
endmodule
