`timescale 1ns / 1ps
`default_nettype none

//=============================================================================
// Module: wb_interconnect
// Description: Wishbone interconnect for multi-peripheral user project
// Author: NativeChips Agent
// Date: 2025-08-27
// License: Apache 2.0
//=============================================================================

module wb_interconnect (
    // Clock and reset
    input  wire        wb_clk_i,
    input  wire        wb_rst_i,
    
    // Master Wishbone interface (from Caravel)
    input  wire        wbs_cyc_i,
    input  wire        wbs_stb_i,
    input  wire        wbs_we_i,
    input  wire [3:0]  wbs_sel_i,
    input  wire [31:0] wbs_adr_i,
    input  wire [31:0] wbs_dat_i,
    output reg  [31:0] wbs_dat_o,
    output reg         wbs_ack_o,
    
    // SPI0 Wishbone interface
    output wire        spi0_cyc_o,
    output wire        spi0_stb_o,
    output wire        spi0_we_o,
    output wire [3:0]  spi0_sel_o,
    output wire [31:0] spi0_adr_o,
    output wire [31:0] spi0_dat_o,
    input  wire [31:0] spi0_dat_i,
    input  wire        spi0_ack_i,
    
    // SPI1 Wishbone interface
    output wire        spi1_cyc_o,
    output wire        spi1_stb_o,
    output wire        spi1_we_o,
    output wire [3:0]  spi1_sel_o,
    output wire [31:0] spi1_adr_o,
    output wire [31:0] spi1_dat_o,
    input  wire [31:0] spi1_dat_i,
    input  wire        spi1_ack_i,
    
    // SPI2 Wishbone interface
    output wire        spi2_cyc_o,
    output wire        spi2_stb_o,
    output wire        spi2_we_o,
    output wire [3:0]  spi2_sel_o,
    output wire [31:0] spi2_adr_o,
    output wire [31:0] spi2_dat_o,
    input  wire [31:0] spi2_dat_i,
    input  wire        spi2_ack_i,
    
    // SPI3 Wishbone interface
    output wire        spi3_cyc_o,
    output wire        spi3_stb_o,
    output wire        spi3_we_o,
    output wire [3:0]  spi3_sel_o,
    output wire [31:0] spi3_adr_o,
    output wire [31:0] spi3_dat_o,
    input  wire [31:0] spi3_dat_i,
    input  wire        spi3_ack_i,
    
    // I3C Wishbone interface
    output wire        i3c_cyc_o,
    output wire        i3c_stb_o,
    output wire        i3c_we_o,
    output wire [3:0]  i3c_sel_o,
    output wire [31:0] i3c_adr_o,
    output wire [31:0] i3c_dat_o,
    input  wire [31:0] i3c_dat_i,
    input  wire        i3c_ack_i,
    
    // GPIO Wishbone interface
    output wire        gpio_cyc_o,
    output wire        gpio_stb_o,
    output wire        gpio_we_o,
    output wire [3:0]  gpio_sel_o,
    output wire [31:0] gpio_adr_o,
    output wire [31:0] gpio_dat_o,
    input  wire [31:0] gpio_dat_i,
    input  wire        gpio_ack_i
);

    // Address map constants
    localparam SPI0_BASE  = 32'h3000_0000;
    localparam SPI1_BASE  = 32'h3000_0100;
    localparam SPI2_BASE  = 32'h3000_0200;
    localparam SPI3_BASE  = 32'h3000_0300;
    localparam I3C_BASE   = 32'h3000_1000;
    localparam GPIO_BASE  = 32'h3000_2000;
    
    localparam PERIPH_SIZE = 32'h0000_0100;  // 256 bytes per peripheral
    
    // Address decoding
    wire spi0_sel  = (wbs_adr_i >= SPI0_BASE)  && (wbs_adr_i < (SPI0_BASE  + PERIPH_SIZE));
    wire spi1_sel  = (wbs_adr_i >= SPI1_BASE)  && (wbs_adr_i < (SPI1_BASE  + PERIPH_SIZE));
    wire spi2_sel  = (wbs_adr_i >= SPI2_BASE)  && (wbs_adr_i < (SPI2_BASE  + PERIPH_SIZE));
    wire spi3_sel  = (wbs_adr_i >= SPI3_BASE)  && (wbs_adr_i < (SPI3_BASE  + PERIPH_SIZE));
    wire i3c_sel   = (wbs_adr_i >= I3C_BASE)   && (wbs_adr_i < (I3C_BASE   + PERIPH_SIZE));
    wire gpio_sel  = (wbs_adr_i >= GPIO_BASE)  && (wbs_adr_i < (GPIO_BASE  + PERIPH_SIZE));
    
    wire valid_addr = spi0_sel | spi1_sel | spi2_sel | spi3_sel | i3c_sel | gpio_sel;
    
    // SPI0 interface
    assign spi0_cyc_o = wbs_cyc_i && spi0_sel;
    assign spi0_stb_o = wbs_stb_i && spi0_sel;
    assign spi0_we_o  = wbs_we_i;
    assign spi0_sel_o = wbs_sel_i;
    assign spi0_adr_o = wbs_adr_i - SPI0_BASE;
    assign spi0_dat_o = wbs_dat_i;
    
    // SPI1 interface
    assign spi1_cyc_o = wbs_cyc_i && spi1_sel;
    assign spi1_stb_o = wbs_stb_i && spi1_sel;
    assign spi1_we_o  = wbs_we_i;
    assign spi1_sel_o = wbs_sel_i;
    assign spi1_adr_o = wbs_adr_i - SPI1_BASE;
    assign spi1_dat_o = wbs_dat_i;
    
    // SPI2 interface
    assign spi2_cyc_o = wbs_cyc_i && spi2_sel;
    assign spi2_stb_o = wbs_stb_i && spi2_sel;
    assign spi2_we_o  = wbs_we_i;
    assign spi2_sel_o = wbs_sel_i;
    assign spi2_adr_o = wbs_adr_i - SPI2_BASE;
    assign spi2_dat_o = wbs_dat_i;
    
    // SPI3 interface
    assign spi3_cyc_o = wbs_cyc_i && spi3_sel;
    assign spi3_stb_o = wbs_stb_i && spi3_sel;
    assign spi3_we_o  = wbs_we_i;
    assign spi3_sel_o = wbs_sel_i;
    assign spi3_adr_o = wbs_adr_i - SPI3_BASE;
    assign spi3_dat_o = wbs_dat_i;
    
    // I3C interface
    assign i3c_cyc_o = wbs_cyc_i && i3c_sel;
    assign i3c_stb_o = wbs_stb_i && i3c_sel;
    assign i3c_we_o  = wbs_we_i;
    assign i3c_sel_o = wbs_sel_i;
    assign i3c_adr_o = wbs_adr_i - I3C_BASE;
    assign i3c_dat_o = wbs_dat_i;
    
    // GPIO interface
    assign gpio_cyc_o = wbs_cyc_i && gpio_sel;
    assign gpio_stb_o = wbs_stb_i && gpio_sel;
    assign gpio_we_o  = wbs_we_i;
    assign gpio_sel_o = wbs_sel_i;
    assign gpio_adr_o = wbs_adr_i - GPIO_BASE;
    assign gpio_dat_o = wbs_dat_i;
    
    // Response multiplexing
    always @(*) begin
        wbs_dat_o = 32'h0;
        wbs_ack_o = 1'b0;
        
        if (spi0_sel) begin
            wbs_dat_o = spi0_dat_i;
            wbs_ack_o = spi0_ack_i;
        end else if (spi1_sel) begin
            wbs_dat_o = spi1_dat_i;
            wbs_ack_o = spi1_ack_i;
        end else if (spi2_sel) begin
            wbs_dat_o = spi2_dat_i;
            wbs_ack_o = spi2_ack_i;
        end else if (spi3_sel) begin
            wbs_dat_o = spi3_dat_i;
            wbs_ack_o = spi3_ack_i;
        end else if (i3c_sel) begin
            wbs_dat_o = i3c_dat_i;
            wbs_ack_o = i3c_ack_i;
        end else if (gpio_sel) begin
            wbs_dat_o = gpio_dat_i;
            wbs_ack_o = gpio_ack_i;
        end
        // For invalid addresses, return 0 and no ACK
    end

endmodule

`default_nettype wire