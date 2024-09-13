module image_crop #(
    parameter DATA_WIDTH = 8,
    parameter IMG_WIDTH = 640,
    parameter IMG_HEIGHT = 480,
    parameter CROP_X = 100,
    parameter CROP_Y = 100,
    parameter CROP_WIDTH = 200,
    parameter CROP_HEIGHT = 200
)(
    input wire clk,
    input wire [DATA_WIDTH-1:0] pixel_in,
    input wire [9:0] x,
    input wire [9:0] y,
    output reg [DATA_WIDTH-1:0] pixel_out,
    output reg valid
);
    // Define inside_crop_area to simplify condition checking
    wire inside_crop_area;
    assign inside_crop_area = (x >= CROP_X && x < CROP_X + CROP_WIDTH && y >= CROP_Y && y < CROP_Y + CROP_HEIGHT);

    always @(posedge clk) begin
        if (inside_crop_area) begin
            pixel_out <= pixel_in;
            valid <= 1;
        end else begin
            pixel_out <= 0;  // Optionally, this line could be removed if not required to clear pixel_out.
            valid <= 0;
        end
    end
endmodule
