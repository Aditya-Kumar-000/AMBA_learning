// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_valid_ready.h for the primary calling header

#ifndef VERILATED_VTB_VALID_READY_VALID_READY_IF_H_
#define VERILATED_VTB_VALID_READY_VALID_READY_IF_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vtb_valid_ready__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_valid_ready_valid_ready_if final {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ clk;
    CData/*0:0*/ rst_n;
    CData/*0:0*/ valid;
    CData/*0:0*/ ready;
    IData/*31:0*/ data;

    // INTERNAL VARIABLES
    Vtb_valid_ready__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vtb_valid_ready_valid_ready_if();
    ~Vtb_valid_ready_valid_ready_if();
    void ctor(Vtb_valid_ready__Syms* symsp, const char* namep);
    void dtor();
    VL_UNCOPYABLE(Vtb_valid_ready_valid_ready_if);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};

std::string VL_TO_STRING(const Vtb_valid_ready_valid_ready_if* obj);

#endif  // guard
