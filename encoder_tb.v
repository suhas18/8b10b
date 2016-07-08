// Code your testbench here
// or browse Examples
module encoder_tb;

reg [7:0] data_i;
reg enable_i;
reg valid_i;
wire [9:0] out10b_o;

encoder_8b10b enc0 (   .data_i(data_i),
                       .enable_i(enable_i),
                       .valid_i(valid_i),
                       .out10b_o(out10b_o) 
                    );     
    initial
    begin
       data_i = 0;
       enable_i = 0;
       valid_i = 0;
   
    #10 enable_i = 1;
    #15 valid_i = 1;
    #5 valid_i = 0;
      $monitor("valid: %b output for input %b is %b",valid_i, data_i, out10b_o);
    #5 valid_i = 1;
    #15 data_i = 8'b0000_0001;
    #5 data_i = 8'b0000_1001; 
    #5 data_i = 8'b1000_1010; 
    #5 data_i = 8'b1000_0111; 
    #5 data_i = 8'b1111_0110; 
    #5 data_i = 8'b1111_0010;
//    #5 valid_i = 0;
    #5 data_i = 8'b0110_1010;
     #5 data_i = 8'b1001_1111;
      
     #5 data_i = 8'b1100_0000; //11110_00001
     #5 data_i = 8'b1101_0000; //00001_11110
     #5 data_i = 8'b1110_0010; //01111_00100
     #5 data_i = 8'b1110_0111; //10000_10111
     #5 data_i = 8'b1110_1001; //11101_10000
	 #5 data_i = 8'b1110_1000; //11110_10000
     #1 valid_i = 0;
     #5 data_i = 8'b1000_0000;
    #5 $finish;
     
    end
          
endmodule
