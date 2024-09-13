module image_rotate #(
    parameter DATA_WIDTH = 8,
    parameter IMG_WIDTH = 640,
    parameter IMG_HEIGHT = 480,
    parameter ANGLE_DEG = 30  // 只支持30°的倍数的角度旋转
)(
    input wire clk,
    input wire rst,
    input wire [DATA_WIDTH-1:0] pixel_in,
    input wire [15:0] x_in,
    input wire [15:0] y_in,
    output reg [DATA_WIDTH-1:0] pixel_out,
    output reg [15:0] x_out,
    output reg [15:0] y_out
);

    // 定义用于三角函数近似的定点数常量
    reg signed [15:0] cos_theta;
    reg signed [15:0] sin_theta;
    reg signed [31:0] x_centered;
    reg signed [31:0] y_centered;
    reg signed [31:0] x_rotated;
    reg signed [31:0] y_rotated;

    // 计算图像中心坐标
    wire signed [15:0] x_center = IMG_WIDTH >> 1;
    wire signed [15:0] y_center = IMG_HEIGHT >> 1;

    // 根据输入角度设置cos和sin值
    always @(*) begin
        case (ANGLE_DEG)
            30: begin
                cos_theta = 8660;   // cos(30°) ≈ 0.866
                sin_theta = 5000;   // sin(30°) ≈ 0.5
            end
            60: begin
                cos_theta = 5000;   // cos(60°) ≈ 0.5
                sin_theta = 8660;   // sin(60°) ≈ 0.866
            end
            90: begin
                cos_theta = 0;
                sin_theta = 10000;  // sin(90°) = 1.0
            end
            // 添加其他支持的角度
            default: begin
                cos_theta = 10000;  // cos(0°) = 1.0
                sin_theta = 0;
            end
        endcase
    end

    // 坐标旋转的实现
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            x_out <= 0;
            y_out <= 0;
            pixel_out <= 0;
        end else begin
            // 将坐标平移到中心
            x_centered = x_in - x_center;
            y_centered = y_in - y_center;

            // 旋转坐标
            x_rotated = (x_centered * cos_theta - y_centered * sin_theta) / 10000;
            y_rotated = (x_centered * sin_theta + y_centered * cos_theta) / 10000;

            // 平移回原位置
            x_out <= x_rotated + x_center;
            y_out <= y_rotated + y_center;
            pixel_out <= pixel_in;
        end
    end
endmodule
