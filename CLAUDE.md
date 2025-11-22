# CLAUDE.md - AI Assistant Guide for lab2 Repository

## Project Overview

**Project Type:** Hardware Design - SystemVerilog
**Purpose:** Implementation of Collatz Conjecture Sequence Generator
**Context:** Academic lab assignment (likely from Columbia University course)
**Language:** SystemVerilog (IEEE 1800-2017)
**Complexity:** Low - Single module implementation

### What is the Collatz Conjecture?

The Collatz conjecture (also known as the 3n+1 problem) states that for any positive integer n:
- If n is even: divide by 2
- If n is odd: multiply by 3 and add 1
- Repeat until reaching 1

This module implements this sequence in hardware.

---

## Repository Structure

```
/home/user/lab2/
├── .git/                    # Git repository metadata
├── collatz(1).sv           # Main SystemVerilog module
└── CLAUDE.md               # This file
```

**Key Files:**
- `collatz(1).sv` (827 bytes, 28 lines) - Single hardware module implementing Collatz sequence

**Missing Infrastructure (by design):**
- No build configuration (Makefile, scripts)
- No test files or testbenches
- No README or documentation
- No CI/CD pipeline
- No package manager or dependencies

This is intentional for a minimal academic submission.

---

## Module Architecture

### Module: `collatz`

**Location:** `collatz(1).sv:1`

**Interface:**
```systemverilog
module collatz(
    input  logic         clk,   // Clock signal
    input  logic         go,    // Load value from n; start iterating
    input  logic [31:0]  n,     // Start value; only read when go = 1
    output logic [31:0]  dout,  // Iteration value: true after go = 1
    output logic         done   // True when dout reaches 1
);
```

**Port Descriptions:**

| Port | Direction | Width | Purpose |
|------|-----------|-------|---------|
| `clk` | Input | 1-bit | System clock for synchronous operation |
| `go` | Input | 1-bit | Control signal: load initial value and start |
| `n` | Input | 32-bit | Initial value for Collatz sequence |
| `dout` | Output | 32-bit | Current iteration value in sequence |
| `done` | Output | 1-bit | High when sequence reaches 1 |

**Design Pattern:**
- **Type:** Synchronous Sequential Logic
- **Trigger:** Positive edge of clock (`posedge clk`)
- **State Machine:** Two-state behavior:
  1. **Load State** (`go=1`): Load initial value from `n` into `dout`
  2. **Iterate State** (`done=0`): Compute next Collatz value

**Implementation Details:**

```systemverilog
always_ff @(posedge clk) begin
    if (go) begin
        dout <= n;              // Load initial value
    end else if (!done) begin
        logic [31:0] temp;
        if (dout[0] == 0) begin // Even case
            temp = dout >> 1;    // Divide by 2
        end else begin
            temp = 3 * dout + 1; // Odd case: 3n+1
        end
        dout <= temp;
    end
end

assign done = (dout == 1);      // Done when value reaches 1
```

**Key Design Choices:**
- Uses modern SystemVerilog `logic` type instead of `wire`/`reg`
- Non-blocking assignments (`<=`) for sequential logic
- Local variable `temp` declared within `always_ff` block
- Bit-shift right (`>> 1`) for efficient division by 2
- LSB check (`dout[0]`) to determine even/odd

---

## Development Workflows

### Simulation Workflow

Since no testbench is included, AI assistants should:

1. **Create Testbench** (if needed for testing):
   ```systemverilog
   module collatz_tb;
       logic clk, go, done;
       logic [31:0] n, dout;

       collatz dut(.*);

       initial begin
           clk = 0;
           forever #5 clk = ~clk;
       end

       initial begin
           // Test case: n=6 → 6,3,10,5,16,8,4,2,1
           go = 1; n = 6; #10;
           go = 0;
           wait(done);
           $finish;
       end
   endmodule
   ```

2. **Compile with iverilog** (open-source):
   ```bash
   iverilog -g2012 -o collatz.vvp collatz\(1\).sv testbench.sv
   vvp collatz.vvp
   ```

3. **Or use ModelSim/QuestaSim**:
   ```bash
   vlog -sv collatz\(1\).sv
   vsim -c collatz -do "run -all; quit"
   ```

4. **Or use Vivado**:
   ```tcl
   read_verilog -sv collatz(1).sv
   synth_design -top collatz
   ```

### Git Workflow

