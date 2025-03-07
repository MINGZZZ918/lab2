module collatz(
    input  logic         clk,   // Clock
    input  logic         go,    // Load value from n; start iterating
    input  logic [31:0]  n,     // Start value; only read when go = 1
    output logic [31:0]  dout,  // Iteration value: true after go = 1
    output logic         done   // True when dout reaches 1
);

   always_ff @(posedge clk) begin
      if (go == 1) begin
         dout <= n;
         done <= (dout == 1);
		
      end else if (!done) begin
			logic [31:0] temp;
         if (dout[0] == 0) begin    // Even case
            temp = dout >> 1;      	// temp = dout/2
				
         end else begin
            temp = 3 * dout + 1;   	// Odd case
         end
			dout <= temp;
         done <= (temp == 1);      	// done = 1 if temp == 1
			
      end
   end

endmodule
