`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/04/2024 01:35:01 AM
// Design Name: 
// Module Name: am2910
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

module stackPointer(clk, clear_s, push_s, pop_s, hold_s, full, sp);
    input clk;
    input push_s;
    input pop_s;
    input hold_s;
    input clear_s;
    output reg full;
    output reg [3:0] sp;
    
    always @(posedge clk)
    begin 
        if(clear_s)
        begin
            sp <= 4'b0;
            full <= 1'b1;
        end
        else if(hold_s)
        begin
            if(sp==9)
                full<=1'b0;
        end
        else if (push_s) 
        begin
            if (sp < 9) 
            begin
                sp <= sp + 1;
                if (sp == 8) 
                    full <= 1'b0;
            end
        end  
        else if (pop_s) 
        begin
            if (sp > 0) 
            begin
                sp <= sp - 1;
                full <= 1'b1;
            end
        end    
    end
endmodule


module stack (clk, clear_s, push_s, pop_s, hold_s, data_in, data_out, sp);
    input clk;
    input push_s;
    input pop_s;
    input hold_s;
    input clear_s;
    input [3:0] sp; 
    input [11:0] data_in;
    output reg [11:0] data_out;
    reg [11:0] mem_stack [0:8];
    integer i;
    always@(posedge clk)
    begin
    if (clear_s) 
    begin
            for (i = 0; i < 9; i = i + 1) begin
                mem_stack[i] <= 12'b0;
            end
    end
    else if (push_s) begin
            mem_stack[sp] <= data_in;
    end 
    else if (pop_s && sp > 0) begin
            mem_stack[sp-1] <= 12'b0;
            data_out <= mem_stack[sp - 1];
    end              
    end
    
endmodule

module incremeter(ci, data_in, data_out);
input ci;
input [11:0]data_in;
output [11:0]data_out;
assign data_out=ci ? (data_in + 1'b1) : data_in;
endmodule

module microprog_register(clk, clear_m, count_m, data_in, data_out);
input clk;
input clear_m;
input count_m;
input [11:0] data_in;
output reg [11:0] data_out;
always@(posedge clk)
    if(clear_m)
        data_out<=12'b0;
    else if(count_m)
        data_out<=data_in;    
endmodule

module zero_detector(data_in, data_out);
input [11:0] data_in;
output wire data_out;
assign data_out=~(|data_in);
endmodule

module reg_cnt(clk, data_in, RLD, dec, hold, load, data_out);
input clk;
input [11:0] data_in;
input dec;
input RLD;
input hold;
input load;
output wire [11:0] data_out;
reg [11:0] cnt, cnt_next;
always@(posedge clk)
     cnt<=cnt_next;

assign data_out=cnt;
always@(load or data_in or RLD or dec or cnt or hold)
begin
       casex({load,RLD,dec,hold})
            4'bx0x1: cnt_next = cnt;  
            4'b0010: cnt_next = cnt-1;
            4'b10x0: cnt_next = data_in;     
            default: cnt_next = cnt;       
                                
       endcase
      
end  

endmodule


module mux(D, R, F, mPC, sel, y);
    input [11:0] D, R, F, mPC;
    input [2:0] sel;
    output reg[11:0] y;
    always@(D or R or F or mPC or sel)
    casex(sel)
        3'b000: y=D;
        3'b001: y=R;
        3'b010: y=F;
        3'b011: y=mPC;
        3'b1xx: y=12'b0;
    endcase
endmodule

module instruction(CCn, i30, zero, dec, hold, load, push_s, pop_s, hold_s, clear_s, clear_m, count_m, map, pl, vect, sel);
    input CCn, zero;
    input [3:0] i30;
    output reg dec, hold, load, push_s, pop_s, hold_s, clear_s, clear_m, count_m, map, pl, vect;
    output reg [2:0] sel;
    always@(i30 or CCn or zero)
    begin
    casex({i30, CCn, zero})
        6'b0000_x_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=0; 
            clear_s=1;clear_m=1; count_m=0; map=0; pl=1; vect=0; sel=3'b100;
        end
        6'b0001_0_x:begin
            dec=0; hold=1; load=0; push_s=1; pop_s=0; hold_s=0; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b000;
        end
        6'b0001_1_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
        6'b0010_0_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=1; pl=0; vect=0; sel=3'b000;
        end
        6'b0010_1_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=1; pl=0; vect=0; sel=3'b000;
        end
        6'b0011_0_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b000;
        end
        6'b0011_1_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
        6'b0100_0_x:begin
            dec=0; hold=0; load=1; push_s=1; pop_s=0; hold_s=0; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
        6'b0100_1_x:begin
            dec=0; hold=1; load=0; push_s=1; pop_s=0; hold_s=0; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
        6'b0101_0_x:begin
            dec=0; hold=1; load=0; push_s=1; pop_s=0; hold_s=0; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b000;
        end
        6'b0101_1_x:begin
            dec=0; hold=1; load=0; push_s=1; pop_s=0; hold_s=0; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b001;
        end
        6'b0110_0_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=0; vect=1; sel=3'b000;
        end
        6'b0110_1_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=0; vect=1; sel=3'b011;
        end
        6'b0111_0_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b000;
        end
        6'b0111_1_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b001;
        end
         6'b1000_0_0:begin
            dec=1; hold=0; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b010;
        end
         6'b1000_0_1:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=1; hold_s=0; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
        6'b1000_1_0:begin
            dec=0; hold=0; load=0; push_s=0; pop_s=0; hold_s=0; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=0; vect=0; sel=3'b010;
        end
         6'b1000_1_1:begin
            dec=1; hold=0; load=0; push_s=0; pop_s=1; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
          6'b1001_0_0:begin
            dec=1; hold=0; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b000;
        end
         6'b1001_0_1:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
        6'b1001_1_0:begin
            dec=1; hold=0; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b000;
        end
        6'b1001_1_1:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
         6'b1010_0_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=1; hold_s=0; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b010;
        end
         6'b1010_1_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
         6'b1011_0_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=1; hold_s=0; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b000;
        end
         6'b1011_1_x:begin
             dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
         6'b1100_0_x:begin
           dec=0; hold=0; load=1; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
         6'b1100_1_x:begin
            dec=0; hold=0; load=1; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
        6'b1101_0_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=1; hold_s=0; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
         6'b1101_1_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b010;
        end
        6'b1110_x_x:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
        
        6'b1111_0_0:begin
            dec=1; hold=0; load=0; push_s=0; pop_s=1; hold_s=0; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
         6'b1111_0_1:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=1; hold_s=0; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b011;
        end
        6'b1111_1_0:begin
            dec=1; hold=0; load=0; push_s=0; pop_s=0; hold_s=1; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b010;
        end
         6'b1111_1_1:begin
            dec=0; hold=1; load=0; push_s=0; pop_s=1; hold_s=0; 
            clear_s=0;clear_m=0; count_m=1; map=0; pl=1; vect=0; sel=3'b000;
        end
    endcase
end
endmodule


module am2910(di, clk, RLD, ci, CCn, i30, oe, pl, map, vect, full, y);
    input [11:0] di;
    input clk, ci, CCn, oe, RLD;
    input [3:0] i30;
    output wire pl, map, vect, full;
    output reg [11:0] y;
    wire dec, hold, load, push_s, pop_s, hold_s, clear_s, clear_m, count_m;
    wire [2:0] sel;
    wire equal_zero;
    wire [11:0] micropc_out, inc_out, stack_out, reg_cnt_out;
    wire [3:0] sp;
    wire [11:0] data_out;
    instruction instruction_pla(CCn, i30, r, dec, hold, load, push_s, pop_s, hold_s, clear_s, clear_m, count_m, map, pl, vect, sel);
    incremeter increm_reg(ci, data_out, inc_out);
    microprog_register micro_PC(clk, clear_m, count_m, inc_out, micropc_out);
    stackPointer s_pointer(clk, clear_s, push_s, pop_s, hold_s, full, sp);
    stack stack_9x12(clk, clear_s, push_s, pop_s, hold_s, micropc_out, stack_out, sp);
    reg_cnt reg_cntR(clk, di, RLD, dec, hold, load, reg_cnt_out);
    zero_detector detector(reg_cnt_out, equal_zero);
    mux mux_out(di, reg_cnt_out, stack_out, micropc_out, sel, data_out);
    always@(posedge clk)
    begin
      y = (oe) ? data_out : 12'bz; 
    end 

endmodule 