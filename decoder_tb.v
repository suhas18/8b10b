// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
module decoder_tb;

reg [9:0] data_i;
reg enable_i;
wire [7:0] out8b_o;
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
      $monitor("input=%b, pop_h=%b, pop_l=%b, output=%b", data_i, pop_h, pop_l, out8b_o);
    #5 enable_i = 1;
//3,2
    #5 data_i = 10'b00111_00110; //simple, simple
    #5 data_i = 10'b11010_01010; //8,simple
    #5 data_i = 10'b11010_10100; //8,8
    #5 data_i = 10'b10101_10100; //simple,8
	#5 data_i = 10'b11100_10010; //9,simple
    #5 data_i = 10'b11100_11000; //9,9
    #5 data_i = 10'b01110_11000; //simple,9     
//2,3
    #5 data_i = 10'b00110_10011; //simple,simple
    #5 $finish;
     
    end
          
endmodule
