// apb_slave_empty.sv
`timescale 1ns/1ps
module apb_slave_empty (
  apb_if.completer_mp apb
); // the instance copy is called apb here
  import apb_pkg::*;

  // For the first timing exercise, the peripheral is always ready and never
  // reports an error. Later exercises can add wait states and PSLVERR cases.
  assign apb.PREADY  = 1'b1;
  assign apb.PSLVERR = 1'b0;

  // TODO(Day 5): assign a fixed read value to PRDATA
  assign apb.PRDATA = data_t'(32'hDEAD_BEEF);

 // complete the APB transfer detection condition.
  logic transfer_complete;
  always_comb begin
    transfer_complete = (apb.PSEL && apb.PENABLE && apb.PREADY); 
  end
      // If transfer_complete is true and PWRITE is 1, print address and write data.
      // If transfer_complete is true and PWRITE is 0, print address and read data.
      always_ff @(posedge apb.PCLK or negedge apb.PRESETn) 
      begin
    if (!apb.PRESETn) 
    begin
      
    end else 
    begin
      if (transfer_complete) 
      begin
        if (apb.PWRITE) 
        begin
          $display("[%0t] APB WRITE addr=0x%08h data=0x%08h",
                    $time, apb.PADDR, apb.PWDATA);
        end else 
        begin
          $display("[%0t] APB READ  addr=0x%08h data=0x%08h",
                    $time, apb.PADDR, apb.PRDATA);
        end
      end
    end
  end

endmodule
