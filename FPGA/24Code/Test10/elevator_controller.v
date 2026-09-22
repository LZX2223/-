module elevator_controller (
    input              clk,            // 系统时钟信号
    input              rst_n,          // 异步复位信号，低电平有效
    input              tick,           // 电梯动作节拍信号，每来一次表示电梯移动一层或开门计时一次
    input      [9:0]   req,            // 10层楼请求信号，req[0]表示1楼，req[9]表示10楼
    output reg [3:0]   current_floor,  // 当前楼层，范围为1~10
    output reg [1:0]   direction,      // 电梯运行方向：00停止，01上行，10下行
    output reg         door_open,      // 电梯门状态：1表示开门，0表示关门
    output reg [3:0]   state_out       // 当前状态输出，便于仿真观察
);

    // ============================================================
    // one-hot 状态编码
    // 每个状态只有一位为1，其余位为0
    // ============================================================
    localparam IDLE = 4'b0001;         // 空闲状态，等待楼层请求
    localparam UP   = 4'b0010;         // 上行状态
    localparam DOWN = 4'b0100;         // 下行状态
    localparam OPEN = 4'b1000;         // 开门状态

    // ============================================================
    // 电梯方向编码
    // ============================================================
    localparam STOP_DIR = 2'b00;       // 停止
    localparam UP_DIR   = 2'b01;       // 上行
    localparam DOWN_DIR = 2'b10;       // 下行

    reg [3:0] state;                   // 状态寄存器，保存当前FSM状态
    reg [9:0] pending_req;             // 请求寄存器，用来保存还没有处理的楼层请求
    reg [3:0] target_floor;            // 目标楼层
    reg [1:0] door_cnt;                // 开门保持时间计数器

    // ============================================================
    // 函数：nearest_floor
    // 功能：在所有请求楼层中，选择距离当前楼层最近的楼层
    // 输入：
    //      requests  ：当前所有待处理请求
    //      cur_floor ：当前楼层
    // 输出：
    //      nearest_floor：距离当前楼层最近的请求楼层
    // ============================================================
    function [3:0] nearest_floor;
        input [9:0] requests;          // 请求信号
        input [3:0] cur_floor;         // 当前楼层

        integer k;                     // 循环变量
        integer floor_num;             // 当前遍历到的楼层号
        integer dist;                  // 当前楼层与请求楼层之间的距离
        integer min_dist;              // 最小距离
        integer best_floor;            // 当前找到的最近楼层

        begin
            min_dist = 20;             // 初始化为较大的值，因为最大楼层距离不会超过9
            best_floor = 0;            // 初始化目标楼层为0，表示暂时没有请求

            // 遍历10个楼层请求
            for (k = 0; k < 10; k = k + 1) begin
                if (requests[k]) begin
                    floor_num = k + 1; // req[0]对应1楼，所以楼层号为k+1

                    // 计算当前楼层与请求楼层之间的绝对距离
                    if (floor_num >= cur_floor)
                        dist = floor_num - cur_floor;
                    else
                        dist = cur_floor - floor_num;

                    // 如果当前请求楼层距离更近，则更新最近楼层
                    if (dist < min_dist) begin
                        min_dist = dist;
                        best_floor = floor_num;
                    end
                end
            end

            nearest_floor = best_floor[3:0]; // 返回最近请求楼层
        end
    endfunction

    // ============================================================
    // 主时序逻辑
    // 在时钟上升沿工作，rst_n为低电平时异步复位
    // ============================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // ----------------------------
            // 复位初始化
            // ----------------------------
            state         <= IDLE;         // 初始为空闲状态
            pending_req   <= 10'b0;        // 清空所有请求
            current_floor <= 4'd1;         // 电梯初始位于1楼
            target_floor  <= 4'd1;         // 初始目标楼层为1楼
            direction     <= STOP_DIR;     // 初始停止
            door_open     <= 1'b0;         // 初始关门
            door_cnt      <= 2'd0;         // 开门计数器清零
            state_out     <= IDLE;         // 状态输出为空闲
        end
        else begin
            // 保存新的楼层请求
            // pending_req保存之前未处理的请求，req表示当前新输入的请求
            pending_req <= pending_req | req;

            // 输出当前状态，方便在ModelSim中观察
            state_out <= state;

            case (state)

                // ====================================================
                // IDLE：空闲状态
                // 如果没有请求则保持空闲；
                // 如果有请求，则选择距离当前楼层最近的楼层作为目标楼层
                // ====================================================
                IDLE: begin
                    door_open <= 1'b0;     // 空闲时关门
                    direction <= STOP_DIR; // 空闲时停止

                    // 判断是否存在请求
                    if ((pending_req | req) != 10'b0) begin
                        // 选择最近楼层作为目标楼层
                        target_floor <= nearest_floor(pending_req | req, current_floor);

                        // 如果目标楼层高于当前楼层，则进入上行状态
                        if (nearest_floor(pending_req | req, current_floor) > current_floor) begin
                            state <= UP;
                            direction <= UP_DIR;
                        end
                        // 如果目标楼层低于当前楼层，则进入下行状态
                        else if (nearest_floor(pending_req | req, current_floor) < current_floor) begin
                            state <= DOWN;
                            direction <= DOWN_DIR;
                        end
                        // 如果目标楼层就是当前楼层，则直接开门
                        else begin
                            state <= OPEN;
                            door_open <= 1'b1;
                            direction <= STOP_DIR;
                            door_cnt <= 2'd0;
                        end
                    end
                end

                // ====================================================
                // UP：上行状态
                // 每来一个tick信号，电梯向上移动一层
                // 到达目标楼层后进入开门状态
                // ====================================================
                UP: begin
                    door_open <= 1'b0;     // 运行过程中关门
                    direction <= UP_DIR;   // 方向为上行

                    if (tick) begin
                        // 若当前楼层低于目标楼层，则楼层加1
                        if (current_floor < target_floor)
                            current_floor <= current_floor + 1'b1;

                        // 判断下一次移动后是否到达目标楼层
                        if ((current_floor + 1'b1) >= target_floor) begin
                            state <= OPEN;         // 到达后进入开门状态
                            direction <= STOP_DIR; // 停止运行
                            door_open <= 1'b1;     // 开门
                            door_cnt <= 2'd0;      // 开门计数清零
                        end
                    end
                end

                // ====================================================
                // DOWN：下行状态
                // 每来一个tick信号，电梯向下移动一层
                // 到达目标楼层后进入开门状态
                // ====================================================
                DOWN: begin
                    door_open <= 1'b0;     // 运行过程中关门
                    direction <= DOWN_DIR; // 方向为下行

                    if (tick) begin
                        // 若当前楼层高于目标楼层，则楼层减1
                        if (current_floor > target_floor)
                            current_floor <= current_floor - 1'b1;

                        // 判断下一次移动后是否到达目标楼层
                        if ((current_floor - 1'b1) <= target_floor) begin
                            state <= OPEN;         // 到达后进入开门状态
                            direction <= STOP_DIR; // 停止运行
                            door_open <= 1'b1;     // 开门
                            door_cnt <= 2'd0;      // 开门计数清零
                        end
                    end
                end

                // ====================================================
                // OPEN：开门状态
                // 到达目标楼层后开门，并清除当前楼层请求
                // 开门保持一定时间后，再判断是否还有其他请求
                // ====================================================
                OPEN: begin
                    door_open <= 1'b1;     // 开门
                    direction <= STOP_DIR; // 开门时电梯停止

                    // 清除当前楼层对应的请求
                    // current_floor为1时清除pending_req[0]
                    // current_floor为10时清除pending_req[9]
                    pending_req[current_floor - 1] <= 1'b0;

                    if (tick) begin
                        // 开门保持3个tick左右
                        if (door_cnt < 2'd2) begin
                            door_cnt <= door_cnt + 1'b1;
                        end
                        else begin
                            // 开门时间结束，准备关门
                            door_open <= 1'b0;
                            door_cnt <= 2'd0;

                            // 判断除了当前楼层外，是否还有其他未处理请求
                            if ((pending_req & ~(10'b1 << (current_floor - 1))) != 10'b0) begin

                                // 重新选择最近楼层作为新的目标楼层
                                target_floor <= nearest_floor(
                                    pending_req & ~(10'b1 << (current_floor - 1)),
                                    current_floor
                                );

                                // 如果新的目标楼层高于当前楼层，则上行
                                if (nearest_floor(pending_req & ~(10'b1 << (current_floor - 1)), current_floor) > current_floor) begin
                                    state <= UP;
                                    direction <= UP_DIR;
                                end
                                // 如果新的目标楼层低于当前楼层，则下行
                                else if (nearest_floor(pending_req & ~(10'b1 << (current_floor - 1)), current_floor) < current_floor) begin
                                    state <= DOWN;
                                    direction <= DOWN_DIR;
                                end
                                // 理论上这种情况较少出现，表示仍停留在当前楼层开门
                                else begin
                                    state <= OPEN;
                                end
                            end
                            else begin
                                // 如果没有其他请求，则回到空闲状态
                                state <= IDLE;
                                direction <= STOP_DIR;
                            end
                        end
                    end
                end

                // ====================================================
                // default：异常状态处理
                // 如果状态机进入非法状态，则回到IDLE
                // ====================================================
                default: begin
                    state <= IDLE;
                    direction <= STOP_DIR;
                    door_open <= 1'b0;
                end

            endcase
        end
    end

endmodule