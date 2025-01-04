
`timescale 1ns / 1ps

module CPU_tb();

    reg clk;
    reg reset;

    // Outputs for observation
    wire [15:0] debug_pc;
    wire [31:0] debug_instruction;
    wire [1:0] debug_state;
    wire [31:0] debug_alu_result;
    wire debug_change_pc;
    wire [15:0] debug_data_address;
    wire [31:0] debug_data_value;
    wire [31:0] debug_reg1;
    wire [31:0] debug_reg2;

    // Instantiate the CPU module
    CPU uut(
        .clk(clk),
        .reset(reset),
        .debug_pc(debug_pc),
        .debug_instruction(debug_instruction),
        .debug_state(debug_state),
        .debug_alu_result(debug_alu_result),
        .debug_change_pc(debug_change_pc),
        .debug_data_address(debug_data_address),
        .debug_data_value(debug_data_value),
        .debug_reg1(debug_reg1),
        .debug_reg2(debug_reg2)
        
        
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Reset sequence
    initial begin
        reset = 1; // Assert reset
        #20;       // Maintain reset for 20ns
        reset = 0; // Deassert reset
    end

    // Monitoring and Debugging
    initial begin
        $monitor("Time=%t, PC=%d, State=%d, Instruction=%h, ALU Result=%d, Change PC=%b", 
                 $time, debug_pc, debug_state, debug_instruction, debug_alu_result, debug_change_pc,debug_reg1,debug_reg2);
    end

    // Check for branch and print memory value
    always @(posedge debug_change_pc) begin
        if (debug_change_pc) begin
            $display("Branch taken at time %t: Address %h, Data %h", $time, debug_data_address, debug_data_value);
        end
    end

    // Simulation time control
    initial begin
        #300; // Run the simulation for 1000 ns
        $finish; // End the simulation
    end

endmodule

