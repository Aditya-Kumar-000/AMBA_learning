`include "apb_pkg.sv"
`include "apb_if.sv"

module apb_reg_block (
  apb_if.completer_mp apb
);
  import apb_pkg::*;

  data_t ctrl_reg;
  data_t status_reg;
  data_t data_in_reg;
  data_t data_out_reg;

  logic transfer_complete;
  logic write_transfer;
  logic read_transfer;

  logic hit_ctrl;
  logic hit_status;
  logic hit_data_in;
  logic hit_data_out;
  logic invalid_addr;

  logic ctrl_we;
  logic data_in_we;

  assign apb.PREADY  = 1'b1;
  assign apb.PSLVERR = 1'b0;

  // Register ownership:
  // CTRL is APB read/write and is owned by software.
  // STATUS is read-only from APB and is owned by hardware/status logic.
  // DATA_IN is APB read/write and is owned by software.
  // DATA_OUT is read-only from APB and is owned by hardware/datapath logic.

  always_comb begin
    // TODO 1: transfer_complete = PSEL && PENABLE && PREADY
    transfer_complete = 1'b0;

    // TODO 2: write_transfer = transfer_complete && PWRITE
    write_transfer = 1'b0;

    // TODO 3: read_transfer = transfer_complete && !PWRITE
    read_transfer = 1'b0;

    // TODO 4: Decode PADDR into hit_ctrl, hit_status, hit_data_in, hit_data_out.
    hit_ctrl     = 1'b0;
    hit_status   = 1'b0;
    hit_data_in  = 1'b0;
    hit_data_out = 1'b0;

    // TODO 5: ctrl_we and data_in_we should qualify write_transfer with address hits.
    ctrl_we    = 1'b0;
    data_in_we = 1'b0;

    // TODO 8: Optional invalid_addr warning helper. PSLVERR stays 0 for this exercise.
    invalid_addr = read_transfer &&
                   !(hit_ctrl || hit_status || hit_data_in || hit_data_out);
  end

  always_ff @(posedge apb.PCLK or negedge apb.PRESETn) begin
    if (!apb.PRESETn) begin
      ctrl_reg     <= '0;
      status_reg   <= 32'h0000_0001;
      data_in_reg  <= '0;
      data_out_reg <= '0;
    end else begin
      // TODO 6: Add write decode.
      // - CTRL updates only on ctrl_we.
      // - DATA_IN updates only on data_in_we.
      // - DATA_OUT updates to PWDATA + 1 when DATA_IN is written.
      // - STATUS is not APB-writable.
    end
  end

  always_comb begin
    // TODO 7: Replace this placeholder with a read mux.
    // - CTRL_ADDR returns ctrl_reg.
    // - STATUS_ADDR returns status_reg.
    // - DATA_IN_ADDR returns data_in_reg.
    // - DATA_OUT_ADDR returns data_out_reg.
    // - default returns 32'hBAD0_ADD0.
    apb.PRDATA = 32'hBAD0_ADD0;
  end

  always_ff @(posedge apb.PCLK) begin
    if (apb.PRESETn && invalid_addr) begin
      $display("[%0t] TODO optional warning: invalid APB address 0x%08h",
               $time, apb.PADDR);
    end
  end
endmodule
