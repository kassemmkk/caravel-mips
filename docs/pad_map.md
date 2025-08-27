# Pad Map

## IO Pin Assignments

The user project uses the following IO pins from the Caravel `mprj_io[]` array:

| Pin Range | Peripheral | Signal | Direction | Description |
|-----------|------------|--------|-----------|-------------|
| io[7:4]   | SPI0       | {miso, sclk, mosi, csb} | {I, O, O, O} | SPI Master 0 |
| io[11:8]  | SPI1       | {miso, sclk, mosi, csb} | {I, O, O, O} | SPI Master 1 |
| io[15:12] | SPI2       | {miso, sclk, mosi, csb} | {I, O, O, O} | SPI Master 2 |
| io[19:16] | SPI3       | {miso, sclk, mosi, csb} | {I, O, O, O} | SPI Master 3 |
| io[21:20] | I3C        | {sda, scl} | {IO, IO} | I3C Controller (open-drain) |
| io[23:22] | GPIO       | {gpio1, gpio0} | {IO, IO} | GPIO with interrupts |

## Detailed Pin Assignments

### SPI0 (io[7:4])
- **io[4]**: SPI0_CSB (Chip Select Bar) - Output, active low
- **io[5]**: SPI0_MOSI (Master Out Slave In) - Output
- **io[6]**: SPI0_SCLK (Serial Clock) - Output
- **io[7]**: SPI0_MISO (Master In Slave Out) - Input

### SPI1 (io[11:8])
- **io[8]**: SPI1_CSB (Chip Select Bar) - Output, active low
- **io[9]**: SPI1_MOSI (Master Out Slave In) - Output
- **io[10]**: SPI1_SCLK (Serial Clock) - Output
- **io[11]**: SPI1_MISO (Master In Slave Out) - Input

### SPI2 (io[15:12])
- **io[12]**: SPI2_CSB (Chip Select Bar) - Output, active low
- **io[13]**: SPI2_MOSI (Master Out Slave In) - Output
- **io[14]**: SPI2_SCLK (Serial Clock) - Output
- **io[15]**: SPI2_MISO (Master In Slave Out) - Input

### SPI3 (io[19:16])
- **io[16]**: SPI3_CSB (Chip Select Bar) - Output, active low
- **io[17]**: SPI3_MOSI (Master Out Slave In) - Output
- **io[18]**: SPI3_SCLK (Serial Clock) - Output
- **io[19]**: SPI3_MISO (Master In Slave Out) - Input

### I3C Controller (io[21:20])
- **io[20]**: I3C_SCL (Serial Clock) - Bidirectional, open-drain
- **io[21]**: I3C_SDA (Serial Data) - Bidirectional, open-drain

### GPIO (io[23:22])
- **io[22]**: GPIO0 - Bidirectional, configurable direction
- **io[23]**: GPIO1 - Bidirectional, configurable direction

## Unused Pins

The following pins are configured as inputs and not used by the design:
- **io[3:0]**: Reserved/unused
- **io[37:24]**: Reserved/unused

## Pin Configuration Notes

### SPI Pins
- All SPI output pins (SCLK, MOSI, CSB) are configured as push-pull outputs
- SPI input pins (MISO) are configured as inputs with no pull-up/pull-down
- CSB is active low and idles high when not in use

### I3C Pins
- Both SCL and SDA are configured as open-drain bidirectional pins
- External pull-up resistors (typically 1kΩ-10kΩ) are required on both lines
- The controller can drive low or release (high-Z) the lines

### GPIO Pins
- Direction is software configurable via the DIR register
- When configured as outputs, pins are push-pull
- When configured as inputs, no internal pull-up/pull-down is applied
- Edge detection is available for interrupt generation

## Changing Pin Assignments

To modify the pin assignments, update the following sections in `user_project.v`:

1. **Signal assignments** in the IO Pin assignments section
2. **io_oeb assignments** for output enable control
3. **Update documentation** to reflect the new assignments

Example for moving SPI0 to different pins:
```verilog
// Move SPI0 from io[7:4] to io[11:8]
assign io_out[8] = spi0_csb;    // was io_out[4]
assign io_out[9] = spi0_mosi;   // was io_out[5]
assign io_out[10] = spi0_sclk;  // was io_out[6]
assign spi0_miso = io_in[11];   // was io_in[7]
```

## External Interface Requirements

### SPI Interface
- Standard SPI slave devices can be connected
- Support for SPI modes 0-3 via CPOL/CPHA configuration
- Maximum SPI clock frequency depends on system clock and prescaler setting

### I3C Interface
- Requires external pull-up resistors on SCL and SDA lines
- Compatible with I2C devices in legacy mode
- Supports basic I3C private transfers

### GPIO Interface
- 3.3V CMOS levels
- Maximum current per pin: 4mA (typical for sky130)
- ESD protection provided by Caravel pad ring