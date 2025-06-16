module MIPS_Pipeline_TB();
    
    reg clk, reset;
    wire [31:0] reg_t0;   // Register 8
    wire [31:0] reg_t1;   // Register 9
    wire [31:0] reg_t2;   // Register 10
    wire [31:0] reg_t3;   // Register 11
    wire [31:0] reg_t4;   // Register 12
    wire [31:0] reg_t5;   // Register 13
    wire [31:0] reg_t6;   // Register 14
    wire [31:0] reg_t7;   // Register 15

    integer cycle_count = 0;
    
    // Khoi tao MIPS pipeline
    MIPS_Pipeline mips_cpu(
        .clk(clk),
        .reset(reset),
        .reg_t0(reg_t0),
        .reg_t1(reg_t1),
        .reg_t2(reg_t2),
        .reg_t3(reg_t3),
        .reg_t4(reg_t4),
        .reg_t5(reg_t5),
        .reg_t6(reg_t6),
        .reg_t7(reg_t7)
    );
    
    // Khoi tao Clock 
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period, 100MHz
    end
    
    // Test instruction memory
    initial begin
        mips_cpu.inst_memory.Memory[0] = 32'h20080000 | 10;  // addi $t0, $zero, 10
        mips_cpu.inst_memory.Memory[1] = 32'h20090000 | 20;  // addi $t1, $zero, 20
        mips_cpu.inst_memory.Memory[2] = 32'h01095020;       // add $t2, $t0, $t1
        mips_cpu.inst_memory.Memory[3] = 32'hAC0A0000;       // sw $t2, 0($zero)
        mips_cpu.inst_memory.Memory[4] = 32'h8C0B0000;       // lw $t3, 0($zero)
        mips_cpu.inst_memory.Memory[5] = 32'h114B0002;       // beq $t2, $t3, 2
        mips_cpu.inst_memory.Memory[6] = 32'h200C0000 | 99;  // addi $t4, $zero, 99
        mips_cpu.inst_memory.Memory[7] = 32'h200D0000 | 55;  // addi $t5, $zero, 55
    end
    
    // Task to print all registers
    task print_registers;
        begin
            $display("\n=== Register Values at Cycle %0d ===", cycle_count);
            $display("$t0 (reg 8):  %d", mips_cpu.register_file.Registers[8]);
            $display("$t1 (reg 9):  %d", mips_cpu.register_file.Registers[9]);
            $display("$t2 (reg 10): %d", mips_cpu.register_file.Registers[10]);
            $display("$t3 (reg 11): %d", mips_cpu.register_file.Registers[11]);
            $display("$t4 (reg 12): %d", mips_cpu.register_file.Registers[12]);
            $display("$t5 (reg 13): %d", mips_cpu.register_file.Registers[13]);
            $display("$t6 (reg 14): %d", mips_cpu.register_file.Registers[14]);
            $display("$t7 (reg 15): %d", mips_cpu.register_file.Registers[15]);
            $display("$t8 (reg 24): %d", mips_cpu.register_file.Registers[24]);
            $display("$t9 (reg 25): %d", mips_cpu.register_file.Registers[25]);
            $display("----------------------------------------");
        end
    endtask
    
    // Test sequence
    initial begin
        $display("Starting MIPS Pipeline Test");
        $display("Time\tPC\tInstruction\tPhase");
        $display("----\t--\t----------\t-----");
        
        reset = 1;
        #15;
        reset = 0;
        
        repeat(20) begin
            @(posedge clk);
            cycle_count = cycle_count + 1;
	$display("\n=== Cycle %0d ===", cycle_count);
            $display("%0t\t%h\t%h\t%s", $time, mips_cpu.pc_current, 
                     mips_cpu.instruction, get_instruction_name(mips_cpu.instruction));
            
            if (mips_cpu.ex_mem_mem_write)
                $display("Memory[%h] = %d", mips_cpu.ex_mem_alu_result, mips_cpu.ex_mem_write_data);
        end
        
        #10;
        $display("\n=== Final Register Values ===");
        print_registers();
        
        $display("\n=== Memory Contents ===");
        $display("Memory[0]: %d", mips_cpu.data_memory.Memory[0]);
        
        if (mips_cpu.register_file.Registers[8] == 10 &&
            mips_cpu.register_file.Registers[9] == 20 &&
            mips_cpu.register_file.Registers[10] == 30 &&
            mips_cpu.register_file.Registers[11] == 30 &&
            mips_cpu.register_file.Registers[12] == 0 &&
            mips_cpu.register_file.Registers[13] == 55) begin
            $display("\n*** TEST PASSED ***");
        end else begin
            $display("\n*** TEST FAILED ***");
        end
        
        $finish;
    end
    
    // Instruction name decoding
    function [8*10:1] get_instruction_name;
        input [31:0] instruction;
        begin
            case (instruction[31:26])
                6'b000000: get_instruction_name = "R-TYPE";
                6'b001000: get_instruction_name = "ADDI";
                6'b100011: get_instruction_name = "LW";
                6'b101011: get_instruction_name = "SW";
                6'b000100: get_instruction_name = "BEQ";
                6'b000010: get_instruction_name = "JUMP";
                default:   get_instruction_name = "UNKNOWN";
            endcase
        end
    endfunction
    
    // Pipeline state 
    always @(posedge clk) begin
        if (!reset) begin
            $display("=== Pipeline Status at time %0t ===", $time);
            $display("IF:  PC=%h, Instruction=%h", mips_cpu.pc_current, mips_cpu.instruction);
            $display("ID:  PC=%h, Instruction=%h", mips_cpu.if_id_pc, mips_cpu.if_id_instruction);
            $display("EX:  ALU_A=%h, ALU_B=%h, ALU_Result=%h", 
                     mips_cpu.alu_input1, mips_cpu.alu_input2, mips_cpu.alu_result);
            $display("MEM: Address=%h, WriteData=%h, ReadData=%h", 
                     mips_cpu.ex_mem_alu_result, mips_cpu.ex_mem_write_data, mips_cpu.mem_read_data);
            $display("WB:  WriteReg=%d, WriteData=%h", 
                     mips_cpu.mem_wb_write_reg, mips_cpu.write_data);
            $display("Hazards: Stall=%b, ForwardA=%b, ForwardB=%b", 
                     mips_cpu.stall, mips_cpu.forward_a, mips_cpu.forward_b);
            $display("----------------------------------------");
        end
    end
    
endmodule
