// tb_apb_basic.sv
// Beginner APB timing testbench.
//
// Goal:
//   1. Reset the design.
//   2. Perform one APB write.
//   3. Perform one APB read.
//   4. Inspect terminal output and wave.vcd.

`timescale 1ns/1ps

module tb_apb_basic;
  import apb_pkg::*;

  localparam time CLK_PERIOD = 10ns;

  apb_if apb();

  apb_slave_empty u_slave (
    .apb(apb)
  );

  // 10 ns clock period.
  initial begin
    apb.PCLK = 1'b0;
    forever #(CLK_PERIOD / 2) apb.PCLK = ~apb.PCLK;
  end

  // Reset and master-side signal defaults.
  initial begin
    apb.PRESETn = 1'b0;
    apb.PADDR   = '0;
    apb.PSEL    = 1'b0;
    apb.PENABLE = 1'b0;
    apb.PWRITE  = 1'b0;
    apb.PWDATA  = '0;

    repeat (3) @(posedge apb.PCLK);
    apb.PRESETn = 1'b1;
    @(posedge apb.PCLK);
  end

  // Waveform dump for GTKWave or another VCD viewer.
  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_apb_basic);
  end

  task automatic apb_write(input addr_t addr, input data_t data);

  begin

    $display("[%0t] APB WRITE REQUEST addr=0x%08h data=0x%08h", $time, addr, data);

    // SETUP phase

    apb.PSEL    = 1'b1;

    apb.PENABLE = 1'b0;

    apb.PADDR   = addr;

    apb.PWRITE  = 1'b1;

    apb.PWDATA  = data;

    @(posedge apb.PCLK);

    // ACCESS phase

    apb.PENABLE = 1'b1;

    // Wait for completion

    do begin

      @(posedge apb.PCLK);

    end while (!apb.PREADY);

    // Return to IDLE

    apb.PSEL    = 1'b0;

    apb.PENABLE = 1'b0;

    apb.PWRITE  = 1'b0;

    apb.PADDR   = '0;

    apb.PWDATA  = '0;

    @(posedge apb.PCLK);

  end

endtask

  task automatic apb_read(input addr_t addr, output data_t data);
    begin
      // data = '0; // Placeholder until you capture PRDATA in the TODO below.
      $display("[%0t] TODO apb_read  addr=0x%08h", $time, addr);

      // TODO(Day 5): drive SETUP phase.
      // APB SETUP means:
      //   PSEL=1, PENABLE=0, PADDR=addr, PWRITE=0
      apb.PSEL = 1'b1;
      apb.PENABLE = 1'b0;
      apb.PADDR = addr;
      apb.PWRITE = 0;

      // TODO(Day 5): wait one rising clock edge.
    @(posedge apb.PCLK);
      // TODO(Day 5): drive ACCESS phase.
      // APB ACCESS means:
      //   PSEL=1, PENABLE=1
      apb.PENABLE = 1'b1;

      // TODO(Day 5): wait until PREADY is high while keeping request stable.
      // During ACCESS wait states, address/control must not change.
      do begin
      @(posedge apb.PCLK);
    end while (!apb.PREADY);

      // TODO(Day 5): capture PRDATA into the data output.
    data = apb.PRDATA;
      // TODO(Day 5): return to IDLE.
      // APB IDLE means:
      //   PSEL=0, PENABLE=0
      apb.PSEL    = 1'b0;

    apb.PENABLE = 1'b0;

    apb.PWRITE  = 1'b0;

    apb.PADDR   = '0;

    apb.PWDATA  = '0;
      // Temporary timing step so the starter project runs before TODOs are filled.
      @(posedge apb.PCLK);
    end
  endtask

  initial begin : main_stimulus
    data_t read_data;

    wait (apb.PRESETn === 1'b1);
    @(posedge apb.PCLK);

    $display("[%0t] Starting Day 5 APB basic timing exercise", $time);

    apb_write(32'h0000_0010, 32'hCAFE_1234);
    apb_read (32'h0000_0010, read_data);

    $display("[%0t] Read task returned data=0x%08h", $time, read_data);
    $display("[%0t] Simulation finished", $time);

    repeat (2) @(posedge apb.PCLK);
    $finish;
  end
endmodule
