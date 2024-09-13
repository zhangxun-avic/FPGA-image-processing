module image_cache
#(
    parameter DATA_WIDTH = 8,
    parameter IMG_WIDTH = 640
)(
    input wire clk,
    input wire rst,
    input wire [DATA_WIDTH-1:0] pixel_in,
    input wire [$clog2(IMG_WIDTH)-1:0] addr,
    output reg [DATA_WIDTH-1:0] window [0:8]
);

    // 状态定义
    localparam IDLE = 2'b00,
               WRITE_LINE = 2'b01,
               UPDATE_WINDOW = 2'b10,
               TOGGLE_BUFFER = 2'b11;

    // 状态寄存器
    reg [1:0] state, next_state;

    // 双缓冲
    reg [DATA_WIDTH-1:0] line_buffer0 [0:IMG_WIDTH-1];
    reg [DATA_WIDTH-1:0] line_buffer1 [0:IMG_WIDTH-1];
    reg ping_pong;  // 乒乓标志

    // 状态机逻辑
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= IDLE;
            ping_pong <= 0;
            // 初始化缓冲区
            for (int i = 0; i < IMG_WIDTH; i++) begin
                line_buffer0[i] <= 0;
                line_buffer1[i] <= 0;
            end
        end else begin
            state <= next_state;
        end
    end

    // 下一个状态和输出逻辑
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = WRITE_LINE;
            end

            WRITE_LINE: begin
                if (addr == IMG_WIDTH - 1)
                    next_state = TOGGLE_BUFFER;
                else
                    next_state = UPDATE_WINDOW;
            end

            UPDATE_WINDOW: begin
                next_state = WRITE_LINE;
            end

            TOGGLE_BUFFER: begin
                next_state = WRITE_LINE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // 行缓冲和窗口更新逻辑
    always @(posedge clk) begin
        if (state == WRITE_LINE) begin
            if (ping_pong == 0)
                line_buffer0[addr] <= pixel_in;
            else
                line_buffer1[addr] <= pixel_in;
        end
        else if (state == UPDATE_WINDOW) begin
            if (addr == 0) begin
                // 复制边界像素以处理边界情况
                window[0] <= line_buffer1[0];
                window[1] <= line_buffer1[0];
                window[2] <= line_buffer1[1];
                window[3] <= line_buffer0[0];
                window[4] <= line_buffer0[0];
                window[5] <= line_buffer0[1];
                window[6] <= line_buffer1[0];
                window[7] <= line_buffer1[0];
                window[8] <= line_buffer1[1];
            end else if (addr == IMG_WIDTH-1) begin
                window[0] <= line_buffer1[IMG_WIDTH-2];
                window[1] <= line_buffer1[IMG_WIDTH-1];
                window[2] <= line_buffer1[IMG_WIDTH-1];
                window[3] <= line_buffer0[IMG_WIDTH-2];
                window[4] <= line_buffer0[IMG_WIDTH-1];
                window[5] <= line_buffer0[IMG_WIDTH-1];
                window[6] <= line_buffer1[IMG_WIDTH-2];
                window[7] <= line_buffer1[IMG_WIDTH-1];
                window[8] <= line_buffer1[IMG_WIDTH-1];
            end else begin
                window[0] <= line_buffer1[addr - 1];
                window[1] <= line_buffer1[addr];
                window[2] <= line_buffer1[addr + 1];
                window[3] <= line_buffer0[addr - 1];
                window[4] <= line_buffer0[addr];
                window[5] <= line_buffer0[addr + 1];
                window[6] <= line_buffer1[addr - 1];
                window[7] <= line_buffer1[addr];
                window[8] <= line_buffer1[addr + 1];
            }
        end
        else if (state == TOGGLE_BUFFER) begin
            ping_pong <= ~ping_pong;
        end
    end
endmodule
