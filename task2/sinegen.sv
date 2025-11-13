module sinegen #(
    parameter  A_WIDTH = 8,
               D_WIDTH = 8
)(
    // interface signals
    input logic                clk,      // clock
    input logic                rst,      // reset
    input logic                en,       // enable
    input logic  [D_WIDTH-1:0] offset,   // phase offset for addr2 counter
    output logic [D_WIDTH-1:0] dout1,    // output data
    output logic [D_WIDTH-1:0] dout2     // output data
);

    logic  [A_WIDTH-1:0]       address1;  // interconnect wire
    logic  [A_WIDTH-1:0]       address2;  // interconnect wire

counter addrCounter (     // instantiate counter module and name it addrCounter
    .clk (clk),
    .rst (rst),
    .en (en),
    .count (address1)  // internal signal name -> external signal name so we can connect it into rom
);

assign address2 = address1 + offset;

rom sineRom (
    .clk (clk),
    .addr1 (address1),
    .addr2 (address2),
    .dout1 (dout1),
    .dout2 (dout2)
);

endmodule