**Current Branch:** `claude/claude-md-mi9m8gg9flfyqjcs-019uFfHPfKAD7jCr8V9uZKLF`

**Standard Operations:**
```bash
# Make changes to code
git add collatz\(1\).sv

# Commit with descriptive message
git commit -m "Fix Collatz module: add reset signal"

# Push to remote (with retry on network failure)
git push -u origin claude/claude-md-mi9m8gg9flfyqjcs-019uFfHPfKAD7jCr8V9uZKLF
```

**Important Git Notes:**
- Always push to branches starting with `claude/` and ending with session ID
- Use exponential backoff retry (2s, 4s, 8s, 16s) for network failures
- Current git user: MINGZZZ918 (ml5160@Columbia.edu)

---

## Code Conventions & Style Guide

### SystemVerilog Coding Standards

**1. Type Declarations:**
- ✅ Use `logic` type (modern SystemVerilog)
- ❌ Avoid `wire`/`reg` unless specifically needed

**2. Port Declarations:**
- Use explicit direction and type for every port
- Include inline comments describing each port
- Example:
  ```systemverilog
  input  logic [31:0]  data,  // 32-bit input data
  output logic         valid  // High when data is valid
  ```

**3. Sequential Logic:**
- Use `always_ff` for flip-flops/registers
- Use non-blocking assignments (`<=`)
- Trigger on `posedge clk` or `negedge clk`

**4. Combinational Logic:**
- Use `always_comb` or `assign` statements
- Use blocking assignments (`=`) in always blocks

**5. Naming Conventions:**
- Modules: lowercase with underscores (`collatz`, `my_module`)
- Signals: lowercase with underscores (`dout`, `temp_value`)
- Parameters: UPPERCASE (`WIDTH`, `DEPTH`)
- Active-low signals: suffix with `_n` (`reset_n`)

**6. Indentation:**
- Use 4 spaces (not tabs)
- Align port declarations
- Indent block contents consistently

**7. Comments:**
- Use `//` for single-line comments
- Place inline comments after significant operations
- Document non-obvious logic choices
- Example:
  ```systemverilog
  if (dout[0] == 0) begin    // Even case
      temp = dout >> 1;       // temp = dout/2
  end
  ```

**8. File Formatting:**
- Use LF line endings (Unix-style), not CRLF
- One module per file
- File name should match module name: `collatz.sv`

---

## AI Assistant Guidelines

### When Modifying Code

1. **Always Read First:**
   - Use `Read` tool before making any changes
   - Understand existing implementation fully
   - Identify dependencies and side effects

2. **Preserve Existing Style:**
   - Match indentation (4 spaces)
   - Follow naming conventions
   - Maintain comment style

3. **Common Enhancement Requests:**

   **Adding Reset Signal:**
   ```systemverilog
   module collatz(
       input  logic         clk,
       input  logic         rst,   // Active-high synchronous reset
       input  logic         go,
       // ... rest of ports

   always_ff @(posedge clk) begin
       if (rst) begin
           dout <= 32'b0;
       end else if (go) begin
           dout <= n;
       end
       // ... rest of logic
   ```

   **Adding Parameter for Bit Width:**
   ```systemverilog
   module collatz #(
       parameter WIDTH = 32
   )(
       input  logic             clk,
       input  logic             go,
       input  logic [WIDTH-1:0] n,
       output logic [WIDTH-1:0] dout,
       output logic             done
   );
   ```

   **Adding Iteration Counter:**
   ```systemverilog
   output logic [7:0] iterations  // Count of steps taken

   logic [7:0] counter;
   always_ff @(posedge clk) begin
       if (go) begin
           counter <= 0;
       end else if (!done) begin
           counter <= counter + 1;
       end
   end
   assign iterations = counter;
   ```

4. **Avoid Over-Engineering:**
   - Don't add features unless requested
   - Don't refactor unrelated code
   - Don't add unnecessary abstractions
   - Keep solutions minimal and focused

5. **Security/Safety Considerations:**
   - Check for potential overflow in `3 * dout + 1` computation
   - Consider adding input validation (n > 0)
   - Document any assumptions about input ranges

### When Creating Testbenches

If asked to create tests:

1. **File Naming:** `collatz_tb.sv` or `tb_collatz.sv`

2. **Test Coverage:**
   - Test known sequences: 6 → 3 → 10 → 5 → 16 → 8 → 4 → 2 → 1
   - Test edge cases: n=1 (immediate done), n=2^31-1 (large value)
   - Test control signals: go assertion, done monitoring

