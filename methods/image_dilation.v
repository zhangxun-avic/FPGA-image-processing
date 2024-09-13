module image_dilation #(
    parameter DATA_WIDTH = 8,
    parameter WINDOW_SIZE = 9  // Assuming a 3x3 window for dilation
)(
    input wire clk,
    input wire rst,
    input wire [DATA_WIDTH-1:0] window [0:WINDOW_SIZE-1],
    output reg [DATA_WIDTH-1:0] pixel_out
);
    reg [3:0] i;  // Smaller loop counter
    reg [DATA_WIDTH-1:0] max_value;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            pixel_out <= 0;
        end else begin
            max_value = window[0];
            for (i = 1; i < WINDOW_SIZE; i = i + 1) begin
                if (window[i] > max_value)
                    max_value = window[i];
            end
            pixel_out <= max_value;
        end
    end
endmodule
