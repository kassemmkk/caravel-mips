# Caravel Multi-Peripheral User Project

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Project Overview

This project integrates a custom user project into the Caravel SoC with multiple peripheral controllers:

### Requirements
1. **4× SPI Masters** at base address `0x3000_0000`
   - Each SPI master occupies 256 bytes (0x100) of address space
   - SPI0: 0x3000_0000 - 0x3000_00FF
   - SPI1: 0x3000_0100 - 0x3000_01FF  
   - SPI2: 0x3000_0200 - 0x3000_02FF
   - SPI3: 0x3000_0300 - 0x3000_03FF

2. **1× I3C Controller** at base address `0x3000_1000`
   - I3C controller occupies 256 bytes (0x100) of address space
   - I3C0: 0x3000_1000 - 0x3000_10FF

3. **2× GPIO Lines** with edge-detect interrupts at base address `0x3000_2000`
   - GPIO controller occupies 256 bytes (0x100) of address space
   - GPIO0: 0x3000_2000 - 0x3000_20FF
   - Supports edge detection and interrupt generation

### Implementation Plan

#### Phase 1: RTL Design and Integration
- [x] Set up Caravel project structure
- [ ] Create peripheral integration module
- [ ] Implement Wishbone address decoder
- [ ] Integrate CF_SPI IP cores (4 instances)
- [ ] Create I3C controller from scratch
- [ ] Integrate EF_GPIO IP core (2 GPIO lines)
- [ ] Create interrupt aggregation logic
- [ ] Create Wishbone wrapper module

#### Phase 2: Verification
- [ ] Create cocotb testbenches for each peripheral
- [ ] Implement bus functional models
- [ ] Create comprehensive test suite
- [ ] Verify interrupt functionality
- [ ] Run gate-level simulation

#### Phase 3: Physical Implementation
- [ ] Configure OpenLane for user macro
- [ ] Run synthesis and place & route
- [ ] Integrate with user_project_wrapper
- [ ] Generate final GDSII

### Address Map

| Peripheral | Base Address | Size | Description |
|------------|-------------|------|-------------|
| SPI0       | 0x3000_0000 | 256B | SPI Master 0 |
| SPI1       | 0x3000_0100 | 256B | SPI Master 1 |
| SPI2       | 0x3000_0200 | 256B | SPI Master 2 |
| SPI3       | 0x3000_0300 | 256B | SPI Master 3 |
| I3C0       | 0x3000_1000 | 256B | I3C Controller |
| GPIO0      | 0x3000_2000 | 256B | GPIO with interrupts |

### Interrupt Mapping

| Source | user_irq bit | Description |
|--------|-------------|-------------|
| SPI0-3 | user_irq[0] | SPI interrupts (OR'd) |
| I3C0   | user_irq[1] | I3C controller interrupt |
| GPIO0  | user_irq[2] | GPIO edge interrupts |

### Directory Structure

```
├── verilog/rtl/           # RTL source files
│   ├── user_project.v     # Main integration module
│   ├── user_project_wrapper.v  # Caravel wrapper
│   ├── wb_interconnect.v  # Wishbone interconnect
│   ├── i3c_controller.v   # Custom I3C controller
│   └── periph/            # Peripheral instances
├── verilog/dv/            # Verification testbenches
│   └── cocotb/            # Cocotb test suite
├── openlane/              # OpenLane configurations
├── docs/                  # Documentation
│   ├── register_map.md    # Register specifications
│   ├── pad_map.md         # Pad assignments
│   └── integration_notes.md # Integration guide
└── fw/                    # Firmware support
    ├── user_periph.h      # Register definitions
    └── smoke.c            # Basic test firmware
```

## Implementation Status

- [x] Project structure created
- [x] Requirements analysis completed
- [x] RTL design and integration
- [x] Wishbone interconnect implemented
- [x] Address decoding verified
- [x] Interrupt aggregation implemented
- [x] Lint verification passed (Verilator)
- [x] Synthesis verification passed (Yosys)
- [x] Documentation completed
- [ ] Verification testbenches (cocotb)
- [ ] OpenLane PnR flow
- [ ] Final validation

## Synthesis Results

The design successfully synthesizes with Yosys:
- **Total cells**: 7,145
- **Logic gates**: 1,369 
- **Multiplexers**: 1,581
- **Flip-flops**: 1,725 (various types)
- **No latches detected**: ✓
- **No synthesis errors**: ✓

## Getting Started

Refer to [Caravel documentation](https://caravel-sim-infrastructure.readthedocs.io/en/latest/index.html) for setup instructions.
