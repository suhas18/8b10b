module encoder_8b10b(
    input [7:0] data_i,
    input enable_i,
    input valid_i,
    output [9:0] out10b_o
    );

	reg [4:0] h3_msb;
	reg [4:0] h3_lsb;
	reg [4:0] h2_msb;
	reg [4:0] h2_lsb;
	reg [4:0] h4_msb;
	reg [4:0] h4_lsb;
	reg [4:0] h1_msb;
	reg [4:0] h1_lsb;
	
	reg [9:0] out10b;
	
	
	h3_encode h3_upper (.i(data_i[5:3]),
						.o(h3_msb)	);
	h3_encode h3_lower (.i(data_i[2:0]),
						.o(h3_lsb)	);
	h2_encode h2_upper (.i(data_i[5:3]),
						.o(h2_msb)	);
	h2_encode h2_lower (.i(data_i[2:0]),
						.o(h2_lsb)	);
	
	h4_encode h4_upper (.i(data_i[3:2]),
						.o(h4_msb)	);
	h4_encode h4_lower (.i(data_i[1:0]),
						.o(h4_lsb)	);
	h1_encode h1_upper (.i(data_i[3:2]),
						.o(h1_msb)	);
	h1_encode h1_lower (.i(data_i[1:0]),
						.o(h1_lsb)	);
						
    always @(*)
    begin
   	 if (enable_i ==1)
    	begin
    		casez({valid_i, data_i})
    		//TODO handle all valid=0 cases
    		9'b0_00_??????:  begin
    							out10b = {h3_msb,h3_lsb};
    						 end //64 unbalanced control cases
    		9'b0_1000_0000: begin
    							out10b = {5'b10100,5'b11010};    		
    						end //no data case, balanced
    		9'b1_00_?????? : begin
    							out10b = {h3_msb,h2_lsb};
    						 end //64 cases
            9'b1_01_?????? : begin
            					out10b = {h2_msb,h3_lsb};
    						 end //64 cases
    		9'b1_10_00_???? : begin
    							if(data_i[3])
    								out10b = {5'b11100,h2_lsb};
    							else
    								out10b = {5'b11010,h2_lsb};
    						  end //16 cases
    		9'b1_10_01_???? : begin
    							if(data_i[3])
    								out10b = {5'b11000,h3_lsb};
    							else
    								out10b = {5'b10100,h3_lsb};
    						  end //16 cases
    		9'b1_10_10_???? : begin
    							if(data_i[3])
    								out10b = {h3_lsb,5'b11000};
    							else
    								out10b = {h3_lsb,5'b10100};
    						  end //16 cases
    		9'b1_10_11_???? : begin
    							if(data_i[3])
    								out10b = {h2_lsb,5'b11100};
    							else
    								out10b = {h2_lsb,5'b11010};
    						  end //16 cases
    		9'b1_11_00_???? : begin
    							out10b = {h4_msb,h1_lsb};
    						  end //16 cases
    		9'b1_11_01_???? : begin
    							out10b = {h1_msb,h4_lsb};
    						  end //16 cases
    		9'b1_11_10_00_?? : begin
    							out10b = {5'b01111,h1_lsb};
    						   end //4 cases
    		9'b1_11_10_01_?? : begin
    							out10b = {5'b10000,h4_lsb};
    						   end //4 cases
    		9'b1_11_10_10_?? : begin
    							out10b = {h4_lsb,5'b10000};
    						   end //4 cases
    		9'b1_11_10_11_?? : begin
    							out10b = {h1_lsb,5'b01111};
    						   end //4 cases
    		9'b1_11_11_00_?? : begin
    							if(data_i[1])
    							begin
    								if(data_i[0])
    									out10b={5'b11100,5'b11000}; //{h3(9),h2(9)}
    								else
    									out10b={5'b11100,5'b10100};//{h3(9),h2(8)};
    							end
    							else
    							begin
    								if(data_i[0])
    									out10b={5'b11010,5'b11000};//{h3(8),h2(9)};
    								else
    									out10b={5'b11010,5'b10100};//{h3(8),h2(8)};
    							end
    						   end //4 cases
    		9'b1_11_11_01_0?: begin
    							if(data_i[0])
    								out10b = {5'b11000,5'b11100};//{h2(9),h3(9)}
    							else
    								out10b = {5'b11000,5'b11010}; //{h2(9),h3(8)}
    						   end //2 cases
    		//individual cases					
    		9'b1_11_11_01_10: begin
    							out10b = {5'b01111,5'b10000}; //{h4(4),h1(4)}
    						   end //1 case
    		9'b1_11_11_01_11: begin
    							out10b = {5'b10000,5'b01111}; //{h1(4),h4(4)}
    						   end //1 case
    		
    		//8 unbalanced cases
    		9'b1_11_11_1_??? : begin
    							out10b = {5'b11010,h3_lsb};
    						   end //8 unbalanced cases
    		default: 		  begin
    							$display("Error in encoder. 8 bit input not mapped");
    						  end
    		
    		endcase
    
   	 	end //if enabled
    end //always block               
    assign out10b_o = out10b;            
endmodule


module h3_encode (
					input [2:0] i,
					output [4:0] o
					);
	reg [4:0] out;
	always @(*)
		begin
			case(i)
			0: out = 5'b00111;
			1: out = 5'b01011;
			2: out = 5'b01101;
			3: out = 5'b01110;
			4: out = 5'b10011;
			5: out = 5'b10101;
			6: out = 5'b10110;
			7: out = 5'b11001;
			8: out = 5'b11010;
			9: out = 5'b11100;
			default: out = 5'b?; //what should the default output be?
			endcase  
		end //end always
	assign o = out;					
					
endmodule

module h2_encode (
					input [2:0] i,
					output [4:0] o
					);
	reg [4:0] out;
	always @(*)
		begin
			case(i)
			0: out = 5'b00011;
			1: out = 5'b00101;
			2: out = 5'b00110;
			3: out = 5'b01010;
			4: out = 5'b01100;
			5: out = 5'b01001;
			6: out = 5'b10001;
			7: out = 5'b10010;
			8: out = 5'b10100;
			9: out = 5'b11000;
			default: out = 5'b?;
			endcase  
		end //end always
	assign o = out;					
					
endmodule   
        
module h4_encode (
					input [1:0] i,
					output [4:0] o
					);
	reg [4:0] out;
	always @(*)
		begin
			case(i)
			0: out = 5'b11110;
			1: out = 5'b11101;
			2: out = 5'b11011;
			3: out = 5'b10111;
			4: out = 5'b01111;
			default: out = 5'b?;
			endcase  
		end //end always
	assign o = out;					
					
endmodule 

module h1_encode (
					input [1:0] i,
					output [4:0] o
					);
	reg [4:0] out;
	always @(*)
		begin
			case(i)
			0: out = 5'b00001;
			1: out = 5'b00010;
			2: out = 5'b00100;
			3: out = 5'b01000;
			4: out = 5'b10000;
			default: out = 5'b?;
			endcase  
		end //end always
	assign o = out;					
					
endmodule 