`include "apb_reg_block.sv"

module tb_apb_reg_block;
  import apb_pkg::*;

  logic PCLK;
  logic PRESETn;

  apb_if #(
    .ADDR_W(ADDR_W),
    .DATA_W(DATA_W)
  ) apb (
    .PCLK(PCLK),
    .PRESETn(PRESETn)
  );

  apb_reg_block dut (
    .apb(apb)
  );

  initial begin
    PCLK = 1'b0;
    forever #5 PCLK = ~PCLK;
  end

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_apb_reg_block);
  end

  task automatic apb_idle();
    begin
      apb.PADDR   = '0;
      apb.PSEL    = 1'b0;
      apb.PENABLE = 1'b0;
      apb.PWRITE  = 1'b0;
      apb.PWDATA  = '0;
    end
  endtask

  task automatic apb_write(input addr_t addr, input data_t data);
    begin
      @(posedge PCLK);
      // SETUP phase: drive address, write control, write data, and select.
      apb.PADDR   = addr;
      apb.PWRITE  = 1'b1;
      apb.PWDATA  = data;
      apb.PSEL    = 1'b1;
      apb.PENABLE = 1'b0;

      @(posedge PCLK);
      // ACCESS phase: assert PENABLE and wait until the completer is ready.
      apb.PENABLE = 1'b1;
      while (!apb.PREADY) begin
        @(posedge PCLK);
      end

      @(posedge PCLK);
      // IDLE phase: deassert the APB controls.
      apb_idle();
    end
  endtask

  task automatic apb_read(input addr_t addr, output data_t data);
    begin
      @(posedge PCLK);
      // SETUP phase: drive address, read control, and select.
      apb.PADDR   = addr;
      apb.PWRITE  = 1'b0;
      apb.PWDATA  = '0;
      apb.PSEL    = 1'b1;
      apb.PENABLE = 1'b0;

      @(posedge PCLK);
      // ACCESS phase: assert PENABLE and wait until the completer is ready.
      apb.PENABLE = 1'b1;
      while (!apb.PREADY) begin
        @(posedge PCLK);
      end
      data = apb.PRDATA;

      @(posedge PCLK);
      // IDLE phase: deassert the APB controls.
      apb_idle();
    end
  endtask

  data_t ctrl_value;
  data_t status_value;
  data_t data_in_value;
  data_t data_out_value;
  data_t invalid_value;

  initial begin
    PRESETn = 1'b0;
    apb_idle();

    repeat (3) @(posedge PCLK);
    PRESETn = 1'b1;
    repeat (2) @(posedge PCLK);

    apb_write(CTRL_ADDR, 32'h0000_0005);
    apb_read(CTRL_ADDR, ctrl_value);

    apb_read(STATUS_ADDR, status_value);

    apb_write(DATA_IN_ADDR, 32'h0000_0010);
    apb_read(DATA_IN_ADDR, data_in_value);
    apb_read(DATA_OUT_ADDR, data_out_value);

    apb_read(32'h0000_0020, invalid_value);

    $display("CTRL     read = 0x%08h", ctrl_value);
    $display("STATUS   read = 0x%08h", status_value);
    $display("DATA_IN  read = 0x%08h", data_in_value);
    $display("DATA_OUT read = 0x%08h", data_out_value);
    $display("INVALID  read = 0x%08h", invalid_value);

    repeat (2) @(posedge PCLK);
    $finish;
  end
endmodule
