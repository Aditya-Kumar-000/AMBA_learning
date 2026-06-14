// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_valid_ready.h for the primary calling header

#include "Vtb_valid_ready__pch.h"

VL_ATTR_COLD void Vtb_valid_ready___024root___eval_initial__TOP(Vtb_valid_ready___024root* vlSelf);
VlCoroutine Vtb_valid_ready___024root___eval_initial__TOP__Vtiming__0(Vtb_valid_ready___024root* vlSelf);
VlCoroutine Vtb_valid_ready___024root___eval_initial__TOP__Vtiming__1(Vtb_valid_ready___024root* vlSelf);

void Vtb_valid_ready___024root___eval_initial(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___eval_initial\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtb_valid_ready___024root___eval_initial__TOP(vlSelf);
    Vtb_valid_ready___024root___eval_initial__TOP__Vtiming__0(vlSelf);
    Vtb_valid_ready___024root___eval_initial__TOP__Vtiming__1(vlSelf);
}

VlCoroutine Vtb_valid_ready___024root___eval_initial__TOP__Vtiming__0(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___eval_initial__TOP__Vtiming__0\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_valid_ready__DOT__clk = 0U;
    while (true) {
        co_await vlSelfRef.__VdlySched.delay(0x0000000000001388ULL, 
                                             nullptr, 
                                             "tb_valid_ready.sv", 
                                             34);
        vlSelfRef.tb_valid_ready__DOT__clk = (1U & 
                                              (~ (IData)(vlSelfRef.tb_valid_ready__DOT__clk)));
    }
    co_return;
}

VlCoroutine Vtb_valid_ready___024root___eval_initial__TOP__Vtiming__1(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___eval_initial__TOP__Vtiming__1\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_valid_ready__DOT__rst_n = 0U;
    co_await vlSelfRef.__VdlySched.delay(0x0000000000004e20ULL, 
                                         nullptr, "tb_valid_ready.sv", 
                                         39);
    vlSelfRef.tb_valid_ready__DOT__rst_n = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x0000000000030d40ULL, 
                                         nullptr, "tb_valid_ready.sv", 
                                         41);
    VL_FINISH_MT("tb_valid_ready.sv", 42, "");
    co_return;
}

void Vtb_valid_ready___024root___eval_triggers_vec__act(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___eval_triggers_vec__act\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered[0U] = (QData)((IData)(
                                                    ((vlSelfRef.__VdlySched.awaitingCurrentTime() 
                                                      << 1U) 
                                                     | ((IData)(vlSelfRef.tb_valid_ready__DOT__clk) 
                                                        & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_valid_ready__DOT__clk__0))))));
    vlSelfRef.__Vtrigprevexpr___TOP__tb_valid_ready__DOT__clk__0 
        = vlSelfRef.tb_valid_ready__DOT__clk;
}

bool Vtb_valid_ready___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___trigger_anySet__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

void Vtb_valid_ready___024root___nba_sequent__TOP__0(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___nba_sequent__TOP__0\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vdly__tb_valid_ready__DOT__u_sink__DOT__stall_counter 
        = vlSelfRef.tb_valid_ready__DOT__u_sink__DOT__stall_counter;
    if (vlSelfRef.tb_valid_ready__DOT__rst_n) {
        if (((IData)(vlSymsp->TOP__tb_valid_ready__DOT__bus.valid) 
             & (IData)(vlSymsp->TOP__tb_valid_ready__DOT__bus.ready))) {
            vlSelfRef.tb_valid_ready__DOT__u_sink__DOT__transfer_count 
                = ((IData)(1U) + vlSelfRef.tb_valid_ready__DOT__u_sink__DOT__transfer_count);
        }
    } else {
        vlSelfRef.tb_valid_ready__DOT__u_sink__DOT__transfer_count = 0U;
    }
}

void Vtb_valid_ready___024root___nba_sequent__TOP__1(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___nba_sequent__TOP__1\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (vlSelfRef.tb_valid_ready__DOT__rst_n) {
        if (((IData)(vlSymsp->TOP__tb_valid_ready__DOT__bus.valid) 
             & (IData)(vlSymsp->TOP__tb_valid_ready__DOT__bus.ready))) {
            vlSymsp->TOP__tb_valid_ready__DOT__bus.data 
                = ((IData)(1U) + vlSymsp->TOP__tb_valid_ready__DOT__bus.data);
        }
    } else {
        vlSymsp->TOP__tb_valid_ready__DOT__bus.data = 0U;
    }
}

