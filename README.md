# 🧠+ RISC-V 5-Stage CPU (RV32IM)

This project is an advanced RISC-V CPU implementation supporting the **RV32IM** instruction set (base RV32I plus the M extension for multiplication and division). It is the evolution of the previous single-cycle RV32I CPU, now redesigned into a realistic, high-performance 5-stage pipeline with full hazard handling, data forwarding, multicycle multiplication/division support, and dynamic branch prediction. 

---

## Directory Structure

```
docs/     – Diagrams, Images
rtl/      – SystemVerilog Source Code
sim/      – Testbenches
sw/       – Programs
```

---

## 📘 Overview

The original single-cycle CPU executed every instruction in a single long clock cycle. This new version uses a classic **5-stage pipeline**, improving performance, hardware utilization, and realism.

**Major improvements over the single-cycle version:**

- RV32IM ISA support
- 5-stage pipeline (IF → ID → EX → MEM → WB)
- Multicycle MUL/DIV hardware
- Full hazard detection (RAW, load-use, branch)
- Data forwarding (EX/MEM/WB paths)
- Branch prediction unit

---

## 🧩 Microarchitecture Diagram

![5-Stage Pipeline](docs/rv-five-stage.svg)

*Figure 1. RV32IM 5-Stage CPU Microarchitecture with Hazard Unit.*

---

## 🚀 New Features

### Instruction Set Support
- Full RV32I base instructions
- M-extension:
  - MUL, MULH, MULHSU, MULHU
  - DIV, DIVU, REM, REMU

### Pipeline Stages
- **IF** – Instruction fetch, PC + 4
- **ID** – Decode, register read, immediate generation, hazard detection
- **EX** – ALU operations, branch calculations, multicycle MUL/DIV
- **MEM** – Load/store operations
- **WB** – Writeback to register file

### Multicycle MUL/DIV
- Dedicated arithmetic units
- EX stage initiates operation
- Fully integrated with hazard logic

### Dynamic Branch Prediction
- GShare predictor using 2-bit pattern history table
- 1024-entry branch target buffer
- 10-bit global history register

---

## 🧠 Control Unit Interface

### Control Unit Inputs
| Signal      | Description                                   |
|-------------|-----------------------------------------------|
| `op`        | Instruction opcode field                      |
| `funct3`    | ALU operation subtype                         |
| `funct7b0`  | Used for distinguishing mul/div instructions. |
| `funct7b5`  | Used for distinguishing add/sub, shifts, etc. |

### Control Unit Outputs
| Signal         | Description                                               |
|----------------|-----------------------------------------------------------|
| `RegWrite`     | Enables register file write                               |
| `ResultSrc`    | Selects Result source (ALU, Data Memory, PC+4, PC+immExt) |
| `MemWrite`     | Enables data memory write                                 |
| `s_sel`        | Chooses type of store operations                          |
| `l_sel`        | Chooses type of load operations                           |
| `u_load`       | Toggles unsigned load operations                          |
| `Jump`         | Changes PC source to PC+immExt                            |
| `Jumpr`        | Changes PC source to ALUResult & ~1                       |
| `Branch`       | Changes PC source to PC+immExt if branch taken            |
| `ALUResultSrc` | Allows forwarding of PC+4 and PC+immExt at Memory Stage   |
| `ALUControl`   | 5-bit signal selecting ALU operation type                 |
| `ALUSrc`       | Selects ALU operand source (register or immediate)        |
| `ImmSrc`       | Selects how to encode immediate value                     |

## 🌀 Branch Prediction Unit Interface

### Branch Prediction Unit Inputs
| Signal        | Description                                                                                |
|---------------|--------------------------------------------------------------------------------------------|
| `PCF`         | PC in IF Stage                                                                             |
| `PCPlus4F`    | PC+4 in IF Stage                                                                           |
| `opF`         | jal/jalr detection in IF Stage to always predict taken                                     |
| `PCE`         | PC in EX (Used as write address for branch target buffer)                                  |
| `PCPlus4E`    | PC+4 in EX (Used on mispredicted taken branches)                                           |
| `PCSrcE`      | PC Source selection in EX Stage (Used during mispredicted branches)                        |
| `JumpE`       | jal detection in EX Stage (Used as write enable for branch target buffer)                  |
| `JumprE`      | jalr detection in EX Stage (Used as write enable for branch target buffer)                 |
| `BranchE`     | Branch detection in EX Stage (Used as write enable for GHR, BTB, and PHT)                  |
| `br_actualE`  | Actual branch outcome in EX Stage (Outcome stored in GHR/PHT; Used in BTB as write enable) |
| `PCTargetE`   | PC+immExt in EX (Used on mispredicted not taken branches or stored in BTB)                 |
| `ALUResultE`  | ALUResult & ~1 in EX (Used on mispredicted not taken branches or stored in BTB)            |
| `mispredictE` | Branch misprediction signal (Flushes pipeline and chooses PCSrcE for the actual PC)        |
| `StallD`      | Stall ID Stage                                                                             |
| `FlushD`      | Flush ID Stage                                                                             |
| `StallE`      | Stall EX Stage                                                                             |
| `FlushE`      | Flush EX Stage                                                                             |

### Branch Prediction Unit Outputs
| Signal        | Description                |
|---------------|----------------------------|
| `br_predictE` | Predicted branch outcome   |
| `PCNextF`     | Typical PC or Predicted PC |

---

## ⚙️ Hazards & Forwarding

### Data Hazards
A hazard detection unit checks dependencies between instructions in ID, EX, MEM, and WB stages.

### Forwarding Paths
- MEM → EX
- WB → EX

These bypass paths resolve most RAW hazards.

### Load-Use Hazard
If an instruction uses a value immediately after a load:
- Forwarding cannot fix it
- A **1-cycle stall** (bubble) is inserted

### Control Hazards
- Correctly predicted branches flow normally through pipeline
- Mispredictions flush instructions in ID and EX stages

### Structural Hazards
- Multicycle MUL/DIV operations occupy the EX stage for several cycles, causing the pipeline to stall until the operation completes.

---

## 🧪 Simulation & Testing

- ✔️ **Tower of Hanoi** — passed
- ✔️ **Basic RV32IM Compliance Test** — passed
- 🚧 **M-extension (MUL/DIV) stress tests** — in progress
- 🚧 **Branch/Jump stress tests** — in progress

---

## 📄 License
This project is open for educational and non-commercial use.  
Feel free to fork, explore, and extend.

---

*Author: jeffreyc-dev*  
*Senior ASIC Design Engineer*