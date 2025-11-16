//
//  Authors: Jeffrey Claudio / ChatGPT
//  Latest Revision: 11-14-2025
//
//  Project: divider_32c.sv
//  Description: A 32-Cycle, Sequential, Non-Restoring Divider
//  License: MIT License (see LICENSE file in the project root)
//

module divider_32c (
    input  logic         clk,
    input  logic         reset,    // active-high synchronous reset behavior in this module
    input  logic         enable,   // level-enable (toggle) — must be held high for duration
    input  logic         sign_sel, // Sign Selection
    input  logic [31:0]  numA,     // dividend
    input  logic [31:0]  denB,     // divisor
    output logic         done,     // one-cycle pulse when quotient/remainder valid
    output logic [31:0]  quotient,
    output logic [31:0]  remainder
);

    // Internal state:
    // rem_reg is 33 bits to hold the running remainder during shift-subtract algorithm.
    // q_reg holds the running quotient bits (shift-left each iteration).
    logic [32:0] rem_reg;   // 33-bit remainder
    logic [31:0] q_reg;     // quotient under construction
    logic [31:0] d_reg;     // divisor latched
    logic  [5:0] count;     // needs to hold values up to 32
    logic        running;   // internal busy flag

    // Temporaries used inside clocked block (declared module-scope)
    logic [32:0] rem_next;
    logic [31:0] q_next;
    logic [32:0] sub;       // for comparison/subtraction (33-bit)

    logic [31:0] newA, newB;
    logic        sign;
    logic [31:0] u_quotient, u_remainder;

  always_comb begin

    case(sign_sel)
      // div,rem
      1'b0 : begin
               newA = numA[31] ? ~numA + 1'b1 : numA;
               newB = denB[31] ? ~denB + 1'b1 : denB;
               sign = numA[31] ^ denB[31];
             end
      // divu,remu
      1'b1 : begin
               newA = numA;
               newB = denB;
               sign = 1'b0;
             end
      // signed/signed by default
   default : begin
               newA = numA[31] ? ~numA + 1'b1 : numA;
               newB = denB[31] ? ~denB + 1'b1 : denB;
               sign = numA[31] ^ denB[31];
             end
    endcase

    quotient  = sign ? ~u_quotient  + 1'b1 : u_quotient;
    remainder = sign ? ~u_remainder + 1'b1 : u_remainder;

  end

    always @(posedge clk) begin
        if (reset | !enable) begin
            // synchronous clear of state (also used on enable deassert)
            rem_reg     <= 33'b0;
            q_reg       <= 32'b0;
            d_reg       <= 32'b0;
            count       <=  6'd0;
            running     <=  1'b0;
            done        <=  1'b0;
            u_quotient  <= 32'b0;
            u_remainder <= 32'b0;
        end else begin
            // default
            done <= 1'b0;

            // enable == 1 path: either start a new division or perform an iteration
            if (!running) begin
                // Start condition: latch operands and begin 32-cycle algorithm
                // Handle divisor==0 as special case per unsigned RISC-V semantics
                if (newB == 32'b0) begin
                    // Division by zero: quotient = all 1s, remainder = dividend
                    u_quotient  <= 32'hFFFF_FFFF;
                    u_remainder <= newA;
                    // produce a done pulse immediately (this counts as finishing)
                    done <= 1'b1;
                    running <= 1'b0;
                    // Keep internal state cleared; wait for enable deassert to reset externally
                    rem_reg <= 33'b0;
                    q_reg   <= 32'b0;
                    d_reg   <= 32'b0;
                    count   <= 6'd0;
                end else begin
                    // Normal start: initialize registers
                    running <= 1'b1;
                    done    <= 1'b0;

                    d_reg  <= newB;
                    // initial remainder = 0, quotient = dividend (we will shift MSB out)
                    rem_reg <= 33'b0;
                    q_reg   <= newA;
                    count   <= 6'd32;
                end
            end else begin
                // Running: perform one division iteration per cycle
                // Algorithm (non-restoring style with left-shift of remainder and MSB of quotient):
                //
                // rem = (rem << 1) | q_reg[31];
                // q_reg = q_reg << 1;
                // if (rem >= d_reg) begin
                //     rem = rem - d_reg;
                //     q_reg[0] = 1;
                // end else begin
                //     q_reg[0] = 0;
                // end
                //
                // We use 33-bit rem to hold the top bit.

                // form next remainder by shifting left and bringing in MSB of q_reg
                rem_next <= { rem_reg[31:0], q_reg[31] }; // rem_reg[31:0] << 1 with q_reg[31] inserted
                // shift quotient left
                q_next   <= (q_reg << 1);

                // compare rem_next and divisor (extend divisor to 33 bits)
                sub <= rem_next - {1'b0, d_reg}; // 33-bit subtraction

                if (!sub[32]) begin
                    // rem_next >= d_reg  (sub MSB 0 indicates non-negative)
                    rem_next <= sub;       // take remainder = rem_next - d
                    q_next[0] <= 1'b1;    // set new LSB of quotient
                end else begin
                    // rem_next < d_reg; keep rem_next, q_next[0] already 0
                    q_next[0] <= 1'b0;
                end

                // commit
                rem_reg <= rem_next;
                q_reg   <= q_next;
                count   <= count - 1;

                // finish when count == 1 (this iteration produced the LSB)
                if (count == 1) begin
                    running     <= 1'b0;
                    done        <= 1'b1;
                    u_quotient  <= q_next;
                    u_remainder <= rem_next[31:0];
                    // Note: keep rem_reg/q_reg updated for this cycle; will be cleared when enable goes low
                end
            end
        end
    end

endmodule
