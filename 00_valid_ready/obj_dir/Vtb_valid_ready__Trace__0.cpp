// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vtb_valid_ready__Syms.h"


void Vtb_valid_ready___024root__trace_chg_0_sub_0(Vtb_valid_ready___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtb_valid_ready___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root__trace_chg_0\n"); );
    // Body
    Vtb_valid_ready___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_valid_ready___024root*>(voidSelf);
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    Vtb_valid_ready___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vtb_valid_ready___024root__trace_chg_0_sub_0(Vtb_valid_ready___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root__trace_chg_0_sub_0\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 0);
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[1U]))) {
        bufp->chgIData(oldp+0,(vlSelfRef.tb_valid_ready__DOT__u_sink__DOT__transfer_count),32);
        bufp->chgCData(oldp+1,(vlSelfRef.tb_valid_ready__DOT__u_sink__DOT__stall_counter),2);
        bufp->chgBit(oldp+2,(vlSymsp->TOP__tb_valid_ready__DOT__bus.valid));
        bufp->chgBit(oldp+3,(vlSymsp->TOP__tb_valid_ready__DOT__bus.ready));
        bufp->chgIData(oldp+4,(vlSymsp->TOP__tb_valid_ready__DOT__bus.data),32);
    }
    bufp->chgBit(oldp+5,(vlSelfRef.tb_valid_ready__DOT__clk));
    bufp->chgBit(oldp+6,(vlSelfRef.tb_valid_ready__DOT__rst_n));
}

void Vtb_valid_ready___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root__trace_cleanup\n"); );
    // Body
    Vtb_valid_ready___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_valid_ready___024root*>(voidSelf);
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
