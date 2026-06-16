module source (
  input logic clk,
  input logic rst_n,
  valid_ready_if.source_mp bus
);
  import vr_pkg::*;

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      bus.valid <= 1'b0;
      bus.data  <= '0;
    end else begin
      bus.valid <= 1'b1;

      if (bus.valid && bus.ready) begin
        bus.data <= bus.data + data_t'(1);
      end
    end
  end
endmodule
