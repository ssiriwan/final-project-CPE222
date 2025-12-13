`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2025 02:44:48 PM
// Design Name: 
// Module Name: clock_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//blinking
module clock_divider (
    input clk, rst,
    output clk_o
);
    reg counter;
    reg clk_reg;
    
    always @(posedge clk) begin
        if(rst) begin
            counter <= 0;
            clk_reg <= 0;
        end else begin
            if(counter == (100/2)-1) begin
                counter <= 0;
                clk_reg <= ~clk_reg;
            end else begin
                counter <= counter + 1;
            end
        end
    end
//    parameter clk_freq_Hz = 100000000,
//    parameter toggle_freq_Hz = 1
//    )(
//    input clk, rst,
//    output reg enable_out
//    );
//    //calculate the count limit for half of the toggle period
//    localparam max_count = (clk_freq_Hz / (2*toggle_freq_Hz)) - 1;
////    localparam counter_width = $clog2(max_count+1);
    
//    reg [25:0] counter = 0;
    
//    always @(posedge clk or posedge rst) begin
//        if(rst)begin
//            counter <= 0;
//            enable_out <= 0;
//        end else begin
//            if(counter == max_count) begin
//                counter <= 0;
//                enable_out <= ~enable_out;
//            end else
//            counter = counter + 1;
//        end
//    end
    
    
endmodule
