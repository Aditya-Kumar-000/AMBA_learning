// Sink: creates deterministic backpressure with a repeating READY pattern.
`timescale 1ns/1ps

module sink (
  valid_ready_if.sink_mp vr,
  output logic [31:0] received_count
);
  logic [3:0] stall_counter;

  // READY pattern repeats every 8 cycles:
  // ready for 3 cycles, stalled for 2 cycles, ready for 3 cycles.
  always_ff @(posedge vr.clk) begin
    if (!vr.rst_n) begin
      stall_counter  <= '0;
      vr.ready       <= 1'b0;
      received_count <= '0;
    end else begin
      stall_counter <= (stall_counter == 4'd7) ? 4'd0 : stall_counter + 4'd1;
      vr.ready      <= !((stall_counter == 4'd3) || (stall_counter == 4'd4));

      if (vr.valid && vr.ready) begin
        received_count <= received_count + 32'd1;
      end
    end
  end
endmodule
