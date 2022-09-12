module SignExtender(BusImm, Imm26, Ctrl); 
  output reg[63:0] BusImm; 
  input [25:0] Imm26; 
  input [2:0] Ctrl; 
  reg extBit; 
 always@(*)
	begin
		case(Ctrl)
			3'b000 : begin // I-type
						 extBit = 1'b0;
						 BusImm = {{52{extBit}}, Imm26[21:10]};
					end
			3'b001 : begin
						 extBit = Imm26[20]; // D-type
						 BusImm = {{55{extBit}}, Imm26[20:12]};
					end
			3'b010 : begin
						 extBit = Imm26[25]; // B-type
						 BusImm = {{38{extBit}}, Imm26};
					end
			3'b011 : begin
						 extBit = Imm26[23]; // CBZ-type
						 BusImm = {{45{extBit}}, Imm26[23:5]};
					end
			3'b100 : begin
						 extBit = 1'b0;
						 case(Imm26[22:21])
						    2'b00 : begin // no shift
						      BusImm = {{48{1'b0}}, Imm26[20:5]};
						    end
						    2'b01 : begin // 16 shift
						      BusImm = {{32{1'b0}}, Imm26[20:5], {16{1'b0}}};
						    end
						    2'b10 : begin // 32 shift
						      BusImm = {{16{1'b0}}, Imm26[20:5], {32{1'b0}}};
						    end
						    2'b11 : begin // 48 shift
						      BusImm = {{0{1'b0}}, Imm26[20:5], {48{1'b0}}};
						    end
						  endcase
						 
						 
					end
			default:
				begin
					BusImm = {64{1'b0}};
				end
		endcase
	end
endmodule
