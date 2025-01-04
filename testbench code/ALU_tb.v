
`timescale 1ns / 1ps

module ALU_tb;

    // Inputs
    reg [31:0] ip_0;
    reg [31:0] ip_1;
    reg [2:0] opcode;

    // Outputs
    wire [31:0] op_0;
    wire change_pc;

    // Instantiate the ALU module
    ALU uut (
        .ip_0(ip_0),
        .ip_1(ip_1),
        .opcode(opcode),
        .op_0(op_0),
        .change_pc(change_pc)
    );

    initial begin
        // Initialize Inputs
        ip_0 = 0;
        ip_1 = 0;
        opcode = 0;

        // Wait for 100 ns for global reset to finish
        #10;

        // Test ADD operation
        ip_0 = 15; // decimal
        ip_1 = 10; // decimal
        opcode = 4; // Opcode for ADD (decimal)
        #10;
        $display("ADD Test: %d + %d = %d", ip_0, ip_1, op_0);

        // Test SUB operation
        ip_0 = 20; // decimal
        ip_1 = 10; // decimal
        opcode = 5; // Opcode for SUB (decimal)
        #10;
        $display("SUB Test: %d - %d = %d", ip_0, ip_1, op_0);

        // Test AND operation
        ip_0 = 5; // decimal
        ip_1 = 3; // decimal
        opcode = 6; // Opcode for AND (decimal)
        #10;
        $display("AND Test: %d & %d = %d", ip_0, ip_1, op_0);

        // Test OR operation
        ip_0 = 5; // decimal
        ip_1 = 2; // decimal
        opcode = 7; // Opcode for OR (decimal)
        #10;
        $display("OR Test: %d | %d = %d", ip_0, ip_1, op_0);

        // Test BEQ operation
        ip_0 = 10; // decimal
        ip_1 = 10; // decimal
        opcode = 2; // Opcode for BEQ (decimal)
        #10;
        $display("BEQ Test: %d == %d, change_pc = %b", ip_0, ip_1, change_pc);

        // Test BLT operation
        ip_0 = 5; // decimal
        ip_1 = 10; // decimal
        opcode = 3; // Opcode for BLT (decimal)
        #10;
        $display("BLT Test: %d < %d, change_pc = %b", ip_0, ip_1, change_pc);

        // Finish the simulation
        $finish;
    end
      
endmodule


