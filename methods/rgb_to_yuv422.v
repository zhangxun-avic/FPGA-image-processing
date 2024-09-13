module rgb_to_yuv422(
    input [7:0] R1, G1, B1, // Pixel 1 RGB
    input [7:0] R2, G2, B2, // Pixel 2 RGB
    output [7:0] Y1, Y2,    // Y values for Pixel 1 and Pixel 2
    output [7:0] U,         // Shared U value
    output [7:0] V          // Shared V value
);
    // Intermediate Y, U, V for pixel 1 and 2
    wire [7:0] Y1_temp, Y2_temp, U1, U2, V1, V2;

    // Instantiate two RGB to YUV444 converters
    rgb_to_yuv444 conv1(.R(R1), .G(G1), .B(B1), .Y(Y1_temp), .U(U1), .V(V1));
    rgb_to_yuv444 conv2(.R(R2), .G(G2), .B(B2), .Y(Y2_temp), .U(U2), .V(V2));

    // Assign outputs
    assign Y1 = Y1_temp;
    assign Y2 = Y2_temp;
    assign U = (U1 + U2) >> 1;
    assign V = (V1 + V2) >> 1;
endmodule
