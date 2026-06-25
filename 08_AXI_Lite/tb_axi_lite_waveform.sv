`timescale 1ns/1ps

module tb_axi_lite_waveform;
  import axi_lite_pkg::*;

  localparam int ADDR_W = 32;
  localparam int DATA_W = 32;

  logic ACLK;
  logic ARESETn;

  axi_lite_if #(
    .ADDR_W(ADDR_W),
    .DATA_W(DATA_W)
  ) axi (
    .ACLK(ACLK),
    .ARESETn(ARESETn)
  );

  initial begin
    ACLK = 1'b0;
    forever #5 ACLK = ~ACLK;
  end

  task automatic clear_bus();
    axi.AWADDR  = '0;
    axi.AWVALID = 1'b0;
    axi.AWREADY = 1'b0;

    axi.WDATA   = '0;
    axi.WSTRB   = '0;
    axi.WVALID  = 1'b0;
    axi.WREADY  = 1'b0;

    axi.BRESP   = AXI_RESP_OKAY;
    axi.BVALID  = 1'b0;
    axi.BREADY  = 1'b0;

    axi.ARADDR  = '0;
    axi.ARVALID = 1'b0;
    axi.ARREADY = 1'b0;

    axi.RDATA   = '0;
    axi.RRESP   = AXI_RESP_OKAY;
    axi.RVALID  = 1'b0;
    axi.RREADY  = 1'b0;
  endtask

  task automatic tick(input string label = "");
    @(posedge ACLK);
    #1;

    if (label != "") begin
      $display("[%0t] %s", $time, label);
    end

    if (axi.AWVALID && axi.AWREADY) begin
      $display("[%0t] AW handshake: AWADDR=0x%08h", $time, axi.AWADDR);
    end

    if (axi.WVALID && axi.WREADY) begin
      $display("[%0t] W  handshake: WDATA=0x%08h WSTRB=0x%0h", $time, axi.WDATA, axi.WSTRB);
    end

    if (axi.BVALID && axi.BREADY) begin
      $display("[%0t] B  handshake: BRESP=%0b", $time, axi.BRESP);
    end

    if (axi.ARVALID && axi.ARREADY) begin
      $display("[%0t] AR handshake: ARADDR=0x%08h", $time, axi.ARADDR);
    end

    if (axi.RVALID && axi.RREADY) begin
      $display("[%0t] R  handshake: RDATA=0x%08h RRESP=%0b", $time, axi.RDATA, axi.RRESP);
    end
  endtask

  task automatic idle_cycles(input int count);
    repeat (count) begin
      tick("idle");
    end
  endtask

  task automatic reset_dut();
    $display("[%0t] reset asserted", $time);
    ARESETn = 1'b0;
    clear_bus();

    // TODO: Change reset length if you want to study reset timing.
    repeat (3) begin
      tick("reset");
    end

    ARESETn = 1'b1;
    tick("reset released");
  endtask

  task automatic simple_write_aw_w_same_cycle();
    $display("\n--- simple write: AW and W handshake in the same cycle ---");

    // TODO: Try changing the address and data values below.
    axi.AWADDR  = 32'h0000_0010;
    axi.AWVALID = 1'b1;
    axi.AWREADY = 1'b1;

    axi.WDATA   = 32'h1111_AAAA;
    axi.WSTRB   = 4'hF;
    axi.WVALID  = 1'b1;
    axi.WREADY  = 1'b1;

    tick("AW and W accepted together");

    axi.AWVALID = 1'b0;
    axi.AWREADY = 1'b0;
    axi.WVALID  = 1'b0;
    axi.WREADY  = 1'b0;

    // Write response comes after both AW and W have been accepted.
    axi.BRESP  = AXI_RESP_OKAY;
    axi.BVALID = 1'b1;
    axi.BREADY = 1'b1;
    tick("B response accepted");

    axi.BVALID = 1'b0;
    axi.BREADY = 1'b0;
    idle_cycles(1);
  endtask

  task automatic write_aw_before_w();
    $display("\n--- write: AW handshakes before W ---");

    // TODO: Try holding AWVALID high for extra cycles before AWREADY rises.
    axi.AWADDR  = 32'h0000_0020;
    axi.AWVALID = 1'b1;
    axi.AWREADY = 1'b1;
    tick("AW accepted first");

    axi.AWVALID = 1'b0;
    axi.AWREADY = 1'b0;
    idle_cycles(1);

    // TODO: Change how long the write data channel waits here.
    axi.WDATA  = 32'h2222_BBBB;
    axi.WSTRB  = 4'hF;
    axi.WVALID = 1'b1;
    axi.WREADY = 1'b1;
    tick("W accepted second");

    axi.WVALID = 1'b0;
    axi.WREADY = 1'b0;

    axi.BRESP  = AXI_RESP_OKAY;
    axi.BVALID = 1'b1;
    axi.BREADY = 1'b1;
    tick("B response accepted");

    axi.BVALID = 1'b0;
    axi.BREADY = 1'b0;
    idle_cycles(1);
  endtask

  task automatic write_w_before_aw();
    $display("\n--- write: W handshakes before AW ---");

    // TODO: Try changing WSTRB to partial byte enables, for example 4'h3.
    axi.WDATA  = 32'h3333_CCCC;
    axi.WSTRB  = 4'hF;
    axi.WVALID = 1'b1;
    axi.WREADY = 1'b1;
    tick("W accepted first");

    axi.WVALID = 1'b0;
    axi.WREADY = 1'b0;
    idle_cycles(1);

    // TODO: Change the address timing and observe that AW is independent of W.
    axi.AWADDR  = 32'h0000_0030;
    axi.AWVALID = 1'b1;
    axi.AWREADY = 1'b1;
    tick("AW accepted second");

    axi.AWVALID = 1'b0;
    axi.AWREADY = 1'b0;

    axi.BRESP  = AXI_RESP_OKAY;
    axi.BVALID = 1'b1;
    axi.BREADY = 1'b1;
    tick("B response accepted");

    axi.BVALID = 1'b0;
    axi.BREADY = 1'b0;
    idle_cycles(1);
  endtask

  task automatic simple_read();
    $display("\n--- simple read: AR handshake followed by R response ---");

    // TODO: Change this address and returned data value.
    axi.ARADDR  = 32'h0000_0040;
    axi.ARVALID = 1'b1;
    axi.ARREADY = 1'b1;
    tick("AR accepted");

    axi.ARVALID = 1'b0;
    axi.ARREADY = 1'b0;

    axi.RDATA  = 32'h4444_DDDD;
    axi.RRESP  = AXI_RESP_OKAY;
    axi.RVALID = 1'b1;
    axi.RREADY = 1'b1;
    tick("R response accepted");

    axi.RVALID = 1'b0;
    axi.RREADY = 1'b0;
    idle_cycles(1);
  endtask

  task automatic stalled_read_response();
    $display("\n--- stalled read response: RVALID high while RREADY is low ---");

    axi.ARADDR  = 32'h0000_0050;
    axi.ARVALID = 1'b1;
    axi.ARREADY = 1'b1;
    tick("AR accepted");

    axi.ARVALID = 1'b0;
    axi.ARREADY = 1'b0;

    axi.RDATA  = 32'h5555_EEEE;
    axi.RRESP  = AXI_RESP_OKAY;
    axi.RVALID = 1'b1;
    axi.RREADY = 1'b0;

    // TODO: Adjust the number of stalled cycles and watch RDATA remain stable.
    repeat (3) begin
      tick("RVALID high, RREADY low: no transfer yet");
    end

    axi.RREADY = 1'b1;
    tick("RREADY rises, R handshakes");

    axi.RVALID = 1'b0;
    axi.RREADY = 1'b0;
    idle_cycles(1);
  endtask

  initial begin
    $dumpfile("axi_lite_day8.vcd");
    $dumpvars(0, tb_axi_lite_waveform);
    $display("AXI responses: OKAY=%0b SLVERR=%0b", AXI_RESP_OKAY, AXI_RESP_SLVERR);

    reset_dut();

    simple_write_aw_w_same_cycle();
    write_aw_before_w();
    write_w_before_aw();
    simple_read();
    stalled_read_response();

    $display("\n[%0t] Day 8 AXI-Lite waveform scaffold complete", $time);
    $finish;
  end

endmodule
