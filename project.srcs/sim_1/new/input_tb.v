`timescale 1ns/1ps

module input_tb;

    reg clk = 0;
    reg rst = 0;
    reg btnU = 0, btnD = 0, btnL = 0, btnR = 0, btnC = 0;

    wire [15:0] number_out;
    wire [1:0] active_digit_out;

    // DUT
    calculator_input uut (
        .clk(clk),
        .rst(rst),
        .btnU(btnU),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .btnC(btnC),
        .number_out(number_out),
        .active_digit_out(active_digit_out)
    );

    // clock 100 MHz
    always #5 clk = ~clk;

    // task กดปุ่ม (pulse)
//    task press_button;
//        output reg btn;
//        begin
//            btn = 1;
//            #20;
//            btn = 0;
//            #20;
//        end
//    endtask

    initial begin
        $display("Start Simulation");
        
        rst = 1;
        #50;
        rst = 0;

        // ============= ทดสอบเลือก digit =============
        $display("Move Digit Right");
//        press_button(btnR);   // ไป digit 3
//        press_button(btnR);   // ไป digit 2
//        press_button(btnR);   // ไป digit 1
        btnR=1; #5
        btnR=1; #5
        btnR=1;

        // ============= ทดสอบเพิ่มค่า =============
        $display("Increment digit value");
//        press_button(btnU);   // +1
//        press_button(btnU);   // +1
//        press_button(btnU);   // +1
        btnU=1; #5
        btnU=1; #5
        btnU=1;

        // ============= ทดสอบลดค่า =============
        $display("Decrement digit value");
//        press_button(btnD);
        btnD=1;        

        // ============= ไป digit ถัดไป =============
//        press_button(btnL);
        btnL=1;
        // เพิ่มค่าที่ digit 2
//        press_button(btnU);
        btnU=1;
        #200;
        $finish;
    end

endmodule
