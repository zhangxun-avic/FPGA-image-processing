module edge_detection_first_order #(
    parameter DATA_WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire [DATA_WIDTH-1:0] window [0:8],
    output reg [DATA_WIDTH-1:0] pixel_out
);
    reg signed [DATA_WIDTH:0] gx, gy;  // 增加一位以处理可能的溢出
    wire [DATA_WIDTH:0] abs_gx, abs_gy;

    // 计算绝对值的硬件友好方法
    assign abs_gx = (gx < 0) ? -gx : gx;
    assign abs_gy = (gy < 0) ? -gy : gy;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            pixel_out <= 0;
        end else begin
            gx = $signed(window[5]) - $signed(window[4]);
            gy = $signed(window[7]) - $signed(window[4]);
            pixel_out <= (abs_gx + abs_gy) >> 1;  // 平均梯度值
        end
    end
endmodule
