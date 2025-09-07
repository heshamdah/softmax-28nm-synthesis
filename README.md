# Softmax Accelerator Synthesis Project

## Overview
This project implements a softmax accelerator function synthesis flow using 28nm Samsung technology. The softmax function is a key component in neural network architectures, particularly in the final layer for classification tasks.

## Project Structure
```
softmax_synthesis/
├── scripts/                    # Synthesis scripts
│   ├── 28nm_submodule.tcl     # Submodule synthesis script
│   ├── 28nm_top.tcl          # Top-level synthesis script
│   └── constraint_28nm.sdc    # Timing constraints
├── Results/                   # Synthesis results and reports
│   ├── top_area.txt          # Top-level area report
│   ├── top_qor.txt           # Top-level QoR report
│   ├── e1_timing.txt         # E1 module timing report
│   ├── e1_area.txt           # E1 module area report
│   └── e1_qor.txt            # E1 module QoR report
├── images/                    # Project images and diagrams
└── README.md                 # This file
```

## Technology
- **Process Node**: 28nm Samsung SAED32_EDK
- **Libraries**: 
  - Standard cells (RVT, LVT, HVT)
  - SRAM macros
  - DesignWare Foundation Library

## Design Components
The softmax accelerator consists of 10 submodules (e_1 through e_10) that are synthesized individually and then integrated at the top level:

### Submodules (e_1 to e_10)
- Individual softmax computation units
- Synthesized with clock gating for power optimization
- Each module generates its own reports and netlists

### Top-Level Integration
- Integrates all 10 submodules
- Final synthesis with timing closure
- Generates complete system netlist

## Synthesis Flow

### 1. Submodule Synthesis
```bash
# Run submodule synthesis
dc_shell -f scripts/28nm_submodule.tcl
```
This script:
- Synthesizes each submodule (e_1 through e_10)
- Applies clock gating optimization
- Generates individual gate-level netlists
- Creates area, timing, and QoR reports

### 2. Top-Level Synthesis
```bash
# Run top-level synthesis
dc_shell -f scripts/28nm_top.tcl
```
This script:
- Reads synthesized submodule netlists
- Synthesizes the top-level integration
- Performs final timing closure
- Generates complete system reports

## Timing Constraints
The `constraint_28nm.sdc` file defines:
- **Clock Period**: 2.5ns (400MHz target frequency)
- **Clock Name**: clk
- **I/O Delays**: 20% of clock period (0.5ns)
- **Input/Output Constraints**: Applied to all non-clock ports

## Key Features
- **Clock Gating**: Implemented for power optimization
- **Multi-Vt Libraries**: Uses RVT, LVT, and HVT cells for optimal power-performance trade-off
- **Hierarchical Synthesis**: Bottom-up approach for better QoR
- **Comprehensive Reporting**: Area, timing, and power analysis

## Results Summary

### Top-Level Results
- **Total Area**: 852.27 square units
- **Cell Count**: 304 cells (188 combinational, 64 sequential)
- **Timing**: All paths meet timing (WNS: 0.00, TNS: 0.00)
- **Clock Frequency**: 400MHz achieved

### E1 Module Results
- **Total Area**: 5074.94 square units
- **Cell Count**: 1728 cells (1602 combinational, 119 sequential)
- **Timing**: Some violations present (WNS: 0.07, TNS: 1.09)
- **Critical Path**: 2.45ns (within 2.5ns target)

## Usage Instructions

1. **Setup Environment**: Ensure Design Compiler is properly configured
2. **Run Submodule Synthesis**: Execute `28nm_submodule.tcl` first
3. **Run Top-Level Synthesis**: Execute `28nm_top.tcl` after submodules complete
4. **Review Results**: Check reports in the Results/ folder

## Dependencies
- Synopsys Design Compiler
- Samsung 28nm SAED32_EDK libraries
- TCL scripting environment

## Project Images
![Softmax Accelerator Architecture](images/softmax_architecture.png)
*High-level architecture of the softmax accelerator showing the 10 submodules and their interconnections*

![Synthesis Flow Diagram](images/synthesis_flow.png)
*Complete synthesis flow from RTL to final netlist*

![Timing Analysis](images/timing_analysis.png)
*Timing analysis showing critical paths and slack distribution*

![Area Breakdown](images/area_breakdown.png)
*Area breakdown by module showing combinational vs sequential logic*

## Contact
For questions or issues related to this synthesis project, please refer to the synthesis reports in the Results/ folder or check the TCL scripts for detailed implementation.

---
*Generated for 28nm Samsung SAED32_EDK Technology*
