//////////////////////////////////////////////////////////////////////////////////////
//                                  Module Description                              //
// Module Name: UART (Transmitter)                                                  // 
// A Universal Asynchronous Receiver/Transmitter (UART) is a block of circuitry     // 
// responsible for implementing serial communication. Transmitting UART converts    //
// parallel data from the master device (eg.ALU) into serial form and transmit in   //
// serial to receiving UART.                                                        //
//////////////////////////////////////////////////////////////////////////////////////
module UART 
  (
  //-------------------------------Input Ports------------------------------------//
  input      wire      [7:0]                         P_DATA,
  input      wire                                    DATA_VALID,
  input      wire      [1:0]                         Configuration, // Configuration[0] = parity bit enable 
                                                                    // Configuration[1] = parity type
  input      wire                                    CLK,
  input      wire                                    RST,           // Active Low Asynchronous Reset
  //-------------------------------Output Ports------------------------------------//
  output     wire                                    S_DATA,
  output     wire                                    Busy
  );

// Internal Connections
    wire    Parity_bit, DATA, En_Data, Finish_Data_Transmission, Load_Data_En;

// Parity Instantiation
    Parity P1 (
        .P_DATA(P_DATA), .Configuration(Configuration), .CLK(CLK),
        .RST(RST), .Load_Data_En(Load_Data_En), .Parity_bit(Parity_bit)
    );

// Counter_Data Instantiation
    Counter_Data CD1 (
        .En(En_Data), .CLK(CLK), .RST(RST), .Finish_Data_Transmission(Finish_Data_Transmission)
    );

// Serializer Instantiation
    Serializer S1(
        .P_DATA(P_DATA), .CLK(CLK), .RST(RST), .Load_Data_en(Load_Data_En),
        .DATA(DATA)
    );

// FSM 
FSM_Data_Transmission FSM(
    .DATA(DATA), .DATA_VALID(DATA_VALID), .Parity_bit(Parity_bit),
    .Parity_en(Configuration[0]), .Finish_Data_Transmission(Finish_Data_Transmission),
    .CLK(CLK), .RST(RST), .S_DATA(S_DATA), .Busy(Busy), .En_Data_Counter(En_Data),
    .Load_Data_en(Load_Data_En)
);

endmodule 