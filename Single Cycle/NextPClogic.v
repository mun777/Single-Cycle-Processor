module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
	input [63:0] CurrentPC, SignExtImm64;
	input Branch, ALUZero, Uncondbranch;
	output reg [63:0] NextPC;
	
	reg BZero, BranchOR;
	
	always @(*)
		begin
			BZero =  ALUZero & Branch;
			BranchOR = BZero | Uncondbranch;
			if(BranchOR == 1) NextPC =  CurrentPC + (SignExtImm64 << 2);
			else NextPC =  CurrentPC + 4;
		end
endmodule
