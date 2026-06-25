`timescale 1ns/1ps

interface axi_lite_if #(
  parameter int ADDR_W = 32,
  parameter int DATA_W = 32
) (
  /* verilator lint_off UNUSEDSIGNAL */
  input logic ACLK,
  input logic ARESETn
  /* verilator lint_on UNUSEDSIGNAL */
);

  // Write address channel: master sends the address for a write.
  logic [ADDR_W-1:0] AWADDR;
  logic              AWVALID;
  logic              AWREADY;

  // Write data channel: master sends write data and byte strobes.
  logic [DATA_W-1:0]     WDATA;
  logic [(DATA_W/8)-1:0] WSTRB;
  logic                  WVALID;
  logic                  WREADY;

  // Write response channel: slave reports write completion status.
  logic [1:0] BRESP;
  logic       BVALID;
  logic       BREADY;

  // Read address channel: master sends the address for a read.
  logic [ADDR_W-1:0] ARADDR;
  logic              ARVALID;
  logic              ARREADY;

  // Read data channel: slave returns read data and response status.
  logic [DATA_W-1:0] RDATA;
  logic [1:0]        RRESP;
  logic              RVALID;
  logic              RREADY;

  modport master (
    input  ACLK,
    input  ARESETn,

    output AWADDR,
    output AWVALID,
    input  AWREADY,

    output WDATA,
    output WSTRB,
    output WVALID,
    input  WREADY,

    input  BRESP,
    input  BVALID,
    output BREADY,

    output ARADDR,
    output ARVALID,
    input  ARREADY,

    input  RDATA,
    input  RRESP,
    input  RVALID,
    output RREADY
  );

  modport slave (
    input  ACLK,
    input  ARESETn,

    input  AWADDR,
    input  AWVALID,
    output AWREADY,

    input  WDATA,
    input  WSTRB,
    input  WVALID,
    output WREADY,

    output BRESP,
    output BVALID,
    input  BREADY,

    input  ARADDR,
    input  ARVALID,
    output ARREADY,

    output RDATA,
    output RRESP,
    output RVALID,
    input  RREADY
  );

  modport monitor (
    input ACLK,
    input ARESETn,

    input AWADDR,
    input AWVALID,
    input AWREADY,

    input WDATA,
    input WSTRB,
    input WVALID,
    input WREADY,

    input BRESP,
    input BVALID,
    input BREADY,

    input ARADDR,
    input ARVALID,
    input ARREADY,

    input RDATA,
    input RRESP,
    input RVALID,
    input RREADY
  );

endinterface
