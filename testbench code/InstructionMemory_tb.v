`timescale 1ns / 1ps

module InstructionMemory_tb;

    // Inputs
    reg [15:0] inst_address;

    // Outputs
    wire [31:0] read_data;

    // Instantiate the InstructionMemory module
    InstructionMemory uut (
        .inst_address(inst_address), 
        .read_data(read_data)
    );
    
integer i;
    initial begin
        // Initialize Inputs
        inst_address = 0;
        // Wait for 20 ns for global reset to finish
        #20;
        
        // Stimulus: Read each instruction from the memory and display it
        for ( i = 0; i < 9; i=i+1) begin
            inst_address = i;  // Apply the address
            #10;  // Wait for the output to stabilize
            $display("Time: %t, Address: %h, Instruction: %h", $time, inst_address, read_data);
        end
        
        // Finish the simulation
        $finish;
    end
      
endmodule