3. **Standard Testbench Structure:**
   ```systemverilog
   module collatz_tb;
       // Declare signals
       logic clk, go, done;
       logic [31:0] n, dout;

       // Instantiate DUT
       collatz dut(.*);

       // Clock generation
       initial begin
           clk = 0;
           forever #5 clk = ~clk;
       end

       // Test stimulus
       initial begin
           // Test case 1
           go = 1; n = 6; @(posedge clk);
           go = 0;
           wait(done);
           assert(dout == 1) else $error("Failed");

           // More tests...
           $finish;
       end
   endmodule
   ```

4. **Simulation Commands:**
   - Document how to run with different tools
   - Include waveform dumping if needed:
     ```systemverilog
     initial begin
         $dumpfile("collatz.vcd");
         $dumpvars(0, collatz_tb);
     end
     ```

### When Answering Questions

1. **About Implementation:**
   - Reference specific line numbers: `collatz(1).sv:15`
   - Quote relevant code sections
   - Explain hardware behavior (clock cycles, timing)

2. **About Verification:**
   - Explain simulation vs synthesis differences
   - Discuss timing considerations
   - Mention tool-specific quirks

3. **About Optimization:**
   - Discuss area vs speed tradeoffs
   - Explain synthesis implications
   - Consider FPGA vs ASIC targets

### Tools & Environment

**Available Tools:**
- Git (for version control)
- Standard Linux utilities
- Text editor/file manipulation

**NOT Available:**
- HDL simulators (iverilog, ModelSim, etc.)
- Synthesis tools (Vivado, Quartus, etc.)
- Waveform viewers (GTKWave, ModelSim GUI)

**Recommendations:**
- Suggest open-source tools when users need to simulate
- Provide commands for multiple tool ecosystems
- Include links to tool documentation

---

## Common Tasks & Examples

### Task 1: Fix Potential Overflow

**Problem:** `3 * dout + 1` can overflow for large values

**Solution:**
```systemverilog
logic [32:0] temp;  // Use 33 bits to prevent overflow
if (dout[0] == 0) begin
    temp = {1'b0, dout >> 1};
end else begin
    temp = {1'b0, dout} * 3 + 1;  // Explicit widening
end
// Check for overflow and handle appropriately
```

### Task 2: Add Configurable Width

**Request:** "Make the module support different bit widths"

**Implementation:**
```systemverilog
module collatz #(
    parameter int WIDTH = 32
)(
    input  logic             clk,
    input  logic             go,
    input  logic [WIDTH-1:0] n,
    output logic [WIDTH-1:0] dout,
    output logic             done
);
    always_ff @(posedge clk) begin
        if (go) begin
            dout <= n;
        end else if (!done) begin
            logic [WIDTH-1:0] temp;
            if (dout[0] == 0) begin
                temp = dout >> 1;
            end else begin
                temp = 3 * dout + 1;
            end
            dout <= temp;
        end
    end

    assign done = (dout == 1);
endmodule
```

### Task 3: Add Reset Signal

**Request:** "Add synchronous reset"

**Implementation:**
```systemverilog
module collatz(
    input  logic         clk,
    input  logic         rst,     // Active-high synchronous reset
    input  logic         go,
    input  logic [31:0]  n,
    output logic [31:0]  dout,
    output logic         done
);
    always_ff @(posedge clk) begin
        if (rst) begin
            dout <= 32'b0;
        end else if (go) begin
            dout <= n;
        end else if (!done) begin
            logic [31:0] temp;
            if (dout[0] == 0) begin
                temp = dout >> 1;
            end else begin
                temp = 3 * dout + 1;
            end
            dout <= temp;
        end
    end

    assign done = (dout == 1);
endmodule
```

### Task 4: Explain Timing Behavior

**Question:** "How many clock cycles does it take?"

**Answer:**
The number of clock cycles depends on the input value and is variable:
- 1 cycle if `n=1` (immediate done)
- 2 cycles if `n=2` (2→1)
- 8 cycles if `n=6` (6→3→10→5→16→8→4→2→1)

The Collatz sequence length is unpredictable - this is the conjecture itself! Some numbers take hundreds of iterations.

---

## Known Issues & Limitations

### Current Implementation

1. **No Reset Signal:**
   - Module lacks reset capability
   - Initial state undefined after power-on
   - **Impact:** Simulation may start with 'x' values

