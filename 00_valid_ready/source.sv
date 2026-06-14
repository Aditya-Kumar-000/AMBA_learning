`timescale 1ns/1ps

module source (
    valid_ready_if.source_mp bus
);

    always_ff @(posedge bus.clk) begin
        if (!bus.rst_n) begin
            bus.valid <= 1'b0;
            bus.data  <= 32'd0;
        end else begin
            bus.valid <= 1'b1;

            if (bus.valid && bus.ready) begin
                bus.data <= bus.data + 32'd1;
            end
        end
    end

endmodule
