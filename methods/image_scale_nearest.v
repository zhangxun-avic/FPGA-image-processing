module image_scale_nearest #(
    parameter DATA_WIDTH = 8,
    parameter IMG_WIDTH = 640,
    parameter IMG_HEIGHT = 480,
    parameter SCALE_FACTOR = 2  // 放大倍数，假设为整数
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
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            x_out <= 0;
            y_out <= 0;
            pixel_out <= 0;
        end else begin
            // 缩放处理，使用位移运算优化除法
            x_out <= x_in >> $clog2(SCALE_FACTOR);
            y_out <= y_in >> $clog2(SCALE_FACTOR);
            pixel_out <= pixel_in;
        end
    end
endmodule
