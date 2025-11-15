//
//  Authors: Jeffrey Claudio / ChatGPT
//  Latest Revision: 11-13-2025
//
//  Project: multiplier_16c.sv
//  Description: A 16-Cycle, Sequential, Radix-4 Multiplier
//  License: MIT License (see LICENSE file in the project root)
//

module multiplier_16c (
    input  logic        clk,
    input  logic        reset,    // synchronous reset
    input  logic        enable,   // start when high and unit idle (pulse is fine)
    input  logic  [1:0] sign_sel, // Sign Selection
    input  logic [31:0] opA,      // multiplicand
    input  logic [31:0] opB,      // multiplier
    output logic        done,     // one-cycle pulse when result valid
    output logic [63:0] product
);

    // P layout (66 bits): {carry1, carry0, ACC[31:0], Q[31:0]}
    logic [65:0] P;

    // temporaries & inputs held
    logic [31:0] M;
    logic  [4:0] count; // counts 16 -> needs 5 bits
    logic        busy;

    // temporaries (module-scope logics used inside always)
    logic [65:0] nextP_temp;
    logic [65:0] nextP_shift;
    logic [33:0] m_ext;     // M extended to 34 bits (2 top zeros)
    logic [33:0] addend;    // 34-bit addend (0, M, 2M, 3M)
    logic [33:0] acc_ext;   // ACC extended to 34 bits
    logic [33:0] sum34;     // result of acc_ext + addend (fits 34 bits)
    logic  [1:0] q_low;

    logic [31:0] newA, newB;
    logic        sign;
    logic [63:0] result;

  always_comb begin

    case(sign_sel)
      // mul,mulh
      2'b00 : begin
                newA = opA[31] ? ~opA + 1'b1 : opA;
                newB = opB[31] ? ~opB + 1'b1 : opB;
                sign = opA[31] ^ opB[31];
              end
      // mulhsu
      2'b01 : begin
                newA = opA[31] ? ~opA + 1'b1 : opA;
                newB = opB;
                sign = opA[31];
              end
      // mulhu
      2'b10 : begin
                newA = opA;
                newB = opB;
                sign = 1'b0;
              end
      // signed/signed by default
    default : begin
                newA = opA[31] ? ~opA + 1'b1 : opA;
                newB = opB[31] ? ~opB + 1'b1 : opB;
                sign = opA[31] ^ opB[31];
              end
    endcase

      product = sign ? ~result + 1'b1 : result;

  end

    // Sequential logic
    always @(posedge clk) begin
        if (reset | !enable) begin
            P      <= 66'b0;
            M      <= 32'b0;
            count  <= 5'd0;
            busy   <= 1'b0;
            done   <= 1'b0;
            result <= 64'b0;

            // clear temporaries (not strictly necessary)
            nextP_temp <= 66'b0;
            nextP_shift <= 66'b0;
            m_ext <= 34'b0;
            addend <= 34'b0;
            acc_ext <= 34'b0;
            sum34 <= 34'b0;
            q_low <= 2'b0;
        end else begin
            // default
            done <= 1'b0;

            if (!busy) begin
                // start on an enable while idle
                if (enable) begin
                    M     <= newA;
                    // init P: carry1/carry0 = 0, ACC = 0, Q = opB
                    P     <= {2'b00, 32'b0, newB};
                    count <= 5'd16;
                    busy  <= 1'b1;
                    // done/result will be produced later
                end
            end else begin
                // Compute nextP in temporaries (blocking ops)
                // Extend M to 34 bits
                m_ext = {2'b00, M};

                // extract low two bits of Q
                q_low = P[1:0];

                // choose addend = 0, M, 2*M, or 3*M (34-bit width)
                case (q_low)
                    2'b00: addend = 34'b0;
                    2'b01: addend = m_ext;
                    2'b10: addend = (m_ext << 1);            // 2*M
                    2'b11: addend = m_ext + (m_ext << 1);    // 3*M
                    default: addend = 34'b0;
                endcase

                // ACC extended to 34 bits (top two bits zero + ACC[31:0])
                acc_ext = {2'b00, P[63:32]};

                // sum fits into 34 bits (proof in notes)
                sum34 = acc_ext + addend;

                // write the upper 34 bits of nextP_temp
                // nextP_temp[65:32] <= sum34
                nextP_temp = P;
                nextP_temp[65:32] = sum34;

                // Keep lower 32 bits (Q) as-is for now (nextP_temp[31:0] same as P[31:0])

                // SHIFT RIGHT by 2: newP = {2'b00, nextP_temp[65:2]}
                nextP_shift = {2'b00, nextP_temp[65:2]};

                // Commit state with nonblocking assignments
                P     <= nextP_shift;
                count <= count - 1;

                if (count == 1) begin
                    busy   <= 1'b0;
                    done   <= 1'b1;
                    result <= nextP_shift[63:0]; // drop top two carry bits
                end
            end
        end
    end

endmodule
