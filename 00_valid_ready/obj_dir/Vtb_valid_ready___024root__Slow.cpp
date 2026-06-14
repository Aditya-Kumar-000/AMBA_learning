// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_valid_ready.h for the primary calling header

#include "Vtb_valid_ready__pch.h"

void Vtb_valid_ready___024root___ctor_var_reset(Vtb_valid_ready___024root* vlSelf);

Vtb_valid_ready___024root::Vtb_valid_ready___024root(Vtb_valid_ready__Syms* symsp, const char* namep)
    : __VdlySched{*symsp->_vm_contextp__}
 {
    vlSymsp = symsp;
    vlNamep = strdup(namep);
    // Reset structure values
    Vtb_valid_ready___024root___ctor_var_reset(this);
}

void Vtb_valid_ready___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vtb_valid_ready___024root::~Vtb_valid_ready___024root() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
