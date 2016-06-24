//include bsg_popcount.v in this file

module decoder(
				input [9:0] data_i,
				input enable_i,
  				output [7:0] out8b_o,
				output [2:0] pop_h,
				output [2:0] pop_l
				);
				
//reg [2:0] pop_h, pop_l;

reg [3:0] h3_msb;
reg [3:0] h3_lsb;
reg [3:0] h2_msb;
reg [3:0] h2_lsb;
reg [7:0] out8b;

h3_decode h3_upper (.in5_i(data_i[9:5]),
					.out_o(h3_msb));

h3_decode h3_lower (.in5_i(data_i[4:0]),
					.out_o(h3_lsb));
					
h2_decode h2_upper (.in5_i(data_i[9:5]),
					.out_o(h2_msb));
					
h2_decode h2_lower (.in5_i(data_i[4:0]),
					.out_o(h2_lsb));															
					
bsg_popcount #(.width_p(5)) high ( .i(data_i[9:5]),
								   .o(pop_h));
								   
bsg_popcount #(.width_p(5)) low ( .i(data_i[4:0]),
								   .o(pop_l));

assign out8b_o = out8b;

always @(*)
	begin
	case({pop_h,pop_l})
		{3'd3,3'd2}: begin
          out8b = {2'b00,h3_msb[2:0],h2_lsb[2:0]};
					$display("pop_h has 3 1s");
					end
//		3'd2:
//		3'd4:
//		3'd1:
//		3'd0:
		default:$display("error");
		
	endcase
		
	
	end

endmodule

module h3_decode (
					input [4:0] in5_i,
 					output [3:0] out_o
					);
  reg [3:0] out;	
		always @(*)
		begin
			case (in5_i)
				5'b00111: out = 4'b?000;
				5'b01011: out = 4'b?001;
				5'b01101: out = 4'b?010;
				5'b01110: out = 4'b?011;
				5'b10011: out = 4'b?100;
				5'b10101: out = 4'b?101;
				5'b10110: out = 4'b?110;
				5'b11001: out = 4'b?111;
				5'b11010: out = 4'b1000;
				5'b11100: out = 4'b1001;
				default: $display("Unmatched h3 input");
			
			endcase
		
		end //end always
  assign out_o = out;
endmodule

module h2_decode (
					input [4:0] in5_i,
  					output [3:0] out_o
					);
  reg [3:0] out;		
		always @(*)
		begin
			case (in5_i)
				5'b00011: out = 4'b?000;
				5'b00101: out = 4'b?001;
				5'b00110: out = 4'b?010;
				5'b01010: out = 4'b?011;
				5'b01100: out = 4'b?100;
				5'b01001: out = 4'b?101;
				5'b10001: out = 4'b?110;
				5'b10010: out = 4'b?111;
				5'b10100: out = 4'b1000;
				5'b11000: out = 4'b1001;
				default: $display("Unmatched h2 input");
			
			endcase
		
		end //end always
  assign out_o = out;
endmodule				

//`include "bsg_defines.v"

// MBT popcount
//
// 10-24-14
//

module bsg_popcount #(parameter width_p="inv")
   (input [width_p-1:0] i
    , output [$clog2(width_p+1)-1:0] o
    );

   // perf fixme: better to round up to nearest power of two and then
   // recurse with side full and one side minimal
   //
   // e.g-> 80 -> 128/2 = 64 --> (64,16)
   //
   // possibly slightly better is to use 2^N-1:
   // 
   // for items that are 5..7 bits wide, we make sure to
   // split into a 4 and a 1/2/3; since the four is relatively optimized.
   //

   localparam first_half_lp  = 4;
   localparam second_half_lp = 1;

   if (width_p <= 3)
     begin : lt3
        assign o[0] = ^i;

        if (width_p == 2)
          assign o[1] = & i;
        else
          if (width_p == 3)
            assign o[1] = (&i[1:0]) | (&i[2:1]) | (i[0]&i[2]);
     end
   else
     // http://www.wseas.us/e-library/conferences/2006hangzhou/papers/531-262.pdf

     if (width_p == 4)
       begin : four
          // half adders
          wire [1:0] s0 = { ^i[3:2], ^i[1:0]};
          wire [1:0] c0 = { &i[3:2], &i[1:0]};

          // low bit is xor of all bits
          assign o[0] =  ^s0;

          // middle bit is: ab ^ cd
          //            or  (a^b) & (c^d)

          assign o[1] =  (^c0) | (&s0);

          // high bit is and of all bits

          assign o[2] =  &c0;
       end
     else
       begin : recurse
          wire [$clog2(first_half_lp+1)-1:0]  lo;
          wire [$clog2(second_half_lp+1)-1:0] hi;

          bsg_popcount #(.width_p(first_half_lp))
             left(.i(i[0+:first_half_lp])
                  ,.o(lo)
                  );

          bsg_popcount #(.width_p(second_half_lp))
          right(.i(i[first_half_lp+:second_half_lp])
                ,.o(hi)
                );

          assign o = lo+hi;
       end

endmodule // bsg_popcount
