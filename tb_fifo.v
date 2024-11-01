`timescale 1ns / 1ps

module tb_fifo;
    reg clk;
    reg rst_n;
    reg wr_en;
    reg rd_en;
    reg [15:0] data_in;
    wire [15:0] data_out;
    wire full;
    wire empty;

    // Instantiate the FIFO module
    fifo uut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );
    initial begin
        $dumpfile("fifo_testbench.vcd"); // Specifies the VCD output file name
        $dumpvars(0, tb_fifo);           // Dumps all variables in the tb_fifo module
    end

    // Clock generation
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        // Apply reset
        #10;
        rst_n = 1; // Release reset

        // Test case 1: Write first data to FIFO
        wr_en = 1; // Enable write
        data_in = 16'hABCD; // First data
        #10; // Wait for a clock cycle

        // Test case 1: Write second data to FIFO
        data_in = 16'h1234; // Second data
        #10; // Wait for a clock cycle

        // Disable write and check full flag
        wr_en = 0; 
        #10; 

        if (full) begin
            $display("FIFO is full at time %0t after writing two items.", $time);
        end else begin
            $display("FIFO is not full at time %0t after writing two items.", $time);
        end

        // Test case 2: Read data from FIFO
        rd_en = 1; // Enable read
        #10; // Wait for a clock cycle

        // Check output data
        if (!empty) begin
            $display("Read data: %h at time %0t", data_out, $time);
        end else begin
            $display("FIFO is empty at time %0t", $time);
        end

        // Read next data
        #10; // Wait for a clock cycle
        if (!empty) begin
            $display("Read data: %h at time %0t", data_out, $time);
        end else begin
            $display("FIFO is empty at time %0t", $time);
        end

        // Disable read after reading
        rd_en = 0; 
        #10;

        // Test case 3: Write additional data to FIFO
        wr_en = 1; // Enable write
        data_in = 16'h5678; // Third data
        #10; // Wait for a clock cycle

        // Write fourth data to FIFO
        data_in = 16'h9ABC; // Fourth data
        #10; // Wait for a clock cycle

        // Disable write
        wr_en = 0; 
        #10;

        // Check if FIFO is full after writing two more items
        if (full) begin
            $display("FIFO is full at time %0t after writing additional items.", $time);
        end else begin
            $display("FIFO is not full at time %0t after writing additional items.", $time);
        end

        // Test case 4: Read all remaining data from FIFO
        rd_en = 1; // Enable read
        #10; // Wait for a clock cycle

        // Check output data
        if (!empty) begin
            $display("Read data: %h at time %0t", data_out, $time);
        end else begin
            $display("FIFO is empty at time %0t", $time);
        end

        // Read next data
        #10; // Wait for a clock cycle
        if (!empty) begin
            $display("Read data: %h at time %0t", data_out, $time);
        end else begin
            $display("FIFO is empty at time %0t", $time);
        end

        // Final read
        #10; // Wait for a clock cycle
        if (!empty) begin
            $display("Read data: %h at time %0t", data_out, $time);
        end else begin
            $display("FIFO is empty at time %0t", $time);
        end

        // Disable read after reading
        rd_en = 0; 
        #10;

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | wr_en: %b | rd_en: %b | data_in: %h | data_out: %h | full: %b | empty: %b", 
                 $time, wr_en, rd_en, data_in, data_out, full, empty);
    end
endmodule

