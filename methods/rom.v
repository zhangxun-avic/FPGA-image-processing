// rom.v
module rom #(
    parameter ADDR_WIDTH = 15,
    parameter DATA_WIDTH = 8,
	parameter DATA_DEPTH = 16000,
    parameter MEM_FILE = "image_data.dat"
)(
    input wire clk,
    input wire en,
    output reg [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] data_out
);
    // ROM存储器
    reg [DATA_WIDTH-1:0] rom_mem [0:DATA_DEPTH-1];

    // 初始化ROM，读取.dat文件
    initial begin
        $readmemh(MEM_FILE, rom_mem);
    end

    // 地址计数器
    always @(posedge clk or negedge rst) begin
        if (!rst)
            addr <= 0;
        else if (en)
            addr <= addr + 1;
    end

    // 读取数据
    always @(posedge clk or negedge rst) begin
        if (!rst)
            data_out <= 0;
        else
            data_out <= rom_mem[addr];
    end
endmodule
