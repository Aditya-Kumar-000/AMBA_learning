// Shared package for the valid-ready assertion examples.
`timescale 1ns/1ps

package vr_pkg;
  parameter int DATA_W = 32;
  typedef logic [DATA_W-1:0] data_t;
endpackage
