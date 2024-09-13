module vga_controller(
    input 	     clk,          // 输入时钟
	input		 rst_n,
    output 		 hsync,       // 水平同步信号
    output 		 vsync,       // 垂直同步信号
    output 		 [11:0] x,     // 当前像素的X坐标
    output 		 [10:0] y,     // 当前像素的Y坐标
    output 		 valid        // 表示当前坐标是否在可显示范围内
);

// VGA timing constants
parameter H_DISP = 1680;  // 水平显示区域
parameter H_FRONT = 104;  // 水平前沿
parameter H_SYNC = 176;   // 水平同步
parameter H_BACK = 280;   // 水平后沿
parameter H_TOTAL = H_DISP + H_FRONT + H_SYNC + H_BACK; // 水平总周期

parameter V_DISP = 1050;  // 垂直显示区域
parameter V_FRONT = 3;  // 垂直前沿
parameter V_SYNC = 6;    // 垂直同步
parameter V_BACK = 30;   // 垂直后沿
parameter V_TOTAL = V_DISP + V_FRONT + V_SYNC + V_BACK; // 垂直总周期

// 水平和垂直计数器
reg [11:0] h_count = 0;
reg [10:0] v_count = 0;



// 生成水平同步和垂直同步信号
assign hsync = (h_count >= (H_DISP + H_FRONT) && h_count < (H_DISP + H_FRONT + H_SYNC));
assign vsync = (v_count >= (V_DISP + V_FRONT) && v_count < (V_DISP + V_FRONT + V_SYNC));

// 有效显示区域信号
assign valid = (h_count < H_DISP) && (v_count < V_DISP);

// 当前坐标输出
assign x = h_count;
assign y = v_count;

// 时钟边沿触发，更新计数器
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		begin
			v_count <= 0;
			h_count <= 0;
		end
	else
		begin
			if (h_count == H_TOTAL - 1) 
				begin
					h_count <= 0;
					if (v_count == V_TOTAL - 1)
						v_count <= 0;
					else
						v_count <= v_count + 1;
				end 
			else
				h_count <= h_count + 1;
		end
end

endmodule
