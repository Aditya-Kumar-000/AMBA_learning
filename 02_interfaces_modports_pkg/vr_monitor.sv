module vr_monitor (
  input logic clk,
  input logic rst_n,
  input string NAME,
  valid_ready_if.monitor_mp bus
);
  import vr_pkg::*;

  always_ff @(posedge clk) begin
    if (rst_n) begin
      if (bus.valid && bus.ready) begin
        $display("[%0t] %s TRANSFER data=0x%08h", $time, NAME, bus.data);
      end else if (bus.valid && !bus.ready) begin
        $display("[%0t] %s STALL data=0x%08h", $time, NAME, bus.data);
      end
    end
  end
endmodule
