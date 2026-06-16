// Simple valid-ready interface used by the source, sink, and checker.
`timescale 1ns/1ps

interface valid_ready_if import vr_pkg::*; (
  input logic clk,
  input logic rst_n
);
  logic  valid;
  logic  ready;
  data_t data;

  // Source drives VALID/DATA and observes READY.
  modport source_mp (
    input  clk,
    input  rst_n,
    input  ready,
    output valid,
    output data
  );

  // Sink drives READY and observes VALID/DATA.
  modport sink_mp (
    input  clk,
    input  rst_n,
    input  valid,
    input  data,
    output ready
  );

  // Checker/testbench only observes the handshake signals.
  modport monitor_mp (
    input clk,
    input rst_n,
    input valid,
    input ready,
    input data
  );
endinterface
