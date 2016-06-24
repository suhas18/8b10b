// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
module decoder_tb;

reg [9:0] data_i;
reg enable_i;
wire [9:0] out8b_o;
wire [2:0] pop_h;
wire [2:0] pop_l;

decoder dec0 (   .data_i(data_i),
            	 .enable_i(enable_i),
              	 .out8b_o(out8b_o),
            	 .pop_h(pop_h),
            	 .pop_l(pop_l)
                    );     
    initial
    begin
       data_i = 0;
       enable_i = 0;
    $monitor("input=%b, pop_h=%b, pop_l=%b", data_i, pop_h, pop_l);
    #5 enable_i = 1;
    #5 data_i = 10'b00000_00001;
    #5 data_i = 10'b00001_00000; 
    #5 data_i = 10'b10000_11000; 
    #5 data_i = 10'b01111_10100; 
    #5 data_i = 10'b10100_10001; 
    #5 data_i = 10'b00000_00000; 
    #5 $finish;
     
    end
          
endmodule
