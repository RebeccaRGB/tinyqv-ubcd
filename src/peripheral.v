/*
 * Copyright (c) 2025 Rebecca G. Bettencourt
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tqvp_rebeccargb_universal_decoder (
    input         clk,          // Clock - the TinyQV project clock is normally set to 64MHz.
    input         rst_n,        // Reset_n - low to reset.
    input  [7:0]  ui_in,        // The input PMOD.  Note that ui_in[7] is normally used for UART RX.
    output [7:0]  uo_out,       // The output PMOD.  Note that uo_out[0] is normally used for UART TX.
    input  [3:0]  address,      // Address within this peripheral's address space
    input         data_write,   // Data write request from the TinyQV core.
    input  [7:0]  data_in,      // Data in to the peripheral, valid when data_write is high.
    output [7:0]  data_out      // Data out from the peripheral, set this in accordance with the supplied address
);

    reg [7:0] data;

    always @(posedge clk) begin
        if (!rst_n) begin
            data <= 0;
        end else if (data_write) begin
            if (address == 4'h0) begin
                data <= data_in;
            end
        end
    end

    // All output pins must be assigned. If not used, assign to 0.
    assign uo_out = data;

    assign data_out = data;

endmodule
