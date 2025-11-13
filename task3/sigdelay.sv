module sinegen #(
    parameter  A_WIDTH = 9,
               D_WIDTH = 8
)(
    // interface signals
    input logic                clk,      // clock
    input logic                rst,      // reset
    input logic                rd,       // read en
    input logic                wr,       // write en
    input logic  [D_WIDTH-1:0] offset,   // phase offset for addr2 counter
    input logic  [D_WIDTH-1:0] mic_signal,     
    output logic [D_WIDTH-1:0] delayed_signal

);

    logic  [A_WIDTH-1:0]       address1;  // interconnect wire
    logic  [A_WIDTH-1:0]       address2;  // interconnect wire

counter addrCounter (     // instantiate counter module and name it addrCounter
    .clk (clk),
    .rst (rst),
    .en  (wr),
    .count (address1)  // internal signal name -> external signal name so we can connect it into rom
);

assign address2 = address1 + offset;

ram delayram (
    .clk     (clk),
    .wr_en   (wr),
    .wr_addr (address2),
    .rd_en   (rd),
    .rd_addr (address1),
    .din     (mic_signal),
    .dout    (delayed_signal)
);

endmodule
