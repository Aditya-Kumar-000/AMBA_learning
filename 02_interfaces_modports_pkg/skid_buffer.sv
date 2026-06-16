module skid_buffer (
  input logic clk,
  input logic rst_n,

  // The input side uses sink_mp because the skid buffer receives data here.
  valid_ready_if.sink_mp in_bus,

  // The output side uses source_mp because the skid buffer sends data here.
  valid_ready_if.source_mp out_bus,

  output logic  full_dbg,
  output vr_pkg::data_t buffer_data_dbg,
  output logic  in_fire_dbg,
  output logic  out_fire_dbg
);
  import vr_pkg::*;

  logic  full;
  data_t buffer_data;
  logic  in_fire;
  logic  out_fire;

  assign in_fire = in_bus.valid && in_bus.ready;
  assign out_fire = out_bus.valid && out_bus.ready;

  assign in_bus.ready = !full || out_bus.ready;
  assign out_bus.valid = full ? 1'b1 : in_bus.valid;
  assign out_bus.data = full ? buffer_data : in_bus.data;

  assign full_dbg = full;
  assign buffer_data_dbg = buffer_data;
  assign in_fire_dbg = in_fire;
  assign out_fire_dbg = out_fire;

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      full        <= 1'b0;
      buffer_data <= '0;
    end else begin
      case ({in_fire, out_fire})
        2'b10: begin
          buffer_data <= in_bus.data;
          full        <= 1'b1;
        end

        2'b01: begin
          full <= 1'b0;
        end

        2'b11: begin
          if (full) begin
            buffer_data <= in_bus.data;
            full        <= 1'b1;
          end else begin
            full <= 1'b0;
          end
        end

        default: begin
          full <= full;
        end
      endcase
    end
  end
endmodule
