module sink (
  input logic clk,
  input logic rst_n,
  valid_ready_if.sink_mp bus,
  output logic [31:0] transfer_count_dbg,
  output logic [1:0]  stall_counter_dbg
);
  logic [31:0] transfer_count;
  logic [1:0]  stall_counter;

  assign transfer_count_dbg = transfer_count;
  assign stall_counter_dbg  = stall_counter;

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      bus.ready      <= 1'b0;
      transfer_count <= 32'd0;
      stall_counter  <= 2'd0;
    end else begin
      stall_counter <= stall_counter + 2'd1;

      if (stall_counter == 2'd3) begin
        bus.ready <= 1'b0;
      end else begin
        bus.ready <= 1'b1;
      end

      if (bus.valid && bus.ready) begin
        transfer_count <= transfer_count + 32'd1;
      end
    end
  end
endmodule
