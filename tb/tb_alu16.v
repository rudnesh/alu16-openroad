`timescale 1ns/1ps

module tb_alu16;
    reg [15:0] a, b;
    reg [3:0] opcode;
    wire [15:0] result;
    wire zero, carry, overflow;

    alu16 dut (
        .a(a), .b(b), .opcode(opcode),
        .result(result), .zero(zero),
        .carry(carry), .overflow(overflow)
    );

    task check;
        input [3:0] op;
        input [15:0] x, y, expected;
        begin
            opcode = op;
            a = x;
            b = y;
            #10;
            if (result !== expected)
                $display("FAIL op=%h got=%h expected=%h", op, result, expected);
            else
                $display("PASS op=%h result=%h", op, result);
        end
    endtask

    initial begin
        check(4'h0, 16'd10, 16'd20, 16'd30);
        check(4'h0, 16'hFFFF, 16'd1, 16'd0);
        check(4'h1, 16'd20, 16'd5, 16'd15);
        check(4'h2, 16'hFF00, 16'h0F0F, 16'h0F00);
        check(4'h3, 16'hF000, 16'h000F, 16'hF00F);
        check(4'h4, 16'hAAAA, 16'hFFFF, 16'h5555);
        check(4'h5, 16'h0000, 16'hFFFF, 16'h0000);
        check(4'h6, 16'd3, 16'd2, 16'd12);
        check(4'h7, 16'd12, 16'd2, 16'd3);
        check(4'h8, 16'hFFF8, 16'd1, 16'hFFFC);
        check(4'h9, 16'd3, 16'd5, 16'd1);
        check(4'hA, 16'd7, 16'd7, 16'd1);
        check(4'hB, 16'hFF00, 16'h0F0F, 16'hF0FF);
        check(4'hC, 16'hAAAA, 16'hFFFF, 16'hAAAA);
        check(4'hD, 16'h1234, 16'h5678, 16'h1234);
        check(4'hE, 16'h1234, 16'h5678, 16'h5678);
        check(4'hF, 16'h1234, 16'h5678, 16'h0000);

        $display("Simulation complete.");
        $finish;
    end
endmodule
