interface valid_ready_if;
  import vr_pkg::*;

  logic  valid;
  logic  ready;
  data_t data;

  // source_mp is used by modules that send data.
  // sink_mp is used by modules that receive data.
  // monitor_mp is read-only for passive observers.
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
