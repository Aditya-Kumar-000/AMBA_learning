// apb_pkg.sv
// Shared APB widths and types for this beginner timing exercise.

`timescale 1ns/1ps

package apb_pkg;
  parameter int ADDR_W = 32; // address will always be 32 bit
  parameter int DATA_W = 32; // data will always be 32 bit


  typedef logic [ADDR_W-1:0] addr_t;
  typedef logic [DATA_W-1:0] data_t;
endpackage
