`timescale 1ns/1ps

module tb_priority_controller();
    // Testbench inputs
    reg [2:0] curr_floor_L1, curr_floor_L2; // Current floors of Lift 1 and Lift 2
    reg [2:0] dest_floor_L1, dest_floor_L2; // Destination floors of Lift 1 and Lift 2
    reg [2:0] req_floor;                    // Requested floor
    reg req_direction;                      // Requested direction (1 = up, 0 = down)

    // Testbench outputs
    wire [1:0] selected_lift;               // Output indicating the selected lift (00 = none, 01 = Lift 1, 10 = Lift 2)

    // Instantiate the priority controller module
    priority_controller uut (
        .curr_floor_L1(curr_floor_L1), .curr_floor_L2(curr_floor_L2),
        .dest_floor_L1(dest_floor_L1), .dest_floor_L2(dest_floor_L2),
        .req_floor(req_floor), .req_direction(req_direction),
        .selected_lift(selected_lift)
    );

    // Test cases
    initial begin
       

        // Test case 3: Lift 1 moving up, Lift 2 at rest, prioritize Lift 1
        curr_floor_L1 = 3'd2; dest_floor_L1 = 3'd5;
        curr_floor_L2 = 3'd3; dest_floor_L2 = 3'd3;
        req_floor = 3'd4; req_direction = 1'b1;
        #10;
        $display("Test Case 1: selected_lift = %b (Expected: 01)", selected_lift);

        // Test case 4: Lift 1 moving down, Lift 2 moving up, prioritize Lift 2
        curr_floor_L1 = 3'd5; dest_floor_L1 = 3'd1;
        curr_floor_L2 = 3'd2; dest_floor_L2 = 3'd6;
        req_floor = 3'd4; req_direction = 1'b1;
        #10;
        $display("Test Case 2: selected_lift = %b (Expected: 10)", selected_lift);

        // Test case 5: Both lifts moving up, Lift 1 closer
        curr_floor_L1 = 3'd2; dest_floor_L1 = 3'd6;
        curr_floor_L2 = 3'd1; dest_floor_L2 = 3'd5;
        req_floor = 3'd3; req_direction = 1'b1;
        #10;
        $display("Test Case 3: selected_lift = %b (Expected: 10)", selected_lift);

        // Test case 6: Both lifts moving in opposite directions, prioritize Lift 2
        curr_floor_L1 = 3'd5; dest_floor_L1 = 3'd1;
        curr_floor_L2 = 3'd1; dest_floor_L2 = 3'd5;
        req_floor = 3'd4; req_direction = 1'b1;
        #10;
        $display("Test Case 4: selected_lift = %b (Expected: 10)", selected_lift);

        $stop;
    end
endmodule


// `timescale 1ns/1ps

// module tb_priority_controller();
//     // Testbench inputs
//     reg [2:0] curr_floor_L1, curr_floor_L2;
//     reg [2:0] dest_floor_L1, dest_floor_L2;
//     reg [2:0] req_floor;
//     reg req_direction;

//     // Testbench outputs
//     wire [1:0] selected_lift;

//     // Instantiate the priority controller module
//     priority_controller uut (
//         .curr_floor_L1(curr_floor_L1), .curr_floor_L2(curr_floor_L2),
//         .dest_floor_L1(dest_floor_L1), .dest_floor_L2(dest_floor_L2),
//         .req_floor(req_floor), .req_direction(req_direction),
//         .selected_lift(selected_lift)
//     );

//     // Test cases
//     initial begin
//         // Test case 1: Both lifts are at rest, Lift 1 is closer
//         curr_floor_L1 = 3'd2; dest_floor_L1 = 3'd2;
//         curr_floor_L2 = 3'd5; dest_floor_L2 = 3'd5;
//         req_floor = 3'd3; req_direction = 1'b1;
//         #10;
//         $display("Test Case 1: selected_lift = %b (Expected: 01)", selected_lift);

//         // Test case 2: Both lifts are at rest, Lift 2 is closer
//         curr_floor_L1 = 3'd2; dest_floor_L1 = 3'd2;
//         curr_floor_L2 = 3'd3; dest_floor_L2 = 3'd3;
//         req_floor = 3'd4; req_direction = 1'b1;
//         #10;
//         $display("Test Case 2: selected_lift = %b (Expected: 10)", selected_lift);

//         // Test case 3: Lift 1 moving up, Lift 2 at rest, prioritize direction (up)
//         curr_floor_L1 = 3'd1; dest_floor_L1 = 3'd4;
//         curr_floor_L2 = 3'd5; dest_floor_L2 = 3'd5;
//         req_floor = 3'd3; req_direction = 1'b1;
//         #10;
//         $display("Test Case 3: selected_lift = %b (Expected: 01)", selected_lift);

//         // Test case 4: Lift 2 moving up, Lift 1 at rest, prioritize direction (up)
//         curr_floor_L1 = 3'd4; dest_floor_L1 = 3'd4;
//         curr_floor_L2 = 3'd2; dest_floor_L2 = 3'd6;
//         req_floor = 3'd3; req_direction = 1'b1;
//         #10;
//         $display("Test Case 4: selected_lift = %b (Expected: 10)", selected_lift);

//         // Test case 5: Both lifts moving in opposite directions, prioritize direction (down)
//         curr_floor_L1 = 3'd6; dest_floor_L1 = 3'd1;
//         curr_floor_L2 = 3'd2; dest_floor_L2 = 3'd6;
//         req_floor = 3'd4; req_direction = 1'b0;
//         #10;
//         $display("Test Case 5: selected_lift = %b (Expected: 01)", selected_lift);
        
//         $finish;
//     end
// endmodule
