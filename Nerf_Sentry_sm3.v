module Nerf_Sentry_sm3(clock, uart, recieved, reset, pos, fire);
	input clock;
	input [7:0] uart;
	input recieved;
	input reset;
	output reg [7:0] pos;
	output reg fire;
	reg [4:0] state;
	reg [7:0] fireReg;
	reg [7:0] x100, x010, x001;
	
	parameter IDLE = 5'b00000,
			    X100 = 5'b00001,
				 X010 = 5'b00010,
				 X001 = 5'b00011,
			    Y100 = 5'b00100,
				 Y010 = 5'b00101,
				 Y001 = 5'b00110,
				 FIRE = 5'b00111,
				 FIRESEL = 5'b01000,
				 SCANSEL = 5'b01001,
				 //Buffer States
				 BIDLE = 5'b01011,
			    BX100 = 5'b01100,
				 BX010 = 5'b01101,
				 BX001 = 5'b01110,
			    BY100 = 5'b01111,
				 BY010 = 5'b10000,
				 BY001 = 5'b10001,
				 BFIRE = 5'b10010,
				 BFIRESEL = 5'b10011,
				 BSCANSEL = 5'b10100;
	
	//State Control Function
	always @ (posedge clock)
		begin
			case(state)
				BIDLE: 
					begin
						if (recieved == 1)
							state <= BIDLE;
						else
							state <= IDLE;
					end
				IDLE: //Check to see if the trigger char is sent 'a'
					begin
						if (recieved == 1)
							begin
								if (uart[7:0] == 8'b01100001)
									state <= BX100;
								else
									state <= IDLE;
							end
					end
				BX100:
					begin
						if (recieved == 1)
							state <= BX100;
						else
							state <= X100;
					end
				X100: ///
					begin
						if (recieved == 1)
							state <= BX010;
						else
							state <= X100;
					end
				BX010:
					begin
						if (recieved == 1)
							state <= BX010;
						else
							state <= X010;
					end
				X010:
					begin
						if (recieved == 1)
							state <= BX001;
						else
							state <= X010;
					end
				BX001:
					begin
						if (recieved == 1)
							state <= BX001;
						else
							state <= X001;
					end
				X001: 
					begin
						if (recieved == 1)
							state <= BY100;
						else
							state <= X001;
					end
				BY100:
					begin
						if (recieved == 1)
							state <= BY100;
						else
							state <= Y100;
					end
				Y100: 
					begin
						if (recieved == 1)
							state <= BY010;
						else
							state <= Y100;
					end
				BY010:
					begin
						if (recieved == 1)
							state <= BY010;
						else
							state <= Y010;
					end
				Y010: 
					begin
						if (recieved == 1)
							state <= BY001;
						else
							state <= Y010;
					end
				BY001:
					begin
						if (recieved == 1)
							state <= BY001;
						else
							state <= Y001;
					end
				Y001:
					begin
						if (recieved == 1)
							state <= BFIRE;
						else
							state <= Y001;
					end
				BFIRE:
					begin
						if (recieved == 1)
							state <= BFIRE;
						else
							state <= FIRE;
					end
				FIRE:
					begin
						if (recieved == 1)
							state <= BFIRESEL;
						else
							state <= FIRE;
					end
				BFIRESEL:
					begin
						if (recieved == 1)
							state <= BFIRESEL;
						else
							state <= FIRESEL;
					end
				FIRESEL:
					begin
						if (recieved == 1)
							state <= BSCANSEL;
						else
							state <= FIRESEL;
					end
				BSCANSEL:
					begin
						if (recieved == 1)
							state <= BSCANSEL;
						else
							state <= SCANSEL;
					end
				SCANSEL: 
					begin
						if (recieved == 1)
							state <= BIDLE;
						else
							state <= SCANSEL;
					end
				default: ;//state <= IDLE;
			endcase
		end
	
	//State Output Function
	always @ (posedge clock)
		begin
			case(state)
				IDLE: 
				begin
					pos[7:0] <= ((x100 - 8'b00110000) * 8'b01100100) + ((x010 - 8'b00110000) * 8'b00001010) + (x001 - 8'b00110000);
					fire <= fireReg[0];
				end
				X100: x100[7:0] <= uart[7:0];
				X010: x010[7:0] <= uart[7:0];
				X001: x001[7:0] <= uart[7:0];
				FIRE: fireReg[7:0] <= uart[7:0];
				default: ;
			endcase
			
		end

endmodule