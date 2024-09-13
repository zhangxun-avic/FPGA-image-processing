`timescale 1ns / 1ps

module tb_vga_controller;

// Inputs
reg clk;

// Outputs
wire hsync;
wire vsync;
wire [11:0] x;
wire [10:0] y;
wire valid;

// 实例化 VGA 控制器
vga_controller uut (
    .clk(clk),
    .hsync(hsync),
    .vsync(vsync),
    .x(x),
    .y(y),
    .valid(valid)
);

// 时钟信号生成，模拟25MHz时钟
initial begin
    clk = 0;
    forever #20 clk = ~clk;  // 25MHz时钟周期为40ns
end

// 模拟测试持续时间
initial begin
    // 模拟运行1ms
    #20000000;
 
end

endmodule



