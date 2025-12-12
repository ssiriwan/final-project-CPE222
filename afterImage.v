`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2025 02:36:23 PM
// Design Name: 
// Module Name: afterImage
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


module afterImage(
    input clk,
    output reg [26:0] activate
    );
    always @(posedge clk) begin
        activate <= activate + 1;
        if(activate == 100000000)
            activate <= 0;
    end
endmodule
