# APB Slave Peripheral – SystemVerilog RTL

## 📌 Project Overview

This project implements a **simple APB (Advanced Peripheral Bus) Slave** using **SystemVerilog RTL**.
The design follows the **AMBA APB protocol** and models a **memory-mapped peripheral register**, typically used in **SoC peripheral subsystems**.

The APB slave supports **read and write transactions**, controlled through a **finite state machine (FSM)** that adheres to the APB **SETUP → ACCESS** transfer sequence.

This is a **non-dummy, protocol-focused RTL project**, suitable for **RTL / SoC / VLSI internships**.

---

## 🧠 Key Features

* Fully synthesizable **SystemVerilog RTL**
* AMBA **APB protocol–compliant slave**
* Supports APB read and write transfers
* FSM-based control logic
* Memory-mapped register implementation
* Simple and clean peripheral design
* Industry-style RTL organization

---

## 🏗️ APB Slave Architecture (High-Level)

### Block Overview

```text
        APB Master
             │
             ▼
        APB Slave FSM
             │
         Internal Register
```

---

## 🔌 APB Interface Signals

### APB Inputs

| Signal    | Description       |
| --------- | ----------------- |
| `PCLK`    | APB clock         |
| `PRESETn` | Active-low reset  |
| `PSEL`    | Peripheral select |
| `PENABLE` | Transfer enable   |
| `PWRITE`  | Write enable      |
| `PADDR`   | Address bus       |
| `PWDATA`  | Write data        |

### APB Outputs

| Signal    | Description    |
| --------- | -------------- |
| `PRDATA`  | Read data      |
| `PREADY`  | Transfer ready |
| `PSLVERR` | Error response |

---

## 🔁 Finite State Machine (FSM)

### FSM States

```text
IDLE → SETUP → ACCESS → IDLE
```

### State Description

| State  | Function                                 |
| ------ | ---------------------------------------- |
| IDLE   | Waits for `PSEL` assertion               |
| SETUP  | Setup phase (PSEL asserted, PENABLE low) |
| ACCESS | Transfer phase (PSEL & PENABLE high)     |

---

## 🔄 APB Transaction Flow

### Write Transfer

1. Master asserts `PSEL` with address and write data
2. FSM moves to SETUP state
3. Master asserts `PENABLE`
4. Slave writes `PWDATA` into internal register
5. `PREADY` indicates transfer completion

### Read Transfer

1. Master asserts `PSEL` with address
2. FSM moves to SETUP state
3. Master asserts `PENABLE`
4. Slave drives `PRDATA` from internal register
5. `PREADY` indicates transfer completion

---

## ⚙️ Design Highlights

* Protocol-accurate APB timing
* Clean SETUP → ACCESS sequencing
* Internal register storage (`reg0`)
* Always-ready slave (`PREADY = 1`)
* No latch inference
* No combinational loops
* Fully synthesizable RTL

---

## ⚠️ Design Assumptions (Intentional)

* Single register peripheral
* No address decoding (single address space)
* Always-ready slave
* Error signaling disabled (`PSLVERR = 0`)

> These simplifications make the design **easy to understand and extend**.

---

## 📂 Repository Structure

```text
src/
└── apb_slave.sv

testbench/
└── apb_slave_tb.sv   (if present)
```

---

## 🚀 Deployment & Simulation Guide

### 🧰 Prerequisites

**Simulator**

* Xilinx Vivado (recommended)
* Questa / ModelSim
* Synopsys VCS

**OS**

* Linux or Windows

**Knowledge**

* SystemVerilog
* AMBA APB protocol basics

---

### 📥 Step 1: Clone the Repository

```bash
git clone https://github.com/Srinu-bhimavarapu/APB.git
cd APB
```

---

### ▶️ Step 2: Run Simulation (Vivado)

#### GUI Method

1. Open **Vivado**
2. Create a new **RTL Project**
3. Add RTL files from `src/`
4. Add testbench files from `testbench/`
5. Set testbench as simulation top
6. Run **Behavioral Simulation**

#### Tcl Flow

```tcl
read_verilog src/apb_slave.sv
read_verilog testbench/*.sv
launch_simulation
```

---

## 🔍 Waveform Verification Checklist

Verify:

* `PSEL` asserted in SETUP and ACCESS
* `PENABLE` asserted only in ACCESS
* `PREADY` asserted during ACCESS
* Correct `PRDATA` on read
* Correct `reg0` update on write
* FSM transitions: IDLE → SETUP → ACCESS → IDLE

---

## 🧪 Verification Status

* Directed SystemVerilog testbench
* Functional APB protocol validation
* Waveform-based checking

---

## 🎯 Learning Outcomes

* APB protocol fundamentals
* FSM-based peripheral design
* Memory-mapped register implementation
* Control-path RTL design
* SoC peripheral integration concepts

---

## 📌 Future Enhancements

* Address decoding for multiple registers
* Wait-state insertion (`PREADY` control)
* Error signaling (`PSLVERR`)
* APB-to-AXI integration
* UVM-based verification

---

## 👤 Author

**Srinu Bhimavarapu**
Electronics & Communication Engineering
Focus Areas: RTL Design, Peripheral IPs, SoC Architecture

---

## ⭐ Recruiter Note

✔ Hand-written RTL
✔ Protocol-correct APB design
✔ FSM-based control
✔ Simulation-validated peripheral

This project demonstrates **strong peripheral and control-bus design fundamentals**, which are essential for **SoC and RTL design roles**.
