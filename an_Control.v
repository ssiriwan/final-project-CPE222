module an_Control(
    input [1:0] active_digit,
    input [26:0] activate, // Assuming this is a counter from Top Module
    input [13:0] value1,
    input [13:0] value2,
    input clk,
    input rst,
    input count,
    input isError,
    output reg [3:0] an,      // Controls which digit is ON
    output reg [3:0] display  // Controls the number (0-9) on that digit
    );

    // --- 1. Blink Timer ---
    reg flag;
    reg [25:0] blink_counter; // 26 bits is enough for 0.5s at 100MHz
    reg prev_rst;

    always @(posedge clk or posedge rst) begin
        if (rst == 1 && prev_rst == 0) begin
            blink_counter <= 0;
            flag <= 1'b0;
        end else begin
            // 25,000,000 cycles = 0.25 seconds (at 100MHz)
            if (blink_counter >= 25000000) begin
                blink_counter <= 0;
                flag <= ~flag; // Toggle flag
            end else begin
                blink_counter <= blink_counter + 1;
            end
        end
        prev_rst = rst;
    end

    // --- 2. Multiplexing & Display Logic ---
    // We use the upper bits of 'activate' to scan through the 4 digits.
    // activate[19:18] changes every ~2.6ms (perfect for eyes).
    
    always @(*) begin
        // default defaults
        an = 4'b1111; // Assume Active LOW (1111 is all off)
        display = 4'b0000;

        case(activate[19:18]) // Use bits to create 4 time slots
            
            // --- TIME SLOT 0: Handle Rightmost Digit ---
            2'b00: begin
                if(isError) begin
                    display = 2'd0;
                end else begin
                    if(count == 0) display = value1 % 10; // Extract digit 0
                    else if(count == 1) display = value2 % 10;
                end
                // Logic: "Is this the digit we are editing?"
                if (active_digit == 2'b00) begin
                    // YES: Blink it (If flag is 1, turn ON. If 0, turn OFF)
                    // Note: If your board is Active Low, '0' is ON.
                    if (flag) an = 4'b1110; // ON
                    else      an = 4'b1111; // OFF (Blink gap)
                end else begin
                    // NO: Just keep it ON constantly
                    an = 4'b1110; 
                end
            end

            // --- TIME SLOT 1: Handle 2nd Digit ---
            2'b01: begin
                if(isError) begin
                    display = 2'd1;
                end else begin
                    if(count == 0) display = (value1 / 10) % 10; // Extract digit 0
                    else if(count == 1) display = (value2 / 10) % 10;
                end                     
                if (active_digit == 2'b01) begin
                    if (flag) an = 4'b1101; 
                    else      an = 4'b1111; 
                end else begin
                    an = 4'b1101; 
                end
            end

            // --- TIME SLOT 2: Handle 3rd Digit ---
            2'b10: begin
                if(isError) begin
                    display = 2'd2;
                end else begin
                    if(count == 0) display = (value1 / 100) % 10; // Extract digit 0
                    else if(count == 1) display = (value2 / 100) % 10;
                end            
                if (active_digit == 2'b10) begin
                    if (flag) an = 4'b1011; 
                    else      an = 4'b1111; 
                end else begin
                    an = 4'b1011; 
                end
            end

            // --- TIME SLOT 3: Handle Leftmost Digit ---
            2'b11: begin
                if(isError) begin
                    display = 2'd3;
                end else begin
                    if(count == 0) display = (value1 / 1000) % 10; // Extract digit 0
                    else if(count == 1) display = (value2 / 1000) % 10;
                end   
                if (active_digit == 2'b11) begin
                    if (flag) an = 4'b0111; 
                    else      an = 4'b1111; 
                end else begin
                    an = 4'b0111; 
                end
            end
            
        endcase
    end
endmodule