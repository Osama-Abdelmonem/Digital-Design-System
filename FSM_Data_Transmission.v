module FSM_Data_Transmission 
(
  //-------------------------------Input Ports------------------------------------//
  input      wire                                    DATA,
  input      wire                                    DATA_VALID,
  input      wire                                    Parity_bit,
  input      wire                                    Parity_en,
  input      wire                                    Finish_Data_Transmission,
  input      wire                                    CLK,
  input      wire                                    RST,           // Active Low Asynchronous Reset
  //-------------------------------Output Ports------------------------------------//
  output     reg                                     S_DATA,
  output     reg                                     Busy,
  output     reg                                     En_Data_Counter,
  output     reg                                     Load_Data_en
);

//-------------------------------- State Variables --------------------------------//
reg      [2:0]     Current_state, Next_state;

//-------------------------------- State Parameters -------------------------------//
// Gray Encoding
localparam IDLE_STATE       = 3'b000;
localparam TRANSMIT_START   = 3'b001;
localparam TRANSMIT_DATA    = 3'b011;
localparam TRANSMIT_PARITY  = 3'b010; 
localparam TRANSMIT_STOP    = 3'b110;

//--------------------------------- State Transitions -----------------------------//
always @(posedge CLK or negedge RST)
    begin
        if (!RST)
          begin
              Current_state <= IDLE_STATE;
          end
        else
          begin
              Current_state <= Next_state;
          end
    end

//---------------------------------- Next State Logic --------------------------------//
always @(*)
    begin
        case (Current_state)
        IDLE_STATE      : begin
                            if (DATA_VALID)
                              begin
                                Next_state = TRANSMIT_START;
                              end
                            else
                              begin
                                Next_state = IDLE_STATE;
                              end
                          end
        TRANSMIT_START  : begin
                            Next_state = TRANSMIT_DATA;
                          end
        TRANSMIT_DATA   : begin
                            if (Finish_Data_Transmission & Parity_en)
                                  begin
                                    Next_state = TRANSMIT_PARITY;
                                  end
                            else if (Finish_Data_Transmission & !Parity_en)
                                  begin
                                    Next_state = TRANSMIT_STOP;
                                  end
                            else
                                  begin
                                    Next_state = TRANSMIT_DATA;
                                  end                      
                          end
        TRANSMIT_PARITY : begin
                            Next_state = TRANSMIT_STOP;
                          end 
        TRANSMIT_STOP   : begin
                            Next_state = IDLE_STATE;
                          end 
        default         : begin
                            Next_state = IDLE_STATE;
                          end
        endcase
    end
//---------------------------------------- Output Logic -------------------------------//
always @(*)
    begin
        case (Current_state)
          IDLE_STATE      : begin
                             Busy            = 1'b0;
                             S_DATA          = 1'b1;
                             En_Data_Counter = 1'b0;
                             if (DATA_VALID)
                                begin
                                  Load_Data_en    = 1'b1;
                                end
                             else 
                                begin
                                  Load_Data_en    = 1'b0;
                                end
                            end
          TRANSMIT_START  : begin
                             Busy            = 1'b1;
                             S_DATA          = 1'b0;
                             En_Data_Counter = 1'b0;
                             Load_Data_en    = 1'b0;
                            end
          TRANSMIT_DATA   : begin
                             Busy            = 1'b1;
                             S_DATA          = DATA;
                             En_Data_Counter = 1'b1;
                             Load_Data_en    = 1'b0;
                            end
          TRANSMIT_PARITY : begin
                             Busy            = 1'b1;
                             S_DATA          = Parity_bit;
                             En_Data_Counter = 1'b0;
                             Load_Data_en    = 1'b0;
                            end
          TRANSMIT_STOP   : begin
                             Busy            = 1'b1;
                             S_DATA          = 1'b1;
                             En_Data_Counter = 1'b0;
                             Load_Data_en    = 1'b0;
                            end
          default         : begin
                             Busy            = 1'b0;
                             S_DATA          = 1'b1;
                             En_Data_Counter = 1'b0;
                             Load_Data_en    = 1'b0;
                            end
        endcase
    end
endmodule 