2. **Overflow Potential:**
   - Expression `3 * dout + 1` can overflow for values > 2^30
   - **Impact:** Incorrect results for large inputs
   - **Mitigation:** Add overflow detection or use wider temporary

3. **No Input Validation:**
   - Doesn't check for n=0 (undefined behavior)
   - **Impact:** Module may hang if n=0 loaded
   - **Mitigation:** Add assertion or handle as special case

4. **Single Iteration Per Clock:**
   - Takes 1 clock cycle per Collatz step
   - **Impact:** Long sequences require many cycles
   - **Note:** This is acceptable for most applications

5. **Line Endings:**
   - File uses CRLF (Windows) instead of LF (Unix)
   - **Impact:** Minor - may show `^M` in some editors
   - **Fix:** Run `dos2unix collatz\(1\).sv`

### Design Constraints

- **Bit Width:** Fixed 32-bit width
- **Throughput:** One iteration per clock cycle
- **Latency:** Variable, depends on input value
- **Area:** Minimal - single 32-bit register + combinational logic

---

## Testing Strategy

### Manual Test Cases

When creating tests, include these scenarios:

| Test Case | Input n | Expected Sequence | Cycles | Purpose |
|-----------|---------|-------------------|--------|---------|
| TC1 | 1 | 1 | 0 | Edge case: immediate done |
| TC2 | 2 | 2→1 | 1 | Simple even number |
| TC3 | 3 | 3→10→5→16→8→4→2→1 | 7 | Simple odd number |
| TC4 | 6 | 6→3→10→5→16→8→4→2→1 | 8 | Mixed even/odd |
| TC5 | 27 | 27→...→1 | 111 | Known long sequence |
| TC6 | 0 | undefined | N/A | Invalid input |
| TC7 | 2^31-1 | varies | N/A | Large value test |

### Verification Checklist

- [ ] Verify `done` signal asserts when `dout=1`
- [ ] Verify `go` signal loads new value correctly
- [ ] Verify even numbers divide by 2
- [ ] Verify odd numbers compute 3n+1
- [ ] Test back-to-back sequences (re-assert `go`)
- [ ] Check for timing violations in synthesis
- [ ] Verify behavior across process/voltage/temp corners

---

## Resources & References

### SystemVerilog Resources

- **IEEE 1800-2017 Standard:** Official SystemVerilog LRM
- **Sutherland HDL:** [SystemVerilog tutorials](http://www.sutherland-hdl.com/)
- **ASIC World:** [SystemVerilog tutorial](http://www.asic-world.com/systemverilog/)
- **ChipVerify:** [SystemVerilog examples](https://www.chipverify.com/systemverilog/)

### Collatz Conjecture

- **Wikipedia:** [Collatz conjecture](https://en.wikipedia.org/wiki/Collatz_conjecture)
- **OEIS:** Sequence A006577 (stopping times)
- **Wolfram MathWorld:** Detailed mathematical analysis

### Simulation Tools

- **Icarus Verilog (iverilog):** Open-source simulator
  ```bash
  sudo apt-get install iverilog
  ```
- **Verilator:** Fast open-source simulator/compiler
- **GTKWave:** Waveform viewer (pairs with iverilog)
  ```bash
  sudo apt-get install gtkwave
  ```

### Synthesis Tools (Free Options)

- **Yosys:** Open synthesis suite
- **Vivado WebPACK:** Free Xilinx FPGA tools
- **Quartus Lite:** Free Intel/Altera FPGA tools

---

## Contact & Course Information

**Student:** MINGZZZ918 (ml5160@Columbia.edu)
**Institution:** Columbia University
**Assignment:** Lab 2

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2025-11-22 | Initial CLAUDE.md creation | AI Assistant |
| 0.1 | 2025-03-07 | Initial module implementation | ml5160 |

---

## AI Assistant Checklist

Before completing any task, verify:

- [ ] I have read the relevant source file(s) using the Read tool
- [ ] I understand the existing implementation
- [ ] My changes preserve the existing code style
- [ ] I have tested my understanding (mentally simulate the hardware)
- [ ] I am not over-engineering or adding unnecessary features
- [ ] My commit message is clear and descriptive
- [ ] I am pushing to the correct branch (starts with `claude/`)
- [ ] I have updated CLAUDE.md if I changed conventions or structure

---

**Last Updated:** 2025-11-22
**Document Version:** 1.0
**Maintained By:** AI Assistants working on this repository
