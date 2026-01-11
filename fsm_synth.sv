module fsm_synth(input logic RESETN,
					  input logic ENTER,
					  input logic MATCH,
					  input logic clk,
					  output logic [1:0] OUTPUTS); 
					  
			

	enum int unsigned { OPEN_FROZEN=0, OPEN_FREE=1, LOCKED_FROZEN=2, LOCKED_FREE=3}
	present_state, next_state;
	
	always_comb begin
		case(present_state)
			OPEN_FROZEN: OUTPUTS 	= 2'b00;
			
			OPEN_FREE: OUTPUTS 		= 2'b01;
			
			LOCKED_FROZEN: OUTPUTS 	= 2'b10;
			
			LOCKED_FREE: OUTPUTS 	= 2'b11;
		endcase
	end
	
	always_comb begin
		
		next_state = present_state; 
		
		case (present_state)
			OPEN_FROZEN:
				if(ENTER) next_state = OPEN_FREE;
				
			OPEN_FREE:
				if(~ENTER) next_state = LOCKED_FROZEN;

			LOCKED_FROZEN:
				if(ENTER) next_state = LOCKED_FREE;
				
			LOCKED_FREE: begin
				if(~ENTER && MATCH) next_state = OPEN_FROZEN;
				else if(~ENTER && ~MATCH) next_state = LOCKED_FROZEN;
			end

		endcase
	end

	always_ff @(posedge clk) begin
		if( ~RESETN )
			present_state <= OPEN_FROZEN;
		else
			present_state <= next_state;
	end

				
					  
endmodule