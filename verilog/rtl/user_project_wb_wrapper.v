`timescale 1ns / 1ps
`default_nettype none

//=============================================================================
// Module: user_project_wb_wrapper
// Description: Wishbone wrapper for multi-peripheral user project
// Author: NativeChips Agent
// Date: 2025-08-27
// License: Apache 2.0
//=============================================================================

module user_project_wb_wrapper (
`ifdef USE_POWER_PINS
    inout VPWR,
    inout VGND,
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
    output [2:0] user_irq
);

    // Instantiate the main user project
    user_project user_proj_inst (
    `ifdef USE_POWER_PINS
        .vccd1(VPWR),
        .vssd1(VGND),
    `endif
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_i),
        .wbs_cyc_i(wbs_cyc_i),
        .wbs_we_i(wbs_we_i),
        .wbs_sel_i(wbs_sel_i),
        .wbs_dat_i(wbs_dat_i),
        .wbs_adr_i(wbs_adr_i),
        .wbs_dat_o(wbs_dat_o),
        .wbs_ack_o(wbs_ack_o),
        .la_data_in(la_data_in),
        .la_data_out(la_data_out),
        .la_oenb(la_oenb),
        .io_in(io_in),
        .io_out(io_out),
        .io_oeb(io_oeb),
        .irq(user_irq)
    );

endmodule

`default_nettype wire