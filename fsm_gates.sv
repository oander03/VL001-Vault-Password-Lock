module fsm_gates(input logic RESETN,
					  input logic ENTER,
					  input logic MATCH,
					  input logic clk,
					  output logic [1:0] OUTPUTS); 
					  
	logic [1:0] present_state;
	logic [1:0] next_state;


					  
	always_comb begin 
    OUTPUTS[0] = present_state[0];
	 OUTPUTS[1] = present_state[1];
	end
	
	always_comb begin
	
		next_state[1] = (~present_state[1] & present_state[0] & ~ENTER) | (present_state[1] & ENTER) | (present_state[1] & ~present_state[0]) | (present_state[0] & ~ENTER & ~MATCH);
			
		next_state[0] = (ENTER);
		 		
	end
					 

	always_ff @(posedge clk) begin
		if( ~RESETN )
			present_state <= 2'b0;
		else
			present_state <= next_state;
	end
	
endmodule