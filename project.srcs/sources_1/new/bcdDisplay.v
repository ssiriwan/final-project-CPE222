`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2025 04:09:19 PM
// Design Name: 
// Module Name: bcdDisplay
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


module bcdDisplay(
    input [3:0]display, isError,
    output reg [6:0] seg
    );
    always @(*) begin
        if(!isError) begin
            case(display)
            0: seg = 7'b1000000;
            1: seg = 7'b1111001;
            2: seg = 7'b0100100;
            3: seg = 7'b0110000;
            4: seg = 7'b0011001;
            5: seg = 7'b0010010;
            6: seg = 7'b0000010;
            7: seg = 7'b1111000;
            8: seg = 7'b0000000;
            9: seg = 7'b0010000;
            default: seg = 7'b1111111;
            endcase
        end else begin
            case(display)
            0: seg = 7'b1111111;
            1: seg = 7'b0101111;
            2: seg = 7'b0101111;
            3: seg = 7'b0000110;
            endcase
        end
    end
endmodule
