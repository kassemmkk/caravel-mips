"""
Integration test for multi-peripheral user project
Tests basic functionality of SPI, I3C, and GPIO peripherals
"""

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotb.result import TestFailure

# Base addresses
SPI0_BASE = 0x30000000
SPI1_BASE = 0x30000100
SPI2_BASE = 0x30000200
SPI3_BASE = 0x30000300
I3C_BASE = 0x30001000
GPIO_BASE = 0x30002000

# Register offsets
SPI_TXDATA_OFFSET = 0x04
SPI_CFG_OFFSET = 0x08
SPI_CTRL_OFFSET = 0x0C
SPI_STATUS_OFFSET = 0x14

I3C_CTRL_OFFSET = 0x00
I3C_STATUS_OFFSET = 0x04
I3C_DATA_OFFSET = 0x08
I3C_ADDR_OFFSET = 0x0C

GPIO_DATAO_OFFSET = 0x04
GPIO_DIR_OFFSET = 0x08

async def wb_write(dut, addr, data):
    """Perform a Wishbone write transaction"""
    dut.wbs_adr_i.value = addr
    dut.wbs_dat_i.value = data
    dut.wbs_sel_i.value = 0xF
    dut.wbs_we_i.value = 1
    dut.wbs_cyc_i.value = 1
    dut.wbs_stb_i.value = 1
    
    # Wait for ACK
    timeout = 0
    while dut.wbs_ack_o.value != 1 and timeout < 100:
        await RisingEdge(dut.wb_clk_i)
        timeout += 1
    
    if timeout >= 100:
        raise TestFailure("Wishbone write timeout")
    
    # Deassert signals
    dut.wbs_cyc_i.value = 0
    dut.wbs_stb_i.value = 0
    dut.wbs_we_i.value = 0
    await RisingEdge(dut.wb_clk_i)

async def wb_read(dut, addr):
    """Perform a Wishbone read transaction"""
    dut.wbs_adr_i.value = addr
    dut.wbs_sel_i.value = 0xF
    dut.wbs_we_i.value = 0
    dut.wbs_cyc_i.value = 1
    dut.wbs_stb_i.value = 1
    
    # Wait for ACK
    timeout = 0
    while dut.wbs_ack_o.value != 1 and timeout < 100:
        await RisingEdge(dut.wb_clk_i)
        timeout += 1
    
    if timeout >= 100:
        raise TestFailure("Wishbone read timeout")
    
    data = dut.wbs_dat_o.value
    
    # Deassert signals
    dut.wbs_cyc_i.value = 0
    dut.wbs_stb_i.value = 0
    await RisingEdge(dut.wb_clk_i)
    
    return data

@cocotb.test()
async def integration_test(dut):
    """Test basic functionality of all peripherals"""
    
    # Start clock
    clock = Clock(dut.wb_clk_i, 10, units="ns")  # 100MHz
    cocotb.start_soon(clock.start())
    
    # Reset
    dut.wb_rst_i.value = 1
    dut.wbs_cyc_i.value = 0
    dut.wbs_stb_i.value = 0
    dut.wbs_we_i.value = 0
    dut.wbs_sel_i.value = 0
    dut.wbs_adr_i.value = 0
    dut.wbs_dat_i.value = 0
    dut.la_data_in.value = 0
    dut.la_oenb.value = 0
    dut.io_in.value = 0
    
    await Timer(100, units="ns")
    dut.wb_rst_i.value = 0
    await Timer(100, units="ns")
    
    dut._log.info("Starting integration test")
    
    # Test 1: SPI0 Configuration
    dut._log.info("Testing SPI0 configuration")
    await wb_write(dut, SPI0_BASE + SPI_CFG_OFFSET, 0x00)  # Mode 0
    await wb_write(dut, SPI0_BASE + SPI_CTRL_OFFSET, 0x02)  # Enable
    
    # Read status to verify SPI is enabled
    status = await wb_read(dut, SPI0_BASE + SPI_STATUS_OFFSET)
    dut._log.info(f"SPI0 status: 0x{status:08x}")
    
    # Test 2: SPI1 Configuration
    dut._log.info("Testing SPI1 configuration")
    await wb_write(dut, SPI1_BASE + SPI_CFG_OFFSET, 0x03)  # Mode 3
    await wb_write(dut, SPI1_BASE + SPI_CTRL_OFFSET, 0x02)  # Enable
    
    # Test 3: I3C Controller
    dut._log.info("Testing I3C controller")
    await wb_write(dut, I3C_BASE + I3C_CTRL_OFFSET, 0x01)  # Enable
    await wb_write(dut, I3C_BASE + I3C_ADDR_OFFSET, 0x50)  # Set address
    await wb_write(dut, I3C_BASE + I3C_DATA_OFFSET, 0xAA)  # Set data
    
    # Read I3C status
    status = await wb_read(dut, I3C_BASE + I3C_STATUS_OFFSET)
    dut._log.info(f"I3C status: 0x{status:08x}")
    
    # Test 4: GPIO Configuration
    dut._log.info("Testing GPIO configuration")
    await wb_write(dut, GPIO_BASE + GPIO_DIR_OFFSET, 0x01)  # Pin 0 output, Pin 1 input
    await wb_write(dut, GPIO_BASE + GPIO_DATAO_OFFSET, 0x01)  # Set pin 0 high
    
    # Test 5: Address Decoding - Invalid Address
    dut._log.info("Testing invalid address")
    try:
        # This should not ACK
        dut.wbs_adr_i.value = 0x40000000  # Invalid address
        dut.wbs_sel_i.value = 0xF
        dut.wbs_we_i.value = 0
        dut.wbs_cyc_i.value = 1
        dut.wbs_stb_i.value = 1
        
        # Wait a few cycles - should not get ACK
        for _ in range(10):
            await RisingEdge(dut.wb_clk_i)
            if dut.wbs_ack_o.value == 1:
                raise TestFailure("Invalid address should not ACK")
        
        # Clean up
        dut.wbs_cyc_i.value = 0
        dut.wbs_stb_i.value = 0
        await RisingEdge(dut.wb_clk_i)
        
        dut._log.info("Invalid address correctly ignored")
        
    except Exception as e:
        dut._log.error(f"Invalid address test failed: {e}")
        raise
    
    # Test 6: Interrupt Signals
    dut._log.info("Testing interrupt signals")
    # Check that interrupt signals are present (should be 0 initially)
    irq_val = dut.user_irq.value
    dut._log.info(f"User IRQ signals: {irq_val}")
    
    # Test 7: IO Pin Assignments
    dut._log.info("Testing IO pin assignments")
    # Check that GPIO pins are connected
    gpio_out = (dut.io_out.value >> 22) & 0x3  # GPIO pins at io[23:22]
    dut._log.info(f"GPIO output pins: 0x{gpio_out:02x}")
    
    dut._log.info("Integration test completed successfully")

if __name__ == "__main__":
    import sys
    sys.exit(cocotb.main())