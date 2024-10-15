module testbench();
    reg clk, reset;
    reg [2:0] curr_floor_L1, curr_floor_L2, dest_floor_L1, dest_floor_L2, req_floor;
    reg req_direction;
    wire [1:0] selected_lift;

    // Instantiate the elevator controller
    elevator_controller ec (
        .clk(clk), .reset(reset),
        .curr_floor_L1(curr_floor_L1), .curr_floor_L2(curr_floor_L2),
        .dest_floor_L1(dest_floor_L1), .dest_floor_L2(dest_floor_L2),
        .req_floor(req_floor), .req_direction(req_direction),
        .selected_lift(selected_lift)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10-unit time period

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        #10 reset = 0;  


        // Test cases
        curr_floor_L1 = 3'd5; curr_floor_L2 = 3'd7;
        dest_floor_L1 = 3'd2; dest_floor_L2 = 3'd6;
        req_floor = 3'd3; req_direction = 1'b0;

        #20;
        curr_floor_L1 = 3'd5; curr_floor_L2 = 3'd1;
        dest_floor_L1 = 3'd0; dest_floor_L2 = 3'd2;
        req_floor = 3'd3; req_direction = 1'b1;

        #30;
        curr_floor_L1 = 3'd1; curr_floor_L2 = 3'd2;
        dest_floor_L1 = 3'd6; dest_floor_L2 = 3'd7;
        req_floor = 3'd5; req_direction = 1'b1;

        #40;
        curr_floor_L1 = 3'd1; curr_floor_L2 = 3'd7;
        dest_floor_L1 = 3'd3; dest_floor_L2 = 3'd3;
        req_floor = 3'd5; req_direction = 1'b1;

        #50;
        curr_floor_L1 = 3'd2; curr_floor_L2 = 3'd1;
        dest_floor_L1 = 3'd5; dest_floor_L2 = 3'd6;
        req_floor = 3'd7; req_direction = 1'b0;

        #60;
        curr_floor_L1 = 3'd4; curr_floor_L2 = 3'd2;
        dest_floor_L1 = 3'd7; dest_floor_L2 = 3'd0;
        req_floor = 3'd4; req_direction = 1'b0;

        #70;
        curr_floor_L1 = 3'd5; curr_floor_L2 = 3'd3;
        dest_floor_L1 = 3'd2; dest_floor_L2 = 3'd1;
        req_floor = 3'd5; req_direction = 1'b1;

        #80;
        $stop;
    end
    initial begin
        $display("time | l1  l1_md | l2  l2_md  | req_floor  req_dirn  |  assigned_lift");
        $monitor("%3d  |  %b  %b |  %b  %b  |  %b        %b        | %b ",$time,curr_floor_L1,dest_floor_L1, curr_floor_L2, dest_floor_L2, req_floor,req_direction,selected_lift);
    end




endmodule
