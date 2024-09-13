module tb_rgb_to_yuv444;
    reg [7:0] R, G, B;
    wire [7:0] Y, U, V;

    // Instantiate the module
    rgb_to_yuv444 uut(.R(R), .G(G), .B(B), .Y(Y), .U(U), .V(V));

    initial begin
        // Apply test vectors
        R = 8'd255; G = 8'd0; B = 8'd0; #10;
        R = 8'd0; G = 8'd255; B = 8'd0; #10;
        R = 8'd0; G = 8'd0; B = 8'd255; #10;
        R = 8'd255; G = 8'd255; B = 8'd255; #10;

        // Finish simulation
        $finish;
    end
endmodule
