module image_translate #(
    parameter DATA_WIDTH = 8,
    parameter IMG_WIDTH = 640,
    parameter IMG_HEIGHT = 480,
    parameter SHIFT_X = 50,
    parameter SHIFT_Y = 50
)(
    input wire clk,
    input wire [DATA_WIDTH-1:0] pixel_in,
    input wire [9:0] x_in,
    input wire [9:0] y_in,
    output reg [DATA_WIDTH-1:0] pixel_out,
    output reg [9:0] x_out,
    output reg [9:0] y_out,
    output reg valid_out  // Add a valid output to indicate when the translated pixel is within bounds
);
    always @(posedge clk) begin
        // Compute new coordinates
        x_out <= x_in + SHIFT_X;
        y_out <= y_in + SHIFT_Y;
        pixel_out <= pixel_in;

        // Check if the new coordinates are within the image bounds
        if ((x_in + SHIFT_X < IMG_WIDTH) && (y_in + SHIFT_Y < IMG_HEIGHT)) begin
            valid_out <= 1;
        end else begin
            valid_out <= 0;
        end
    end
endmodule
