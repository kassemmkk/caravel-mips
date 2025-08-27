/*
 * SPDX-FileCopyrightText: 2025 NativeChips
 * SPDX-License-Identifier: Apache-2.0
 */

#include "user_periph.h"

// Simple delay function
void delay(int count) {
    for (int i = 0; i < count; i++) {
        asm("nop");
    }
}

// SPI initialization
void spi_init(uint32_t spi_base, uint32_t prescaler, uint32_t mode) {
    // Enable clock gating
    SPI_REG(spi_base, SPI_GCLK_OFFSET) = 1;
    
    // Set prescaler (minimum 2)
    SPI_REG(spi_base, SPI_PR_OFFSET) = (prescaler < 2) ? 2 : prescaler;
    
    // Configure SPI mode (CPOL/CPHA)
    SPI_REG(spi_base, SPI_CFG_OFFSET) = mode & 0x3;
    
    // Enable SPI and RX
    SPI_REG(spi_base, SPI_CTRL_OFFSET) = SPI_CTRL_ENABLE | SPI_CTRL_RX_EN;
}

// SPI transfer function
uint8_t spi_transfer(uint32_t spi_base, uint8_t data) {
    // Wait for TX FIFO not full
    while (SPI_REG(spi_base, SPI_STATUS_OFFSET) & SPI_STATUS_TX_F);
    
    // Send data
    SPI_REG(spi_base, SPI_TXDATA_OFFSET) = data;
    
    // Assert slave select
    SPI_REG(spi_base, SPI_CTRL_OFFSET) |= SPI_CTRL_SS;
    
    // Wait for transaction complete
    while (SPI_REG(spi_base, SPI_STATUS_OFFSET) & SPI_STATUS_BUSY);
    
    // Deassert slave select
    SPI_REG(spi_base, SPI_CTRL_OFFSET) &= ~SPI_CTRL_SS;
    
    // Read received data
    if (!(SPI_REG(spi_base, SPI_STATUS_OFFSET) & SPI_STATUS_RX_E)) {
        return SPI_REG(spi_base, SPI_RXDATA_OFFSET) & 0xFF;
    }
    
    return 0;
}

// I3C initialization
void i3c_init(void) {
    // Enable I3C controller
    I3C_CTRL = I3C_CTRL_ENABLE;
    
    // Enable transaction complete interrupt
    I3C_IRQ_EN = 1;
}

// I3C write function
int i3c_write(uint8_t addr, uint8_t data) {
    // Wait for controller not busy
    while (I3C_STATUS & I3C_STATUS_BUSY);
    
    // Set address and data
    I3C_ADDR = addr;
    I3C_DATA = data;
    
    // Start write transaction
    I3C_CTRL = I3C_CTRL_ENABLE | I3C_CTRL_WRITE_MODE | I3C_CTRL_START;
    
    // Wait for completion
    while (I3C_STATUS & I3C_STATUS_BUSY);
    
    // Check for errors
    if (I3C_STATUS & I3C_STATUS_ERROR) {
        return -1;
    }
    
    // Clear interrupt
    I3C_IRQ_CLR = 1;
    
    return 0;
}

// I3C read function
int i3c_read(uint8_t addr, uint8_t *data) {
    // Wait for controller not busy
    while (I3C_STATUS & I3C_STATUS_BUSY);
    
    // Set address
    I3C_ADDR = addr | 1; // Set read bit
    
    // Start read transaction
    I3C_CTRL = I3C_CTRL_ENABLE | I3C_CTRL_READ_MODE | I3C_CTRL_START;
    
    // Wait for completion
    while (I3C_STATUS & I3C_STATUS_BUSY);
    
    // Check for errors
    if (I3C_STATUS & I3C_STATUS_ERROR) {
        return -1;
    }
    
    // Read data
    *data = I3C_DATA & 0xFF;
    
    // Clear interrupt
    I3C_IRQ_CLR = 1;
    
    return 0;
}

// GPIO initialization
void gpio_init(void) {
    // Set both pins as inputs initially
    GPIO_DIR = 0;
    
    // Clear any pending interrupts
    GPIO_IC = 0xFFFFFFFF;
}

// GPIO set direction
void gpio_set_direction(uint8_t pin, uint8_t dir) {
    if (pin < 2) {
        if (dir) {
            GPIO_DIR |= (1 << pin);
        } else {
            GPIO_DIR &= ~(1 << pin);
        }
    }
}

// GPIO write
void gpio_write(uint8_t pin, uint8_t value) {
    if (pin < 2) {
        if (value) {
            GPIO_DATAO |= (1 << pin);
        } else {
            GPIO_DATAO &= ~(1 << pin);
        }
    }
}

// GPIO read
uint8_t gpio_read(uint8_t pin) {
    if (pin < 2) {
        return (GPIO_DATAI >> pin) & 1;
    }
    return 0;
}

// GPIO enable interrupt
void gpio_enable_interrupt(uint8_t pin, uint32_t flags) {
    GPIO_IM |= flags;
}

// GPIO clear interrupt
void gpio_clear_interrupt(uint32_t flags) {
    GPIO_IC = flags;
}

// Main smoke test
int main(void) {
    // Test SPI0
    spi_init(SPI0_BASE_ADDR, 10, 0); // Mode 0, prescaler 10
    
    // Test SPI loopback (connect MOSI to MISO externally)
    uint8_t spi_test_data = 0xA5;
    uint8_t spi_result = spi_transfer(SPI0_BASE_ADDR, spi_test_data);
    
    // Test SPI1
    spi_init(SPI1_BASE_ADDR, 10, 0);
    spi_transfer(SPI1_BASE_ADDR, 0x55);
    
    // Test SPI2
    spi_init(SPI2_BASE_ADDR, 10, 0);
    spi_transfer(SPI2_BASE_ADDR, 0xAA);
    
    // Test SPI3
    spi_init(SPI3_BASE_ADDR, 10, 0);
    spi_transfer(SPI3_BASE_ADDR, 0xFF);
    
    // Test I3C
    i3c_init();
    
    // Test I3C write (address 0x50, data 0x12)
    int i3c_write_result = i3c_write(0x50, 0x12);
    
    // Test I3C read
    uint8_t i3c_read_data;
    int i3c_read_result = i3c_read(0x50, &i3c_read_data);
    
    // Test GPIO
    gpio_init();
    
    // Set GPIO0 as output, GPIO1 as input
    gpio_set_direction(0, GPIO_DIR_OUTPUT);
    gpio_set_direction(1, GPIO_DIR_INPUT);
    
    // Test GPIO output
    gpio_write(0, 1);
    delay(1000);
    gpio_write(0, 0);
    delay(1000);
    
    // Test GPIO input
    uint8_t gpio_value = gpio_read(1);
    
    // Enable GPIO interrupts for edge detection
    gpio_enable_interrupt(1, GPIO_IRQ_P1PE | GPIO_IRQ_P1NE);
    
    // Simple pass/fail indication
    // If we get here without hanging, basic functionality works
    
    // Toggle GPIO0 to indicate test completion
    for (int i = 0; i < 10; i++) {
        gpio_write(0, 1);
        delay(500);
        gpio_write(0, 0);
        delay(500);
    }
    
    return 0;
}