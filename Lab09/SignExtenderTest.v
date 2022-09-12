`timescale 1ns/1ps
`define STRLEN 15
module SignExtenderTest_v;

   task passTest;
      input [63:0] actualOut, expectedOut;
      input [`STRLEN*8:0] testType;
      inout [7:0]         passed;
      
      if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
      else $display ("%s failed: %d should be %d", testType, actualOut, expectedOut);
   endtask
   
   task allPassed;
      input [7:0] passed;
      input [7:0] numTests;
      
      if(passed == numTests) $display ("All tests passed");
      else $display("Some tests failed");
   endtask

   // Inputs
   reg [25:0]     Imm26;
   reg [2:0]      Ctrl;
   reg [7:0]      passed;

   // Outputs
   wire [63:0]    BusImm;
   
   initial //This initial block used to dump all wire/reg values to dump file
     begin
       $dumpfile("SignExtenderTest.vcd");
       $dumpvars(0,SignExtenderTest_v);
     end

   // Instantiate the Device Under Test (DUT)
   SignExtender dut (
		.BusImm(BusImm), 
		.Imm26(Imm26), 
		.Ctrl(Ctrl)
	        );

   initial begin
      // Initialize Inputs
      Imm26 = 0;
      Ctrl = 0;
      passed = 0;

      // Add stimulus here
      #90; Imm26=26'b01110001000100111010001101;Ctrl=3'b000; #10; passTest({BusImm}, 64'h0000000000000113, "I-type 1", passed);
      #90; Imm26=26'b01111001000100111010001101;Ctrl=3'b000; #10; passTest({BusImm}, 64'h0000000000000913, "I-type 2", passed);
      #90; Imm26=26'b11000111010001011100100011;Ctrl=3'b001; #10; passTest({BusImm}, 64'b1111111111111111111111111111111111111111111111111111111111010001, "D-type neg", passed);
      #90; Imm26=26'b11000011010001011100100011;Ctrl=3'b001; #10; passTest({BusImm}, 64'h00000000000000D1, "D-type pos", passed);
      #90; Imm26=26'b00001110001001110101000100;Ctrl=3'b010; #10; passTest({BusImm}, 64'h0000000000389D44, "B-type pos", passed);
      #90; Imm26=26'b10001110001001110101000100;Ctrl=3'b010; #10; passTest({BusImm}, 64'b1111111111111111111111111111111111111110001110001001110101000100, "B-type neg", passed);
      #90; Imm26=26'b10000010010101000100010110;Ctrl=3'b011; #10; passTest({BusImm}, 64'h0000000000004A88, "CBZ-type pos", passed);
      #90; Imm26=26'b10100010010101000100010110;Ctrl=3'b011; #10; passTest({BusImm}, 64'b1111111111111111111111111111111111111111111111000100101010001000, "CBZ-type neg", passed);
      
      #90; Imm26=26'b01001100101010101010101010;Ctrl=3'b100; #10; passTest({BusImm}, 64'b000000000000000000000000000000010010101010101010000000000000000, "WEIRD ASS TEST", passed);
	  #90;
      
      allPassed(passed, 9);

   end
   
endmodule
