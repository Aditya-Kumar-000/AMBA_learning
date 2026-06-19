interface apb_if #(
  parameter int ADDR_W = 32,
  parameter int DATA_W = 32
) (
  input logic PCLK,
  input logic PRESETn
);
  logic [ADDR_W-1:0] PADDR;
  logic              PSEL;
  logic              PENABLE;
  logic              PWRITE;
  logic [DATA_W-1:0] PWDATA;
  logic [DATA_W-1:0] PRDATA;
  logic              PREADY;
  logic              PSLVERR;

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
