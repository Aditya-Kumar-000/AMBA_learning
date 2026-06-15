
`timescale 1ns/1ps
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
    assign in_fire = in_bus.valid && in_bus.ready;
    assign out_fire = out_bus.valid && out_bus.ready;





    //
    // 2. Combinational valid-ready/data behavior:
    //      - When the buffer is empty, the input beat can pass through.
    //      - When the buffer is full, drive the saved buffer_data.
    //      - The input side should be ready when there is space, or when the
    //        output side is also accepting data.
    assign in_bus.ready = ~full || out_bus.ready;
    assign out_bus.valid = full ? 1'b1 : in_bus.valid;
    assign out_bus.data = full ? buffer_data : in_bus.data;
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

    always_ff @(posedge clk)
    begin
        if(!rst_n)
        begin
            full <= '0;
            buffer_data <= '0;
        end

        else 
        begin

            case ({in_fire, out_fire})
            2'b10: 
            begin
                full <= 1'b1;
                buffer_data <= in_bus.data;
            end
            2'b01: 
            begin
                full <= 1'b0;
            end
            2'b11: 
            begin // three things: 1. full stays high if high, or if already empty stay empty, 2.) Data comes from src and 3) data goes to sink
            if(full)
            begin
                buffer_data <= in_bus.data;
                full  <= 1'b1;
            end
            else
            begin
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