void Vtb_valid_ready___024root___nba_sequent__TOP__2(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___nba_sequent__TOP__2\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSymsp->TOP__tb_valid_ready__DOT__bus.valid = vlSelfRef.tb_valid_ready__DOT__rst_n;
    if (vlSelfRef.tb_valid_ready__DOT__rst_n) {
        vlSelfRef.__Vdly__tb_valid_ready__DOT__u_sink__DOT__stall_counter 
            = (3U & ((IData)(1U) + (IData)(vlSelfRef.tb_valid_ready__DOT__u_sink__DOT__stall_counter)));
        vlSymsp->TOP__tb_valid_ready__DOT__bus.ready 
            = (3U != (IData)(vlSelfRef.tb_valid_ready__DOT__u_sink__DOT__stall_counter));
    } else {
        vlSymsp->TOP__tb_valid_ready__DOT__bus.ready = 0U;
        vlSelfRef.__Vdly__tb_valid_ready__DOT__u_sink__DOT__stall_counter = 0U;
    }
    vlSelfRef.tb_valid_ready__DOT__u_sink__DOT__stall_counter 
        = vlSelfRef.__Vdly__tb_valid_ready__DOT__u_sink__DOT__stall_counter;
}

void Vtb_valid_ready___024root___eval_nba(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___eval_nba\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vtb_valid_ready___024root___nba_sequent__TOP__0(vlSelf);
        vlSelfRef.__Vm_traceActivity[1U] = 1U;
        Vtb_valid_ready___024root___nba_sequent__TOP__1(vlSelf);
        Vtb_valid_ready___024root___nba_sequent__TOP__2(vlSelf);
    }
}

void Vtb_valid_ready___024root___timing_resume(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___timing_resume\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((2ULL & vlSelfRef.__VactTriggered[0U])) {
        vlSelfRef.__VdlySched.resume();
    }
}

void Vtb_valid_ready___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((IData)(1U) + n);
    } while ((0U >= n));
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_valid_ready___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vtb_valid_ready___024root___eval_phase__act(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___eval_phase__act\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VactExecute;
    // Body
    Vtb_valid_ready___024root___eval_triggers_vec__act(vlSelf);
    Vtb_valid_ready___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VactTriggered, vlSelfRef.__VactTriggeredAcc);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtb_valid_ready___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vtb_valid_ready___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    __VactExecute = Vtb_valid_ready___024root___trigger_anySet__act(vlSelfRef.__VactTriggered);
    if (__VactExecute) {
        vlSelfRef.__VactTriggeredAcc.fill(0ULL);
        Vtb_valid_ready___024root___timing_resume(vlSelf);
    }
    return (__VactExecute);
}

bool Vtb_valid_ready___024root___eval_phase__inact(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___eval_phase__inact\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VinactExecute;
    // Body
    __VinactExecute = vlSelfRef.__VdlySched.awaitingZeroDelay();
    if (__VinactExecute) {
        VL_FATAL_MT("tb_valid_ready.sv", 3, "", "ZERODLY: Design Verilated with '--no-sched-zero-delay', but #0 delay executed at runtime");
    }
    return (__VinactExecute);
}

void Vtb_valid_ready___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___trigger_clear__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((IData)(1U) + n);
    } while ((1U > n));
}

bool Vtb_valid_ready___024root___eval_phase__nba(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___eval_phase__nba\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vtb_valid_ready___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        Vtb_valid_ready___024root___eval_nba(vlSelf);
        Vtb_valid_ready___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

void Vtb_valid_ready___024root___eval(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___eval\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VnbaIterCount;
    // Body
    __VnbaIterCount = 0U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vtb_valid_ready___024root___dump_triggers__act(vlSelfRef.__VnbaTriggered, "nba"s);
#endif
            VL_FATAL_MT("tb_valid_ready.sv", 3, "", "DIDNOTCONVERGE: NBA region did not converge after '--converge-limit' of 10000 tries");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        vlSelfRef.__VinactIterCount = 0U;
        do {
            if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VinactIterCount)))) {
                VL_FATAL_MT("tb_valid_ready.sv", 3, "", "DIDNOTCONVERGE: Inactive region did not converge after '--converge-limit' of 10000 tries");
            }
            vlSelfRef.__VinactIterCount = ((IData)(1U) 
                                           + vlSelfRef.__VinactIterCount);
            vlSelfRef.__VactIterCount = 0U;
            do {
                if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                    Vtb_valid_ready___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
                    VL_FATAL_MT("tb_valid_ready.sv", 3, "", "DIDNOTCONVERGE: Active region did not converge after '--converge-limit' of 10000 tries");
                }
                vlSelfRef.__VactIterCount = ((IData)(1U) 
                                             + vlSelfRef.__VactIterCount);
                vlSelfRef.__VactPhaseResult = Vtb_valid_ready___024root___eval_phase__act(vlSelf);
            } while (vlSelfRef.__VactPhaseResult);
            vlSelfRef.__VinactPhaseResult = Vtb_valid_ready___024root___eval_phase__inact(vlSelf);
        } while (vlSelfRef.__VinactPhaseResult);
        vlSelfRef.__VnbaPhaseResult = Vtb_valid_ready___024root___eval_phase__nba(vlSelf);
    } while (vlSelfRef.__VnbaPhaseResult);
}

#ifdef VL_DEBUG
void Vtb_valid_ready___024root___eval_debug_assertions(Vtb_valid_ready___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root___eval_debug_assertions\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
#endif  // VL_DEBUG
