`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2024 01:49:36 PM
// Design Name: 
// Module Name: AM2910_tb_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AM2910_tb_mem;
    //inputs
    
    reg [19:0] memory [0:2047];
    initial begin
        $readmemb("E:/proiect-AMD-2910/valori_memorie.txt", memory);
        $display("Memorie initializata");
        $display("Memory[0] = %b", memory[0]);
        
    end
    
    //inputs
    reg [11:0] di;
    reg clk;
    reg CI;
    reg CCn;
    reg OE;
    reg RLD;
    reg [3:0] i30;
    
    //outputs
    wire pl;
    wire map;
    wire vect;
    wire full;
    wire [11:0] y;


//module AM2910_design(di, clk, RLD, CI, CCn, i30,
//OE, pl, map, vect, full, y );
    AM2910_design am2910(
        .di(di),
        .clk(clk),
        .RLD(RLD),
        .CI(CI),
        .CCn(CCn),
        .i30(i30),
        .OE(OE),
        .pl(pl),
        .map(map),
        .vect(vect),
        .full(full),
        .y(y)
        
        
    );
    
    
    initial 
    begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
   initial begin
         
        // Initial values from memory location 0
        #10
        {di, i30, CCn, OE, RLD, CI} = memory[0];
        $display("Initial values - di: %h, instr: %b, cc: %b, oe: %b, rld: %b, ci: %b", di, instr, cc, oe, rld, ci);
        
        $monitor("At time %t: di = %h, instr = %b, cc = %b, oe = %b, rld = %b, ci = %b, y = %h", 
             $time, di, instr, cc, oe, rld, ci, y);
         #20
        {di, i30, CCn, OE, RLD, CI} = memory[1];
        #20
        
        {di, i30, CCn, OE, RLD, CI} = memory[2];
        
        forever begin
            #7; 
            if (y < 2048) begin
                {di, i30, CCn, OE, RLD, CI} = memory[y];
            end else begin
                $display("Error: `y` value %d is out of range!", y);
            end
        end
        #20
       $finish;
        
    end  
    
endmodule

