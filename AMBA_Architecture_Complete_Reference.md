# AMBA Architecture — Complete Technical Reference

> **Purpose of this document.** This is a single, self-contained, LLM-readable reference for the
> **AMBA (Advanced Microcontroller Bus Architecture)** on-chip interconnect family. It is
> consolidated from three Arm source documents so that an LLM (e.g. ChatGPT, Claude) can answer
> precise questions about AMBA buses, signals, timing, and protocol behavior **without needing the
> originals**:
>
> 1. **ARM IHI 0011A — AMBA Specification (Rev 2.0), 1999** → defines **AHB**, **ASB**, **APB (rev 2.0)** and the AMBA test methodology.
> 2. **ARM IHI 0024E — AMBA APB Protocol Specification, 2023** → the modern **APB (APB2/APB3/APB4/APB5)** definition with `PREADY`, `PSLVERR`, `PPROT`, `PSTRB`, wake-up, user signals, RME.
> 3. **Arm 102202 (Issue 01), 2020 — Introduction to AMBA AXI4** → the **AXI3/AXI4** five-channel protocol.
>
> Every signal name, encoding table, and protocol rule below is drawn from these documents. Where a
> fact is version-specific (Rev 2.0 vs. modern APB, AXI3 vs. AXI4) the version is stated explicitly.

---

## Table of Contents

