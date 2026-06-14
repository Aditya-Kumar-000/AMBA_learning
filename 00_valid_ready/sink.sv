`timescale 1ns/1ps

module sink (
    valid_ready_if.sink_mp bus,
    output logic [31:0] transfer_count_o,
    output logic [1:0]  stall_counter_o
);

    logic [31:0] transfer_count;
    logic [1:0]  stall_counter;

    assign transfer_count_o = transfer_count;
    assign stall_counter_o  = stall_counter;

    always_ff @(posedge bus.clk) begin
        if (!bus.rst_n) begin
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
