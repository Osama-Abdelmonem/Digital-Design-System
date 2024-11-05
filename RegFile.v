//////////////////////////////////////////////////////////////////////////////////////
//                                  Module Description                              //
// Module Name: Register File                                                       // 
// A register file is an array of processor registers in a central processing       //
// unit (CPU). The following register file is 8*16 RegFile that reserves the first  //
// four memory locations for some of the required configuations for proper system   //
// functionality.                                                                   //                                                     
//////////////////////////////////////////////////////////////////////////////////////

module RegFile 
  #(parameter Data_bus_width    = 8,
              Address_bus_width = 4)
   (
    //-------------------------------Input Ports------------------------------------//
      input      wire       [Data_bus_width - 1:0]      WrData,
      input      wire       [Address_bus_width - 1:0]   Address,
      input      wire                                   WrEn, RdEn,
      input      wire                                   CLK,
      input      wire                                   RST,         // Active Low Asynchronous Reset
    //-------------------------------Output Ports------------------------------------//
      output     reg        [Data_bus_width - 1:0]      RdData,
      output     wire       [Data_bus_width - 1:0]      REG0, REG1, REG2, REG3, REG4, REG5  
   );
   
    // Loop Variables
      integer i;
    // Constant Parameters 
      localparam memory_depth = 1 << Address_bus_width;
      
    // Memory 
      reg     [Data_bus_width - 1:0]     Memory     [0:memory_depth - 1];
      
    // Main combinational Logic
      assign REG0 = Memory[0];                                      // Store ALU operand A value 
      assign REG1 = Memory[1];                                      // Store ALU operand B value
      assign REG2 = Memory[2];                                      // ALU Configuration 0
      assign REG3 = Memory[3];                                      // ALU Configuration 1
      assign REG4 = Memory[4];                                      // UART Configuration
      assign REG5 = Memory[5];                                      // Division Ration
      
    // Main Sequential Block
      always @(posedge CLK or negedge RST)
        begin
          if (!RST)
            begin
              for (i = 0; i < memory_depth; i = i + 1)
                begin
                  Memory[i]   <= 'b0;
                end
            end
          else if (WrEn)
            begin
              Memory[Address] <= WrData;
            end
          else if (RdEn)
            begin
              RdData <= Memory[Address];
            end
        end
endmodule 
      
    
    
    
    
    
    
    
    
    
    
    