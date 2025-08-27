/*
 * SPDX-FileCopyrightText: 2025 NativeChips
 * SPDX-License-Identifier: Apache-2.0
 */

#include <firmware_apis.h>
#include "../../fw/user_periph.h"

void integration_test() {
    // Configure management GPIO
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    
    // Test SPI0 configuration
    spi_init(SPI0_BASE_ADDR, 10, 0);  // Mode 0, prescaler 10
    
    // Test SPI1 configuration  
    spi_init(SPI1_BASE_ADDR, 10, 3);  // Mode 3, prescaler 10
    
    // Test I3C controller
    i3c_init();
    
    // Test GPIO configuration
    gpio_init();
    gpio_set_direction(0, GPIO_DIR_OUTPUT);
    gpio_set_direction(1, GPIO_DIR_INPUT);
    gpio_write(0, 1);
    
    // Signal test completion
    ManagmentGpio_write(1);
    
    // Simple test patterns
    for (int i = 0; i < 5; i++) {
        gpio_write(0, 1);
        delay(1000);
        gpio_write(0, 0);
        delay(1000);
    }
    
    print("Integration test completed\n");
}