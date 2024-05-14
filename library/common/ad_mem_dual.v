// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module ad_mem_dual #(
  parameter INITIALIZE = 0,
  parameter DATA_WIDTH = 16,
  parameter ADDRESS_WIDTH = 5
) (
  input                            clka,
  input                            wea,
  input                            ea,
  input      [(ADDRESS_WIDTH-1):0] addra,
  input      [(DATA_WIDTH-1):0]    dina,
  output reg [(DATA_WIDTH-1):0]    douta,

  input                            clkb,
  input                            web,
  input                            eb,
  input      [(ADDRESS_WIDTH-1):0] addrb,
  input      [(DATA_WIDTH-1):0]    dinb,
  output reg [(DATA_WIDTH-1):0]    doutb
);

  (* ram_style = "block" *)
  reg [(DATA_WIDTH-1):0] m_ram[0:((2**ADDRESS_WIDTH)-1)];

  genvar i;
  generate
    if (INITIALIZE) begin
      for (i = 0; i < (2**ADDRESS_WIDTH); i = i + 1) begin: gen_m_ram
        initial m_ram[i] = 'b0;
      end
    end
  endgenerate

  always @(posedge clka) begin
    if (ea == 1'b1) begin
      if (wea == 1'b1) begin
        m_ram[addra] <= dina;
      end
      douta <= m_ram[addra];
    end
  end

  always @(posedge clkb) begin
    if (eb == 1'b1) begin
      if (web == 1'b1) begin
        m_ram[addrb] <= dinb;
      end
      doutb <= m_ram[addrb];
    end
  end

endmodule
