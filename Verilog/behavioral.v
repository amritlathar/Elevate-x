module lfsr_random_num(
    input clk,          // Clock signal
    input reset,        // Reset signal to reinitialize LFSR
    output reg [3:0] random_num // 4-bit random number
);
    reg [3:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset)
            lfsr <= 4'b0001;  // Initial state
        else begin
            // XOR feedback (taps at position 3 and 2 for 4-bit LFSR)
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
        end
    assign random_num = lfsr;
    end

endmodule

module fullness_check (
    input [3:0] random_num,
    output reg full
);
    always @(*) begin
        if (random_num > 4'd15)
            full = 1'b1;
        else
            full = 1'b0;
    end
endmodule





module priority_controller (
    input [2:0] curr_floor_L1, curr_floor_L2, // Current floors of Lift 1 and Lift 2
    input [2:0] dest_floor_L1, dest_floor_L2, // Destination floors of Lift 1 and Lift 2
    input [2:0] req_floor,                    // Requested floor
    input req_direction,                      // Requested direction (1 = up, 0 = down)
    input full_L1, full_L2,                   // Fullness status of Lift 1 and Lift 2
    output reg [1:0] selected_lift            // 00 = none, 01 = Lift 1, 10 = Lift 2
);

    reg [2:0] dist_L1, dist_L2;               // Variables for distance between requested floor and current lift positions

    
    function [2:0] abs_diff(input [2:0] a, input [2:0] b);
        begin
            if (a > b)
                abs_diff = a - b;
            else
                abs_diff = b - a;
        end
    endfunction

    always @(*) begin
       
        selected_lift = 2'b00;

        // Check if either lift is full
        if (full_L1 && full_L2) begin
            // Both lifts are full, no lift selected
            selected_lift = 2'b00;
        end else if (full_L1) begin
            // Lift 1 is full, select Lift 2
            selected_lift = 2'b10;
        end else if (full_L2) begin
            // Lift 2 is full, select Lift 1
            selected_lift = 2'b01;
        end else begin
            // Check if either lift is at rest (current floor = destination floor)
            if (curr_floor_L1 == dest_floor_L1 && curr_floor_L2 == dest_floor_L2) begin
                // Both lifts are at rest, calculate proximity to the requested floor
                dist_L1 = abs_diff(req_floor, curr_floor_L1);
                dist_L2 = abs_diff(req_floor, curr_floor_L2);

                if (dist_L1 < dist_L2)
                    selected_lift = 2'b01;  // Lift 1 is closer
                else
                    selected_lift = 2'b10;  // Lift 2 is closer
            end else begin
                // Check if lifts have passed the request floor in their respective directions
                if (req_direction == 1) begin  // Request going up
                    if (curr_floor_L1 > req_floor) begin
                        // Lift 1 has passed the request floor going up, prioritize Lift 2
                        selected_lift = 2'b10;
                    end else if (curr_floor_L2 > req_floor) begin
                        // Lift 2 has passed the request floor going up, prioritize Lift 1
                        selected_lift = 2'b01;
                    end else begin
                        // Neither lift has passed the request floor, calculate proximity
                        dist_L1 = abs_diff(req_floor, curr_floor_L1);
                        dist_L2 = abs_diff(req_floor, curr_floor_L2);
                        
                        if (dist_L1 < dist_L2)
                            selected_lift = 2'b01;  // Lift 1 is closer
                        else
                            selected_lift = 2'b10;  // Lift 2 is closer
                    end
                end else begin  // Request going down
                    if (curr_floor_L1 < req_floor) begin
                        // Lift 1 has passed the request floor going down, prioritize Lift 2
                        selected_lift = 2'b10;
                    end else if (curr_floor_L2 < req_floor) begin
                        // Lift 2 has passed the request floor going down, prioritize Lift 1
                        selected_lift = 2'b01;
                    end else begin
                        // Neither lift has passed the request floor, calculate proximity
                        dist_L1 = abs_diff(req_floor, curr_floor_L1);
                        dist_L2 = abs_diff(req_floor, curr_floor_L2);
                        
                        if (dist_L1 < dist_L2)
                            selected_lift = 2'b01;  // Lift 1 is closer
                        else
                            selected_lift = 2'b10;  // Lift 2 is closer
                    end
                end
            end
        end
    end
endmodule



module elevator_controller (
    input clk, reset,  // Clock and reset signals
    input [2:0] curr_floor_L1, curr_floor_L2, dest_floor_L1, dest_floor_L2, req_floor,
    input req_direction,
    output [1:0] selected_lift
);
    wire full_L1, full_L2;

    wire [3:0] random_num_L1, random_num_L2;

    // Instantiate LFSR-based random number generators for both lifts
    lfsr_random_num rng1 (.clk(clk), .reset(reset), .random_num(random_num_L1));
    lfsr_random_num rng2 (.clk(clk), .reset(reset), .random_num(random_num_L2));

    // Fullness check for both lifts
    fullness_check fc1 (.random_num(random_num_L1), .full(full_L1));
    fullness_check fc2 (.random_num(random_num_L2), .full(full_L2));

    // Priority controller module
    priority_controller pc (
        .curr_floor_L1(curr_floor_L1), .curr_floor_L2(curr_floor_L2),
        .dest_floor_L1(dest_floor_L1), .dest_floor_L2(dest_floor_L2),
        .req_floor(req_floor), .req_direction(req_direction),
        .full_L1(full_L1), .full_L2(full_L2),
        .selected_lift(selected_lift)
    );
endmodule

