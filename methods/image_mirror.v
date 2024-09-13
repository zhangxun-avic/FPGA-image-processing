module image_mirror #(
    parameter DATA_WIDTH = 8,
    parameter IMG_WIDTH = 640
)(
    input wire clk,
    input wire [DATA_WIDTH-1:0] pixel_in,
    input wire [9:0] x_in,
    output reg [DATA_WIDTH-1:0] pixel_out,
    output reg [9:0] x_out,
    output reg valid_out  // Add a valid output to indicate when the mirrored pixel is within bounds
);
    always @(posedge clk) begin
        x_out <= IMG_WIDTH - 1 - x_in;
        pixel_out <= pixel_in;

        // Assume x_in is always valid within 0 to IMG_WIDTH-1, valid_out can be high
        valid_out <= 1;
    end
endmodule
