cat > valid_ready_if.sv <<'EOF'
`timescale 1ns/1ps

interface valid_ready_if #(parameter DATA_W = 32) (
    input logic clk,
    input logic rst_n
);

    logic              valid;
    logic              ready;
    logic [DATA_W-1:0] data;

    modport source_mp (
        input  clk,
        input  rst_n,
        input  ready,
        output valid,
        output data
    );

    modport sink_mp (
        input  clk,
        input  rst_n,
        input  valid,
        input  data,
        output ready
    );

    modport monitor_mp (
        input clk,
        input rst_n,
        input valid,
        input ready,
        input data
    );

endinterface
EOF