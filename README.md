# FIFO

## Code
*FIFO design*
```
module fifo (
    input clk,
    input rst_n,
    input wr_en,                   // Write enable
    input rd_en,                   // Read enable
    input [15:0] data_in,          // 16-bit input data
    output reg [15:0] data_out,    // 16-bit output data
    output reg full,               // FIFO full flag
    output reg empty               // FIFO empty flag
);
    parameter FIFO_DEPTH = 32;     // FIFO depth of 32 elements (each 8 bits wide)

    reg [7:0] fifo [0:FIFO_DEPTH-1]; // 32x8 FIFO memory to store 1 byte per element
    reg [4:0] wr_ptr, rd_ptr;         // 5-bit write and read pointers (0-31 range)
    reg [5:0] count;                  // Counter for elements in the FIFO (0-32 range)

    // Sequential logic for read and write operations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
            data_out <= 16'b0; // Initialize output data
        end else begin
            // Write operation (16-bit data split into two 8-bit parts)
            if (wr_en && (count <= FIFO_DEPTH - 2)) begin
                fifo[wr_ptr] <= data_in[15:8];         // Upper 8 bits of data_in
                fifo[wr_ptr + 1] <= data_in[7:0];      // Lower 8 bits of data_in
                wr_ptr <= (wr_ptr + 2) % FIFO_DEPTH;   // Increment write pointer by 2, wrap if necessary
                count <= count + 2;                    // Increment count by 2
            end
            
            // Read operation (Combine two 8-bit FIFO entries into one 16-bit data_out)
            if (rd_en && (count >= 2)) begin
                data_out <= {fifo[rd_ptr], fifo[rd_ptr + 1]}; // Concatenate two 8-bit values to 16-bit
                rd_ptr <= (rd_ptr + 2) % FIFO_DEPTH;          // Increment read pointer by 2, wrap if necessary
                count <= count - 2;                           // Decrement count by 2
            end
            
            // Update full and empty flags
            full <= (count >= FIFO_DEPTH - 1);
            empty <= (count == 0);
        end
    end
endmodule

```

## RTL simulation 
*commands*
```
$ gvim fifo.v tb_fifo.v
$ gedit fifo.v tb_fifo.v
$ iverilog fifo.v tb_fifo.v
$ ls
$ ./a.out
$ gtkwave fifo_testbench.vcd

```
*gtkwave output*

![FIFO_simulation](https://github.com/user-attachments/assets/c6c3c0d4-1764-4574-93d0-1943341d2101)
![rtl](https://github.com/user-attachments/assets/833ef2f4-22d0-45ff-9939-0726f4b2e8ab)


## RTL synthesis

*commands for synthesis*

```
yosys> read_liberty -lib /lib/sky130_fd_sc_hd__tt_025C_1v80.lib
yosys> read_verilog fifo.v
yosys> synth -top fifo 
yosys> abc -liberty /lib/sky130_fd_sc_hd__tt_025C_1v80.lib
yosys> show
```
![Screenshot from 2024-11-03 15-57-55](https://github.com/user-attachments/assets/17816eb8-f48f-463b-9f80-d3dea04988d5)

## Synthesis

![FIFO_synth](https://github.com/user-attachments/assets/bd9cd38e-09b8-449f-8d40-2ae965b7fce3)
![FIFO_synth1](https://github.com/user-attachments/assets/db4c6f88-2da1-4ca4-a556-47e740517a3d)

## DFFLIBMAP results

![DFFLIBMAP](https://github.com/user-attachments/assets/5f339970-3b61-4981-887e-7a4c044466cf)

## ABC results 

![ABC](https://github.com/user-attachments/assets/7d03121f-7071-44c7-b44c-1b479cc89d1a)

## NETLIST simulation 

![netlist2](https://github.com/user-attachments/assets/b9cbb5c6-ce9c-4efb-ac4d-0a549ad4901c)

**NOTE :** _RTL Simulation is the same as Netlist Simulation_

## STA analasys

![FIFO_slack](https://github.com/user-attachments/assets/e002d4af-a75e-4e3c-9a03-733475c071c1)

~~~
Library used : sky130_fd_sc_hd__tt_025C_1v80
Wost Slack : 3.84

Clock Frequency : 162.337662 MHz
~~~


