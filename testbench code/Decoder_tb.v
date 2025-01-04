`timescale 1ns / 1ps

module Decoder_tb;

    // Input
    reg [31:0] inst;

    // Outputs
    wire [2:0] opcode;
    wire [4:0] reg_addr_0;
    wire [4:0] reg_addr_1;
    wire [4:0] reg_addr_2;
    wire [15:0] addr;

    // Instantiate the Decoder module
    Decoder uut (
        .inst(inst), 
        .opcode(opcode),
        .reg_addr_0(reg_addr_0),
        .reg_addr_1(reg_addr_1),
        .reg_addr_2(reg_addr_2),
        .addr(addr)
    );

    // Array of test instructions
    reg [31:0] test_instructions[7:0];
    integer i;

    initial begin
        // Initialize test instructions
        test_instructions[0] = 32'h0100_0004;
        test_instructions[1] = 32'h2100_0004;
        test_instructions[2] = 32'h4110_0008;
        test_instructions[3] = 32'h6110_0008;
        test_instructions[4] = 32'h8110_C000;
        test_instructions[5] = 32'hA110_C000;
        test_instructions[6] = 32'hC110_C000;
        test_instructions[7] = 32'hE110_C000;

        // Wait for 100 ns for global reset to finish
        #10;
        
        // Stimulus: Apply each test instruction and display the outputs
        for (i = 0; i < 8; i = i + 1) begin
            inst = test_instructions[i];
            #10;  // Wait for the output to stabilize
            $display("Time: %t, Instruction: %h, Opcode: %b, reg_addr_0: %d, reg_addr_1: %d, reg_addr_2: %d, addr: %h",
                     $time, inst, opcode, reg_addr_0, reg_addr_1, reg_addr_2, addr);
        end

        // Finish the simulation
        $finish;
    end
      
endmodule

