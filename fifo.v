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

