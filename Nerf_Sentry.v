module Nerf_Sentry(CLOCK_50, uart_RX, reset, servo_PWM, fire_pin, LED);
	input CLOCK_50;
	input uart_RX;
	input reset;
	output servo_PWM;
	output fire_pin;
	output [7:0] LED;
	wire uart_recieved;
	wire [7:0] uart_byte;
	wire [7:0] servo_pos;
	
	uart uart_1(CLOCK_50, , uart_RX, , , , uart_recieved, uart_byte, , , );
	Nerf_Sentry_sm3 Nerf_Sentry_sm_1(CLOCK_50, uart_byte, uart_recieved, , servo_pos, fire_pin);
	servo_PWM servo_PWM_1(CLOCK_50, servo_pos, servo_PWM);

endmodule