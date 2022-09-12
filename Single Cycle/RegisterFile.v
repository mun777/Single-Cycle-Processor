module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
	output [63:0] BusA;
    output [63:0] BusB;
    input [63:0] BusW;
    input [4:0] RA, RB, RW;
    input RegWr;
    input Clk;
    reg [63:0] registers [31:0];


	
    initial
    begin
		registers[31] = 0;
	end
	
	assign BusA = registers[RA];
    assign  BusB = registers[RB];
    
    always @(negedge Clk)
		begin
			if(RegWr == 1 && RW != 31) registers[RW] =  BusW;
		end
	
endmodule
