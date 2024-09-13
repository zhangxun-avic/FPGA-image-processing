module edge_detection_laplacian #(
    parameter DATA_WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire [DATA_WIDTH-1:0] window [0:8],
    output reg [DATA_WIDTH-1:0] pixel_out
);
    reg signed [DATA_WIDTH+2:0] laplacian; // 加大数据宽度以处理可能的溢出
    wire [DATA_WIDTH+2:0] abs_laplacian;

    // 使用连续赋值语句计算绝对值
    assign abs_laplacian = (laplacian < 0) ? -laplacian : laplacian;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            pixel_out <= 0;
        end else begin
            laplacian = -window[1] - window[3] + 4*window[4] - window[5] - window[7];
            // 除以4简化为右移2位
            pixel_out <= abs_laplacian >> 2;
        end
    end
endmodule
