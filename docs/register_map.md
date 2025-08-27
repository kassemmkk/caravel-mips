# Register Map

## Address Map Overview

| Peripheral | Base Address | Size | Description |
|------------|-------------|------|-------------|
| SPI0       | 0x3000_0000 | 256B | SPI Master 0 |
| SPI1       | 0x3000_0100 | 256B | SPI Master 1 |
| SPI2       | 0x3000_0200 | 256B | SPI Master 2 |
| SPI3       | 0x3000_0300 | 256B | SPI Master 3 |
| I3C0       | 0x3000_1000 | 256B | I3C Controller |
| GPIO0      | 0x3000_2000 | 256B | GPIO with interrupts |

## SPI Master Registers (CF_SPI)

Each SPI master (SPI0-SPI3) has the same register layout:

| Register | Offset | Access | Reset | Description |
|----------|--------|--------|-------|-------------|
| RXDATA   | 0x00   | R      | 0x00000000 | RX Data register |
| TXDATA   | 0x04   | W      | 0x00000000 | TX Data register |
| CFG      | 0x08   | W      | 0x00000000 | Configuration Register |
| CTRL     | 0x0C   | W      | 0x00000000 | Control Register |
| PR       | 0x10   | W      | 0x00000002 | SPI clock Prescaler |
| STATUS   | 0x14   | R      | 0x00000000 | Status register |
| RX_FIFO_LEVEL | 0xFE00 | R | 0x00000000 | RX FIFO Level |
| RX_FIFO_THRESHOLD | 0xFE04 | W | 0x00000000 | RX FIFO Threshold |
| RX_FIFO_FLUSH | 0xFE08 | W | 0x00000000 | RX FIFO Flush |
| TX_FIFO_LEVEL | 0xFE10 | R | 0x00000000 | TX FIFO Level |
| TX_FIFO_THRESHOLD | 0xFE14 | W | 0x00000000 | TX FIFO Threshold |
| TX_FIFO_FLUSH | 0xFE18 | W | 0x00000000 | TX FIFO Flush |
| IM       | 0xFF00 | W      | 0x00000000 | Interrupt Mask |
| RIS      | 0xFF08 | R      | 0x00000000 | Raw Interrupt Status |
| MIS      | 0xFF04 | R      | 0x00000000 | Masked Interrupt Status |
| IC       | 0xFF0C | W      | 0x00000000 | Interrupt Clear |
| GCLK     | 0xFF10 | W      | 0x00000000 | Gated clock enable |

### SPI Register Details

#### CFG Register (0x08)
| Bit | Field | Description |
|-----|-------|-------------|
| 0   | CPOL  | SPI Clock Polarity |
| 1   | CPHA  | SPI Clock Phase |
| 31:2| -     | Reserved |

#### CTRL Register (0x0C)
| Bit | Field | Description |
|-----|-------|-------------|
| 0   | SS    | Slave Select (Active High) |
| 1   | enable| Enable SPI master pulse generation |
| 2   | rx_en | Enable storing bytes received from slave |
| 31:3| -     | Reserved |

#### STATUS Register (0x14)
| Bit | Field | Description |
|-----|-------|-------------|
| 0   | TX_E  | Transmit FIFO is Empty |
| 1   | TX_F  | Transmit FIFO is Full |
| 2   | RX_E  | Receive FIFO is Empty |
| 3   | RX_F  | Receive FIFO is Full |
| 4   | TX_B  | Transmit FIFO level is Below Threshold |
| 5   | RX_A  | Receive FIFO level is Above Threshold |
| 6   | busy  | SPI busy flag |
| 7   | done  | SPI done flag |
| 31:8| -     | Reserved |

## I3C Controller Registers

Base Address: 0x3000_1000

| Register | Offset | Access | Reset | Description |
|----------|--------|--------|-------|-------------|
| CTRL     | 0x00   | RW     | 0x00000000 | Control register |
| STATUS   | 0x04   | R      | 0x00000000 | Status register |
| DATA     | 0x08   | RW     | 0x00000000 | Data register |
| ADDR     | 0x0C   | RW     | 0x00000000 | Address register |
| IRQ_EN   | 0x10   | RW     | 0x00000000 | Interrupt enable |
| IRQ_STAT | 0x14   | R      | 0x00000000 | Interrupt status |
| IRQ_CLR  | 0x18   | W      | 0x00000000 | Interrupt clear |

### I3C Register Details

#### CTRL Register (0x00)
| Bit | Field | Description |
|-----|-------|-------------|
| 0   | enable| Enable I3C controller |
| 1   | start | Start transaction (self-clearing) |
| 2   | stop  | Stop transaction (self-clearing) |
| 3   | read_mode | Read mode enable |
| 4   | write_mode| Write mode enable |
| 31:5| -     | Reserved |

#### STATUS Register (0x04)
| Bit | Field | Description |
|-----|-------|-------------|
| 0   | busy  | Transaction in progress |
| 1   | done  | Transaction complete |
| 2   | ack_received | ACK received from slave |
| 3   | error | Transaction error |
| 31:4| -     | Reserved |

## GPIO Registers (EF_GPIO8)

Base Address: 0x3000_2000 (using only 2 pins from 8-pin GPIO)

| Register | Offset | Access | Reset | Description |
|----------|--------|--------|-------|-------------|
| DATAI    | 0x00   | R      | 0x00000000 | Data In Register |
| DATAO    | 0x04   | W      | 0x00000000 | Data Out Register |
| DIR      | 0x08   | W      | 0x00000000 | Direction Register |
| IM       | 0x0F00 | W      | 0x00000000 | Interrupt Mask |
| RIS      | 0x0F08 | R      | 0x00000000 | Raw Interrupt Status |
| MIS      | 0x0F04 | R      | 0x00000000 | Masked Interrupt Status |
| IC       | 0x0F0C | W      | 0x00000000 | Interrupt Clear |

### GPIO Register Details

#### DATAI Register (0x00)
| Bit | Field | Description |
|-----|-------|-------------|
| 1:0 | GPIO  | GPIO pin input values |
| 31:2| -     | Reserved |

#### DATAO Register (0x04)
| Bit | Field | Description |
|-----|-------|-------------|
| 1:0 | GPIO  | GPIO pin output values |
| 31:2| -     | Reserved |

#### DIR Register (0x08)
| Bit | Field | Description |
|-----|-------|-------------|
| 1:0 | DIR   | GPIO direction (1=output, 0=input) |
| 31:2| -     | Reserved |

#### GPIO Interrupt Flags
| Bit | Flag | Description |
|-----|------|-------------|
| 0   | P0HI | Pin 0 is high |
| 1   | P1HI | Pin 1 is high |
| 8   | P0LO | Pin 0 is low |
| 9   | P1LO | Pin 1 is low |
| 16  | P0PE | Pin 0 positive edge |
| 17  | P1PE | Pin 1 positive edge |
| 24  | P0NE | Pin 0 negative edge |
| 25  | P1NE | Pin 1 negative edge |

## Interrupt Summary

| Source | user_irq bit | Description |
|--------|-------------|-------------|
| SPI0-3 | user_irq[0] | Any SPI interrupt (OR'd together) |
| I3C0   | user_irq[1] | I3C controller interrupt |
| GPIO0  | user_irq[2] | GPIO edge/level interrupts |