module safe (	input logic MAX10_CLK1_50, 
					input logic [9:0] SW,
					input logic [1:0] KEY,
					output logic [6:0] HEX5,
					output logic [6:0] HEX4,
					output logic [6:0] HEX3,
					output logic [6:0] HEX2,
					output logic [6:0] HEX1,
					output logic [6:0] HEX0,
					output logic [9:0] LEDR );

					
	fsm_gates u1 (
		.RESETN(KEY[0]),
		.ENTER(KEY[1]),
		.MATCH(match),
		.clk(MAX10_CLK1_50),
		.OUTPUTS(present_state)
	);
					
	localparam logic [47:0] OPEN = 48'hF7_C0_8C_86_AB_F7;
	localparam logic [47:0] LOCKED = 48'hC7_C0_C6_89_86_C0;
	logic [47:0] hex;
	
	assign HEX5 = hex[46:40];
   assign HEX4 = hex[38:32];
   assign HEX3 = hex[30:24];
   assign HEX2 = hex[22:16]; 
   assign HEX1 = hex[14:8]; 
   assign HEX0 = hex[6:0];
	
	logic [9:0] savePW;
	logic [9:0] next_savePW;
	logic [9:0] saveAT;
	logic [9:0] next_saveAT;
	logic [1:0] present_state;
	
	logic [3:0] wrong_count;
	assign LEDR[9:8] = present_state;
	assign LEDR[3:0] = (present_state > 2'b01) ? wrong_count : 4'b0;
	assign LEDR[7:4] = 6'b0;
	//assign LEDR[7] = match;
	
	logic [9:0] wrong_bits;
	assign wrong_bits = savePW ^ next_saveAT;
	
	assign wrong_count = wrong_bits[0] + wrong_bits[1] + wrong_bits[2] + 
								wrong_bits[3] + wrong_bits[4] + wrong_bits[5] +
								wrong_bits[6] + wrong_bits[7] + wrong_bits[8] +
								wrong_bits[9];
								
	assign match = ((savePW ^ saveAT) == 0) ? 1 : 0;
	
	always_ff @(posedge MAX10_CLK1_50) begin
		if (~KEY[0]) begin
			savePW <= 10'b0;
			saveAT <= 10'b1;
		end
		if (~KEY[1]) begin
			next_saveAT <= SW;
		end
		else begin
			savePW <= next_savePW; 
			saveAT <= SW;
		end
	end
	
	
	always_comb begin
	
		hex = '0;
		next_savePW = savePW;
		
		if(present_state == 'b00) begin
			hex = OPEN;
		end
		else if(present_state == 'b01) begin
			hex = OPEN;
			next_savePW = saveAT;
		end
		else if(present_state == 'b10) begin
			hex = LOCKED;
		end
		else if(present_state == 'b11) begin
			hex = LOCKED;
		end
		
	end

endmodule