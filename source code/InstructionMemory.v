`timescale 1ns / 1ps
/*
Instruction Module

A 2-d register array with one read port
*/


module  InstructionMemory(
    input [15:0] inst_address,
    output [31:0] read_data
    );
    
    reg [31:0] ram [255:0];
        // Initialize Instructions in the memory for testing
    initial begin
        //ram[0] <= 32'h2000_0004; // Store instruction that reads registerFile[0] and write to dataMemory[4].
       ram[0] <= 32'h0000_0000;
       ram[1] <= 32'h0100_0004; // Load data from address 4 into register 1
       ram[2] <= 32'h2100_0004; // store data from register 1 into adress 4
       ram[3] <= 32'h4110_0008; // branch to adress 8 if register 1 equal register 2
       ram[4] <= 32'h6110_0008; // branch to adress 8 if register 1 is less than register 2
       ram[5] <= 32'h8110_C000; // add register 1 and register 2, result in register 3
       ram[6] <= 32'hA110_C000; // sub register 2 from register 1, result in register 3
       ram[7] <= 32'hC110_C000; // AND register 1 with register 2, result in 3
       ram[8] <= 32'hE110_C000; // OR register 1 with register 2, result in 3
    end
    
    // Assign statement to read ram based on inst_address
       assign read_data = ram[inst_address];
    
endmodule