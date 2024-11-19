# RISC-V Processor Implementation in Verilog

This is a Verilog implementation of a simplified RISC-V processor. The design incorporates key components required for executing fundamental RISC-V instructions and simulating their behavior. The project focuses on modular design and verification through simulation.

## Key Features
- **Program Counter (PC)**: Manages the address of the current instruction.
- **Instruction Memory**: Stores and retrieves RISC-V instructions, including R-type, I-type, L-type, S-type, and SB-type.
- **Register File**: Provides 32 general-purpose registers with read and write functionalities.
- **Immediate Generator**: Generates sign-extended immediate values for instructions.
- **Control Unit**: Decodes instruction opcodes and produces control signals for execution.
- **Arithmetic Logic Unit (ALU)**: Performs arithmetic and logical operations based on control signals.
- **Data Memory**: Supports read and write operations for load/store instructions.
- **Multiplexers**: Facilitates control flow and data selection.

## Project Highlights
- Developed all components in Verilog, adhering to the RISC-V architecture specification.
- Designed a top module integrating all submodules into a cohesive processor.
- Implemented a testbench for simulation to verify the correct execution of instructions and control flow.
- Organized the memory to handle various instruction types and immediate values.

## Potential Applications
This design is a fundamental step toward understanding and building RISC-V-based processors. It serves as a foundation for implementing more advanced features, such as pipelining, hazard detection, and cache integration which will be done in the future.
