//////////////////////////////////////////////////////////////////////////////////////
//                                  Module Description                              //
// Module Name: FSM Controller                                                      // 
// The main responsibility of the finite state machine is to orchestrate the flow of//
// signals with the datapath unit that contains UART, ALU and Clock Gating. This    //  
// is done by using certain flags to change the states and accordingly change the   //
// corresponding outputs.                                                           //                                                                                                      
//////////////////////////////////////////////////////////////////////////////////////
module FSM_Controller (
//-------------------------------Input Ports------------------------------------//
input                        Enable,
input    wire     [7:0]      ALU_Config0,
input    wire     [7:0]      ALU_Config1,
input                        UART_Busy,
input    wire                RST,
input    wire                CLK,
//-------------------------------Output Ports------------------------------------//
output   wire                ALU_Enable,
output   wire     [3:0]      ALU_FUN,
output   wire                CLKG_EN,
output   wire                Done_Flag
);

// Internal Connections 
wire    [4:0]      Prev_Check_State;
wire               Save_Enable;
wire    [4:0]      Saved_State;

// Module Instantiations
Save_State_Unit SaveUnit (
    .Save_Enable(Save_Enable), .Prev_Check_State(Prev_Check_State),
    .Saved_State(Saved_State), .CLK(CLK), .RST(RST)
);

FSM_Control_Unit FSMUnit (
    .Enable(Enable), .ALU_Config0(ALU_Config0), .ALU_Config1(ALU_Config1),
    .UART_Busy(UART_Busy), .CLK(CLK), .RST(RST), .Saved_State(Saved_State),
    .ALU_Enable(ALU_Enable), .ALU_FUN(ALU_FUN), .CLKG_EN(CLKG_EN), 
    .Done_Flag(Done_Flag), .Save_Enable(Save_Enable),
    .Prev_Check_State(Prev_Check_State)
);

endmodule