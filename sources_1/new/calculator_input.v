module calculator_core(
    input clk, 
    input rst, 
    input btnU, btnD, btnL, btnR, btnC, 
    input [3:0] sw,
    output [13:0] value1,
    output [13:0] value2,
    output [1:0] active_digit_out, 
    output reg led,
    output reg [3:0] led_op,
    output reg count,
    output reg isError
);
     
    // Array to store 4 digits (each 4 bits wide)
    reg [3:0] num [3:0];
    reg [3:0] num2 [3:0];
    reg [1:0] active_digit;
    reg [1:0] op_reg;
    reg [1:0] saved_op;
    
    // History registers for Edge Detection
    reg prev_btnL, prev_btnR, prev_btnU, prev_btnD, prev_btnC;
    
    reg [13:0] val1;
    reg [13:0] val2;
    reg [27:0] res; // à¼×èÍ¼Å¤Ù³¤èÒàÂÍÐæ
     
    // --- MAIN LOGIC BLOCK ---
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            // Reset everything
            if(count == 0) begin num[0] <= 0; num[1] <= 0; num[2] <= 0; num[3] <= 0; end
            else if(count == 1) begin num2[0] <= 0; num2[1] <= 0; num2[2] <= 0; num2[3] <= 0; end
            active_digit <= 2'b00;
            prev_btnL <= 0; prev_btnR <= 0; prev_btnU <= 0; prev_btnD <= 0; prev_btnC <= 0;
            isError <= 0;
        end else begin
            
            // 1. LEFT Button (Change Digit)
            if(btnL == 1 && prev_btnL == 0) begin
                if(active_digit == 2'b11) active_digit <= 2'b00;
                else active_digit <= active_digit + 1; 
            end

            // 2. RIGHT Button (Change Digit)
            if(btnR == 1 && prev_btnR == 0) begin
                if(active_digit == 2'b00) active_digit <= 2'b11;
                else active_digit <= active_digit - 1;
            end

            // 3. UP Button (Increment Current Digit)
            if(btnU == 1 && prev_btnU == 0) begin
                // Operate directly on the specific digit we are looking at
                if(count == 0) begin
                    if(num[active_digit] == 9) 
                        num[active_digit] <= 0;
                    else 
                        num[active_digit] <= num[active_digit] + 1;
                end else if(count == 1) begin
                    if(num2[active_digit] == 9) 
                        num2[active_digit] <= 0;
                    else 
                        num2[active_digit] <= num2[active_digit] + 1;                
                end
            end

            // 4. DOWN Button (Decrement Current Digit)
            if(btnD == 1 && prev_btnD == 0) begin
                if(count == 0) begin 
                    if(num[active_digit] == 0) 
                        num[active_digit] <= 9;
                    else 
                        num[active_digit] <= num[active_digit] - 1;
                end
                else if(count == 1) begin 
                    if(num2[active_digit] == 0) 
                        num2[active_digit] <= 9;
                    else 
                        num2[active_digit] <= num2[active_digit] - 1;
                end
            end
            // 7. operations
            if (sw[0] == 1 && sw[1] == 0 && sw[2] == 0 && sw[3] == 0)begin op_reg <= 2'b00; led_op <= 4'b0001; end // ADD
            else if (sw[1] == 1 && sw[0] == 0 && sw[2] == 0 && sw[3] == 0)begin op_reg <= 2'b01; led_op <= 4'b0010; end // SUB
            else if (sw[2] == 1 && sw[1] == 0 && sw[0] == 0 && sw[3] == 0)begin op_reg <= 2'b10; led_op <= 4'b0100; end // MUL
            else if (sw[3] == 1 && sw[1] == 0 && sw[0] == 0 && sw[2] == 0) begin op_reg <= 2'b11; led_op <= 4'b1000; end // DIV
            else begin led_op <= 4'b0000; end //Default
            
            // 5. center button (comfirm operation and value1)
            if(btnC == 1 && prev_btnC == 0) begin
                if(count == 0) begin //editing num move to edit val2
                    count <= 1;
                    led <= 1;
                    active_digit <= 0;
                    saved_op <= op_reg;
                    isError <= 0;
                end else begin //val2 stage and calculate here
                    val1 = num[0] + (num[1] * 10) + (num[2] * 100) + (num[3] * 1000);
                    val2 = num2[0] + (num2[1] * 10) + (num2[2] * 100) + (num2[3] * 1000);
                
                    //calculate
                    case (saved_op)
                        2'b00: res = val1 + val2;
                        2'b01: res = (val1 >= val2) ? (val1 - val2) : 0;
                        2'b10: res = val1 * val2;
                        2'b11: res = (val2 != 0) ? (val1 / val2) : 0;
                    endcase
                
                   // Overflow Protection & Save result
                   if (res > 9999)  isError <= 1;
                   else if (saved_op == 2'b11 && val2 == 0) isError <= 1;
                   
                   else begin
                       isError <= 0;
                       num[0] <= res % 10;
                       num[1] <= (res / 10) % 10;
                       num[2] <= (res / 100) % 10;
                       num[3] <= (res / 1000) % 10;
                   end
                   num2[0] <= 0; num2[1] <= 0; num2[2] <= 0; num2[3] <= 0;
                   count <= 0; led <= 0;
                end
            end
  
            // 6. Update History (Crucial for edge detection!)
            prev_btnL <= btnL;
            prev_btnR <= btnR;
            prev_btnU <= btnU;
            prev_btnD <= btnD;
            prev_btnC <= btnC;
        end
    end

    // --- OUTPUT ASSIGNMENTS ---
    // Calculate the total value (Combinational Logic)
    assign value1 = num[0] + (num[1] * 10) + (num[2] * 100) + (num[3] * 1000);
    assign value2 = num2[0] + (num2[1] * 10) + (num2[2] * 100) + (num2[3] * 1000);
    assign active_digit_out = active_digit;  

endmodule
