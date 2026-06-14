// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vtb_valid_ready__Syms.h"


VL_ATTR_COLD void Vtb_valid_ready___024root__trace_init_sub__TOP__tb_valid_ready__DOT__bus__0(Vtb_valid_ready___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vtb_valid_ready___024root__trace_init_sub__TOP__0(Vtb_valid_ready___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root__trace_init_sub__TOP__0\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    VL_TRACE_PUSH_PREFIX(tracep, "tb_valid_ready", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BIT(tracep,c+5,0,"clk",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+6,0,"rst_n",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+0,0,"transfer_count",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+1,0,"stall_counter",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 1,0);
    VL_TRACE_DECL_BIT(tracep,c+2,0,"dbg_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+3,0,"dbg_ready",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+4,0,"dbg_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_PUSH_PREFIX(tracep, "bus", VerilatedTracePrefixType::SCOPE_INTERFACE, 0, 0);
    Vtb_valid_ready___024root__trace_init_sub__TOP__tb_valid_ready__DOT__bus__0(vlSelf, tracep);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "u_sink", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+0,0,"transfer_count_o",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+1,0,"stall_counter_o",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 1,0);
    VL_TRACE_DECL_BUS(tracep,c+0,0,"transfer_count",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+1,0,"stall_counter",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 1,0);
    VL_TRACE_PUSH_PREFIX(tracep, "bus", VerilatedTracePrefixType::SCOPE_INTERFACE, 0, 0);
    Vtb_valid_ready___024root__trace_init_sub__TOP__tb_valid_ready__DOT__bus__0(vlSelf, tracep);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "u_source", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_PUSH_PREFIX(tracep, "bus", VerilatedTracePrefixType::SCOPE_INTERFACE, 0, 0);
    Vtb_valid_ready___024root__trace_init_sub__TOP__tb_valid_ready__DOT__bus__0(vlSelf, tracep);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_POP_PREFIX(tracep);
}

VL_ATTR_COLD void Vtb_valid_ready___024root__trace_init_sub__TOP__tb_valid_ready__DOT__bus__0(Vtb_valid_ready___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root__trace_init_sub__TOP__tb_valid_ready__DOT__bus__0\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    VL_TRACE_DECL_BUS(tracep,c+7,0,"DATA_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+5,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+6,0,"rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+2,0,"valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+3,0,"ready",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+4,0,"data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
}

VL_ATTR_COLD void Vtb_valid_ready___024root__trace_init_top(Vtb_valid_ready___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root__trace_init_top\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtb_valid_ready___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vtb_valid_ready___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vtb_valid_ready___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtb_valid_ready___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtb_valid_ready___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vtb_valid_ready___024root__trace_register(Vtb_valid_ready___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root__trace_register\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Vtb_valid_ready___024root__trace_const_0, 0, vlSelf);
    tracep->addFullCb(&Vtb_valid_ready___024root__trace_full_0, 0, vlSelf);
    tracep->addChgCb(&Vtb_valid_ready___024root__trace_chg_0, 0, vlSelf);
    tracep->addCleanupCb(&Vtb_valid_ready___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vtb_valid_ready___024root__trace_const_0_sub_0(Vtb_valid_ready___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtb_valid_ready___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root__trace_const_0\n"); );
    // Body
    Vtb_valid_ready___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_valid_ready___024root*>(voidSelf);
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vtb_valid_ready___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vtb_valid_ready___024root__trace_const_0_sub_0(Vtb_valid_ready___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root__trace_const_0_sub_0\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullIData(oldp+7,(0x00000020U),32);
}

VL_ATTR_COLD void Vtb_valid_ready___024root__trace_full_0_sub_0(Vtb_valid_ready___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtb_valid_ready___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root__trace_full_0\n"); );
    // Body
    Vtb_valid_ready___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_valid_ready___024root*>(voidSelf);
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vtb_valid_ready___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vtb_valid_ready___024root__trace_full_0_sub_0(Vtb_valid_ready___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_valid_ready___024root__trace_full_0_sub_0\n"); );
    Vtb_valid_ready__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullIData(oldp+0,(vlSelfRef.tb_valid_ready__DOT__u_sink__DOT__transfer_count),32);
    bufp->fullCData(oldp+1,(vlSelfRef.tb_valid_ready__DOT__u_sink__DOT__stall_counter),2);
    bufp->fullBit(oldp+2,(vlSymsp->TOP__tb_valid_ready__DOT__bus.valid));
    bufp->fullBit(oldp+3,(vlSymsp->TOP__tb_valid_ready__DOT__bus.ready));
    bufp->fullIData(oldp+4,(vlSymsp->TOP__tb_valid_ready__DOT__bus.data),32);
    bufp->fullBit(oldp+5,(vlSelfRef.tb_valid_ready__DOT__clk));
    bufp->fullBit(oldp+6,(vlSelfRef.tb_valid_ready__DOT__rst_n));
}
