module servo_PWM (clk, pos, servo_pulse);
	input clk;
	input[7:0] pos;
	output reg servo_pulse;
	reg [19:0] counter;
	reg [7:0] test;

	parameter CLOCK_DIVIDER = 196;
	
	always @ (posedge clk)
		begin
			counter <= counter + 1;
			test[7:0] <= pos[7:0];
			if (counter <= (test[7:0] * CLOCK_DIVIDER) + 50000) servo_pulse <= 1;
			else servo_pulse <= 0;
			if (counter >= 1000000) counter <= 0;
		end
		
endmodule