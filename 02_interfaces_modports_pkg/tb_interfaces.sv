module tb_interfaces;
  import vr_pkg::*;

  logic clk;
  logic rst_n;

  valid_ready_if in_bus();
  valid_ready_if out_bus();

  logic        in_valid_dbg;
  logic        in_ready_dbg;
  data_t       in_data_dbg;
  logic        out_valid_dbg;
  logic        out_ready_dbg;
  data_t       out_data_dbg;
  logic        full_dbg;
  data_t       buffer_data_dbg;
  logic        in_fire_dbg;
  logic        out_fire_dbg;
  logic [31:0] transfer_count_dbg;
  logic [1:0]  stall_counter_dbg;

  assign in_valid_dbg  = in_bus.valid;
  assign in_ready_dbg  = in_bus.ready;
  assign in_data_dbg   = in_bus.data;
  assign out_valid_dbg = out_bus.valid;
  assign out_ready_dbg = out_bus.ready;
  assign out_data_dbg  = out_bus.data;

  source u_source (
    .clk   (clk),
    .rst_n (rst_n),
    .bus   (in_bus.source_mp)
  );

  skid_buffer u_skid_buffer (
    .clk             (clk),
    .rst_n           (rst_n),
    .in_bus          (in_bus.sink_mp),
    .out_bus         (out_bus.source_mp),
    .full_dbg        (full_dbg),
    .buffer_data_dbg (buffer_data_dbg),
    .in_fire_dbg     (in_fire_dbg),
    .out_fire_dbg    (out_fire_dbg)
  );

  sink u_sink (
    .clk                (clk),
    .rst_n              (rst_n),
    .bus                (out_bus.sink_mp),
    .transfer_count_dbg (transfer_count_dbg),
    .stall_counter_dbg  (stall_counter_dbg)
  );

  vr_monitor u_input_monitor (
    .clk   (clk),
    .rst_n (rst_n),
    .NAME  ("IN "),
    .bus   (in_bus.monitor_mp)
  );

  vr_monitor u_output_monitor (
    .clk   (clk),
    .rst_n (rst_n),
    .NAME  ("OUT"),
    .bus   (out_bus.monitor_mp)
  );

  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("interfaces_day3.vcd");
    $dumpvars(0, tb_interfaces);

    rst_n = 1'b0;
    #20;
    rst_n = 1'b1;

    #220;
    $finish;
  end
endmodule
