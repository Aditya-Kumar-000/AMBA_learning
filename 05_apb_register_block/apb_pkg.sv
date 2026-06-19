package apb_pkg;
  localparam int ADDR_W = 32;
  localparam int DATA_W = 32;

  typedef logic [ADDR_W-1:0] addr_t;
  typedef logic [DATA_W-1:0] data_t;

  localparam addr_t CTRL_ADDR     = 32'h0000_0000;
  localparam addr_t STATUS_ADDR   = 32'h0000_0004;
  localparam addr_t DATA_IN_ADDR  = 32'h0000_0008;
  localparam addr_t DATA_OUT_ADDR = 32'h0000_000C;
endpackage
