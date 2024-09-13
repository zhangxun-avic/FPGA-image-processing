module image_scale_bilinear #(
    parameter DATA_WIDTH = 8,
    parameter IMG_WIDTH = 640,
    parameter IMG_HEIGHT = 480,
    parameter SCALE_FACTOR_NUM = 2,  // 缩放因子的分子
    parameter SCALE_FACTOR_DEN = 1   // 缩放因子的分母
)(
    input wire clk,
    input wire rst,
    input wire [DATA_WIDTH-1:0] pixel_matrix [0:3],  // 四个邻近像素
    input wire [15:0] x_in,
    input wire [15:0] y_in,
    output reg [DATA_WIDTH-1:0] pixel_out
);
    reg [31:0] x_scaled;
    reg [31:0] y_scaled;
    reg [15:0] x_int;
    reg [15:0] y_int;
    reg [15:0] x_frac;
    reg [15:0] y_frac;
    reg [DATA_WIDTH-1:0] p00, p01, p10, p11;
    reg [DATA_WIDTH-1:0] tmp0, tmp1, pixel_value;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            pixel_out <= 0;
        end else begin
            // 缩放处理
            x_scaled = (x_in * SCALE_FACTOR_NUM) / SCALE_FACTOR_DEN;
            y_scaled = (y_in * SCALE_FACTOR_NUM) / SCALE_FACTOR_DEN;
            x_int = x_scaled >> 16;  // 假设使用16位定点数
            y_int = y_scaled >> 16;
            x_frac = x_scaled & 16'hFFFF;
            y_frac = y_scaled & 16'hFFFF;

            // 取得四个邻近像素
            p00 = pixel_matrix[0];
            p01 = pixel_matrix[1];
            p10 = pixel_matrix[2];
            p11 = pixel_matrix[3];

            // 双线性插值计算
            tmp0 = (p00 * (65536 - x_frac) + p01 * x_frac) >> 16;
            tmp1 = (p10 * (65536 - x_frac) + p11 * x_frac) >> 16;
            pixel_value = (tmp0 * (65536 - y_frac) + tmp1 * y_frac) >> 16;
            pixel_out <= pixel_value;
        end
    end
endmodule
