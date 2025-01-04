
`timescale 1ns / 1ps

module CPU(
    input clk,
    input reset,
    output reg [15:0] debug_pc,          // Output for monitoring PC
    output reg [31:0] debug_instruction, // Output for monitoring the current instruction
    output reg [1:0] debug_state,        // Output to monitor state
    output reg [31:0] debug_alu_result,  // Output ALU result for monitoring
    output reg debug_change_pc,          // Output to indicate a change in PC
    output reg [15:0] debug_data_address,// Address being accessed
    output reg [31:0] debug_data_value,   // Value at the address
    output reg [31:0] debug_reg1, // Debug output for register 1
    output reg [31:0] debug_reg2  // Debug output for register 2
);

    // Define CPU States
    localparam FETCH = 2'd0,
               DECODE = 2'd1,
               EXECUTE = 2'd2,
               MEMORY = 2'd3;

    // State register
    reg [1:0] state_q = FETCH;
    
    // Program Counter
    reg [15:0] pc_q = 0; 
    wire [31:0] instruction_q; 

    // Wires for Decoder Outputs
    wire [2:0] opcode;
    wire [4:0] reg_addr_0, reg_addr_1, reg_addr_2;
    wire [15:0] addr;

    // Wires for Register File Outputs
    wire [31:0] read_data_0, read_data_1;
    
    // Wires for ALU Outputs
    wire [31:0] alu_result, read_data_mem;
    wire change_pc;

    // Wires for Memory Access
    wire [31:0] mem_read_data;
    reg write_en, write_en_mem, write_en_reg;

    // Instantiate Instruction Memory
    InstructionMemory instruction_memory(
        .inst_address(pc_q),
        .read_data(instruction_q)
    );

    // Instantiate Decoder
    Decoder decoder(
        .inst(instruction_q),
        .opcode(opcode),
        .reg_addr_0(reg_addr_0),
        .reg_addr_1(reg_addr_1),
        .reg_addr_2(reg_addr_2),
        .addr(addr)
    );

    // Instantiate Register File
    RegisterFile reg_file(
        .read_address_0(reg_addr_0),
        .read_address_1(reg_addr_1),
        .write_address_0(reg_addr_2),
        .write_en(write_en_reg), // Write enable for LOAD instruction
        .write_data(read_data_mem),//alu_result // Data to write is the data read from memory
        .read_data_0(read_data_0),
        .read_data_1(read_data_1)
    );

    // Instantiate ALU
    ALU alu(
        .ip_0(read_data_0),
        .ip_1(read_data_1),
        .opcode(opcode),
        .op_0(alu_result),
        .change_pc(change_pc)
    );

    // Instantiate Data Memory
    DataMemory data_memory(
        .data_address(addr),
        .write_en(write_en_mem),
        .write_data(read_data_0),
        .read_data(read_data_mem)
    );

    // Main state machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_q <= 0;
            state_q <= FETCH;
            write_en <= 0;
        end else begin
            case (state_q)
                FETCH: begin
                    pc_q <= pc_q + 1; // Increment PC
                    state_q <= DECODE;
                end
                DECODE: begin
                    state_q <= EXECUTE;
                end
                EXECUTE: begin
                    if (opcode == 3'b000 || opcode == 3'b001) begin // LOAD or STORE
                        state_q <= MEMORY;
                    end else begin
                        state_q <= FETCH; // Non-memory operations complete in EXECUTE
                    end
                    if (change_pc) begin
                        pc_q <= addr; // Handle branch
                    end
                end
                MEMORY: begin
                 write_en_mem <= (opcode == 1); // Store
                  write_en_reg <= (opcode == 0 || opcode >= 4 && opcode <= 7);
                    
                    state_q <= FETCH; // Return to fetch after memory operation
                end
                default: begin
                    state_q <= FETCH;
                end
            endcase
        end
    end

    // Debug signals assignment
    always @(posedge clk) begin
        debug_pc <= pc_q;
        debug_instruction <= instruction_q;
        debug_state <= state_q;
        debug_alu_result <= alu_result;
        debug_change_pc <= change_pc;
        debug_data_address <= addr;
        debug_data_value <= read_data_mem;
        debug_reg1 <= read_data_0; //  register 1 is at read_data_0
        debug_reg2 <= read_data_1; //  register 2 is at read_data_1
    end

endmodule 