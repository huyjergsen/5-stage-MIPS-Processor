module MIPS_Pipeline(
    input clk,
    input reset,
    // Thêm output cho các thanh ghi $t0-$t7 (registers 8-15)
    output [31:0] reg_t0,   // Register 8
    output [31:0] reg_t1,   // Register 9
    output [31:0] reg_t2,   // Register 10
    output [31:0] reg_t3,   // Register 11
    output [31:0] reg_t4,   // Register 12
    output [31:0] reg_t5,   // Register 13
    output [31:0] reg_t6,   // Register 14
    output [31:0] reg_t7    // Register 15
);
    
    // ========== Wires and Registers ==========
    
    // PC and Instruction Fetch
    wire [31:0] pc_current, pc_next, pc_plus4;
    wire [31:0] instruction;
    wire [31:0] if_id_pc, if_id_instruction;
    
    // Control signals
    wire reg_write, mem_to_reg, mem_write, mem_read, branch, alu_src, reg_dst;
    wire [1:0] alu_op;
    wire pc_write, if_id_write, stall;
    wire jump; // Thêm tín hiệu jump bị thiếu
    
    // Register file
    wire [4:0] write_reg;
    wire [31:0] write_data, read_data1, read_data2;
    
    // ALU and forwarding
    wire [31:0] alu_input1, alu_input2, alu_result;
    wire [3:0] alu_control;
    wire zero;
    wire [1:0] forward_a, forward_b;
    wire [31:0] forwarded_a, forwarded_b;
    
    // Sign extension and shifting
    wire [31:0] sign_extended;
    wire [31:0] branch_offset;
    wire [31:0] branch_address;
    
    // Data memory
    wire [31:0] mem_read_data;
    
    // Branch control
    wire branch_taken;
    
    // Pipeline registers signals
    wire id_ex_reg_write, id_ex_mem_to_reg, id_ex_mem_write, id_ex_mem_read;
    wire id_ex_branch, id_ex_alu_src, id_ex_reg_dst;
    wire [1:0] id_ex_alu_op;
    wire [31:0] id_ex_pc, id_ex_read_data1, id_ex_read_data2, id_ex_sign_ext;
    wire [4:0] id_ex_rs, id_ex_rt, id_ex_rd;
    wire [5:0] id_ex_funct;
    
    wire ex_mem_reg_write, ex_mem_mem_to_reg, ex_mem_mem_write, ex_mem_mem_read;
    wire ex_mem_branch, ex_mem_zero;
    wire [31:0] ex_mem_branch_addr, ex_mem_alu_result, ex_mem_write_data;
    wire [4:0] ex_mem_write_reg;
    
    wire mem_wb_reg_write, mem_wb_mem_to_reg;
    wire [31:0] mem_wb_read_data, mem_wb_alu_result;
    wire [4:0] mem_wb_write_reg;
    
    // ========== Stage 1: Instruction Fetch (IF) ==========
    
    PC pc_register(
        .clk(clk),
        .reset(reset),
        .NextPC(pc_next),
        .CurrentPC(pc_current)
    );
    
    PCAdder pc_adder(
        .PC(pc_current),
        .PCPlus4(pc_plus4)
    );
    
    InstructionMemory inst_memory(
        .Address(pc_current),
        .Instruction(instruction)
    );
    
    // PC control logic
    assign branch_taken = ex_mem_branch & ex_mem_zero;
    
    Mux21 #(32) pc_mux(
        .Input0(pc_plus4),
        .Input1(ex_mem_branch_addr),
        .Select(branch_taken),
        .Output(pc_next)
    );
    
    // IF/ID Pipeline Register
    IF_ID_Register if_id_reg(
        .clk(clk),
        .reset(reset),
        .flush(branch_taken),
        .stall(~if_id_write),
        .PC_In(pc_plus4),
        .Instruction_In(instruction),
        .PC_Out(if_id_pc),
        .Instruction_Out(if_id_instruction)
    );
    
    // ========== Stage 2: Instruction Decode (ID) ==========
    
    ControlUnit control_unit(
        .Opcode(if_id_instruction[31:26]),
        .RegWrite(reg_write),
        .MemtoReg(mem_to_reg),
        .MemWrite(mem_write),
        .MemRead(mem_read),
        .Branch(branch),
        .ALUSrc(alu_src),
        .RegDst(reg_dst),
        .Jump(jump),
        .ALUOp(alu_op)
    );
    
    RegisterFile register_file(
        .clk(clk),
        .reset(reset),
        .RegWrite(mem_wb_reg_write),
        .ReadReg1(if_id_instruction[25:21]),
        .ReadReg2(if_id_instruction[20:16]),
        .WriteReg(mem_wb_write_reg),
        .WriteData(write_data),
        .ReadData1(read_data1),
        .ReadData2(read_data2),
        // Thêm output cho các thanh ghi $t0-$t7
        .reg_t0_out(reg_t0),
        .reg_t1_out(reg_t1),
        .reg_t2_out(reg_t2),
        .reg_t3_out(reg_t3),
        .reg_t4_out(reg_t4),
        .reg_t5_out(reg_t5),
        .reg_t6_out(reg_t6),
        .reg_t7_out(reg_t7)
    );
    
    SignExtend sign_extend(
        .DataIn(if_id_instruction[15:0]),
        .DataOut(sign_extended)
    );
    
    // Hazard Detection
    HazardDetectionUnit hazard_unit(
        .ID_EX_Rt(id_ex_rt),
        .ID_EX_MemRead(id_ex_mem_read),
        .IF_ID_Rs(if_id_instruction[25:21]),
        .IF_ID_Rt(if_id_instruction[20:16]),
        .PCWrite(pc_write),
        .IF_ID_Write(if_id_write),
        .Stall(stall)
    );
    
    // ID/EX Pipeline Register
    ID_EX_Register id_ex_reg(
        .clk(clk),
        .reset(reset),
        .flush(stall || branch_taken),
        .RegWrite_In(stall ? 1'b0 : reg_write),
        .MemtoReg_In(stall ? 1'b0 : mem_to_reg),
        .MemWrite_In(stall ? 1'b0 : mem_write),
        .MemRead_In(stall ? 1'b0 : mem_read),
        .Branch_In(stall ? 1'b0 : branch),
        .ALUSrc_In(stall ? 1'b0 : alu_src),
        .RegDst_In(stall ? 1'b0 : reg_dst),
        .ALUOp_In(stall ? 2'b0 : alu_op),
        .PC_In(if_id_pc),
        .ReadData1_In(read_data1),
        .ReadData2_In(read_data2),
        .SignExtImm_In(sign_extended),
        .Rs_In(if_id_instruction[25:21]),
        .Rt_In(if_id_instruction[20:16]),
        .Rd_In(if_id_instruction[15:11]),
        .Funct_In(if_id_instruction[5:0]),
        .RegWrite_Out(id_ex_reg_write),
        .MemtoReg_Out(id_ex_mem_to_reg),
        .MemWrite_Out(id_ex_mem_write),
        .MemRead_Out(id_ex_mem_read),
        .Branch_Out(id_ex_branch),
        .ALUSrc_Out(id_ex_alu_src),
        .RegDst_Out(id_ex_reg_dst),
        .ALUOp_Out(id_ex_alu_op),
        .PC_Out(id_ex_pc),
        .ReadData1_Out(id_ex_read_data1),
        .ReadData2_Out(id_ex_read_data2),
        .SignExtImm_Out(id_ex_sign_ext),
        .Rs_Out(id_ex_rs),
        .Rt_Out(id_ex_rt),
        .Rd_Out(id_ex_rd),
        .Funct_Out(id_ex_funct)
    );
    
    // ========== Stage 3: Execute (EX) ==========
    
    // Forwarding Unit
    ForwardingUnit forwarding_unit(
        .ID_EX_Rs(id_ex_rs),
        .ID_EX_Rt(id_ex_rt),
        .EX_MEM_Rd(ex_mem_write_reg),
        .MEM_WB_Rd(mem_wb_write_reg),
        .EX_MEM_RegWrite(ex_mem_reg_write),
        .MEM_WB_RegWrite(mem_wb_reg_write),
        .ForwardA(forward_a),
        .ForwardB(forward_b)
    );
    
    // Forwarding Muxes
    Mux31 #(32) forward_mux_a(
        .Input0(id_ex_read_data1),
        .Input1(write_data),
        .Input2(ex_mem_alu_result),
        .Select(forward_a),
        .Output(forwarded_a)
    );
    
    Mux31 #(32) forward_mux_b(
        .Input0(id_ex_read_data2),
        .Input1(write_data),
        .Input2(ex_mem_alu_result),
        .Select(forward_b),
        .Output(forwarded_b)
    );
    
    // ALU input selection
    assign alu_input1 = forwarded_a;
    
    Mux21 #(32) alu_src_mux(
        .Input0(forwarded_b),
        .Input1(id_ex_sign_ext),
        .Select(id_ex_alu_src),
        .Output(alu_input2)
    );
    
    // ALU Control
    ALUControl alu_ctrl(
        .ALUOp(id_ex_alu_op),
        .Funct(id_ex_funct),
        .ALUControlOut(alu_control)
    );
    
    // ALU
    ALU alu(
        .A(alu_input1),
        .B(alu_input2),
        .ALUControl(alu_control),
        .ALUResult(alu_result),
        .Zero(zero)
    );
    
    // Write register selection
    Mux21 #(5) write_reg_mux(
        .Input0(id_ex_rt),
        .Input1(id_ex_rd),
        .Select(id_ex_reg_dst),
        .Output(write_reg)
    );
    
    // Branch address calculation
    ShiftLeft2 branch_shift(
        .DataIn(id_ex_sign_ext),
        .DataOut(branch_offset)
    );
    
    Adder branch_adder(
        .A(id_ex_pc),
        .B(branch_offset),
        .Sum(branch_address)
    );
    
    // EX/MEM Pipeline Register
    EX_MEM_Register ex_mem_reg(
        .clk(clk),
        .reset(reset),
        .flush(1'b0),
        .RegWrite_In(id_ex_reg_write),
        .MemtoReg_In(id_ex_mem_to_reg),
        .MemWrite_In(id_ex_mem_write),
        .MemRead_In(id_ex_mem_read),
        .Branch_In(id_ex_branch),
        .BranchAddress_In(branch_address),
        .Zero_In(zero),
        .ALUResult_In(alu_result),
        .WriteData_In(forwarded_b),
        .WriteReg_In(write_reg),
        .RegWrite_Out(ex_mem_reg_write),
        .MemtoReg_Out(ex_mem_mem_to_reg),
        .MemWrite_Out(ex_mem_mem_write),
        .MemRead_Out(ex_mem_mem_read),
        .Branch_Out(ex_mem_branch),
        .BranchAddress_Out(ex_mem_branch_addr),
        .Zero_Out(ex_mem_zero),
        .ALUResult_Out(ex_mem_alu_result),
        .WriteData_Out(ex_mem_write_data),
        .WriteReg_Out(ex_mem_write_reg)
    );
    
    // ========== Stage 4: Memory Access (MEM) ==========
    
    DataMemory data_memory(
        .clk(clk),
        .MemWrite(ex_mem_mem_write),
        .MemRead(ex_mem_mem_read),
        .Address(ex_mem_alu_result),
        .WriteData(ex_mem_write_data),
        .ReadData(mem_read_data)
    );
    
    // MEM/WB Pipeline Register
    MEM_WB_Register mem_wb_reg(
        .clk(clk),
        .reset(reset),
        .flush(1'b0),
        .RegWrite_In(ex_mem_reg_write),
        .MemtoReg_In(ex_mem_mem_to_reg),
        .ReadData_In(mem_read_data),
        .ALUResult_In(ex_mem_alu_result),
        .WriteReg_In(ex_mem_write_reg),
        .RegWrite_Out(mem_wb_reg_write),
        .MemtoReg_Out(mem_wb_mem_to_reg),
        .ReadData_Out(mem_wb_read_data),
        .ALUResult_Out(mem_wb_alu_result),
        .WriteReg_Out(mem_wb_write_reg)
    );
    
    // ========== Stage 5: Write Back (WB) ==========
    
    Mux21 #(32) write_back_mux(
        .Input0(mem_wb_alu_result),
        .Input1(mem_wb_read_data),
        .Select(mem_wb_mem_to_reg),
        .Output(write_data)
    );
    
endmodule