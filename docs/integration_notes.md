# Integration Notes

## Clock and Reset Architecture

### Clock Domain
- **Single clock domain**: All peripherals operate on `wb_clk_i` from Caravel management SoC
- **Clock frequency**: Typically 10-50 MHz depending on Caravel configuration
- **Clock gating**: SPI modules support optional clock gating via GCLK register

### Reset Strategy
- **Synchronous reset**: `wb_rst_i` is synchronous, active high
- **Reset synchronization**: I3C controller internally converts to active-low reset
- **Reset behavior**: All registers reset to documented default values

## Bus Architecture

### Wishbone Interface
- **Protocol**: Wishbone B4 Classic, 32-bit
- **Timing**: Single-cycle read/write operations
- **Address decoding**: Hierarchical decode with 256-byte blocks per peripheral
- **Byte lanes**: Full byte-lane support via `wbs_sel_i`

### Address Map
```
0x3000_0000 - 0x3000_00FF: SPI0
0x3000_0100 - 0x3000_01FF: SPI1  
0x3000_0200 - 0x3000_02FF: SPI2
0x3000_0300 - 0x3000_03FF: SPI3
0x3000_1000 - 0x3000_10FF: I3C Controller
0x3000_2000 - 0x3000_20FF: GPIO Controller
```

### Bus Timing
- **Setup time**: 1 clock cycle
- **Hold time**: 0 clock cycles
- **ACK response**: Exactly 1 cycle after valid access to decoded address
- **Invalid addresses**: No ACK generated, returns 0x00000000

## Interrupt Architecture

### Interrupt Mapping
| Source | user_irq | Type | Description |
|--------|----------|------|-------------|
| SPI0-3 | [0] | Level | OR of all SPI interrupt sources |
| I3C | [1] | Level | I3C transaction complete/error |
| GPIO | [2] | Level | GPIO edge/level detection |

### Interrupt Handling
- **Type**: Level-triggered, active high
- **Clearing**: Write-1-to-clear (W1C) in respective IC registers
- **Masking**: Individual interrupt sources can be masked
- **Aggregation**: SPI interrupts are OR'd together before user_irq[0]

## Power Architecture

### Power Domains
- **Digital supply**: vccd1 (1.8V)
- **Digital ground**: vssd1
- **Power pins**: Connected via USE_POWER_PINS macro

### Power Management
- **Clock gating**: Available in SPI modules via GCLK register
- **Idle state**: All peripherals enter low-power state when not enabled
- **Reset power**: All modules reset to lowest power configuration

## Peripheral Integration Details

### SPI Masters (CF_SPI)
- **IP Version**: CF_SPI v2.0.0
- **Features**: Master mode only, configurable FIFO depth, interrupt support
- **Clock generation**: Programmable prescaler from system clock
- **FIFO depth**: 16 entries (configurable in IP)

### I3C Controller (Custom)
- **Implementation**: Basic I3C controller with Wishbone interface
- **Features**: Private transfers, basic I2C compatibility
- **Clock generation**: Fixed divide-by-100 from system clock (~1MHz I3C clock)
- **Limitations**: No CCC (Common Command Code) support, no HDR modes

### GPIO Controller (EF_GPIO8)
- **IP Version**: EF_GPIO8 v1.1.0
- **Configuration**: 2 pins used from 8-pin controller
- **Features**: Bidirectional, edge detection, level detection, interrupts
- **Synchronization**: 2-stage input synchronizer

## Simulation and Testing

### RTL Simulation
- **Simulator**: Icarus Verilog, Verilator
- **Testbench**: Cocotb-based Python testbenches
- **Coverage**: Functional coverage with assertions

### Gate-Level Simulation
- **Netlist**: Post-synthesis and post-PnR netlists
- **Timing**: SDF back-annotation for timing simulation
- **Verification**: Same testbenches as RTL simulation

### Formal Verification
- **Tool**: SymbiYosys (optional)
- **Properties**: Bus protocol compliance, interrupt behavior
- **Coverage**: Bounded model checking

## Physical Implementation

### Synthesis
- **Tool**: Yosys
- **Target**: sky130_fd_sc_hd standard cell library
- **Constraints**: SDC format timing constraints
- **Optimization**: Area and timing optimization enabled

### Place and Route
- **Tool**: OpenLane 2.0
- **Technology**: SKY130A PDK
- **Utilization**: Target 40-60% core utilization
- **Routing**: 5 metal layers (M1-M5)

### Design Rules
- **DRC**: Magic DRC clean
- **LVS**: Netgen LVS clean
- **Antenna**: Antenna rules compliant

## Verification Strategy

### Test Levels
1. **Unit tests**: Individual peripheral testing
2. **Integration tests**: Multi-peripheral interactions
3. **System tests**: Full Caravel integration
4. **Regression tests**: Automated test suite

### Test Coverage
- **Functional**: All register accesses, all interrupt sources
- **Protocol**: SPI/I3C protocol compliance
- **Error cases**: Invalid addresses, error conditions
- **Performance**: Maximum throughput testing

### Cocotb Test Structure
```
verilog/dv/cocotb/
├── spi_test/
│   ├── spi_test.py
│   └── spi_test.c
├── i3c_test/
│   ├── i3c_test.py
│   └── i3c_test.c
├── gpio_test/
│   ├── gpio_test.py
│   └── gpio_test.c
└── integration_test/
    ├── integration_test.py
    └── integration_test.c
```

## Known Limitations

### I3C Controller
- **Limited features**: Basic private transfers only
- **No CCC support**: Common Command Codes not implemented
- **No HDR modes**: High Data Rate modes not supported
- **Fixed timing**: Clock generation not programmable

### SPI Masters
- **Master only**: Slave mode not supported
- **Single slave**: One chip select per SPI master
- **FIFO depth**: Fixed at compile time

### GPIO
- **Pin count**: Only 2 pins used from 8-pin controller
- **Pull resistors**: No internal pull-up/pull-down
- **Drive strength**: Fixed drive strength

## Debugging and Troubleshooting

### Logic Analyzer Signals
The design exports key signals to the Logic Analyzer for debugging:
- `la_data_out[31:0]`: Wishbone address
- `la_data_out[63:32]`: Wishbone write data
- `la_data_out[95:64]`: Wishbone read data
- `la_data_out[99:96]`: Wishbone control signals
- `la_data_out[102:100]`: Interrupt signals

### Common Issues
1. **No ACK response**: Check address is within valid range
2. **SPI not working**: Verify clock prescaler and enable bits
3. **I3C timeouts**: Check external pull-up resistors
4. **GPIO interrupts**: Verify interrupt enable and clear sequence

### Debug Checklist
- [ ] Clock and reset signals stable
- [ ] Address decoding correct
- [ ] Interrupt routing verified
- [ ] Pin assignments match documentation
- [ ] External components (pull-ups) present