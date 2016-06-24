// Code your design here
module encoder_8b10b(
    input [7:0] data_i,
    input enable_i,
    input valid_i,
    output [9:0] out10b_o
    );

/*    
    reg [4:0] h3_0 = 5'b00111;
    reg [4:0] h3_1 = 5'b01011;
    reg [4:0] h3_2 = 5'b01101;
    reg [4:0] h3_3 = 5'b01110;
    reg [4:0] h3_4 = 5'b10011;
    reg [4:0] h3_5 = 5'b10101;
    reg [4:0] h3_6 = 5'b10110;
    reg [4:0] h3_7 = 5'b11001;
	reg [4:0] h3_8 = 5'b11010;
	reg [4:0] h3_9 = 5'b11100;
	
	reg [4:0] h2_0 = 5'b00011;
    reg [4:0] h2_1 = 5'b00101;
    reg [4:0] h2_2 = 5'b00110;
    reg [4:0] h2_3 = 5'b01010;
    reg [4:0] h2_4 = 5'b01100;
    reg [4:0] h2_5 = 5'b01001;
    reg [4:0] h2_6 = 5'b10001;
    reg [4:0] h2_7 = 5'b10010;
	reg [4:0] h2_8 = 5'b10100;
	reg [4:0] h2_9 = 5'b11000;
	
	reg [4:0] h4_0 = 5'b11110;
	reg [4:0] h4_1 = 5'b11101;
	reg [4:0] h4_2 = 5'b11011;
	reg [4:0] h4_3 = 5'b10111;
	reg [4:0] h4_4 = 5'b11110;

    reg [4:0] h1_0 = 5'b00001;
	reg [4:0] h1_1 = 5'b00010;
	reg [4:0] h1_2 = 5'b00100;
	reg [4:0] h1_3 = 5'b01000;
	reg [4:0] h1_4 = 5'b10000;
*/
  
  //in these 2 bit selectors, [1] is active if choosing that module, [0] if that module has to output to MSB
  reg  h3_unbalance_selector = 0;
  reg [1:0] h3_selector = 0; 
  reg [1:0] h2_selector = 0; 
  reg [1:0] h4_selector = 0; 
  reg [1:0] h1_selector = 0; 
  
  reg [3:0] h3u_data_forward_lsb;
  reg [3:0] h3u_data_forward_msb;
  
  reg [3:0] h3_data_forward;
  reg [3:0] h2_data_forward;
  reg [2:0] h4_data_forward;
  reg [2:0] h1_data_forward;
	
    //define all the table values in reg. Construct case statements for encoding
    
    always @(*)
    begin
   	 if (enable_i ==1)
    	begin
    		casez({valid_i, data_i})
    		//TODO handle all valid=0 cases
    		9'b0_00_??????:  begin
    							h3_unbalance_selector = 1;
    							h3u_data_forward_lsb = data_i[2:0];
    							h3u_data_forward_msb = data_i[5:3];
    						 end //64 unbalanced control cases
    		9'b0_1000_0000: begin
    							h3_selector = 2'b10;
    							h2_selector = 2'b11;
    							h3_data_forward = 4'b1000;
    							h2_data_forward = 4'b1000;    		
    						end //no data case, balanced
    		9'b1_00_?????? : begin
    							h3_selector = 2'b11;
    							h2_selector = 2'b10;
    							h3_data_forward = data_i[5:3];
    							h2_data_forward = data_i[2:0];
    						 end //64 cases
            9'b1_01_?????? : begin
            					h3_selector = 2'b10;
    							h2_selector = 2'b11;
    							h3_data_forward = data_i[2:0];
    							h2_data_forward = data_i[5:3];
    						 end //64 cases
    		9'b1_10_00_???? : begin
    							h3_selector = 2'b11;
    							h2_selector = 2'b10;
    							h3_data_forward = {3'b100,data_i[3]};
    							h2_data_forward = data_i[2:0];
    						  end //16 cases
    		9'b1_10_01_???? : begin
    							h3_selector = 2'b10;
    							h2_selector = 2'b11;
    							h2_data_forward = {3'b100,data_i[3]};
    							h3_data_forward = data_i[2:0];
    						  end //16 cases
    		9'b1_10_10_???? : begin
    							h3_selector = 2'b11;
    							h2_selector = 2'b10;
    							h2_data_forward = {3'b100,data_i[3]};
    							h3_data_forward = data_i[2:0];
    						  end //16 cases
    		9'b1_10_11_???? : begin
    							h3_selector = 2'b10;
    							h2_selector = 2'b11;
    							h3_data_forward = {3'b100,data_i[3]};
    							h2_data_forward = data_i[2:0];
    						  end //16 cases
    		9'b1_11_00_???? : begin
    							h4_selector = 2'b11;
    							h1_selector = 2'b10;
    							h4_data_forward = data_i[3:2];
    							h1_data_forward = data_i[1:0];
    						  end //16 cases
    		9'b1_11_01_???? : begin
    							h4_selector = 2'b10;
    							h1_selector = 2'b11;
    							h1_data_forward = data_i[3:2];
    							h4_data_forward = data_i[1:0];
    						  end //16 cases
    		9'b1_11_10_00_?? : begin
    							h4_selector = 2'b11;
    							h1_selector = 2'b10;
    							h4_data_forward = 3'b100;
    							h1_data_forward = data_i[1:0];
    						   end //4 cases
    		9'b1_11_10_01_?? : begin
    							h4_selector = 2'b10;
    							h1_selector = 2'b11;
    							h1_data_forward = 3'b100;
    							h4_data_forward = data_i[1:0];
    						   end //4 cases
    		9'b1_11_10_10_?? : begin
    							h4_selector = 2'b11;
    							h1_selector = 2'b10;
    							h1_data_forward = 3'b100;
    							h4_data_forward = data_i[1:0];
    						   end //4 cases
    		9'b1_11_10_11_?? : begin
    							h4_selector = 2'b10;
    							h1_selector = 2'b11;
    							h4_data_forward = 3'b100;
    							h1_data_forward = data_i[1:0];
    						   end //4 cases
    		9'b1_11_11_00_?? : begin
    							h3_selector = 2'b11;
    							h2_selector = 2'b10;
    							h3_data_forward = {3'b100,data_i[1]};
    							h2_data_forward = {3'b100,data_i[0]};
    						   end //4 cases
    		9'b1_11_11_01_0?: begin
    							h3_selector = 2'b10;
    							h2_selector = 2'b11;
    							h3_data_forward = {3'b100,data_i[0]};
    							h2_data_forward = 4'b1001;
    						   end //2 cases
    		//individual cases					
    		9'b1_11_11_01_10: begin
    							h4_selector = 2'b11;
    							h1_selector = 2'b10;
    							h4_data_forward = 3'b100;
    							h1_data_forward = 3'b100;
    						   end //1 case
    		9'b1_11_11_01_11: begin
    							h4_selector = 2'b10;
    							h1_selector = 2'b11;
    							h4_data_forward = 3'b100;
    							h1_data_forward = 3'b100;
    						   end //1 case
    		
    		//8 unbalanced cases
    		9'b1_11_11_1_??? : begin
    							h3_unbalance_selector = 1;
    							h3u_data_forward_lsb = data_i[2:0];
    							h3u_data_forward_msb = 4'b1000;
    						   end //8 unbalanced cases
    		default: 		  begin
    							h3_unbalance_selector = 0;
    							h3_selector = 0;
    							h2_selector = 0;
    							h4_selector = 0;
    							h1_selector = 0;
    						  end
    		
    		endcase
    
   	 	end
    end
  return_h3 h3 (.selector_i(h3_selector),
  				.index_i(h3_data_forward),
                .h3_out(out10b_o[9:0]));
  return_h2 h2 (.selector_i(h2_selector),
  				.index_i(h2_data_forward),
                .h2_out(out10b_o[9:0])); 
  return_h4 h4 (.selector_i(h4_selector),
  				.index_i(h4_data_forward),
                .h4_out(out10b_o[9:0])); 
  return_h1 h1 (.selector_i(h1_selector),
  				.index_i(h1_data_forward),
                .h1_out(out10b_o[9:0]));
                
  return_unbalance_h3 h3u_MSB (
  				.selector_i(h3_unbalance_selector),
  				.index_i(h3u_data_forward_msb),
  				.h3_out(out10b_o[9:5])
				);
  return_unbalance_h3 h3u_LSB (
  				.selector_i(h3_unbalance_selector),
  				.index_i(h3u_data_forward_lsb),
  				.h3_out(out10b_o[4:0])
				); 
                
                
endmodule

module return_h3(
  				input [1:0]selector_i,
  				input [3:0] index_i,
  				output [9:0] h3_out
				);
  	reg [9:0] h3_out;			
	
	reg [4:0] h3_0 = 5'b00111;
    reg [4:0] h3_1 = 5'b01011;
    reg [4:0] h3_2 = 5'b01101;
    reg [4:0] h3_3 = 5'b01110;
    reg [4:0] h3_4 = 5'b10011;
    reg [4:0] h3_5 = 5'b10101;
    reg [4:0] h3_6 = 5'b10110;
    reg [4:0] h3_7 = 5'b11001;
	reg [4:0] h3_8 = 5'b11010;
	reg [4:0] h3_9 = 5'b11100;
	
	always @(*)
	begin
      if(selector_i[1])
      begin
        if(selector_i[0])
          begin
            
			case(index_i)
			0: h3_out = 10'b00111_?????;
			1: h3_out = 10'b01011_?????;
			2: h3_out = 10'b01101_?????;
			3: h3_out = 10'b01110_?????;
			4: h3_out = 10'b10011_?????;
			5: h3_out = 10'b10101_?????;
			6: h3_out = 10'b10110_?????;
			7: h3_out = 10'b11001_?????;
			8: h3_out = 10'b11010_?????;
			9: h3_out = 10'b11100_?????;
			default: h3_out = 10'b?;
			endcase
		   end 
		 else
		 begin
		 	case(index_i)
			0: h3_out = 10'b?????_00111;
			1: h3_out = 10'b?????_01011;
			2: h3_out = 10'b?????_01101;
			3: h3_out = 10'b?????_01110;
			4: h3_out = 10'b?????_10011;
			5: h3_out = 10'b?????_10101;
			6: h3_out = 10'b?????_10110;
			7: h3_out = 10'b?????_11001;
			8: h3_out = 10'b?????_11010;
			9: h3_out = 10'b?????_11100;
			default: h3_out = 10'b?;
			endcase
		 end //end else
	end //end if (selected)
	else 
		h3_out = 10'b?;
//      $display("in h3 input is %b", index_i);
//  	  $display("in h3 output is %b", h3_out);
      
	end //end always
  
				
endmodule
                
        
module return_h2(
				input [1:0] selector_i,
			    input [3:0] index_i,
  				output [9:0] h2_out
				);
  	reg [9:0] h2_out;			
	
	always @(*)
	begin
	if(selector_i[1])
	begin
		if(selector_i[0])
		begin
			case(index_i)
			0: h2_out = 10'b00011_?????;
			1: h2_out = 10'b00101_?????;
			2: h2_out = 10'b00110_?????;
			3: h2_out = 10'b01010_?????;
			4: h2_out = 10'b01100_?????;
			5: h2_out = 10'b01001_?????;
			6: h2_out = 10'b10001_?????;
			7: h2_out = 10'b10010_?????;
			8: h2_out = 10'b10100_?????;
			9: h2_out = 10'b11000_?????;
			default: h2_out = 10'b?;
			endcase
		end
		else
		begin
			case(index_i)
			0: h2_out = 10'b?????_00011;
			1: h2_out = 10'b?????_00101;
			2: h2_out = 10'b?????_00110;
			3: h2_out = 10'b?????_01010;
			4: h2_out = 10'b?????_01100;
			5: h2_out = 10'b?????_01001;
			6: h2_out = 10'b?????_10001;
			7: h2_out = 10'b?????_10010;
			8: h2_out = 10'b?????_10100;
			9: h2_out = 10'b?????_11000;
			default: h2_out = 10'b?;
			endcase
		
		end //end else
//      $display("in h2 input is %b", index_i);
//  	  $display("in h2 output is %b", h2_out);
	end //end if(selected)
	else 
		h2_out = 10'b?;
  	end //end always
				
endmodule

module return_h4(
				input [1:0] selector_i,
			    input [2:0] index_i,
  				output [9:0] h4_out
				);
  	reg [9:0] h4_out;			
	
	always @(*)
	begin
	if(selector_i[1])
	begin
		if(selector_i[0])
		begin
			case(index_i)
			0: h4_out = 10'b11110_?????;
			1: h4_out = 10'b11101_?????;
			2: h4_out = 10'b11011_?????;
			3: h4_out = 10'b10111_?????;
			4: h4_out = 10'b11110_?????;
			default: h4_out = 10'b?;
			endcase
		end
		else
		begin
			case(index_i)
			0: h4_out = 10'b?????_11110;
			1: h4_out = 10'b?????_11101;
			2: h4_out = 10'b?????_11011;
			3: h4_out = 10'b?????_10111;
			4: h4_out = 10'b?????_11110;
			default: h4_out = 10'b?;
			endcase
		
		end //end else
	end //end if(selected)
	else 
		h4_out = 10'b?;
  	end //end always
				
endmodule 

module return_h1(
				input [1:0] selector_i,
			    input [2:0] index_i,
  				output [9:0] h1_out
				);
  	reg [9:0] h1_out;			
	
	reg [4:0] h1_0 = 5'b00001;
	reg [4:0] h1_1 = 5'b00010;
	reg [4:0] h1_2 = 5'b00100;
	reg [4:0] h1_3 = 5'b01000;
	reg [4:0] h1_4 = 5'b10000;
	
	always @(*)
	begin
	if(selector_i[1])
	begin
		if(selector_i[0])
		begin
			case(index_i)
			0: h1_out = 10'b00001_?????;
			1: h1_out = 10'b00010_?????;
			2: h1_out = 10'b00100_?????;
			3: h1_out = 10'b01000_?????;
			4: h1_out = 10'b10000_?????;
			default: h1_out = 10'b?;
			endcase
		end
		else
		begin
			case(index_i)
			0: h1_out = 10'b?????_00001;
			1: h1_out = 10'b?????_00010;
			2: h1_out = 10'b?????_00100;
			3: h1_out = 10'b?????_01000;
			4: h1_out = 10'b?????_10000;
			default: h1_out = 10'b?;
			endcase
		
		end //end else
	end //end if(selected)
	else 
		h1_out = 10'b?;
  	end //end always
				
endmodule     

//alternate implementation methods: Do MSB LSB separately as done for unbalanced case for balance case also.                     

module return_unbalance_h3(
  				input selector_i,
  				input [3:0] index_i,
  				output [4:0] h3_out
				);
  	reg [4:0] h3_out;			
	
	always @(*)
	begin
      if(selector_i)
      begin
            
			case(index_i)
			0: h3_out = 5'b00111;
			1: h3_out = 5'b01011;
			2: h3_out = 5'b01101;
			3: h3_out = 5'b01110;
			4: h3_out = 5'b10011;
			5: h3_out = 5'b10101;
			6: h3_out = 5'b10110;
			7: h3_out = 5'b11001;
			8: h3_out = 5'b11010;
			9: h3_out = 5'b11100;
			default: h3_out = 5'b?;
			endcase
		    
	  end //end if (selected)
	  else  
	  		h3_out = 5'b?;    
	end //end always
  	
endmodule

//alternate implementation methods: Do MSB LSB separately as done for unbalanced case for balance case also.                     