1. [AMBA at a glance](#1-amba-at-a-glance)
2. [AMBA generations / history](#2-amba-generations--history)
3. [Common terminology](#3-common-terminology)
4. [Signal naming conventions](#4-signal-naming-conventions)
5. [AHB — Advanced High-performance Bus](#5-ahb--advanced-high-performance-bus)
6. [ASB — Advanced System Bus](#6-asb--advanced-system-bus)
7. [APB — Advanced Peripheral Bus](#7-apb--advanced-peripheral-bus)
8. [Bridging: AHB/ASB/AXI ↔ APB](#8-bridging-ahbasbaxi--apb)
9. [AXI — Advanced eXtensible Interface (AXI3/AXI4)](#9-axi--advanced-extensible-interface-axi3axi4)
10. [Cross-protocol comparison](#10-cross-protocol-comparison)
11. [Master quick-reference signal tables](#11-master-quick-reference-signal-tables)
12. [Glossary](#12-glossary)

---

## 1. AMBA at a glance

AMBA defines an on-chip communications standard for designing high-performance embedded
microcontrollers. The Rev 2.0 specification defines **three distinct buses** plus a test methodology:

- **AHB (Advanced High-performance Bus)** — high-performance, high clock frequency system backbone. Connects processors, on-chip memory, external memory interfaces, DMA, and high-bandwidth peripherals. Pipelined, multi-master, supports bursts and split transactions, single-clock-edge, non-tristate.
- **ASB (Advanced System Bus)** — the *first generation* AMBA system bus; an alternative to AHB where AHB's high performance is not required. Pipelined, multi-master, burst transfers, uses **both** clock edges (bidirectional tristate data bus).
- **APB (Advanced Peripheral Bus)** — low-power, low-complexity bus for peripherals. Unpipelined, single master (a bridge), latched address/control, no bursts. Used as a secondary bus hanging off AHB/ASB/AXI through a bridge.

### Objectives of the AMBA specification (IHI 0011A §1.2)

1. Facilitate right-first-time development of embedded microcontrollers with one or more CPUs/DSPs.
2. Be technology-independent so reusable macrocells migrate across IC processes (full-custom, standard cell, gate array).
3. Encourage modular system design for processor independence and peripheral libraries.
4. Minimize silicon infrastructure for efficient on-chip/off-chip communication including manufacturing test.

### Typical AMBA-based microcontroller

A high-performance backbone bus (**AHB or ASB**) carries the CPU, on-chip RAM, external memory
interface, and DMA. A **bridge** connects that backbone to the lower-bandwidth **APB**, where most
peripherals live (UART, Timer, Keypad, PIO, etc.). The APB peripherals are typically memory-mapped
register devices with no high-bandwidth interfaces, accessed under programmed control.

```
 [ARM processor]  [on-chip RAM]
        |              |
        +======= AHB or ASB =======+----[Bridge]----+=== APB ===+
        |                          |                 |  UART     |
 [External Mem I/F]          [DMA master]            |  Timer    |
                                                     |  Keypad   |
                                                     |  PIO      |
                                                     +===========+
```

### Choosing the right bus (IHI 0011A §1.8)

- **AHB is recommended for all new designs** (vs ASB): higher bandwidth and the single-clock-edge protocol integrates more smoothly with synthesis/ASIC tools.
- **Full AHB/ASB interface** for: bus masters, on-chip memory blocks, external memory interfaces, high-bandwidth peripherals with FIFO interfaces, DMA slave peripherals.
- **Simple APB interface** for: simple register-mapped slave devices; very-low-power interfaces where clocks cannot be globally routed; grouping narrow-bus peripherals to avoid loading the system bus.

### Notes on the specification

- **Technology independent:** AMBA only specifies the bus protocol at the clock-cycle level.
- **No electrical characteristics** are defined (process-dependent).
- **Timing is cycle-level only;** exact setup/hold budgets are left to the system integrator and process.

---

## 2. AMBA generations / history

(From the AXI4 introduction, §2.3.)

| Year | Generation | What it added |
|------|-----------|---------------|
| ~1996 | **AMBA / AMBA 1** | **ASB** and **APB**. |
| 1999 | **AMBA 2** | **AHB** — single clock-edge protocol, address phase + data phase, central MUX (one master at a time), pipelined. (APB remains unpipelined for simplicity.) |
| 2003 | **AMBA 3** | **AXI** (Advanced eXtensible Interface), **AHB-Lite** (single-master subset of AHB), and **ATB** (Advanced Trace Bus, part of CoreSight debug/trace). |
| 2010–2011 | **AMBA 4** | **AXI4**, **ACE** (AXI Coherency Extensions, system-wide coherency for e.g. big.LITTLE), **ACE-Lite** (one-way coherency), **AXI4-Stream** (unidirectional master→slave streaming, ideal for FPGAs). |
| 2014 | **AMBA 5** | **CHI** (Coherent Hub Interface) — redesigned high-speed transport layer. |
| 2016 | **AHB5** | Updates AHB-Lite to complement Armv8-M; extends TrustZone security from processor to system. |
| 2019 | **AMBA ATP** | Adaptive Traffic Profiles for modeling memory-access behavior. |

---

## 3. Common terminology

(IHI 0011A §1.4, plus AXI definitions.)

- **Bus cycle** — one bus clock period. For **AHB/APB** a cycle is rising-edge to rising-edge. For **ASB** a cycle is falling-edge to falling-edge. All signal timing is referenced to the bus-cycle clock.
- **Bus transfer** — a read or write of a data object.
  - **AHB/ASB:** may take one or more cycles, terminated by a completion response from the addressed slave. ASB sizes: byte (8), halfword (16), word (32). AHB additionally supports 64-bit and 128-bit (up to 1024-bit) transfers.
  - **APB:** always requires (at least) **two** bus cycles.
- **Burst operation** — one or more data transactions of consistent width to an incremental region of address space; the increment step equals the transfer width (byte/halfword/word). **No burst operation is supported on APB.**
- **Master** — initiates read/write by driving address + control. Only one master actively uses an AHB/ASB at a time.
- **Slave** — responds to a read/write within its address range; signals success/failure/wait back to the master.
- **Arbiter** — ensures only one master uses the bus at a time (one per AHB/ASB system).
- **Decoder** — decodes the transfer address and selects the appropriate slave (one centralized decoder per AHB/ASB system).
- **AXI-specific:**
  - **Transfer** — a single information exchange, one VALID/READY handshake.
  - **Transaction** — an entire burst: one address transfer plus one or more data transfers (+ a write response for writes).
  - **Active / outstanding transaction** — started but not yet fully completed (see §9.7).

> **Master/Slave vs Requester/Completer:** The older specs (AHB/ASB/APB Rev 2.0, AXI3/AXI4) use
> **master/slave**. The modern APB spec (IHI 0024E) uses **Requester** (the bridge driving the
> transfer) and **Completer** (the peripheral). They are the same roles renamed.

---

## 4. Signal naming conventions

(IHI 0011A §2.1.) Every AMBA signal's **first letter indicates which bus** it belongs to. A lower-case
`n` in a name means **active LOW**; otherwise names are all upper case and active HIGH.

| Prefix | Bus / meaning |
|--------|----------------|
| `H` | AHB signal (e.g. `HREADY`, active HIGH). |
| `B` | ASB signal (e.g. `BnRES`, active LOW reset). |
| `A` | Unidirectional signal between ASB **bus masters and the arbiter** (e.g. `AREQx`, `AGNTx`). |
| `D` | Unidirectional ASB **decoder** signal (e.g. `DSELx`). |
| `P` | APB signal (e.g. `PCLK`, `PSEL`). |
| `AW/W/B/AR/R` | AXI channel prefixes (Write Address / Write Data / Write Response / Read Address / Read Data). |
| `T` | Test signal (regardless of bus type — AMBA test methodology). |

---

## 5. AHB — Advanced High-performance Bus

### 5.1 Overview & key features

AHB is the high-performance system backbone bus for high clock-frequency synthesizable designs.
Features: **burst transfers**, **split transactions**, **single-cycle bus master handover**,
**single-clock-edge operation**, **non-tristate implementation** (separate read/write data buses),
and **wide data buses (64/128 bits and beyond)**.

Components in a typical AHB system:

- **AHB master** — initiates reads/writes by driving address + control. Only one master uses the bus at a time.
- **AHB slave** — responds within its address range; signals success / failure / wait.
- **AHB arbiter** — guarantees one master at a time. Protocol is fixed; *algorithm* (priority, fair, etc.) is implementation-defined. Exactly **one arbiter** per system.
- **AHB decoder** — centralized address decode producing a select (`HSELx`) per slave. Exactly **one decoder** per system.

Interconnection uses a **central multiplexor** scheme (not tristate): each master drives its address/data
onto shared lines, and the address-and-control MUX (driven by `HMASTER`) selects the active master's
signals; a read-data MUX selects the responding slave.

### 5.2 AHB signal list (IHI 0011A Table 2-1)

All AHB signals are prefixed `H`.

| Signal | Source | Description |
|--------|--------|-------------|
| `HCLK` | Clock source | Bus clock; **all timing referenced to the rising edge** of HCLK. |
| `HRESETn` | Reset controller | Bus/system reset, **active LOW**. The only active-LOW AHB signal. |
| `HADDR[31:0]` | Master | 32-bit system address bus. |
| `HTRANS[1:0]` | Master | Transfer type: IDLE, BUSY, NONSEQ, SEQ. |
| `HWRITE` | Master | HIGH = write, LOW = read. |
| `HSIZE[2:0]` | Master | Transfer size — byte/halfword/word … up to 1024 bits. |
| `HBURST[2:0]` | Master | Burst type — 4/8/16-beat, incrementing or wrapping, single, or undefined length. |
| `HPROT[3:0]` | Master | Protection control (opcode/data, user/privileged, bufferable, cacheable). |
| `HWDATA[31:0]` | Master | Write data bus (master→slave). Min width 32 bits, extendable. |
| `HSELx` | Decoder | Per-slave select; combinatorial decode of the address bus. |
| `HRDATA[31:0]` | Slave | Read data bus (slave→master). Min width 32 bits, extendable. |
| `HREADY` | Slave | HIGH = transfer finished; driven LOW to insert wait states. **Slaves need it as both input and output.** |
| `HRESP[1:0]` | Slave | Transfer response: OKAY, ERROR, RETRY, SPLIT. |

**Arbitration signals (IHI 0011A Table 2-2).** Many are dedicated point-to-point links; suffix `x` = from module X.

| Signal | Source | Description |
|--------|--------|-------------|
| `HBUSREQx` | Master | Bus request from master x. Up to **16 masters** per system. |
| `HLOCKx` | Master | HIGH = master requires locked (indivisible) access; no other master granted until LOW. |
| `HGRANTx` | Arbiter | Master x is currently highest priority. Master gains the bus when **both** `HGRANTx` **and** `HREADY` are HIGH at the rising edge of HCLK. |
| `HMASTER[3:0]` | Arbiter | Which master is performing the current transfer; used by SPLIT-capable slaves. Timing aligned with address/control. |
| `HMASTLOCK` | Arbiter | Current master is performing a locked sequence; same timing as `HMASTER`. |
| `HSPLITx[15:0]` | SPLIT-capable Slave | 16-bit split bus telling the arbiter which masters may re-attempt a split transaction (one bit per master). |

### 5.3 Basic transfer (pipelined address + data)

An AHB transfer has two sections:

- **Address phase** — lasts a single cycle.
- **Data phase** — may take several cycles, extended via `HREADY`.

The **address phase of one transfer overlaps the data phase of the previous transfer** — this pipelining
is fundamental to AHB performance.

Simple transfer with no wait states:
1. Master drives address + control after the rising edge of HCLK.
2. Slave samples address/control on the next rising edge.
3. Slave drives the response; master samples it on the third rising edge.

**Wait states:** a slave drives `HREADY` LOW to extend a transfer. For **writes**, the master holds write
data stable through the extended cycles. For **reads**, the slave need only present valid data as the
transfer is about to complete (`HREADY` HIGH). Extending one transfer's data phase also extends the
*following* transfer's address phase.

### 5.4 Transfer types — `HTRANS[1:0]` (Table 3-1)

| `HTRANS[1:0]` | Type | Meaning |
|---------------|------|---------|
| `00` | **IDLE** | No data transfer wanted (master granted but idle). Slave must give a **zero-wait-state OKAY** and ignore it. |
| `01` | **BUSY** | Master is mid-burst but not ready for the next beat; inserts idle cycles inside a burst. Address/control reflect the **next** beat. Slave must give zero-wait OKAY and ignore. |
| `10` | **NONSEQ** | First transfer of a burst, or a single transfer. Address/control unrelated to previous transfer. (Singles are treated as bursts of one → NONSEQ.) |
| `11` | **SEQ** | Remaining beats of a burst. Address = previous address + size (in bytes); control identical to previous. For wrapping bursts the address wraps at `size × beats`. |

### 5.5 Burst operation — `HBURST[2:0]` (Table 3-2)

| `HBURST[2:0]` | Type | Description |
|---------------|------|-------------|
| `000` | **SINGLE** | Single transfer. |
| `001` | **INCR** | Incrementing burst of **unspecified** length. |
| `010` | **WRAP4** | 4-beat wrapping burst. |
| `011` | **INCR4** | 4-beat incrementing burst. |
| `100` | **WRAP8** | 8-beat wrapping burst. |
| `101` | **INCR8** | 8-beat incrementing burst. |
| `110` | **WRAP16** | 16-beat wrapping burst. |
| `111` | **INCR16** | 16-beat incrementing burst. |

Rules:
- **Incrementing** bursts access sequential addresses (address = previous + size).
- **Wrapping** bursts wrap at the `size × beats` boundary. Example: a 4-beat word (4-byte) wrapping burst starting at `0x34` → `0x34, 0x38, 0x3C, 0x30` (wraps at 16-byte boundary).
- **Bursts must not cross a 1KB address boundary.** Masters must not start a fixed-length incrementing burst that would cross it.
- Burst length is **beats**, not bytes; total bytes = beats × (bytes per beat from `HSIZE`).
- All transfers within a burst must be **aligned** to the transfer size (word → `A[1:0]=00`; halfword → `A[0]=0`).
- A single transfer may be done as an unspecified-length INCR of length one.

**Early burst termination:** a burst may not complete (e.g. the master loses the bus). A slave detects
early termination by watching `HTRANS`: after a burst starts, every beat should be SEQ or BUSY; a
NONSEQ or IDLE means a new burst started (so the previous one ended). If a master loses the bus
mid-burst it must rebuild the remainder using a legal burst encoding (e.g. complete 1 of 4 beats → use a
3-beat undefined-length burst for the rest).

### 5.6 Control signals (IHI 0011A §3.7)

Control signals have the **same timing as the address bus** and must remain constant throughout a burst.

**Transfer direction:** `HWRITE` HIGH = write (master drives `HWDATA`), LOW = read (slave drives `HRDATA`).

**Transfer size — `HSIZE[2:0]` (Table 3-3):**

| `HSIZE[2:0]` | Size | Name |
|--------------|------|------|
| `000` | 8 bits | Byte |
| `001` | 16 bits | Halfword |
| `010` | 32 bits | Word |
| `011` | 64 bits | — |
| `100` | 128 bits | 4-word line |
| `101` | 256 bits | 8-word line |
| `110` | 512 bits | — |
| `111` | 1024 bits | — |

**Protection control — `HPROT[3:0]` (Table 3-4):** additional access info, intended for modules
implementing protection. Not all masters generate accurate values, so slaves should avoid using `HPROT`
unless strictly necessary.

| Bit | Name | `0` | `1` |
|-----|------|-----|-----|
| `HPROT[0]` | data / opcode | Opcode fetch | Data access |
| `HPROT[1]` | privileged | User access | Privileged access |
| `HPROT[2]` | bufferable | Not bufferable | Bufferable |
| `HPROT[3]` | cacheable | Not cacheable | Cacheable |

### 5.7 Address decoding (IHI 0011A §3.8)

A **central decoder** drives `HSELx` for each slave; `HSELx` is a combinatorial decode of high-order
address bits. A slave must sample address/control + `HSELx` **only when `HREADY` is HIGH** (the
current transfer is completing).

- **Minimum slave address space = 1KB.** Combined with the 1KB burst-boundary rule, a burst never crosses a decode boundary.
- **Default slave:** for unfilled memory maps, a default slave responds to nonexistent locations — **ERROR** for NONSEQ/SEQ transfers, **zero-wait OKAY** for IDLE/BUSY. Usually built into the central decoder.

### 5.8 Slave transfer responses — `HRESP[1:0]` (Table 3-5)

No master can cancel a transfer once started. The slave drives `HREADY` (to extend) and `HRESP`
(status). A slave can: complete immediately; insert wait states; signal an error; or back off (SPLIT/RETRY).

| `HRESP[1:0]` | Response | Meaning |
|--------------|----------|---------|
| `00` | **OKAY** | Transfer completed successfully (when `HREADY` HIGH). Also used for wait-state cycles (`HREADY` LOW) before one of the other three responses. |
| `01` | **ERROR** | Transfer failed (e.g. protection error such as writing read-only memory). **Two-cycle** response. |
| `10` | **RETRY** | Not yet complete; master should retry until it completes. Arbiter keeps the **normal priority** scheme (only higher-priority masters get the bus). **Two-cycle** response. |
| `11` | **SPLIT** | Not yet complete; master must retry when next granted. Slave will request bus access on the master's behalf when ready. Arbiter adjusts priority so **any** other requesting master (even lower priority) can run. **Two-cycle** response. |

**Two-cycle response mechanism:** Only OKAY can be given in a single cycle. For ERROR/RETRY/SPLIT,
in the **penultimate** cycle the slave drives `HRESP` to the response while holding `HREADY` LOW; in the
**final** cycle it drives `HREADY` HIGH with `HRESP` still indicating the response. Extra leading wait
states (with `HREADY` LOW, `HRESP`=OKAY) are allowed if the slave needs more than two cycles. The
two-cycle requirement exists because the pipeline has already broadcast the *next* address — the two
cycles give the master time to cancel it and drive `HTRANS`=IDLE.

- For **SPLIT/RETRY** the following (already-broadcast) transfer **must** be cancelled.
- For **ERROR** the master may cancel remaining burst beats or continue them (optional); completing the following transfer is optional.

**SPLIT vs RETRY:** Both free the bus. RETRY only lets higher-priority masters in; SPLIT completely
frees the bus (the arbiter masks the split master's request until the slave signals completion via
`HSPLITx`). A master treats SPLIT and RETRY identically: keep requesting and retrying until OKAY or
ERROR. Slaves should have a predetermined max wait-state count; **recommended (not mandatory): ≤16
wait states** to avoid locking the bus.

### 5.9 Data buses & endianness (IHI 0011A §3.10)

Separate `HWDATA` (write) and `HRDATA` (read) buses avoid tristate. Minimum width 32 bits.

- For narrow transfers on a wider bus, only the appropriate **byte lanes** are active; the slave selects write data from the correct lanes, the master selects read data from the correct lanes.
- Valid read data is only required on an **OKAY** completion; SPLIT/RETRY/ERROR need no valid read data.
- **Endianness is not specified by AHB** — but **all masters/slaves/bridges must share the same endianness.** Dynamic endianness is not supported.

**Active byte lanes, 32-bit little-endian (Table 3-6):**

| Size | Addr offset | `[31:24]` | `[23:16]` | `[15:8]` | `[7:0]` |
|------|-------------|-----------|-----------|----------|---------|
| Word | 0 | Y | Y | Y | Y |
| Halfword | 0 | – | – | Y | Y |
| Halfword | 2 | Y | Y | – | – |
| Byte | 0 | – | – | – | Y |
| Byte | 1 | – | – | Y | – |
| Byte | 2 | – | Y | – | – |
| Byte | 3 | Y | – | – | – |

**Active byte lanes, 32-bit big-endian (Table 3-7):**

| Size | Addr offset | `[31:24]` | `[23:16]` | `[15:8]` | `[7:0]` |
|------|-------------|-----------|-----------|----------|---------|
| Word | 0 | Y | Y | Y | Y |
| Halfword | 0 | Y | Y | – | – |
| Halfword | 2 | – | – | Y | Y |
| Byte | 0 | Y | – | – | – |
| Byte | 1 | – | Y | – | – |
| Byte | 2 | – | – | Y | – |
| Byte | 3 | – | – | – | Y |

### 5.10 Arbitration (IHI 0011A §3.11)

The arbiter observes requests and grants one master at a time; it also receives SPLIT-completion
requests from slaves.

- **Requesting:** master asserts `HBUSREQx` in any cycle. For **fixed-length** bursts the master need not keep requesting — the arbiter watches `HBURST` to know how many beats remain. For **undefined-length (INCR)** bursts the master must keep asserting the request until it starts the last transfer. A master may be granted when not requesting (default master) — so an unneeded grant must be driven as IDLE.
- **Granting:** arbiter asserts `HGRANTx`; the master gains the **address bus** when `HGRANTx` and `HREADY` are both HIGH at the HCLK rising edge. The arbiter sets `HMASTER[3:0]` to the granted master number. Because of the central MUX, each master can drive out its desired address immediately; `HGRANTx` only tells it when the address has actually been sampled.
- **Data bus ownership** is delayed relative to address bus ownership: when a transfer completes (`HREADY` HIGH) the address-bus owner takes the data bus until its transfer completes. A delayed version of `HMASTER` controls the write-data MUX.
- **Handover at burst end:** arbiter changes `HGRANTx` when the **penultimate** address is sampled; the new grant is sampled with the last address of the burst.
- **Early burst termination:** arbiter may move the grant before a burst completes (to bound access latency); the losing master must re-arbitrate and use a legal burst encoding for the remainder.
- **Locked transfers:** `HLOCKx` must be asserted **at least one cycle before** the address it refers to. The arbiter grants no other master until the locked sequence ends, and keeps the master granted for **one extra** transfer afterwards (to confirm the last locked transfer didn't get SPLIT/RETRY). It is recommended (not mandatory) that the master insert an IDLE after a locked sequence. The arbiter asserts `HMASTLOCK` (same timing as address/control).
- **Default bus master:** every system must include one, granted when no other master can use the bus; it must drive only IDLE transfers. Used to quiesce the bus before low-power modes, and granted when all masters are awaiting SPLIT completions.

### 5.11 SPLIT transfers in detail (IHI 0011A §3.12)

SPLIT improves bus utilization by separating address delivery from the slave's (slow) data response.

Sequence:
1. Master starts the transfer normally (address + control). The arbiter broadcasts the master number (tag) on `HMASTER[3:0]`.
2. If the slave will be slow, it returns a **SPLIT** response and **records the master number**.
3. The arbiter masks that master's request, lets other masters use the bus (or grants the default master if all are split), and handover occurs.
4. When ready, the slave asserts the bit for that master on `HSPLITx[15:0]` (one cycle is enough — the arbiter samples `HSPLITx` every cycle).
5. The arbiter restores that master's priority; the master is regranted and retries; the transfer completes.

Multiple SPLIT-capable slaves' `HSPLITx` buses can be **OR-ed** into one `HSPLIT` bus to the arbiter.
The arbiter needs only as many bits as there are masters, but slaves should be designed to support up to
**16 masters**.

### 5.12 Reset & timing parameters

- `HRESETn` is active LOW and is the only active-LOW AHB signal; it resets the system and bus.
- AMBA does not fix absolute timing; IHI 0011A defines named cycle-level setup/hold parameters per component, e.g.:
  - **Master inputs:** `Tisgnt/Tihgnt` (grant), `Tisrdy/Tihrdy` (ready), `Tisrsp/Tihrsp` (response), `Tisrd/Tihrd` (read data), `Tisrst/Tihrst` (reset).
  - **Master outputs:** `Tovtr` (transfer type), `Tova/Toha` (address), `Tovctl` (control), `Tovwd` (write data), `Tovreq` (request), `Tovlck` (lock).
  - **Arbiter:** input `Tisreq/Tislck/Tissplt/Tistr/Tisctl`; output `Tovgnt` (grant), `Tovmst` (master number), `Tovmlck` (master-lock).
  - **Decoder:** `Tadsel` — delay from Address to Select valid.

### 5.13 AHB component interface summary

- **AHB slave** inputs: `HSELx, HADDR, HWRITE, HTRANS, HSIZE, HBURST, HWDATA, HMASTER, HMASTLOCK, HREADY (in), HRESETn, HCLK`; outputs: `HRDATA, HREADY (out), HRESP, HSPLITx` (if SPLIT-capable).
- **AHB master** drives `HADDR, HTRANS, HWRITE, HSIZE, HBURST, HPROT, HWDATA, HBUSREQx, HLOCKx`; receives `HGRANTx, HREADY, HRESP, HRDATA`.
- **AHB arbiter** receives `HBUSREQx, HLOCKx, HADDR, HSPLITx, HTRANS, HBURST, HRESP, HREADY`; drives `HGRANTx, HMASTER, HMASTLOCK`.
- **AHB decoder** receives `HADDR`; drives `HSELx` (and typically the default-slave response).

---

## 6. ASB — Advanced System Bus

### 6.1 Overview

ASB is the **first-generation** AMBA system bus: high-performance, pipelined, multi-master, supports
bursts. Unlike AHB it uses a **bidirectional tristate data bus** and both clock phases (an ASB bus cycle
is falling-edge to falling-edge). For new designs Arm recommends AHB instead.

Components: ASB master, ASB slave, ASB decoder (also keeps the bus operational when idle), ASB arbiter
(one per system). Basic flow: arbiter grants a master → master initiates transfers → decoder selects a
slave from high-order address bits → slave returns a response and data moves.

### 6.2 ASB signal list (IHI 0011A Table 2-3)

| Signal | Description |
|--------|-------------|
| `AGNTx` | Arbiter→master x bus grant. Master becomes granted when `AGNTx` is HIGH and `BWAIT` is LOW on a rising edge. One per master. |
| `AREQx` | Master x→arbiter bus request. One per master. |
| `BA[31:0]` | System address bus, driven by the active master. |
| `BCLK` | Bus clock; **both LOW and HIGH phases** control transfers. |
| `BD[31:0]` | **Bidirectional** system data bus (master drives on writes, slave drives on reads). |
| `BERROR` | Slave→ transfer error: HIGH = error, LOW = success. With `BLAST` also indicates a **bus retract**. Driven by the decoder when no slave is selected. |
| `BLAST` | Slave→ last-of-burst indicator. HIGH = decoder must allow time for address decoding (burst ending); LOW = next transfer may continue the burst. With `BERROR` also indicates bus retract. Decoder-driven when no slave selected. |
| `BLOK` | Active master→ locked/indivisible transfers; no other master should get the bus. Used by the arbiter. |
| `BnRES` | Bus reset, **active LOW** (the only active-LOW ASB signal). |
| `BPROT[1:0]` | Protection control (opcode/data, user/privileged); driven by active master, same timing as address. |
| `BSIZE[1:0]` | Transfer size (byte/halfword/word); same timing as address. |
| `BTRAN[1:0]` | Type of the **next** transaction: ADDRESS-ONLY, NONSEQ, or SEQ. Driven by a master when its `AGNTx` is asserted. |
| `BWAIT` | Slave→ wait response. HIGH = need another cycle; LOW = transfer may complete this cycle. Decoder-driven when no slave selected. |
| `BWRITE` | HIGH = write, LOW = read; driven by active master, same timing as address. |
| `DSELx` | Decoder→slave x select. One per slave. |

### 6.3 Transfer types — `BTRAN[1:0]` (Table 4-1)

| `BTRAN[1:0]` | Type | Use |
|--------------|------|-----|
| `00` | **ADDRESS-ONLY** | No data movement. Three uses: (a) IDLE cycles; (b) bus-master handover cycles; (c) speculative address decoding without committing to a transfer. |
| `01` | — | Reserved. |
| `10` | **NONSEQUENTIAL** | Single transfer or first beat of a burst; address unrelated to previous. |
| `11` | **SEQUENTIAL** | Successive burst beats; address related to previous transfer. |

`BTRAN[1]=1` therefore means "a data transfer is required next cycle." `BTRAN` is driven by a master in
the HIGH phase of `BCLK` while `AGNTx` is HIGH, and is only valid once the previous transfer
completed (`BWAIT` LOW), because the driving master can change mid-transfer.

**Transfer direction — `BWRITE` (Table 4-2):** `0` = read, `1` = write.

**Transfer size — `BSIZE[1:0]` (Table 4-3):** `00` byte (8b), `01` halfword (16b), `10` word (32b), `11` reserved.

**Protection — `BPROT[1:0]` (Table 4-4):** `[0]` = 0 opcode fetch / 1 data access; `[1]` = 0 user / 1 privileged.

### 6.4 ADDRESS-ONLY transfers

A single-cycle transfer with no slave access (`BWAIT` driven LOW by the decoder). Only `BTRAN` (next
type) and `BLOK` (to keep arbitration going) must be valid; address/control may be invalid. Three uses:
true IDLE; **speculative address broadcast** (lets the decoder pre-decode so a following SEQ can start the
burst without an extra DECODE cycle); and **turnaround during handover** — a newly granted master must
start with an ADDRESS-ONLY transfer, driving real address/control only in the LOW phase of `BCLK`.

### 6.5 Address decode (IHI 0011A §4.4)

A centralized decoder uses the transfer type to choose behavior:

- **ADDRESS-ONLY:** decoder responds DONE, no slave selected; pre-decodes speculatively.
- **NONSEQUENTIAL** (or after a LAST response): decoder inserts a single wait state — the **DECODE cycle** — during which no `DSELx` is asserted, allowing time for address decode. In the second cycle it either selects the slave (`DSELx`) or returns an **ERROR**. ERROR is given when: no slave at the address; access to a protected region; or an alignment the memory system doesn't support.
- **SEQUENTIAL:** decoder asserts `DSELx` and the slave responds; no re-decode needed. The slave (or the decoder's internal LAST detection) must give a **LAST** response if the burst is about to cross a memory boundary.

In low-frequency systems the DECODE cycle may be omitted entirely.

### 6.6 Transfer response (IHI 0011A §4.5)

The response is driven during the **LOW phase** of the clock, via `BWAIT`, `BERROR`, `BLAST`:

| Response | Meaning |
|----------|---------|
| **WAIT** | Transfer must be extended before it can complete (`BWAIT` HIGH). |
| **DONE** | Transfer completed successfully. |
| **ERROR** | Transfer completed but an error occurred. |
| **LAST** | Completed successfully, but the slave cannot accept further burst beats / a memory boundary is reached. To the master this is identical to DONE; to the decoder it means "insert a DECODE cycle next transfer." |
| **RETRACT** | Transfer not yet completed; master should retry. Frees the bus so a higher-priority master can run; used by slaves with long/uncertain completion times to avoid deadlocking the bus. |

**RETRACT is a two-stage response:**
- Stage 1 — **RETNEXT**: slave signals a retract is coming with `BWAIT`, `BLAST`, `BERROR` **all HIGH**.
- Stage 2 — **RETRACT**: transfer completes with `BWAIT` LOW, `BLAST` and `BERROR` both HIGH.

This warns the master not to treat the transfer as complete when `BWAIT` goes LOW. **All masters must
support RETRACT;** not all slaves need implement it. The decoder provides the response when the transfer
is ADDRESS-ONLY, targets empty memory, or violates a protected region.

### 6.7 Multi-master operation & reset

A potential next master becomes granted when `AGNTx` is HIGH and `BWAIT` is LOW on a rising edge,
then starts with an ADDRESS-ONLY (turnaround) transfer. `BLOK` enforces indivisible (locked)
sequences. `BnRES` (active LOW) resets the bus.

---

## 7. APB — Advanced Peripheral Bus

> APB exists in two materially different definitions covered here:
> **(A)** the original **APB Rev 2.0** (IHI 0011A Chapter 5), and
> **(B)** the modern **APB (APB2/APB3/APB4/APB5)** of **IHI 0024E**, which adds `PREADY`,
> `PSLVERR`, `PPROT`, `PSTRB`, wake-up, user, and RME signals. Modern designs use (B).

### 7.1 APB characteristics (both versions)

- **Low power, low complexity, unpipelined.** Optimized for minimal power and simple peripheral interfaces.
- Appears as a **single AHB/ASB/AXI slave** encapsulated behind a **bridge**.
- **All signal transitions reference the rising edge of `PCLK`** (the "rev D"/modern improvement over earlier latch-based APB). Benefits: easier high-frequency operation, mark-space-ratio independence, simpler static timing analysis, automatic test insertion, better library register selection, cycle-based simulation.
- **Every transfer takes at least two cycles** (Setup + Access). **No bursts.**
- Address and control are valid throughout the access (unpipelined); write data is valid for the whole access; zero-power when idle (the peripheral bus is static when not in use).

### 7.2 APB Rev 2.0 signal list (IHI 0011A Table 2-4)

All prefixed `P`. (`PCLK`/reset may connect directly to the system bus equivalents.)

| Signal | Description |
|--------|-------------|
| `PCLK` | APB clock; rising edge times all APB transfers. |
| `PRESETn` | APB reset, active LOW; normally tied to the system bus reset. |
| `PADDR[31:0]` | APB address bus (up to 32 bits), driven by the bridge. |
| `PSELx` | Per-slave select from the bridge's secondary decoder; indicates that slave x is selected and a transfer is required. |
| `PENABLE` | Strobe marking the **second cycle** of an APB transfer; its rising edge occurs in the middle of the transfer. |
| `PWRITE` | HIGH = write, LOW = read. |
| `PRDATA` | Read data bus (slave→bridge), driven on reads. Up to 32 bits. |
| `PWDATA` | Write data bus (bridge→slave), driven on writes. Up to 32 bits. |

### 7.3 Modern APB signal list (IHI 0024E Table 2-1)

Source column: **Requester** = the bridge driving the bus; **Completer** = the peripheral.

| Signal | Source | Width | Description |
|--------|--------|-------|-------------|
| `PCLK` | Clock | 1 | Clock; all APB signals timed to its rising edge. |
| `PRESETn` | System reset | 1 | Reset, active LOW; normally tied to system bus reset. |
| `PADDR` | Requester | `ADDR_WIDTH` (≤32) | Byte address bus. |
| `PPROT` | Requester | 3 | Protection type (normal/privileged, secure/non-secure, data/instruction). |
| `PNSE` | Requester | 1 | Extension to protection type for **RME** (Realm Management Extension). |
| `PSELx` | Requester | 1 | One per Completer; selects the Completer and signals a transfer. |
| `PENABLE` | Requester | 1 | Marks the second (and subsequent) cycles of a transfer. |
| `PWRITE` | Requester | 1 | HIGH = write, LOW = read. |
| `PWDATA` | Requester | `DATA_WIDTH` (8/16/32) | Write data (valid when `PWRITE` HIGH). |
| `PSTRB` | Requester | `DATA_WIDTH/8` | Write **byte strobes**; `PSTRB[n]` ↔ `PWDATA[8n+7:8n]`. Must be LOW (inactive) on reads. |
| `PREADY` | Completer | 1 | Ready; Completer drives LOW to insert wait states / extend the transfer. |
| `PRDATA` | Completer | `DATA_WIDTH` (8/16/32) | Read data (valid when `PWRITE` LOW). |
| `PSLVERR` | Completer | 1 | **Optional** transfer error; HIGH = error. |
| `PWAKEUP` | Requester | 1 | Indicates activity on the APB interface (wake-up signaling). |
| `PAUSER` | Requester | `USER_REQ_WIDTH` (≤128 rec.) | User request attribute. |
| `PWUSER` | Requester | `USER_DATA_WIDTH` (≤`DATA_WIDTH/2` rec.) | User write-data attribute. |
| `PRUSER` | Completer | `USER_DATA_WIDTH` (≤`DATA_WIDTH/2` rec.) | User read-data attribute. |
| `PBUSER` | Completer | `USER_RESP_WIDTH` (≤16 rec.) | User response attribute. |

> `PADDR` indicates a **byte address** and may be unaligned to the data width, but the result of an
> unaligned access is **UNPREDICTABLE**.

### 7.4 APB operating states (IHI 0024E Chapter 4)

```
        ┌────────┐  no transfer
        │  IDLE  │◄───────────────┐
        └───┬────┘                │
   transfer │ (assert PSELx)      │ PREADY=1 & no more transfers
            ▼                     │
        ┌────────┐                │
        │ SETUP  │  (1 cycle only)│
        └───┬────┘                │
            ▼ always              │
        ┌────────┐                │
        │ ACCESS │  PENABLE=1     │
        └───┬────┘                │
   PREADY=0 │ stay in ACCESS      │
   PREADY=1 └─────────────────────┘  (or → SETUP if another transfer follows)
```

- **IDLE** — default state.
- **SETUP** — entered when a transfer is required; `PSELx` asserted; lasts **exactly one cycle**; always moves to ACCESS.
- **ACCESS** — `PENABLE` asserted. The address `PADDR`, direction `PWRITE`, select `PSEL`, write data `PWDATA`, `PPROT`, `PAUSER` etc. **must not change** between SETUP→ACCESS or between ACCESS cycles. Exit is controlled by `PREADY`: if `PREADY` LOW, stay in ACCESS (wait state); if `PREADY` HIGH, exit — back to IDLE if no more transfers, or to SETUP for the next transfer.

### 7.5 APB transfers (IHI 0024E Chapter 3)

All signals sampled on the rising edge of `PCLK`.

**Write, no wait states:** T1 = Setup phase (`PSEL` asserted; `PADDR`, `PWRITE`, `PWDATA` valid). T2 =
Access phase (`PENABLE` asserted; `PREADY` HIGH means data accepted at T3). At end, `PENABLE`
deasserts, and `PSEL` deasserts unless another transfer to the same peripheral follows.

**Read, no wait states:** address/`PWRITE`/`PSEL`/`PENABLE` timing same as write; the Completer must
present `PRDATA` before the end of the transfer.

**Wait states:** the Completer drives `PREADY` LOW during the Access phase to extend the transfer (any
number of extra cycles ≥0). While `PREADY` is LOW the following must stay unchanged: `PADDR`,
`PWRITE`, `PSEL`, `PENABLE`, `PPROT`, `PAUSER`.

### 7.6 Write strobes — `PSTRB` (IHI 0024E §3.2)

Enables **sparse writes**: each `PSTRB` bit qualifies one byte lane; `PSTRB[n]` ↔ `PWDATA[8n+7:8n]`.
Example, 32-bit bus → `PSTRB[3:0]` map to bytes `[31:24],[23:16],[15:8],[7:0]`. **On reads, the
Requester must drive all `PSTRB` bits LOW.** `PSTRB` is optional; compatibility when a Requester or
Completer lacks it is defined (tie `PSTRB` inputs to the `PWRITE` output if the Requester has no strobes
but the Completer does; sparse writes simply aren't supported when either side lacks it).

### 7.7 Error response — `PSLVERR` (IHI 0024E §3.4)

- `PSLVERR` indicates an error on read or write. It is **only valid in the last cycle** of a transfer, when `PSEL`, `PENABLE`, and `PREADY` are all HIGH. Recommended (not required) to drive it LOW otherwise.
- A transaction receiving an error **may or may not** have changed peripheral state (peripheral-specific). A write error does **not** guarantee the register was not updated.
- A read error may return invalid data; there's **no requirement** to drive `PRDATA` to zero, and the Requester may still use the data.
- Completers need not support `PSLVERR`; if absent, the Requester's input is tied LOW.
- **Bridge mapping:** AXI→APB maps `PSLVERR` to `RRESP` (reads) / `BRESP` (writes); AHB→APB maps `PSLVERR` to `HRESP` (both).

### 7.8 Protection — `PPROT[2:0]` (IHI 0024E §3.5) & RME

| Bit | Meaning | `0` (LOW) | `1` (HIGH) |
|-----|---------|-----------|------------|
| `PPROT[0]` | Normal / Privileged | Normal access | Privileged access |
| `PPROT[1]` | Secure / Non-secure | Secure access | Non-secure access |
| `PPROT[2]` | Data / Instruction | Data access | Instruction access (a **hint**, not always accurate) |

The primary use of `PPROT` is identifying Secure vs Non-secure transactions.

**RME (Realm Management Extension):** `PNSE` together with `PPROT[1]` selects the physical address space:

| `PNSE` | `PPROT[1]` | Physical address space |
|--------|-----------|------------------------|
| 0 | 0 | Secure |
| 0 | 1 | Non-secure |
| 1 | 0 | Root |
| 1 | 1 | Realm |

---

## 8. Bridging: AHB/ASB/AXI ↔ APB

The **APB bridge** is the single APB Requester/master. It appears as a slave on the system bus and:

- Latches address, data, and control from the system bus.
- Provides a **second level of decode** to generate `PSELx` for each APB peripheral.
- Handles the bus handshake and control-signal retiming on behalf of the peripheral bus.
- Converts AHB/ASB/AXI transfers into the APB Setup/Access two-cycle sequence.

Error mapping when bridging to APB (modern APB): APB `PSLVERR` → `HRESP` (from AHB) or →
`RRESP`/`BRESP` (from AXI). IHI 0011A Chapter 5 also covers interfacing rev D APB peripherals to rev
2.0 APB and the AHB↔APB / ASB↔APB bridge state behavior.

---

## 9. AXI — Advanced eXtensible Interface (AXI3/AXI4)

### 9.1 Nature of AXI

AXI is a **point-to-point interface specification** between a **master** interface and a **slave** interface —
**not a bus specification**. It defines only the signals and timing between interfaces. Master and slave
interfaces are **symmetrical** and contain the same signals, simplifying IP integration. To connect
multiple masters/slaves, an **interconnect fabric** is used; that fabric itself implements master and slave
interfaces (and can convert between AXI3 and AXI4, which commonly coexist in one SoC).

### 9.2 The five channels (§3.2)

| Channel | Prefix | Direction | Carries |
|---------|--------|-----------|---------|
| Write Address | `AW` | master → slave | Address + control for a write. |
| Write Data | `W` | master → slave | Write data beats. |
| Write Response | `B` | slave → master | Write completion response. |
| Read Address | `AR` | master → slave | Address + control for a read. |
| Read Data | `R` | slave → master | Read data beats **and** read response. |

- Each channel is **unidirectional**. There is a separate Write Response (`B`) channel; there is **no** separate read response channel because the read response travels with the data on `R`.
- Independent read and write channel sets allow reads and writes simultaneously, maximizing bandwidth.
- **Multiple outstanding addresses** and **out-of-order completion** are supported (via transaction IDs).
- Write data can lead or follow the write address.

### 9.3 Channel handshake — VALID/READY (§4.1)

Every channel uses the same handshake: **`VALID`** (source→destination, "information is available") and
**`READY`** (destination→source, "I can accept it"). A transfer happens on the **rising edge of the clock**
when **both `VALID` and `READY` are HIGH** (it is *not* an asynchronous handshake). Whether master or
slave is "source" depends on the channel — e.g. the master is the source on AR but the destination on R.

### 9.4 Write channel signals (§5.1)

**Write Address (`AW`):**

| Signal | AXI version |
|--------|-------------|
| `AWVALID`, `AWREADY` | AXI3 & AXI4 |
| `AWADDR[31:0]` | AXI3 & AXI4 |
| `AWSIZE[2:0]` | AXI3 & AXI4 |
| `AWBURST[1:0]` | AXI3 & AXI4 |
| `AWCACHE[3:0]` | AXI3 & AXI4 |
| `AWPROT[2:0]` | AXI3 & AXI4 |
| `AWID[x:0]` | AXI3 & AXI4 |
| `AWLEN[3:0]` | **AXI3 only** (up to 16 beats) |
| `AWLEN[7:0]` | **AXI4 only** (up to 256 beats) |
| `AWLOCK[1:0]` | **AXI3 only** |
| `AWLOCK` (1 bit) | **AXI4 only** |
| `AWQOS[3:0]` | **AXI4 only** |
| `AWREGION[3:0]` | **AXI4 only** |
| `AWUSER[x:0]` | **AXI4 only** |

**Write Data (`W`):** `WVALID`, `WREADY`, `WLAST`, `WDATA[x:0]`, `WSTRB[x:0]` (all AXI3 & AXI4);
`WID[x:0]` (**AXI3 only**); `WUSER[x:0]` (**AXI4 only**).

**Write Response (`B`):** `BVALID`, `BREADY`, `BRESP[1:0]`, `BID[x:0]` (AXI3 & AXI4); `BUSER[x:0]` (**AXI4 only**).

### 9.5 Read channel signals (§5.2)

**Read Address (`AR`):** `ARVALID`, `ARREADY`, `ARADDR[31:0]`, `ARSIZE[2:0]`, `ARBURST[1:0]`,
`ARCACHE[3:0]`, `ARPROT[2:0]`, `ARID[x:0]` (AXI3 & AXI4); `ARLEN[3:0]` (**AXI3**) / `ARLEN[7:0]`
(**AXI4**); `ARLOCK[1:0]` (**AXI3**) / `ARLOCK` 1-bit (**AXI4**); `ARQOS[3:0]`, `ARREGION[3:0]`,
`ARUSER[x:0]` (**AXI4 only**).

**Read Data (`R`):** `RVALID`, `RREADY`, `RLAST`, `RDATA[x:0]`, `RRESP[1:0]`, `RID[x:0]` (AXI3 & AXI4);
`RUSER[x:0]` (**AXI4 only**).

> **AXI3 → AXI4 changes:** wider `AxLEN` (longer bursts); `AxLOCK` reduced to 1 bit (locked transfers
> removed, exclusive only); added `AxQOS`, `AxREGION`, and per-channel `xUSER`; **removed `WID`**
> (write-data reordering/interleaving no longer allowed in AXI4).

### 9.6 Transaction attributes

**Length — `AxLEN`:** number of transfers (beats). AXI3 `[3:0]` → **1–16**; AXI4 `[7:0]` → **1–256**.

**Size — `AxSIZE[2:0]`:** max bytes per beat — encodes **1, 2, 4, 8, 16, 32, 64, or 128 bytes**.

**Burst type — `AxBURST[1:0]` (§5.3):**

| Value | Type | Notes | Length | Alignment |
|-------|------|-------|--------|-----------|
| `0b00` | **FIXED** | Same address repeatedly (e.g. FIFO). | 1–16 | Fixed byte lanes from start address + size. |
| `0b01` | **INCR** | Address increments by the transfer size each beat (block transfers). | AXI3 1–16 / AXI4 1–256 | Unaligned starts supported. |
| `0b10` | **WRAP** | Like INCR but wraps at an upper limit back to a lower address (cache-line fills). | 2, 4, 8, or 16 | Start address must be aligned to the transfer size. |
| `0b11` | RESERVED | — | — | — |

**Protection — `AxPROT[2:0]` (§5.4):** `[0]` (P) 1=privileged/0=unprivileged; `[1]` (NS) 1=Non-secure/0=Secure;
`[2]` (I) 1=instruction/0=data (a hint; recommended 0 unless known instruction). Useful for TrustZone.

**Cache — `AxCACHE[3:0]` (§5.5):** `[0]` (B) Bufferable; `[1]` Cacheable (AXI3) / Modifiable (AXI4);
`[2]` (RA) Read-Allocate hint; `[3]` (WA) Write-Allocate hint. If `AxCACHE[2]` or `[3]` is asserted the
transaction must be looked up in caches. If the Cacheable/Modifiable bit `[1]` is not asserted, `[2]` and
`[3]` cannot be asserted.

**Atomicity — `AxLOCK` (§5.8, Ch.6):**
- **Locked** (AXI3 only — *removed in AXI4*): channel stays locked to one master until an unlocked transfer ends the sequence; the interconnect blocks all other masters' access to the slave (performance cost; legacy only).
- **Exclusive** (AXI3 & AXI4): non-blocking semaphore-style access; multiple masters may access the slave but not the same exclusive region simultaneously.
- AXI3 `AxLOCK[1:0]`: `00` Normal, `01` Exclusive, `10` Locked, `11` Reserved. AXI4 `AxLOCK` (1 bit): `0` Normal, `1` Exclusive.

**QoS — `AxQOS[3:0]` (AXI4, §5.9):** 4-bit priority per transaction; `0x0` lowest, `0xF` highest. Default
behavior: a component choosing between transactions processes the higher-QoS one first.

**Region — `AxREGION[3:0]` (AXI4, §5.10):** lets one physical slave interface present up to 16 logical
interfaces at different address-map locations, so the slave needn't decode between them.

**User — `xUSER` (AXI4, §5.11):** optional, implementation-defined extra control info per channel;
not defined by the protocol (interoperability risk if misused).

**Write data strobes — `WSTRB` (§5.7):** one strobe bit per data byte; a master sets a strobe HIGH only for
valid byte lanes (e.g. on a 64-bit bus, `WSTRB=0xFC` means bytes 7..2 valid). Strobes can change between
beats and can be used to early-terminate by zeroing remaining lanes (though the full burst length must
still complete). **No read-side equivalent** — the master simply masks unwanted returned bytes.

### 9.7 Response signaling — `RRESP`/`BRESP` (§5.6)

Both are 2 bits:

| Code | Response | Meaning |
|------|----------|---------|
| `0b00` | **OKAY** | Normal access success (also: exclusive access **failure**). |
| `0b01` | **EXOKAY** | Exclusive access OK — the read or write portion of an exclusive access succeeded. |
| `0b10` | **SLVERR** | Slave error — access reached the slave but it returns an error (e.g. unsupported size, write to read-only). |
| `0b11` | **DECERR** | Decode error — usually from the interconnect: no slave at the address. |

For **reads** there is an `RRESP` for **every beat** of the transaction. For **writes** there is a single
`BRESP` per transaction on the `B` channel. **No early burst termination:** if any beat errors, the full
indicated transaction length must still complete.

### 9.8 Active (outstanding) transactions (§4.8)

- **Active read:** read address transferred but the last read data not yet transferred.
- **Active write:** the write address **or** leading write data transferred, but the write response not yet transferred.

### 9.9 Channel dependencies (§5.12)

- `WLAST` must complete **before** `BVALID` is asserted — in AXI4 all write data *and* the address must be transferred before the master can see a write response (this dependency did not exist in AXI3).
- `RVALID` cannot assert until `ARADDR` has been transferred (the slave needs the address first).
- `WVALID` **can** assert **before** `AWVALID` (write data may lead the address).

### 9.10 Transaction IDs & ordering (§7.2–7.5)

IDs: `AWID`, `WID` (AXI3 only), `BID`, `ARID`, `RID`. Rules:
- All transfers must have an ID; all transfers within a transaction share the same ID.
- **Transactions with the same ID must be ordered**; transactions with **different IDs have no ordering restriction** (can complete out of order). This lets fast-memory accesses bypass slow ones.
- Masters may use multiple IDs (threads); slaves generally need a configurable ID width. Two key parameters: **write ID width** (`AWID/WID/BID`) and **read ID width** (`ARID/RID`).

**Write ordering rules:** (1) write data on `W` must follow the same order as addresses on `AW`;
(2) different-ID transactions may complete in any order; (3) same-ID outstanding transactions must be
performed and complete in order. Interleaving write data of different IDs was allowed in AXI3 but is
**deprecated in AXI4** (hence `WID` removal).

**Read ordering rules:** (1) read data for different IDs has no ordering restriction; (2) read data of
different IDs **may be interleaved** on `R` (distinguished by `RID`); (3) same-ID read data must return in
request order.

**Read vs write channels:** no ordering relationship to each other — they may complete in any order. If a
master needs ordering between a read and a write, it must explicitly wait for one to complete before
issuing the other.

### 9.11 Unaligned transfers & endianness (§7.6–7.7)

- **Unaligned start address:** AXI supports an unaligned start address that affects only the **first** beat; all subsequent beats are aligned. Strobes (`WSTRB`) can also express unaligned/sparse writes.
- **Endianness:** AXI defines byte lanes for little-endian and **big-endian BE-8** (byte-invariant). For a single byte there is no LE/BE difference (uses byte lane 0). BE-8 in AXI eases dynamic-endianness support; configurable-endianness cores (e.g. Arm cores supporting BE-8) reorder bytes internally so nothing is needed at the interconnect level.

### 9.12 Interface attributes (§7.8)

- **Write:** Write issuing capability (max active write transactions a master can generate); Write interleave capability (**AXI3 only**); Write acceptance capability (**AXI3 only**, max a slave can accept); Write interleave depth (active writes a slave can receive data from).
- **Read:** Read issuing capability (max active reads a master can generate); Read acceptance capability (max a slave can accept); Read data reordering depth (active reads a slave can transmit data for, from the earliest transaction).

### 9.13 Exclusive-access behavior (§6.4–6.5)

Slave-side **exclusive access monitor** hardware records the **ID + address** of each exclusive read. An
exclusive write returns **EXOKAY** only if no other master has written that location since the exclusive
read (then the write succeeds and the monitor entry is cleared). If another master modified the location,
the exclusive write returns **OKAY** and is **not** performed — an exclusive failure, and the master must
restart the whole exclusive read→write sequence. This non-blocking scheme gives higher throughput than
LOCK accesses.

---

## 10. Cross-protocol comparison

| Property | APB | ASB | AHB | AXI3/AXI4 |
|----------|-----|-----|-----|-----------|
| Generation | AMBA 1 / refreshed 2023 | AMBA 1 | AMBA 2 | AMBA 3 / AMBA 4 |
| Topology | Bridge + slaves (1 master) | Multi-master shared bus | Multi-master, central MUX | Point-to-point + interconnect |
| Clock edge | Rising (`PCLK`) | Both phases (`BCLK`) | Rising (`HCLK`) | Rising |
| Data bus | Separate `PRDATA`/`PWDATA` | Bidirectional tristate `BD` | Separate `HRDATA`/`HWDATA` | Separate per-channel `WDATA`/`RDATA` |
| Pipelined | No | Yes | Yes (addr/data overlap) | Yes (5 independent channels) |
| Bursts | No | Yes | Yes (1/4/8/16/undef, incr/wrap) | Yes (FIXED/INCR/WRAP; ≤16 AXI3, ≤256 AXI4) |
| Outstanding / OoO | No | No | SPLIT only | Yes, via IDs |
| Min transfer length | 2 cycles | 1+ cycles | 2 phases (addr+data) | 1+ transfers |
| Responses | `PSLVERR` (OK/error) | WAIT/DONE/ERROR/LAST/RETRACT | OKAY/ERROR/RETRY/SPLIT | OKAY/EXOKAY/SLVERR/DECERR |
| Wait mechanism | `PREADY` LOW | `BWAIT` HIGH | `HREADY` LOW | `READY` LOW |
| Atomicity | — | `BLOK` | `HLOCKx` (locked) | Locked (AXI3) / Exclusive (both) |
| Address width | ≤32 (`PADDR`) | 32 (`BA`) | 32 (`HADDR`) | 32 (`AxADDR`, extendable) |

---

## 11. Master quick-reference signal tables

### AHB signals
`HCLK, HRESETn, HADDR[31:0], HTRANS[1:0], HWRITE, HSIZE[2:0], HBURST[2:0], HPROT[3:0],
HWDATA[31:0], HSELx, HRDATA[31:0], HREADY, HRESP[1:0]` + arbitration
`HBUSREQx, HLOCKx, HGRANTx, HMASTER[3:0], HMASTLOCK, HSPLITx[15:0]`.

- `HTRANS`: 00 IDLE, 01 BUSY, 10 NONSEQ, 11 SEQ.
- `HBURST`: 000 SINGLE, 001 INCR, 010 WRAP4, 011 INCR4, 100 WRAP8, 101 INCR8, 110 WRAP16, 111 INCR16.
- `HSIZE`: 000 byte … 010 word … 111 1024-bit.
- `HRESP`: 00 OKAY, 01 ERROR, 10 RETRY, 11 SPLIT.

### ASB signals
`AGNTx, AREQx, BA[31:0], BCLK, BD[31:0], BERROR, BLAST, BLOK, BnRES, BPROT[1:0], BSIZE[1:0],
BTRAN[1:0], BWAIT, BWRITE, DSELx`.

- `BTRAN`: 00 ADDRESS-ONLY, 01 reserved, 10 NONSEQ, 11 SEQ.
- `BSIZE`: 00 byte, 01 halfword, 10 word, 11 reserved.
- Response (BWAIT/BERROR/BLAST): WAIT / DONE / ERROR / LAST / RETRACT (RETNEXT then RETRACT).

### APB signals (modern, IHI 0024E)
`PCLK, PRESETn, PADDR, PPROT[2:0], PNSE, PSELx, PENABLE, PWRITE, PWDATA, PSTRB, PREADY,
PRDATA, PSLVERR, PWAKEUP, PAUSER, PWUSER, PRUSER, PBUSER`. States: IDLE → SETUP → ACCESS.

### AXI signals (per channel)
- `AW`: AWVALID, AWREADY, AWADDR, AWSIZE, AWBURST, AWCACHE, AWPROT, AWID, AWLEN, AWLOCK, AWQOS*, AWREGION*, AWUSER*.
- `W`: WVALID, WREADY, WLAST, WDATA, WSTRB, WID(AXI3), WUSER*.
- `B`: BVALID, BREADY, BRESP, BID, BUSER*.
- `AR`: ARVALID, ARREADY, ARADDR, ARSIZE, ARBURST, ARCACHE, ARPROT, ARID, ARLEN, ARLOCK, ARQOS*, ARREGION*, ARUSER*.
- `R`: RVALID, RREADY, RLAST, RDATA, RRESP, RID, RUSER*. (`*` = AXI4-only.)
- Response: 00 OKAY, 01 EXOKAY, 10 SLVERR, 11 DECERR. Burst: 00 FIXED, 01 INCR, 10 WRAP, 11 reserved.

---

## 12. Glossary

- **Address phase / data phase** — the two parts of an AHB transfer; address lasts one cycle, data may take several.
- **Beat** — one data transfer within a burst.
- **Bridge** — the unit that connects a system bus (AHB/ASB/AXI) to APB; it is the sole APB master/Requester and does secondary address decode.
- **Burst** — a sequence of transfers to a contiguous (or wrapping) address region.
- **Completer** — modern APB term for the peripheral (slave).
- **DECERR** — AXI decode error (no slave at the address).
- **Decode cycle** — an ASB wait cycle inserted on NONSEQ transfers to allow address decoding.
- **Default slave / default master** — fallback slave for unmapped addresses (AHB), and fallback master granted when no real master needs the bus.
- **EXOKAY** — AXI exclusive-access success response.
- **Handover** — change of bus ownership between masters.
- **Interconnect** — fabric connecting multiple AXI masters and slaves; implements master/slave interfaces and can convert between protocol versions.
- **Locked transfer** — indivisible sequence during which no other master is granted (`HLOCKx`/`BLOK`/`AxLOCK` AXI3).
- **Outstanding / active transaction** — issued but not yet completed.
- **Requester** — modern APB term for the bridge (master).
- **RETRACT / RETNEXT** — ASB two-stage "retry later, free the bus" response.
- **SPLIT / RETRY** — AHB responses that free the bus while a slow slave fetches data (SPLIT frees it for any master; RETRY only for higher-priority masters).
- **VALID/READY** — the AXI handshake pair; transfer occurs when both are HIGH at a clock edge.
- **Wait state** — an extra cycle inserted by a slave (`HREADY`/`PREADY` LOW, `BWAIT` HIGH, AXI `READY` LOW) to extend a transfer.
- **Wrapping burst** — a burst whose address wraps at a `size × beats` boundary (used for cache-line fills).

---

### Source documents
- **ARM IHI 0011A** — *AMBA Specification (Rev 2.0)*, ARM Limited, 1999 (AHB, ASB, APB rev 2.0, test methodology).
- **ARM IHI 0024E** — *AMBA APB Protocol Specification*, Arm Ltd, 2003–2023 (ID022823) — modern APB (APB2/3/4/5).
- **Arm 102202, Issue 01** — *Introduction to AMBA AXI4*, Arm Ltd, 2020 (AXI3/AXI4).
