/*
 * SPDX-FileCopyrightText: 2025 NativeChips
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef USER_PERIPH_H
#define USER_PERIPH_H

#include <stdint.h>

// Base addresses
#define SPI0_BASE_ADDR    0x30000000UL
#define SPI1_BASE_ADDR    0x30000100UL
#define SPI2_BASE_ADDR    0x30000200UL
#define SPI3_BASE_ADDR    0x30000300UL
#define I3C_BASE_ADDR     0x30001000UL
#define GPIO_BASE_ADDR    0x30002000UL

// SPI Register offsets (same for all SPI masters)
#define SPI_RXDATA_OFFSET        0x00
#define SPI_TXDATA_OFFSET        0x04
#define SPI_CFG_OFFSET           0x08
#define SPI_CTRL_OFFSET          0x0C
#define SPI_PR_OFFSET            0x10
#define SPI_STATUS_OFFSET        0x14
#define SPI_RX_FIFO_LEVEL_OFFSET 0xFE00
#define SPI_RX_FIFO_THRESHOLD_OFFSET 0xFE04
#define SPI_RX_FIFO_FLUSH_OFFSET 0xFE08
#define SPI_TX_FIFO_LEVEL_OFFSET 0xFE10
#define SPI_TX_FIFO_THRESHOLD_OFFSET 0xFE14
#define SPI_TX_FIFO_FLUSH_OFFSET 0xFE18
#define SPI_IM_OFFSET            0xFF00
#define SPI_RIS_OFFSET           0xFF08
#define SPI_MIS_OFFSET           0xFF04
#define SPI_IC_OFFSET            0xFF0C
#define SPI_GCLK_OFFSET          0xFF10

// I3C Register offsets
#define I3C_CTRL_OFFSET     0x00
#define I3C_STATUS_OFFSET   0x04
#define I3C_DATA_OFFSET     0x08
#define I3C_ADDR_OFFSET     0x0C
#define I3C_IRQ_EN_OFFSET   0x10
#define I3C_IRQ_STAT_OFFSET 0x14
#define I3C_IRQ_CLR_OFFSET  0x18

// GPIO Register offsets
#define GPIO_DATAI_OFFSET   0x00
#define GPIO_DATAO_OFFSET   0x04
#define GPIO_DIR_OFFSET     0x08
#define GPIO_IM_OFFSET      0x0F00
#define GPIO_RIS_OFFSET     0x0F08
#define GPIO_MIS_OFFSET     0x0F04
#define GPIO_IC_OFFSET      0x0F0C

// SPI register access macros
#define SPI_REG(base, offset) (*(volatile uint32_t*)((base) + (offset)))

// SPI0 registers
#define SPI0_RXDATA     SPI_REG(SPI0_BASE_ADDR, SPI_RXDATA_OFFSET)
#define SPI0_TXDATA     SPI_REG(SPI0_BASE_ADDR, SPI_TXDATA_OFFSET)
#define SPI0_CFG        SPI_REG(SPI0_BASE_ADDR, SPI_CFG_OFFSET)
#define SPI0_CTRL       SPI_REG(SPI0_BASE_ADDR, SPI_CTRL_OFFSET)
#define SPI0_PR         SPI_REG(SPI0_BASE_ADDR, SPI_PR_OFFSET)
#define SPI0_STATUS     SPI_REG(SPI0_BASE_ADDR, SPI_STATUS_OFFSET)
#define SPI0_IM         SPI_REG(SPI0_BASE_ADDR, SPI_IM_OFFSET)
#define SPI0_RIS        SPI_REG(SPI0_BASE_ADDR, SPI_RIS_OFFSET)
#define SPI0_MIS        SPI_REG(SPI0_BASE_ADDR, SPI_MIS_OFFSET)
#define SPI0_IC         SPI_REG(SPI0_BASE_ADDR, SPI_IC_OFFSET)
#define SPI0_GCLK       SPI_REG(SPI0_BASE_ADDR, SPI_GCLK_OFFSET)

// SPI1 registers
#define SPI1_RXDATA     SPI_REG(SPI1_BASE_ADDR, SPI_RXDATA_OFFSET)
#define SPI1_TXDATA     SPI_REG(SPI1_BASE_ADDR, SPI_TXDATA_OFFSET)
#define SPI1_CFG        SPI_REG(SPI1_BASE_ADDR, SPI_CFG_OFFSET)
#define SPI1_CTRL       SPI_REG(SPI1_BASE_ADDR, SPI_CTRL_OFFSET)
#define SPI1_PR         SPI_REG(SPI1_BASE_ADDR, SPI_PR_OFFSET)
#define SPI1_STATUS     SPI_REG(SPI1_BASE_ADDR, SPI_STATUS_OFFSET)
#define SPI1_IM         SPI_REG(SPI1_BASE_ADDR, SPI_IM_OFFSET)
#define SPI1_RIS        SPI_REG(SPI1_BASE_ADDR, SPI_RIS_OFFSET)
#define SPI1_MIS        SPI_REG(SPI1_BASE_ADDR, SPI_MIS_OFFSET)
#define SPI1_IC         SPI_REG(SPI1_BASE_ADDR, SPI_IC_OFFSET)
#define SPI1_GCLK       SPI_REG(SPI1_BASE_ADDR, SPI_GCLK_OFFSET)

// SPI2 registers
#define SPI2_RXDATA     SPI_REG(SPI2_BASE_ADDR, SPI_RXDATA_OFFSET)
#define SPI2_TXDATA     SPI_REG(SPI2_BASE_ADDR, SPI_TXDATA_OFFSET)
#define SPI2_CFG        SPI_REG(SPI2_BASE_ADDR, SPI_CFG_OFFSET)
#define SPI2_CTRL       SPI_REG(SPI2_BASE_ADDR, SPI_CTRL_OFFSET)
#define SPI2_PR         SPI_REG(SPI2_BASE_ADDR, SPI_PR_OFFSET)
#define SPI2_STATUS     SPI_REG(SPI2_BASE_ADDR, SPI_STATUS_OFFSET)
#define SPI2_IM         SPI_REG(SPI2_BASE_ADDR, SPI_IM_OFFSET)
#define SPI2_RIS        SPI_REG(SPI2_BASE_ADDR, SPI_RIS_OFFSET)
#define SPI2_MIS        SPI_REG(SPI2_BASE_ADDR, SPI_MIS_OFFSET)
#define SPI2_IC         SPI_REG(SPI2_BASE_ADDR, SPI_IC_OFFSET)
#define SPI2_GCLK       SPI_REG(SPI2_BASE_ADDR, SPI_GCLK_OFFSET)

// SPI3 registers
#define SPI3_RXDATA     SPI_REG(SPI3_BASE_ADDR, SPI_RXDATA_OFFSET)
#define SPI3_TXDATA     SPI_REG(SPI3_BASE_ADDR, SPI_TXDATA_OFFSET)
#define SPI3_CFG        SPI_REG(SPI3_BASE_ADDR, SPI_CFG_OFFSET)
#define SPI3_CTRL       SPI_REG(SPI3_BASE_ADDR, SPI_CTRL_OFFSET)
#define SPI3_PR         SPI_REG(SPI3_BASE_ADDR, SPI_PR_OFFSET)
#define SPI3_STATUS     SPI_REG(SPI3_BASE_ADDR, SPI_STATUS_OFFSET)
#define SPI3_IM         SPI_REG(SPI3_BASE_ADDR, SPI_IM_OFFSET)
#define SPI3_RIS        SPI_REG(SPI3_BASE_ADDR, SPI_RIS_OFFSET)
#define SPI3_MIS        SPI_REG(SPI3_BASE_ADDR, SPI_MIS_OFFSET)
#define SPI3_IC         SPI_REG(SPI3_BASE_ADDR, SPI_IC_OFFSET)
#define SPI3_GCLK       SPI_REG(SPI3_BASE_ADDR, SPI_GCLK_OFFSET)

// I3C registers
#define I3C_CTRL        SPI_REG(I3C_BASE_ADDR, I3C_CTRL_OFFSET)
#define I3C_STATUS      SPI_REG(I3C_BASE_ADDR, I3C_STATUS_OFFSET)
#define I3C_DATA        SPI_REG(I3C_BASE_ADDR, I3C_DATA_OFFSET)
#define I3C_ADDR        SPI_REG(I3C_BASE_ADDR, I3C_ADDR_OFFSET)
#define I3C_IRQ_EN      SPI_REG(I3C_BASE_ADDR, I3C_IRQ_EN_OFFSET)
#define I3C_IRQ_STAT    SPI_REG(I3C_BASE_ADDR, I3C_IRQ_STAT_OFFSET)
#define I3C_IRQ_CLR     SPI_REG(I3C_BASE_ADDR, I3C_IRQ_CLR_OFFSET)

// GPIO registers
#define GPIO_DATAI      SPI_REG(GPIO_BASE_ADDR, GPIO_DATAI_OFFSET)
#define GPIO_DATAO      SPI_REG(GPIO_BASE_ADDR, GPIO_DATAO_OFFSET)
#define GPIO_DIR        SPI_REG(GPIO_BASE_ADDR, GPIO_DIR_OFFSET)
#define GPIO_IM         SPI_REG(GPIO_BASE_ADDR, GPIO_IM_OFFSET)
#define GPIO_RIS        SPI_REG(GPIO_BASE_ADDR, GPIO_RIS_OFFSET)
#define GPIO_MIS        SPI_REG(GPIO_BASE_ADDR, GPIO_MIS_OFFSET)
#define GPIO_IC         SPI_REG(GPIO_BASE_ADDR, GPIO_IC_OFFSET)

// SPI Configuration bits
#define SPI_CFG_CPOL    (1 << 0)
#define SPI_CFG_CPHA    (1 << 1)

// SPI Control bits
#define SPI_CTRL_SS     (1 << 0)
#define SPI_CTRL_ENABLE (1 << 1)
#define SPI_CTRL_RX_EN  (1 << 2)

// SPI Status bits
#define SPI_STATUS_TX_E (1 << 0)
#define SPI_STATUS_TX_F (1 << 1)
#define SPI_STATUS_RX_E (1 << 2)
#define SPI_STATUS_RX_F (1 << 3)
#define SPI_STATUS_TX_B (1 << 4)
#define SPI_STATUS_RX_A (1 << 5)
#define SPI_STATUS_BUSY (1 << 6)
#define SPI_STATUS_DONE (1 << 7)

// I3C Control bits
#define I3C_CTRL_ENABLE     (1 << 0)
#define I3C_CTRL_START      (1 << 1)
#define I3C_CTRL_STOP       (1 << 2)
#define I3C_CTRL_READ_MODE  (1 << 3)
#define I3C_CTRL_WRITE_MODE (1 << 4)

// I3C Status bits
#define I3C_STATUS_BUSY         (1 << 0)
#define I3C_STATUS_DONE         (1 << 1)
#define I3C_STATUS_ACK_RECEIVED (1 << 2)
#define I3C_STATUS_ERROR        (1 << 3)

// GPIO Direction bits
#define GPIO_DIR_INPUT  0
#define GPIO_DIR_OUTPUT 1

// GPIO Interrupt bits
#define GPIO_IRQ_P0HI   (1 << 0)
#define GPIO_IRQ_P1HI   (1 << 1)
#define GPIO_IRQ_P0LO   (1 << 8)
#define GPIO_IRQ_P1LO   (1 << 9)
#define GPIO_IRQ_P0PE   (1 << 16)
#define GPIO_IRQ_P1PE   (1 << 17)
#define GPIO_IRQ_P0NE   (1 << 24)
#define GPIO_IRQ_P1NE   (1 << 25)

// Function prototypes
void spi_init(uint32_t spi_base, uint32_t prescaler, uint32_t mode);
uint8_t spi_transfer(uint32_t spi_base, uint8_t data);
void spi_write(uint32_t spi_base, uint8_t data);
uint8_t spi_read(uint32_t spi_base);
int spi_busy(uint32_t spi_base);

void i3c_init(void);
int i3c_write(uint8_t addr, uint8_t data);
int i3c_read(uint8_t addr, uint8_t *data);

void gpio_init(void);
void gpio_set_direction(uint8_t pin, uint8_t dir);
void gpio_write(uint8_t pin, uint8_t value);
uint8_t gpio_read(uint8_t pin);
void gpio_enable_interrupt(uint8_t pin, uint32_t flags);
void gpio_clear_interrupt(uint32_t flags);

#endif // USER_PERIPH_H