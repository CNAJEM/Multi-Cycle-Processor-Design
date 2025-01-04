`timescale 1ns / 1ps

module DataMemory_tb;

    // Inputs
    reg [15:0] data_address;
    reg write_en;
    reg [31:0] write_data;

    // Output
    wire [31:0] read_data;

    // Instantiate the DataMemory module
    DataMemory uut (
        .data_address(data_address),
        .write_en(write_en),
        .write_data(write_data),
        .read_data(read_data)
    );

    integer i;

    initial begin
        // Initialize Inputs
        data_address = 0;
        write_en = 0;
        write_data = 0;

        // Wait for 10 ns for global reset to finish
        #10;

        // Read initial values from three specific data locations
        for (i = 0; i < 4; i = i + 1) begin
            data_address = i; // Set data address to read from
            #10; // Wait for read to stabilize
            $display("Initial read at address %d: %h", data_address, read_data);
        end
        
        // Write a random value to a specific location
        data_address = 5'd3;  // Choose a data address to write to
        write_data = 32'h12345678; // Random data to write
        write_en = 1; // Enable the write
        #10; // Perform the write operation

        // Disable write and read from the same location to verify the write
        write_en = 0;
        data_address = 5'd3;
        #10; // Allow time for the read to take place
        $display("Data read at address %d after write: %h (Expected: 12345678)", data_address, read_data);

        // Finish the simulation
        $finish;
    end
      
endmodule

