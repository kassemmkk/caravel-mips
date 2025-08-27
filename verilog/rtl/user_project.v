`timescale 1ns / 1ps
`default_nettype none

//=============================================================================
// Module: user_project
// Description: Multi-peripheral user project with SPI, I3C, and GPIO
// Author: NativeChips Agent
// Date: 2025-08-27
// License: Apache 2.0
//=============================================================================

module user_project (
`ifdef USE_POWER_PINS
    inout vccd1,    // User area 1 1.8V supply
    inout vssd1,    // User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input         wb_clk_i,
    input         wb_rst_i,
    input         wbs_stb_i,
    input         wbs_cyc_i,
    input         wbs_we_i,
    input  [3:0]  wbs_sel_i,
    input  [31:0] wbs_dat_i,
    input  [31:0] wbs_adr_i,
    output [31:0] wbs_dat_o,
    output        wbs_ack_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [37:0] io_in,
    output [37:0] io_out,
    output [37:0] io_oeb,

    // IRQ
    output [2:0] irq
);

    // Internal signals
    wire rst_n = ~wb_rst_i;
    
    // Wishbone interconnect signals
    // SPI0
    wire        spi0_cyc, spi0_stb, spi0_we;
    wire [3:0]  spi0_sel;
    wire [31:0] spi0_adr, spi0_dat_mosi, spi0_dat_miso;
    wire        spi0_ack;
    
    // SPI1
    wire        spi1_cyc, spi1_stb, spi1_we;
    wire [3:0]  spi1_sel;
    wire [31:0] spi1_adr, spi1_dat_mosi, spi1_dat_miso;
    wire        spi1_ack;
    
    // SPI2
    wire        spi2_cyc, spi2_stb, spi2_we;
    wire [3:0]  spi2_sel;
    wire [31:0] spi2_adr, spi2_dat_mosi, spi2_dat_miso;
    wire        spi2_ack;
    
    // SPI3
    wire        spi3_cyc, spi3_stb, spi3_we;
    wire [3:0]  spi3_sel;
    wire [31:0] spi3_adr, spi3_dat_mosi, spi3_dat_miso;
    wire        spi3_ack;
    
    // I3C
    wire        i3c_cyc, i3c_stb, i3c_we;
    wire [3:0]  i3c_sel;
    wire [31:0] i3c_adr, i3c_dat_mosi, i3c_dat_miso;
    wire        i3c_ack;
    
    // GPIO
    wire        gpio_cyc, gpio_stb, gpio_we;
    wire [3:0]  gpio_sel;
    wire [31:0] gpio_adr, gpio_dat_mosi, gpio_dat_miso;
    wire        gpio_ack;
    
    // Peripheral interface signals
    // SPI signals
    wire spi0_miso, spi0_mosi, spi0_csb, spi0_sclk;
    wire spi1_miso, spi1_mosi, spi1_csb, spi1_sclk;
    wire spi2_miso, spi2_mosi, spi2_csb, spi2_sclk;
    wire spi3_miso, spi3_mosi, spi3_csb, spi3_sclk;
    
    // I3C signals
    wire i3c_scl, i3c_sda;
    
    // GPIO signals
    wire [1:0] gpio_in, gpio_out, gpio_oe;
    wire [7:0] gpio_full_out, gpio_full_oe;
    
    // Interrupt signals
    wire spi0_irq, spi1_irq, spi2_irq, spi3_irq;
    wire i3c_irq, gpio_irq;
    
    // Wishbone Interconnect
    wb_interconnect wb_intercon (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        
        // Master interface
        .wbs_cyc_i(wbs_cyc_i),
        .wbs_stb_i(wbs_stb_i),
        .wbs_we_i(wbs_we_i),
        .wbs_sel_i(wbs_sel_i),
        .wbs_adr_i(wbs_adr_i),
        .wbs_dat_i(wbs_dat_i),
        .wbs_dat_o(wbs_dat_o),
        .wbs_ack_o(wbs_ack_o),
        
        // SPI0 interface
        .spi0_cyc_o(spi0_cyc),
        .spi0_stb_o(spi0_stb),
        .spi0_we_o(spi0_we),
        .spi0_sel_o(spi0_sel),
        .spi0_adr_o(spi0_adr),
        .spi0_dat_o(spi0_dat_mosi),
        .spi0_dat_i(spi0_dat_miso),
        .spi0_ack_i(spi0_ack),
        
        // SPI1 interface
        .spi1_cyc_o(spi1_cyc),
        .spi1_stb_o(spi1_stb),
        .spi1_we_o(spi1_we),
        .spi1_sel_o(spi1_sel),
        .spi1_adr_o(spi1_adr),
        .spi1_dat_o(spi1_dat_mosi),
        .spi1_dat_i(spi1_dat_miso),
        .spi1_ack_i(spi1_ack),
        
        // SPI2 interface
        .spi2_cyc_o(spi2_cyc),
        .spi2_stb_o(spi2_stb),
        .spi2_we_o(spi2_we),
        .spi2_sel_o(spi2_sel),
        .spi2_adr_o(spi2_adr),
        .spi2_dat_o(spi2_dat_mosi),
        .spi2_dat_i(spi2_dat_miso),
        .spi2_ack_i(spi2_ack),
        
        // SPI3 interface
        .spi3_cyc_o(spi3_cyc),
        .spi3_stb_o(spi3_stb),
        .spi3_we_o(spi3_we),
        .spi3_sel_o(spi3_sel),
        .spi3_adr_o(spi3_adr),
        .spi3_dat_o(spi3_dat_mosi),
        .spi3_dat_i(spi3_dat_miso),
        .spi3_ack_i(spi3_ack),
        
        // I3C interface
        .i3c_cyc_o(i3c_cyc),
        .i3c_stb_o(i3c_stb),
        .i3c_we_o(i3c_we),
        .i3c_sel_o(i3c_sel),
        .i3c_adr_o(i3c_adr),
        .i3c_dat_o(i3c_dat_mosi),
        .i3c_dat_i(i3c_dat_miso),
        .i3c_ack_i(i3c_ack),
        
        // GPIO interface
        .gpio_cyc_o(gpio_cyc),
        .gpio_stb_o(gpio_stb),
        .gpio_we_o(gpio_we),
        .gpio_sel_o(gpio_sel),
        .gpio_adr_o(gpio_adr),
        .gpio_dat_o(gpio_dat_mosi),
        .gpio_dat_i(gpio_dat_miso),
        .gpio_ack_i(gpio_ack)
    );
    
    // SPI0 Instance
    CF_SPI_WB spi0_inst (
        .clk_i(wb_clk_i),
        .rst_i(wb_rst_i),
        .adr_i(spi0_adr),
        .dat_i(spi0_dat_mosi),
        .dat_o(spi0_dat_miso),
        .sel_i(spi0_sel),
        .cyc_i(spi0_cyc),
        .stb_i(spi0_stb),
        .ack_o(spi0_ack),
        .we_i(spi0_we),
        .IRQ(spi0_irq),
        .miso(spi0_miso),
        .mosi(spi0_mosi),
        .csb(spi0_csb),
        .sclk(spi0_sclk)
    );
    
    // SPI1 Instance
    CF_SPI_WB spi1_inst (
        .clk_i(wb_clk_i),
        .rst_i(wb_rst_i),
        .adr_i(spi1_adr),
        .dat_i(spi1_dat_mosi),
        .dat_o(spi1_dat_miso),
        .sel_i(spi1_sel),
        .cyc_i(spi1_cyc),
        .stb_i(spi1_stb),
        .ack_o(spi1_ack),
        .we_i(spi1_we),
        .IRQ(spi1_irq),
        .miso(spi1_miso),
        .mosi(spi1_mosi),
        .csb(spi1_csb),
        .sclk(spi1_sclk)
    );
    
    // SPI2 Instance
    CF_SPI_WB spi2_inst (
        .clk_i(wb_clk_i),
        .rst_i(wb_rst_i),
        .adr_i(spi2_adr),
        .dat_i(spi2_dat_mosi),
        .dat_o(spi2_dat_miso),
        .sel_i(spi2_sel),
        .cyc_i(spi2_cyc),
        .stb_i(spi2_stb),
        .ack_o(spi2_ack),
        .we_i(spi2_we),
        .IRQ(spi2_irq),
        .miso(spi2_miso),
        .mosi(spi2_mosi),
        .csb(spi2_csb),
        .sclk(spi2_sclk)
    );
    
    // SPI3 Instance
    CF_SPI_WB spi3_inst (
        .clk_i(wb_clk_i),
        .rst_i(wb_rst_i),
        .adr_i(spi3_adr),
        .dat_i(spi3_dat_mosi),
        .dat_o(spi3_dat_miso),
        .sel_i(spi3_sel),
        .cyc_i(spi3_cyc),
        .stb_i(spi3_stb),
        .ack_o(spi3_ack),
        .we_i(spi3_we),
        .IRQ(spi3_irq),
        .miso(spi3_miso),
        .mosi(spi3_mosi),
        .csb(spi3_csb),
        .sclk(spi3_sclk)
    );
    
    // I3C Controller Instance
    i3c_controller i3c_inst (
        .clk(wb_clk_i),
        .rst_n(rst_n),
        .wb_cyc_i(i3c_cyc),
        .wb_stb_i(i3c_stb),
        .wb_we_i(i3c_we),
        .wb_sel_i(i3c_sel),
        .wb_adr_i(i3c_adr),
        .wb_dat_i(i3c_dat_mosi),
        .wb_dat_o(i3c_dat_miso),
        .wb_ack_o(i3c_ack),
        .scl(i3c_scl),
        .sda(i3c_sda),
        .irq(i3c_irq)
    );
    
    // GPIO Instance (using only 2 pins from 8-pin GPIO)
    EF_GPIO8_WB gpio_inst (
        .ext_clk(wb_clk_i),
        .clk_i(wb_clk_i),
        .rst_i(wb_rst_i),
        .adr_i(gpio_adr),
        .dat_i(gpio_dat_mosi),
        .dat_o(gpio_dat_miso),
        .sel_i(gpio_sel),
        .cyc_i(gpio_cyc),
        .stb_i(gpio_stb),
        .ack_o(gpio_ack),
        .we_i(gpio_we),
        .IRQ(gpio_irq),
        .io_in({6'b0, gpio_in}),
        .io_out(gpio_full_out),
        .io_oe(gpio_full_oe)
    );
    
    // Extract only the 2 GPIO pins we're using
    assign gpio_out = gpio_full_out[1:0];
    assign gpio_oe = gpio_full_oe[1:0];
    
    // Interrupt aggregation
    assign irq[0] = spi0_irq | spi1_irq | spi2_irq | spi3_irq;  // SPI interrupts
    assign irq[1] = i3c_irq;                                    // I3C interrupt
    assign irq[2] = gpio_irq;                                   // GPIO interrupt
    
    // IO Pin assignments
    // SPI0: io[7:4] = {sclk, mosi, miso, csb}
    assign io_out[4] = spi0_csb;
    assign io_out[5] = spi0_mosi;
    assign io_out[6] = spi0_sclk;
    assign spi0_miso = io_in[7];
    assign io_oeb[4] = 1'b0;  // csb output
    assign io_oeb[5] = 1'b0;  // mosi output
    assign io_oeb[6] = 1'b0;  // sclk output
    assign io_oeb[7] = 1'b1;  // miso input
    
    // SPI1: io[11:8] = {sclk, mosi, miso, csb}
    assign io_out[8] = spi1_csb;
    assign io_out[9] = spi1_mosi;
    assign io_out[10] = spi1_sclk;
    assign spi1_miso = io_in[11];
    assign io_oeb[8] = 1'b0;   // csb output
    assign io_oeb[9] = 1'b0;   // mosi output
    assign io_oeb[10] = 1'b0;  // sclk output
    assign io_oeb[11] = 1'b1;  // miso input
    
    // SPI2: io[15:12] = {sclk, mosi, miso, csb}
    assign io_out[12] = spi2_csb;
    assign io_out[13] = spi2_mosi;
    assign io_out[14] = spi2_sclk;
    assign spi2_miso = io_in[15];
    assign io_oeb[12] = 1'b0;  // csb output
    assign io_oeb[13] = 1'b0;  // mosi output
    assign io_oeb[14] = 1'b0;  // sclk output
    assign io_oeb[15] = 1'b1;  // miso input
    
    // SPI3: io[19:16] = {sclk, mosi, miso, csb}
    assign io_out[16] = spi3_csb;
    assign io_out[17] = spi3_mosi;
    assign io_out[18] = spi3_sclk;
    assign spi3_miso = io_in[19];
    assign io_oeb[16] = 1'b0;  // csb output
    assign io_oeb[17] = 1'b0;  // mosi output
    assign io_oeb[18] = 1'b0;  // sclk output
    assign io_oeb[19] = 1'b1;  // miso input
    
    // I3C: io[21:20] = {sda, scl} (open-drain)
    assign io_out[20] = 1'b0;  // scl open-drain
    assign io_out[21] = 1'b0;  // sda open-drain
    assign io_oeb[20] = i3c_scl ? 1'b1 : 1'b0;  // scl control
    assign io_oeb[21] = i3c_sda ? 1'b1 : 1'b0;  // sda control
    
    // GPIO: io[23:22] = {gpio1, gpio0}
    assign io_out[22] = gpio_out[0];
    assign io_out[23] = gpio_out[1];
    assign gpio_in[0] = io_in[22];
    assign gpio_in[1] = io_in[23];
    assign io_oeb[22] = ~gpio_oe[0];  // 0 = output, 1 = input
    assign io_oeb[23] = ~gpio_oe[1];  // 0 = output, 1 = input
    
    // Unused IOs
    assign io_out[3:0] = 4'b0;
    assign io_out[37:24] = 14'b0;
    assign io_oeb[3:0] = 4'b1;    // inputs
    assign io_oeb[37:24] = 14'b1; // inputs
    
    // Logic Analyzer - expose some internal signals for debugging
    assign la_data_out[31:0] = wbs_adr_i;
    assign la_data_out[63:32] = wbs_dat_i;
    assign la_data_out[95:64] = wbs_dat_o;
    assign la_data_out[96] = wbs_cyc_i;
    assign la_data_out[97] = wbs_stb_i;
    assign la_data_out[98] = wbs_we_i;
    assign la_data_out[99] = wbs_ack_o;
    assign la_data_out[102:100] = irq;
    assign la_data_out[127:103] = 25'b0;

endmodule

`default_nettype wire