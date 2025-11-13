#include "Vsinegen.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

int main(int argc, char **argv, char **env){   
    // these arguments needed for info about the code e.g. array of all the listed arguments
   
    Verilated::commandArgs(argc, argv);   
    // passes those arguments to allow Verilator's command line features to work

    Vsinegen* top = new Vsinegen;   // creates c++ object for verilog module sinegen
    
    Verilated::traceEverOn(true);  // enaqbles waveform tracing
    VerilatedVcdC* tfp = new VerilatedVcdC;  // writes waveform data to a .vcd file
    top->trace(tfp, 99);   // records signals using tfp with up to 99 levels of hierarchy
    tfp->open("sinegen.vcd");  // opens a sinegen.vcd file for writing signals

    // init Vbuddy
    if (vbdOpen()!=1) return(-1);
    vbdHeader("Lab 2: Sine Wave");
    vbdSetMode(1);

    // initialise input signals
    top->clk = 1;
    top->rst = 0;
    top->en = 1;
    top->incr = 1;

    // main simulation loop
    for(int i = 0; i<500000; i++) {

        int vbd_incr;
        if (i % 50 == 0) {     // only update every 50 cycles so I can see the transition
            vbd_incr = vbdValue();
        }
        top->incr = vbd_incr >> 3;  // scale it down

        for(int clk = 0; clk < 2; clk++){   // taking rising & falling edge of clock cycle
            tfp->dump(2*i+clk);
            top->clk = !top->clk;
            top->eval();
        }
        
        vbdPlot(int(top->dout), 0, 255);

        if ((Verilated::gotFinish()) || (vbdGetkey()=='q')) 
            exit(0);               // ... exit if finish OR 'q' pressed
    }
    vbdClose(); 
    tfp->close();
    exit(0);
}
