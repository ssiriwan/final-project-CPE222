`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 09:26:56 PM
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clk, rst, btnU, btnD, btnL, btnR, btnC, [3:0] sw,
    output [6:0] seg,
    output [3:0] an, 
    output led,
    output [3:0] led_op
    );
    
    wire [3:0]display; //decimal want to display
//    wire [3:0] number_reg;//decimal in each index
    wire [1:0] current_active_digit;
//    wire clk_o;
    wire [26:0] activate_display;
    wire [13:0]value1;
    wire [13:0]value2;
    wire [1:0] op;
    wire count;
    wire isError;
    
//    clock_divider U_divider (
//    .clk(clk), .rst(rst), .clk_o(clk_o));
    
    calculator_core U_core(
    .clk(clk), .rst(rst), .btnU(btnU), .btnD(btnD), .btnL(btnL), .btnR(btnR), .btnC(btnC), .sw(sw),
    .value1(value1), .value2(value2), 
    .active_digit_out(current_active_digit), .led(led), .led_op(led_op), .count(count), .isError(isError));
    
    afterImage U_image(
    .clk(clk), .activate(activate_display));
    
    an_Control U_anode(
    .active_digit(current_active_digit), .activate(activate_display),.value1(value1),.value2(value2), .clk(clk), .rst(rst),.count(count),.isError(isError),.an(an),.display(display));
    
    bcdDisplay U_decoder (
    .display(display),.isError(isError),.seg(seg));
    

    
    
endmodule
