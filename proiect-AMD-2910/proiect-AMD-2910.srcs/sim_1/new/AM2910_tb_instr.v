`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/04/2024 01:36:43 AM
// Design Name: 
// Module Name: am2910_tb
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
module am2910_tb;
    // Inputs
    reg [19:0] memory [0:2047]; 
    initial begin
        $readmemb("E:/proiect-AMD-2910/valori_memorie.txt", memory);   
        $display("Memory Initialized");
       
        $display("Memory[0] = %b", memory[0]);
        
    end
    //Inputs
    reg [11:0] di;
    reg clk;
    reg ci;
    reg cc;
    reg oe;
    reg rld;
    reg [3:0] instr;
   
    // Outputs
    wire pl;
    wire map;
    wire vect;
    wire full;
    wire [11:0] y;
    
    am2910 uut (
        .di(di),
        .clk(clk),
        .ci(ci),
        .CCn(cc),
        .oe(oe),
        .RLD(rld),
        .i30(instr),
        .pl(pl),
        .map(map),
        .vect(vect),
        .full(full),
        .y(y)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    
    initial begin
         
        // Initial values from memory location 0
        #10
        {di, instr, cc, oe, rld, ci} = memory[0];
        $display("Initial values - di: %h, instr: %b, cc: %b, oe: %b, rld: %b, ci: %b", di, instr, cc, oe, rld, ci);
        
        $monitor("At time %t: di = %h, instr = %b, cc = %b, oe = %b, rld = %b, ci = %b, y = %h", 
             $time, di, instr, cc, oe, rld, ci, y);
         #20
        {di, instr, cc, oe, rld, ci} = memory[1];
        #20
        
        {di, instr, cc, oe, rld, ci} = memory[2];
        
        forever begin
            #7; 
            if (y < 2048) begin
                {di, instr, cc, oe, rld, ci} = memory[y];
            end else begin
                $display("Error: `y` value %d is out of range!", y);
            end
        end
        #20
       $finish;
        
    end  
    
endmodule

/*
memory_values.txt:
memory[0]: instr 0(jump zero)
memory[1]: instr 1(cond jsb pl)
memory[2]: instr e(continue)
...repetare 1+e pentru testarea stivei(pana la umplerea celor 9 nivele ale stivei)
memory[24]: instr d(test end loop): operatie de pop
memory[25]: instr c(ld cntr and continue) incarcare date reg-cntr 
memory[26]: instr 9(repeat pl) testare functionalitate reg-cntr
memory[27]-final: testare functionalitate loop pentru set de instructiuni instr 4(push/cond ld cntr) + instr 8(repeat loop cntr !=0)
*/