// Source: produces incrementing DATA and holds VALID until READY accepts it.
`timescale 1ns/1ps

module source #(
  parameter bit BUG_DROP_VALID  = 1'b0,
  parameter bit BUG_CHANGE_DATA = 1'b0
) (
  valid_ready_if.source_mp vr,
  output logic [31:0] transfer_count
);
  import vr_pkg::*;

  data_t next_data;

  // The next value is kept separate so the sequential block is easy to read.
  always_comb begin
    next_data = vr.data + data_t'(1);
  end

  always_ff @(posedge vr.clk) begin
    if (!vr.rst_n) begin
      vr.valid       <= 1'b0;
      vr.data        <= '0;
      transfer_count <= '0;
    end else begin
      // After reset, this simple source always has data available.
      vr.valid <= 1'b1;

      if (vr.valid && vr.ready) begin
        vr.data        <= next_data;
        transfer_count <= transfer_count + 32'd1;
      end

      // Intentional bug: drop VALID during a stall before READY returns.
      // TODO assertion p_valid_held_when_stalled should catch this.
      if (BUG_DROP_VALID && vr.valid && !vr.ready) begin
        vr.valid <= 1'b0;
      end

      // Intentional bug: change DATA while VALID is high and READY is low.
      // Example assertion p_data_stable_when_stalled should catch this.
      if (BUG_CHANGE_DATA && vr.valid && !vr.ready) begin
        vr.data <= vr.data + data_t'(32'h10);
      end
    end
  end
endmodule
