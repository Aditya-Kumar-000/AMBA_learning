// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_valid_ready.h for the primary calling header

#include "Vtb_valid_ready__pch.h"

VL_ATTR_COLD void Vtb_valid_ready_valid_ready_if___ctor_var_reset(Vtb_valid_ready_valid_ready_if* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+          Vtb_valid_ready_valid_ready_if___ctor_var_reset\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16707436170211756652ull);
    vlSelf->rst_n = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1638864771569018232ull);
    vlSelf->valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 4944192500720994163ull);
    vlSelf->ready = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 898948264233693212ull);
    vlSelf->data = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 10363016170300574568ull);
}
