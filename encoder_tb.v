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
    #15 data_i = 8'b0000_0001;
	#1 $display("output is %b",out10b_o);
    #5 data_i = 8'b0000_1001; 
    #1 $display("output is %b",out10b_o);
    #5 data_i = 8'b0000_1000; 
    #1 $display("output is %b",out10b_o);
    #5 data_i = 8'b0100_1000; 
    #1 $display("output is %b",out10b_o);
    #5 data_i = 8'b1000_1000; 
    #1 $display("output is %b",out10b_o);  
    #5 data_i = 8'b1011_1000; 
    #1 $display("output is %b",out10b_o);
    #5 $finish;
     
    end
          
endmodule
