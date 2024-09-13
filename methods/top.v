// top_module.v
module top(
    input wire clk,
    input wire rst
);
    // 定义必要的连线和信号
    wire [16:0] rom_addr;
    wire [7:0] rom_data;
    wire [7:0] pixel_window [0:8];
    wire [7:0] dilation_pixel;
    wire [7:0] erosion_pixel;
    wire [7:0] rotated_pixel;
    wire [15:0] x_in, y_in;
    wire [15:0] x_out, y_out;

    // ROM实例化
    rom #(
        .ADDR_WIDTH(17),
        .DATA_WIDTH(8),
		.DATA_DEPTH(50000),
        .MEM_FILE("image_data.dat")
    ) u_rom (
        .clk(clk),
        .en(1'b1),
        .addr(rom_addr),
        .data_out(rom_data)
    );


    // 图像缓存实例化
    image_cache #(
        .DATA_WIDTH(8),
        .IMG_WIDTH(145)
    ) u_image_cache (
        .clk(clk),
        .rst(rst),
        .pixel_in(rom_data),
		.addr(rom_addr),
        .window(pixel_window)
    );

    // 图像膨胀实例化
    image_dilation #(
        .DATA_WIDTH(8)
    ) u_image_dilation (
        .clk(clk),
        .rst(rst),
        .window(pixel_window),
        .pixel_out(dilation_pixel)
    );

    // 图像腐蚀实例化
    image_erosion #(
        .DATA_WIDTH(8)
    ) u_image_erosion (
        .clk(clk),
        .rst(rst),
        .window(pixel_window),
        .pixel_out(erosion_pixel)
    );

    // 图像旋转实例化
    image_rotate #(
        .DATA_WIDTH(8),
        .IMG_WIDTH(640),
        .IMG_HEIGHT(480),
        .ANGLE(30)
    ) u_image_rotate (
        .clk(clk),
        .rst(rst),
        .pixel_in(rom_data),
        .x_in(rom_addr % 640),
        .y_in(rom_addr / 640),
        .pixel_out(rotated_pixel),
        .x_out(x_out),
        .y_out(y_out)
    );

    // 其他模块的实例化...

    // 地址生成逻辑
    reg [15:0] addr_counter;
    always @(posedge clk or negedge rst) begin
        if (!rst)
            addr_counter <= 0;
        else
            addr_counter <= addr_counter + 1;
    end
    assign rom_addr = addr_counter;

    // 输出或进一步处理
    // ...
endmodule
