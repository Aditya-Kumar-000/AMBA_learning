// apb_if.sv
// Simple APB interface bundling the request, response, clock, and reset signals.

`timescale 1ns/1ps

interface apb_if;
  import apb_pkg::*;

  logic  PCLK;
  logic  PRESETn;

  addr_t PADDR;
  logic  PSEL;
  logic  PENABLE;
  logic  PWRITE;
  data_t PWDATA;

  data_t PRDATA;
  logic  PREADY;
  logic  PSLVERR;

  // Requester/master side:
  // drives address/control/write data, reads read data/ready/error.
  modport requester_mp (
    input  PCLK,
    input  PRESETn,
    output PADDR,
    output PSEL,
    output PENABLE,
    output PWRITE,
    output PWDATA,
    input  PRDATA,
    input  PREADY,
    input  PSLVERR
  );

  // Completer/peripheral side:
  // reads address/control/write data, drives read data/ready/error.
  modport completer_mp (
    input  PCLK,
    input  PRESETn,
    input  PADDR,
    input  PSEL,
    input  PENABLE,
    input  PWRITE,
    input  PWDATA,
    output PRDATA,
    output PREADY,
    output PSLVERR
  );

  // Passive monitor side:
  // reads every APB signal without driving anything.
  modport monitor_mp (
    input PCLK,
    input PRESETn,
    input PADDR,
    input PSEL,
    input PENABLE,
    input PWRITE,
    input PWDATA,
    input PRDATA,
    input PREADY,
    input PSLVERR
  );
endinterface
