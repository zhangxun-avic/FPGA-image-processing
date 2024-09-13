module rgb_to_yuv444(
    input [7:0] R,
    input [7:0] G,
    input [7:0] B,
    output [7:0] Y,
    output [7:0] U,
    output [7:0] V
);
    // Coefficients based on ITU-R BT.601 standard
    wire signed [15:0] wR = R;
    wire signed [15:0] wG = G;
    wire signed [15:0] wB = B;

    wire signed [15:0] tmpY = (77 * wR + 150 * wG + 29 * wB) >> 8;
    wire signed [15:0] tmpU = ((-43 * wR - 85 * wG + 128 * wB) >> 8) + 128;
    wire signed [15:0] tmpV = ((128 * wR - 107 * wG - 21 * wB) >> 8) + 128;

    assign Y = tmpY[7:0];
    assign U = tmpU[7:0];
    assign V = tmpV[7:0];
endmodule
