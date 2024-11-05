//////////////////////////////////////////////////////////////////////////////////////
//                                  Module Description                              //
// Module Name: ALU                                                                 // 
// ALU is the fundamental building block of the processor, which is responsible for // 
// carrying out the arithmetic, logic functions, Shift functions and Comparison     //
// functions. This is a 16-bit ALU that performs 16 different operations and carries//
// out some of the required flags as outputs.                                       //                                                                         
//////////////////////////////////////////////////////////////////////////////////////

module ALU 
  #(parameter Data_bus_width = 8, 
              ALU_FUNC_width = 4)
   (
   //-------------------------------Input Ports------------------------------------//
    input       wire       [Data_bus_width - 1:0]         A,B,
    input       wire       [ALU_FUNC_width - 1:0]         ALU_FUN,
    input       wire                                      Enable,
    input       wire                                      CLK,
    input       wire                                      RST,         // Active Low Asynchronous Reset 
   //-------------------------------Output Ports------------------------------------//
    output      reg        [Data_bus_width - 1:0]         ALU_OUT,
    output      reg                                       OUT_VALID                        
   );
   
   // Main Sequential Logic
    always @(posedge CLK or negedge RST)
      begin
        if (!RST)
          begin
            ALU_OUT   <=  'b0;
            OUT_VALID <= 1'b0;
          end
        else if (Enable == 1'b1)
          begin
            case (ALU_FUN)
              'b0000 : begin
                        ALU_OUT   <= A + B;
                        OUT_VALID <= 1'b1;
                       end
              'b0001 : begin
                        ALU_OUT   <= A - B;
                        OUT_VALID <= 1'b1;
                       end
              'b0010 : begin
                        ALU_OUT   <= A * B;
                        OUT_VALID <= 1'b1;
                       end
              'b0011 : begin
                        ALU_OUT   <= A / B;
                        OUT_VALID <= 1'b1;
                       end
              'b0100 : begin
                        ALU_OUT   <= A & B;
                        OUT_VALID <= 1'b1;
                       end
              'b0101 : begin
                        ALU_OUT   <= A | B;
                        OUT_VALID <= 1'b1;
                       end
              'b0110 : begin
                        ALU_OUT   <= ~(A & B);
                        OUT_VALID <= 1'b1;
                       end
              'b0111 : begin
                        ALU_OUT   <= ~(A | B);
                        OUT_VALID <= 1'b1;
                       end
              'b1000 : begin
                        ALU_OUT   <= A ^ B;
                        OUT_VALID <= 1'b1;
                       end
              'b1001 : begin
                        ALU_OUT   <= A ~^ B;
                        OUT_VALID <= 1'b1;
                       end
              'b1010 : begin
                        ALU_OUT   <= (A == B) ? 'd1 : 'b0;
                        OUT_VALID <= 1'b1;
                       end
              'b1011 : begin
                        ALU_OUT   <= (A > B)  ? 'd2 : 'b0;
                        OUT_VALID <= 1'b1;
                       end
              'b1100 : begin
                        ALU_OUT   <= (A < B)  ? 'd3 : 'b0;
                        OUT_VALID <= 1'b1;
                       end
              'b1101 : begin
                        ALU_OUT   <= A >> 1;
                        OUT_VALID <= 1'b1;
                       end
              'b1110 : begin
                        ALU_OUT   <= A << 1;
                        OUT_VALID <= 1'b1;
                       end
              default: begin
                        ALU_OUT   <=  'b0;
                        OUT_VALID <= 1'b0;
                       end
            endcase
          end
        else 
          begin
            ALU_OUT   <=  'b0;
            OUT_VALID <= 1'b0;
          end
      end
endmodule
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
