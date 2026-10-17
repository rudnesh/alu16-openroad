`timescale 1ns/1ps

module alu16 (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire [3:0]  opcode,
    output reg  [15:0] result,
    output reg         zero,
    output reg         carry,
    output reg         overflow
);

    reg [16:0] temp;

    always @(*) begin
        result   = 16'b0;
        carry    = 1'b0;
        overflow = 1'b0;
        temp     = 17'b0;

        case (opcode)
            4'h0: begin // ADD
                temp = {1'b0, a} + {1'b0, b};
                result = temp[15:0];
                carry = temp[16];
                overflow = (~(a[15] ^ b[15])) &
                            (result[15] ^ a[15]);
            end

            4'h1: begin // SUB
                result = a - b;
                carry = (a >= b); // 1 means no borrow
                overflow = (a[15] ^ b[15]) &
                           (result[15] ^ a[15]);
            end

            4'h2: result = a & b;
            4'h3: result = a | b;
            4'h4: result = a ^ b;
            4'h5: result = ~(a | b);
            4'h6: result = a << b[3:0];
            4'h7: result = a >> b[3:0];
            4'h8: result = $signed(a) >>> b[3:0];
            4'h9: result = (a < b) ? 16'd1 : 16'd0;
            4'hA: result = (a == b) ? 16'd1 : 16'd0;
            4'hB: result = ~(a & b);
            4'hC: result = ~(a ^ b);
            4'hD: result = a;
            4'hE: result = b;
            4'hF: result = 16'b0;
        endcase

        zero = (result == 16'b0);
    end

endmodule
