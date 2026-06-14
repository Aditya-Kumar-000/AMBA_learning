// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_valid_ready.h for the primary calling header

#ifndef VERILATED_VTB_VALID_READY___024ROOT_H_
#define VERILATED_VTB_VALID_READY___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"
class Vtb_valid_ready_valid_ready_if;


class Vtb_valid_ready__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_valid_ready___024root final {
  public:
    // CELLS
    Vtb_valid_ready_valid_ready_if* __PVT__tb_valid_ready__DOT__bus;

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ tb_valid_ready__DOT__clk;
    CData/*0:0*/ tb_valid_ready__DOT__rst_n;
    CData/*1:0*/ tb_valid_ready__DOT__u_sink__DOT__stall_counter;
    CData/*1:0*/ __Vdly__tb_valid_ready__DOT__u_sink__DOT__stall_counter;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_valid_ready__DOT__clk__0;
    CData/*0:0*/ __VactPhaseResult;
    CData/*0:0*/ __VinactPhaseResult;
    CData/*0:0*/ __VnbaPhaseResult;
    IData/*31:0*/ tb_valid_ready__DOT__u_sink__DOT__transfer_count;
    IData/*31:0*/ __VactIterCount;
    IData/*31:0*/ __VinactIterCount;
    IData/*31:0*/ __Vi;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggeredAcc;
    VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;
    VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;
    VlDelayScheduler __VdlySched;

    // INTERNAL VARIABLES
    Vtb_valid_ready__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vtb_valid_ready___024root(Vtb_valid_ready__Syms* symsp, const char* namep);
    ~Vtb_valid_ready___024root();
    VL_UNCOPYABLE(Vtb_valid_ready___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
