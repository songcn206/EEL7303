/*
--------------------------------------------------------------------------
--                                                                      --
-- Copyright (c) 2001 by Cadence Design System  All rights reserved.    --
--                                                                      --
-- This source file may be used and distributed without restriction     --
-- provided that this copyright statement is not removed from the file  --
-- and that any derivative work contains this copyright notice.         --
--                                                                      --
--      File name: STANDARD_VERILOG.VHX                                   --
--      Purpose:
--
--       Verilog Source Editor Samples for OrCAD Capture                  --
--
--    History:                                                          --
--     December 22, 2001                                                --
--
--
--    Instructions:                                                     --
--    All text in between the Begin_Sample and End_Sample comments will --
--    appear in the list dialog available from the Verilog Samples      --
--    option of the Edit menu.                                          --
--    The begin and end comments must start in the first column.        --
--    The name of the sample is the first non-blank character following --
--    the Begin_Sample string to the end of the line.                   --
--------------------------------------------------------------------------
*/

//Begin_Sample Always
always @(inputs)
  begin
    ...  //combinational logic
  end

always @(inputs)
  if (enable)
  begin
    ...  //latches
  end

always @(posedge clock)
  begin
    ...  //synchronous
  end

always @(posedge clock or negedge reset)
  begin
    if (!reset)
      ...  //asynchronous
    else
      ...  //synchronous
  end
//End_Sample

//Begin_Sample Assign
wire cout, cin;
wire [3:0] sum, a, b;
assign {cout, sum} = a + b + cin;
//End_Sample

//Begin_Sample Arithemtic Operators
NEGATE = -X;
SUM  = X + Y;
DIFF = X - Y;
MULT = X * Y;
DIVD = X / Y;
REMAINDER = X % Y;
//End_Sample

//Begin_Sample Array
integer count[0:7];  //An array of 8 count variables
reg [3:0] ID[4:0];  //Array of 5 ID; each ID is a byte wide
//End_Sample

//Begin_Sample Case
case (Address)
 0 : A <= 1;
 1 : begin
        A <= 1;
        B <= 1;
     end
 2 : C <= 1;
 default  B <= 0;
endcase
//End_Sample

//Begin_Sample Comments
// "//" or "/* */"marks a comment in Verilog
// Anything on a line following "//" is interpreted as a comment.
/*
   Anything between "/*" and "*/" is comment
*/
// Sample:
  always @swap
  fork          //swap the values of a and b
    a = #5 b;
    b = #5 a;
  join          //completes after a delay of 5
//End_Sample

//Begin_Sample Relational Operators
(a > b)  //a greater than b
(a >= b) //a greater than or equal to b
(a < b) //a less than b
(a <= b) //a less than or equal to b
//End_Sample

//Begin_Sample Equality Operators
(a == b)  //a equal to b, result in x if either operand has x or z
(a === b) //a equal to b, including x and z
(a != b)  //a not equal to b, result in x if either operand has x or z
(a !== b) //a not equal to b, including x and z
//End_Sample

//Begin_Sample Conditional Assignment
if (alu == 0)
  y = x + z;
else if (alu == 1)
  y = x - z;
//End_Sample

//Begin_Sample Data Types
wire a;          //scalar net variable
reg  a;          //scalar register
real a;          //real variable
integer a;       //general purpose variable
time a;          //time variable
parameter a = 5; //constant
//End_Sample

//Begin_Sample Design Unit
module design_name(a, b, c, d, e);
  //data type declaration
  input a, b, c;
  output d, e;

  reg d, e, f, g;
  wire a, b, c;

  //procedural assignment
  always @(insert inputs)
  begin
    //insert statements

  end

endmodule
//End_Sample

//Begin Sample File
integer fileopen
begin
  fileopen = $fopen("file.txt");
  // statements

  $fclose(fileopen);
end
//End_Sample

//Begin_Sample For Loop
//Reverse Bit
for (i = 0; i < 4; i = i + 1)
  ReverseBit[3-i] = Bit[i]
//End_Sample

//Begin_Sample Fork
fork : Label
  reset = 0;
  #10 reset = 1;
join
//End_Sample

//Begin_Sample Function
//Function Definition
function [3:0] ReverseBit
  input [3:0] Bit;
  integer i;
  begin
    for (i = 0; i < 4; i = i + 1)
        ReverseBit[3-i] = Bit[i]
  end
endfunction

//Function Call
flip_data = ReverseBit(data);
//End_Sample

//Begin_Sample Module
module DFF (d, clk, clr, q, qb)
  input d, clk, clr;
  output q, qb;

endmodule
//End_Sample

//Begin_Sample Port
//Port declarations
output A, B;
input C;
inout IO;
//End_Sample

//Begin_Sample Shift Operators
Y = X >> 1;
Y = X << 2;
//End_Sample

//Begin_Sample Specify Blocks
specify
  (a ==> out) = 9;  //a delay of 9 between a and out
  (b ==> out) = 9;
endspecify
//End_Sample

//Begin_Sample Testbench
module testfixture;
  //Data type declaration
  reg a, b, sel;
  wire out;

  //Instance modules
  MUX2_1 mux1 (out, a, b, sel);

  //Apply stimulus
  initial
  begin
    a = 0; b = 1; sel = 0;
    #50 b = 0; sel =1;
    #100 $finish;
  end

  //Display results
  initial
  $monitor($time, ": %b,  %b,  %b,  %b", out, a, b, sel);

endmodule
//End_Sample

//Begin_Sample Timescale
'timescale <time_unit> / <time_precision>
'timescale 1ns/10ps
//End_Sample

//Begin_Sample While Loop
while (continue && (i < 32))
begin
  if (word[i])
    continue = 'FALSE;
  i = i + 1;
end
//End_Sample
