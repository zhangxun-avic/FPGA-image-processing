module edge_detection_sobel #(
    parameter DATA_WIDTH = 8,
    parameter KERNEL_SIZE = 3
)(
    input wire clk,
    input wire signed [DATA_WIDTH-1:0] pixel_matrix [0:KERNEL_SIZE*KERNEL_SIZE-1],
    output reg [DATA_WIDTH-1:0] pixel_out
);
    reg signed [DATA_WIDTH+1:0] gx, gy; // 加大数据宽度以处理可能的溢出
    wire [DATA_WIDTH+1:0] abs_gx, abs_gy;

    // 使用连续赋值语句计算绝对值
    assign abs_gx = (gx < 0) ? -gx : gx;
    assign abs_gy = (gy < 0) ? -gy : gy;

    always @(posedge clk) begin
        // Sobel算子X方向
        gx = -pixel_matrix[0] - 2*pixel_matrix[1] - pixel_matrix[2] +
              pixel_matrix[6] + 2*pixel_matrix[7] + pixel_matrix[8];
        // Sobel算子Y方向
        gy = -pixel_matrix[0] - 2*pixel_matrix[3] - pixel_matrix[6] +
              pixel_matrix[2] + 2*pixel_matrix[5] + pixel_matrix[8];
        // 除以8简化为右移3位
        pixel_out <= (abs_gx + abs_gy) >> 3;
    end
endmodule
