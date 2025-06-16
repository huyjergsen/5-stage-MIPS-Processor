# 5-stage-MIPS-Processor# 5-stage-MIPS-Processor

## Project Description
This project implements the design and simulation of a MIPS processor using a 5-stage pipeline architecture, written in Verilog HDL. The processor consists of the following main stages:

1. **Instruction Fetch (IF)**: Fetches instructions from memory
2. **Instruction Decode (ID)**: Decodes instructions and reads register values
3. **Execute (EX)**: Performs arithmetic and logical operations
4. **Memory Access (MEM)**: Accesses data memory
5. **Write Back (WB)**: Writes results back to registers

## Key Features

### Supported Instruction Set
- Arithmetic and logical instructions
- Load/store instructions for memory access
- Conditional branch instructions

### Hazard Handling
- Data Hazard: Using forwarding technique (forwarding unit)
- Control Hazard: Basic handling through stall and branch prediction

## Testing

The project includes test cases to verify:
- Operation of each pipeline stage
- Hazard handling
- MIPS instruction accuracy
- Overall processor performance

## Contributing

Contributions are welcome. Please feel free to submit issues or pull requests.