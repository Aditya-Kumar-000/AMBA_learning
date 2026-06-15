interface valid_ready_if #(parameter int DATA_W = 32);
    logic valid;
    logic ready;
    logic [DATA_W-1:0] data;

    modport source_mp (
        output valid,
        output data,
        input  ready
    );

    modport sink_mp (
        input  valid,
        input  data,
        output ready
    );

    modport monitor_mp (
        input valid,
        input ready,
        input data
    );
endinterface
