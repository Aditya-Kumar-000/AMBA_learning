// Checker module: watches valid-ready behaviour and reports assertion failures.
`timescale 1ns/1ps

module vr_assertions (
  valid_ready_if.monitor_mp vr,
  /* verilator lint_off UNUSEDSIGNAL */
  input logic [31:0] transfer_count
  /* verilator lint_on UNUSEDSIGNAL */
);

  // Example assertion 1:
  // Rule: DATA must remain stable while VALID is high and READY is low.
  property p_data_stable_when_stalled;
    @(posedge vr.clk) disable iff (!vr.rst_n)
      (vr.valid && !vr.ready) |=> $stable(vr.data);
  endproperty

  assert property (p_data_stable_when_stalled)
    else $error("ASSERTION FAILED: data changed while valid was stalled at time %0t", $time);

  // Example assertion 2:
  // Rule: VALID and READY must not be X after reset.
  property p_no_x_valid_ready_after_reset;
    @(posedge vr.clk) disable iff (!vr.rst_n)
      !$isunknown({vr.valid, vr.ready});
  endproperty

  assert property (p_no_x_valid_ready_after_reset)
    else $error("ASSERTION FAILED: valid or ready was X after reset at time %0t", $time);

  // --------------------------------------------------------------------------
  // TODO assertion 1:
  // Rule: Once VALID is asserted during a stall, VALID must stay high until the
  // transfer completes.
  //
  // Name: p_valid_held_when_stalled
  property p_valid_held_when_stalled;

    @(posedge vr.clk) disable iff (!vr.rst_n)

      (vr.valid && !vr.ready) |=> vr.valid;

  endproperty

  assert property (p_valid_held_when_stalled)

    else $error("ASSERTION FAILED: valid dropped before transfer completed at time %0t", $time);
  // --------------------------------------------------------------------------
  // TODO assertion 2:
  // Rule: DATA must not be X when VALID is high after reset.
  //
  // Name: p_no_x_data_when_valid
  //
  // Hints:
  // - Gate the check with vr.valid.
  // - Use $isunknown on vr.data.
  // - This is similar in shape to p_no_x_valid_ready_after_reset.
  //
  // Starter skeleton, intentionally commented out so the project compiles:
  //
  // property p_no_x_data_when_valid;
  //   @(posedge vr.clk) disable iff (!vr.rst_n)
  //     (/* when valid is high */) |-> (/* data is known */);
  // endproperty
  //
  // assert property (p_no_x_data_when_valid)
  //   else $error("ASSERTION FAILED: data was X while valid was high at time %0t", $time);
  property p_no_x_data_when_valid;

    @(posedge vr.clk) disable iff (!vr.rst_n)

      vr.valid |-> !$isunknown(vr.data);

  endproperty

  assert property (p_no_x_data_when_valid)

    else $error("ASSERTION FAILED: data was X while valid was high at time %0t", $time);

  // --------------------------------------------------------------------------
  // TODO assertion 3:
  // Rule: transfer_count should only increment when VALID && READY.
  //
  // Name: p_transfer_count_only_on_fire
  //
  // Hints:
  // - The checker has transfer_count as an input.
  // - A transfer is often called a "fire": vr.valid && vr.ready.
  // - Look for a change in transfer_count, then require that a fire happened.
  // - $past(...) may be useful, but be careful around reset.
  //
  // Starter skeleton, intentionally commented out so the project compiles:
  //
  // property p_transfer_count_only_on_fire;
  //   @(posedge vr.clk) disable iff (!vr.rst_n)
  //     (/* transfer_count changed */) |-> (/* valid and ready fired */);
  // endproperty
  //
  // assert property (p_transfer_count_only_on_fire)
  //   else $error("ASSERTION FAILED: transfer_count changed without valid && ready at time %0t", $time);

property p_transfer_count_increments_after_fire;

    @(posedge vr.clk) disable iff (!vr.rst_n)

      (vr.valid && vr.ready) |=> (transfer_count == $past(transfer_count) + 32'd1);

  endproperty

  assert property (p_transfer_count_increments_after_fire)

    else $error("ASSERTION FAILED: transfer_count did not increment after VALID && READY at time %0t", $time);
  

endmodule
