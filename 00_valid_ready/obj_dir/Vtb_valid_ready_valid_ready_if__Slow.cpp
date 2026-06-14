// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_valid_ready.h for the primary calling header

#include "Vtb_valid_ready__pch.h"

void Vtb_valid_ready_valid_ready_if___ctor_var_reset(Vtb_valid_ready_valid_ready_if* vlSelf);

Vtb_valid_ready_valid_ready_if::Vtb_valid_ready_valid_ready_if() = default;
Vtb_valid_ready_valid_ready_if::~Vtb_valid_ready_valid_ready_if() = default;

void Vtb_valid_ready_valid_ready_if::ctor(Vtb_valid_ready__Syms* symsp, const char* namep) {
    vlSymsp = symsp;
    vlNamep = strdup(Verilated::catName(vlSymsp->name(), namep));
    // Reset structure values
    Vtb_valid_ready_valid_ready_if___ctor_var_reset(this);
}

void Vtb_valid_ready_valid_ready_if::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

void Vtb_valid_ready_valid_ready_if::dtor() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
