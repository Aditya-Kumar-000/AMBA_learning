`timescale 1ns/1ps

module tb_valid_ready;

    logic        clk;
    logic        rst_n;
    logic [31:0] transfer_count;
    logic [1:0]  stall_counter;
    logic        dbg_valid;
    logic        dbg_ready;
    logic [31:0] dbg_data;

    valid_ready_if bus (
        .clk   (clk),
        .rst_n (rst_n)
    );

    assign dbg_valid = bus.valid;
    assign dbg_ready = bus.ready;
    assign dbg_data  = bus.data;

    source u_source (
        .bus (bus)
    );

    sink u_sink (
        .bus              (bus),
        .transfer_count_o (transfer_count),
        .stall_counter_o  (stall_counter)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 1'b0;
        #20;
        rst_n = 1'b1;
        #200;
        $finish;
    end

    initial begin
        $dumpfile("valid_ready.vcd");
        $dumpvars(0, tb_valid_ready);
    end

endmodule
