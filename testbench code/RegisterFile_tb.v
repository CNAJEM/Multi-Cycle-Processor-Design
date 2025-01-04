`timescale 1ns / 1ps

module RegisterFile_tb;

    // Inputs
    reg [4:0] read_address_0;
    reg [4:0] read_address_1;
    reg [4:0] write_address_0;
    reg write_en;
    reg [31:0] write_data;

    // Outputs
    wire [31:0] read_data_0;
    wire [31:0] read_data_1;

    // Instantiate the RegisterFile module
    RegisterFile uut (
        .read_address_0(read_address_0),
        .read_address_1(read_address_1),
        .write_address_0(write_address_0),
        .write_en(write_en),
        .write_data(write_data),
        .read_data_0(read_data_0),
        .read_data_1(read_data_1)
    );

    initial begin
        // Initialize Inputs
        read_address_0 = 0;
        read_address_1 = 0;
        write_address_0 = 0;
        write_en = 0;
        write_data = 0;

        // Wait for 10 ns for global reset to finish
        #10;

        // Test Write Operation
        write_address_0 = 5'd1;   // Write to register 1
        write_data = 32'hA5A5A5A5;
        write_en = 1'b1;          // Enable writing
        #10;                      // Wait a moment
        write_en = 1'b0;          // Disable writing

        // Test Read Operation
        read_address_0 = 5'd1;    // Read from register 1
        read_address_1 = 5'd2;    // Read from register 2
        #10;

        $display("Register 1 Data: %h (Expected: A5A5A5A5)", read_data_0);
        $display("Register 2 Data: %h (Expected: 00000000)", read_data_1);

        // Test Read After Write with Different Address
        write_address_0 = 5'd2;   // Write to register 2
        write_data = 32'h5A5A5A5A;
        write_en = 1'b1;          // Enable writing
        #10;
        write_en = 1'b0;          // Disable writing
        #10;

        $display("Register 1 Data: %h (Expected: A5A5A5A5)", read_data_0);
        $display("Register 2 Data: %h (Expected: 5A5A5A5A)", read_data_1);

        // Add more test cases as needed for read and write operations

        // Finish the simulation
        $finish;
    end

    // Add a clock if necessary for your design, although this RegisterFile design does not use one.
      
endmodule



/*
Testbench for RegisterFile Module

This testbench will check the functionality of writing to and reading from the register file.
*/

/*`timescale 1ns / 1ps

module RegisterFile_tb;

    // Inputs to the RegisterFile
    reg [4:0] read_address_0;
    reg [4:0] read_address_1;
    reg [4:0] write_address_0;
    reg write_en;
    reg [31:0] write_data;

    // Outputs from the RegisterFile
    wire [31:0] read_data_0;
    wire [31:0] read_data_1;

    // Instantiate the RegisterFile
    RegisterFile rf(
        .read_address_0(read_address_0),
        .read_address_1(read_address_1),
        .write_address_0(write_address_0),
        .write_en(write_en),
        .write_data(write_data),
        .read_data_0(read_data_0),
        .read_data_1(read_data_1)
    );

    // Testbench logic
    initial begin
        // Initialize Inputs
        read_address_0 = 0;
        read_address_1 = 0;
        write_address_0 = 0;
        write_en = 0;
        write_data = 0;

        // Wait for global reset to finish
        #100;

        // Example test case 1: Write and then read from the same address
        write_address_0 = 5;
        write_data = 32'hA5A5A5A5;
        write_en = 1;
        #10; // small delay to model write timing
        write_en = 0; // disable writing
        read_address_0 = 5;
        #10; // delay to allow read operation

        // Example test case 2: Write to one address and read from another
        write_address_0 = 10;
        write_data = 32'h12345678;
        write_en = 1;
        #10;
        write_en = 0;
        read_address_0 = 10;
        read_address_1 = 5; // previously written address
        #10;

        // Add more test cases as needed to verify all functionality

        // Finish simulation
        $finish;
    end

    // Optional: Monitor changes in outputs
    initial begin
        $monitor("At time %t, read_data_0 = %h, read_data_1 = %h", $time, read_data_0, read_data_1);
    end
    
endmodule*/


