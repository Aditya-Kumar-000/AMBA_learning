// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_valid_ready.h for the primary calling header

#include "Vtb_valid_ready__pch.h"

VL_ATTR_COLD void Vtb_valid_ready___024root___eval_static(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___eval_static\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__tb_valid_ready__DOT__clk__0 
        = vlSelfRef.tb_valid_ready__DOT__clk;
    do {
        vlSelfRef.__VactTriggeredAcc[vlSelfRef.__Vi] 
            = vlSelfRef.__VactTriggered[vlSelfRef.__Vi];
        vlSelfRef.__Vi = ((IData)(1U) + vlSelfRef.__Vi);
    } while ((0U >= vlSelfRef.__Vi));
}

VL_ATTR_COLD void Vtb_valid_ready___024root___eval_initial__TOP(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___eval_initial__TOP\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSymsp->_vm_contextp__->dumpfile("valid_ready.vcd"s);
    vlSymsp->_traceDumpOpen();
}

VL_ATTR_COLD void Vtb_valid_ready___024root___eval_final(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___eval_final\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vtb_valid_ready___024root___eval_settle(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___eval_settle\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

bool Vtb_valid_ready___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_valid_ready___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(Vtb_valid_ready___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge tb_valid_ready.clk)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 1U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 1 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtb_valid_ready___024root___ctor_var_reset(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___ctor_var_reset\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->tb_valid_ready__DOT__clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 6768075055089156430ull);
    vlSelf->tb_valid_ready__DOT__rst_n = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 7075248209720819035ull);
    vlSelf->tb_valid_ready__DOT__u_sink__DOT__transfer_count = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 8253086181743427888ull);
    vlSelf->tb_valid_ready__DOT__u_sink__DOT__stall_counter = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 4654866012459189158ull);
    vlSelf->__Vdly__tb_valid_ready__DOT__u_sink__DOT__stall_counter = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggeredAcc[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__tb_valid_ready__DOT__clk__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VnbaTriggered[__Vi0] = 0;
    }
    vlSelf->__Vi = 0;
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
