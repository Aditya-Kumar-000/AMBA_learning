`timescale 1ns/1ps

module tb_skid_buffer;
    localparam int DATA_W = 32;

    logic clk;
    logic rst_n;

    valid_ready_if #(.DATA_W(DATA_W)) in_bus();
    valid_ready_if #(.DATA_W(DATA_W)) out_bus();

    logic full_dbg;
    logic [DATA_W-1:0] buffer_data_dbg;
    logic in_fire_dbg;
    logic out_fire_dbg;

    logic in_valid_dbg;
    logic in_ready_dbg;
    logic [DATA_W-1:0] in_data_dbg;
    logic out_valid_dbg;
    logic out_ready_dbg;
    logic [DATA_W-1:0] out_data_dbg;

    int unsigned expected_q[$];
    logic stalled_last_cycle;
    logic [DATA_W-1:0] stalled_data;

    skid_buffer #(.DATA_W(DATA_W)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_bus(in_bus),
        .out_bus(out_bus),
        .full_dbg(full_dbg),
        .buffer_data_dbg(buffer_data_dbg),
        .in_fire_dbg(in_fire_dbg),
        .out_fire_dbg(out_fire_dbg)
    );

    assign in_valid_dbg = in_bus.valid;
    assign in_ready_dbg = in_bus.ready;
    assign in_data_dbg = in_bus.data;
    assign out_valid_dbg = out_bus.valid;
    assign out_ready_dbg = out_bus.ready;
    assign out_data_dbg = out_bus.data;

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task automatic reset_dut;
        begin
            rst_n = 1'b0;
            in_bus.valid = 1'b0;
            in_bus.data = '0;
            out_bus.ready = 1'b0;
            stalled_last_cycle = 1'b0;
            stalled_data = '0;
            repeat (4) @(posedge clk);
            rst_n = 1'b1;
            @(posedge clk);
        end
    endtask

    task automatic send_word(input logic [DATA_W-1:0] value);
        begin
            in_bus.valid = 1'b1;
            in_bus.data = value;
            do begin
                @(posedge clk);
            end while (!in_bus.ready);
            in_bus.valid = 1'b0;
            in_bus.data = '0;
        end
    endtask

    task automatic idle_cycles(input int count);
        begin
            repeat (count) @(posedge clk);
        end
    endtask

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            expected_q.delete();
            stalled_last_cycle <= 1'b0;
            stalled_data <= '0;
        end else begin
            if (in_bus.valid && in_bus.ready) begin
                expected_q.push_back(in_bus.data);
            end

            if (out_bus.valid && out_bus.ready) begin
                if (expected_q.size() == 0) begin
                    $error("Output fired when no input data was expected");
                end else if (out_bus.data !== expected_q[0]) begin
                    $error("Data ordering error: expected %0d, got %0d",
                           expected_q[0], out_bus.data);
                end else begin
                    void'(expected_q.pop_front());
                end
            end

            if (stalled_last_cycle) begin
                if (!out_bus.valid) begin
                    $error("out_bus.valid dropped while stalled");
                end
                if (out_bus.data !== stalled_data) begin
                    $error("out_bus.data changed while stalled: expected %0d, got %0d",
                           stalled_data, out_bus.data);
                end
            end

            stalled_last_cycle <= out_bus.valid && !out_bus.ready;
            stalled_data <= out_bus.data;
        end
    end

    initial begin
        $dumpfile("skid_buffer.vcd");
        $dumpvars(0, tb_skid_buffer);

        reset_dut();

        $display("Scenario 1: no stalls");
        out_bus.ready = 1'b1;
        send_word(32'd1);
        send_word(32'd2);
        send_word(32'd3);
        idle_cycles(3);

        $display("Scenario 2: one-cycle stall");
        out_bus.ready = 1'b1;
        send_word(32'd10);
        out_bus.ready = 1'b0;
        fork
            begin
                send_word(32'd11);
            end
            begin
                @(posedge clk);
                out_bus.ready = 1'b1;
            end
        join
        send_word(32'd12);
        idle_cycles(4);

        $display("Scenario 3: multi-cycle stall");
        out_bus.ready = 1'b1;
        send_word(32'd20);
        out_bus.ready = 1'b0;
        fork
            begin
                send_word(32'd21);
                send_word(32'd22);
                send_word(32'd23);
            end
            begin
                repeat (3) @(posedge clk);
                out_bus.ready = 1'b1;
            end
        join
        idle_cycles(8);

        if (expected_q.size() != 0) begin
            $error("Simulation ended with %0d expected values still queued",
                   expected_q.size());
        end

        $display("Finished tb_skid_buffer");
        $finish;
    end
endmodule
