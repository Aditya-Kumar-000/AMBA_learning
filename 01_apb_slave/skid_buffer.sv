module skid_buffer #(
    parameter int DATA_W = 32
) (
    input logic clk,
    input logic rst_n,

    valid_ready_if.sink_mp in_bus,
    valid_ready_if.source_mp out_bus,

    output logic full_dbg,
    output logic [DATA_W-1:0] buffer_data_dbg,
    output logic in_fire_dbg,
    output logic out_fire_dbg
);
    logic full;
    logic [DATA_W-1:0] buffer_data;
    logic in_fire;
    logic out_fire;

    assign full_dbg = full;
    assign buffer_data_dbg = buffer_data;
    assign in_fire_dbg = in_fire;
    assign out_fire_dbg = out_fire;

    // ---------------------------------------------------------------------
    // STUDENT TODO: Fill in the core skid-buffer logic.
    //
    // Write these pieces manually:
    //
    // 1. Transfer detection:
    //      - in_fire should mean the input side completed a valid/ready beat.
    //      - out_fire should mean the output side completed a valid/ready beat.
    //
    // 2. Combinational valid-ready/data behavior:
    //      - When the buffer is empty, the input beat can pass through.
    //      - When the buffer is full, drive the saved buffer_data.
    //      - The input side should be ready when there is space, or when the
    //        output side is also accepting data.
    //
    // 3. State update:
    //      - Reset full to 0 and buffer_data to 0.
    //      - Store input data when an input beat arrives and no output beat
    //        leaves in the same cycle.
    //      - Clear full when an output beat leaves and no input beat arrives.
    //      - If both sides fire while already full, replace buffer_data with
    //        the new input data and keep full set.
    //      - If both sides fire while empty, stay empty because the data passed
    //        straight through.
    //
    // Do not change the debug assignments above.
    // ---------------------------------------------------------------------

endmodule
