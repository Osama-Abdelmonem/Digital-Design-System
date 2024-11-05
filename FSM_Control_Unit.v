module FSM_Control_Unit (
//-------------------------------Input Ports------------------------------------//
input                        Enable,
input    wire     [7:0]      ALU_Config0,
input    wire     [7:0]      ALU_Config1,
input                        UART_Busy,
input    wire                RST,
input    wire                CLK,
input    wire     [4:0]      Saved_State,
//-------------------------------Output Ports------------------------------------//
output   reg                 ALU_Enable,
output   reg      [3:0]      ALU_FUN,
output   reg                 CLKG_EN,
output   reg                 Done_Flag, 
output   reg                 Save_Enable,
output   reg      [4:0]      Prev_Check_State
);

//-------------------------------- State Variables --------------------------------//
reg      [4:0]     Current_state, Next_state;

//-------------------------------- State Parameters -------------------------------//
// Binary Encoding
localparam IDLE_STATE       = 5'b0_0000;
localparam Wait_STATE       = 5'b0_0001;
localparam Check_0          = 5'b0_0010;
localparam Check_1          = 5'b0_0011;
localparam Check_2          = 5'b0_0100;
localparam Check_3          = 5'b0_0101;
localparam Check_4          = 5'b0_0110;
localparam Check_5          = 5'b0_0111;
localparam Check_6          = 5'b0_1000;
localparam Check_7          = 5'b0_1001;
localparam Check_8          = 5'b0_1010;
localparam Check_9          = 5'b0_1011;
localparam Check_10         = 5'b0_1100;
localparam Check_11         = 5'b0_1101;
localparam Check_12         = 5'b0_1110;
localparam Check_13         = 5'b0_1111;
localparam Check_14         = 5'b1_0000;
localparam Check_15         = 5'b1_0001;
localparam ALU_CALC_CYCLE   = 5'b1_0010;

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
            IDLE_STATE       : begin
                                if (Enable)
                                    begin
                                        Next_state = Check_0;
                                    end
                                else 
                                    begin
                                        Next_state = IDLE_STATE;
                                    end
                               end
            ALU_CALC_CYCLE   : begin
                                 Next_state = Wait_STATE;
                               end
            Wait_STATE       : begin
                                if (!UART_Busy)
                                    begin
                                        if (Saved_State != Check_15)
                                            begin
                                                Next_state = Saved_State + 5'b0_0001;
                                            end
                                        else 
                                            begin
                                                Next_state = IDLE_STATE;
                                            end
                                    end
                                else 
                                    begin
                                        Next_state = Wait_STATE;
                                    end
                               end
            Check_0          : begin
                                if (ALU_Config0[0])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_1;
                                    end
                               end
            Check_1          : begin
                                if (ALU_Config0[1])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_2;
                                    end
                               end
            Check_2          : begin
                                if (ALU_Config0[2])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_3;
                                    end
                               end
            Check_3          : begin
                                if (ALU_Config0[3])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_4;
                                    end
                               end
            Check_4          : begin
                                if (ALU_Config0[4])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_5;
                                    end
                               end
            Check_5          : begin
                                if (ALU_Config0[5])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_6;
                                    end
                               end
            Check_6          : begin
                                if (ALU_Config0[6])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_7;
                                    end
                               end
            Check_7          : begin
                                if (ALU_Config0[7])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_8;
                                    end
                               end
            Check_8          : begin
                                if (ALU_Config1[0])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_9;
                                    end
                               end
            Check_9          : begin
                                if (ALU_Config1[1])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_10;
                                    end
                               end
            Check_10         : begin
                                if (ALU_Config1[2])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_11;
                                    end
                               end
            Check_11         : begin
                                if (ALU_Config1[3])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_12;
                                    end
                               end
            Check_12         : begin
                                if (ALU_Config1[4])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_13;
                                    end
                               end
            Check_13         : begin
                                if (ALU_Config1[5])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_14;
                                    end
                               end
            Check_14         : begin
                                if (ALU_Config1[6])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = Check_15;
                                    end
                               end
            Check_15         : begin
                                if (ALU_Config1[7])
                                    begin
                                        Next_state = ALU_CALC_CYCLE;
                                    end
                                else 
                                    begin
                                        Next_state = IDLE_STATE;
                                    end
                               end
            default          : begin
                                Next_state = IDLE_STATE;
                               end
        endcase
    end

//---------------------------------------- Output Logic -------------------------------//
always @(*)
    begin
        case (Current_state)
            IDLE_STATE       : begin
                                ALU_Enable                  = 1'b0;
                                ALU_FUN                     = 4'b0000; 
                                CLKG_EN                     = 1'b0;
                                Done_Flag				    = 1'b1;
                                Save_Enable                 = 1'b0;
                                Prev_Check_State            = IDLE_STATE;
                               end
            ALU_CALC_CYCLE   : begin
                                ALU_Enable                  = 1'b0;
                                ALU_FUN                     = 4'b0000; 
                                CLKG_EN                     = 1'b1;
                                Done_Flag				    = 1'b0;
                                Save_Enable                 = 1'b0;
                                Prev_Check_State            = IDLE_STATE;
                               end
            Wait_STATE       : begin
                                ALU_Enable                  = 1'b0;
                                ALU_FUN                     = 4'b0000; 
                                CLKG_EN                     = 1'b0;
                                Done_Flag				    = 1'b0;
                                Save_Enable                 = 1'b0;
                                Prev_Check_State            = IDLE_STATE;
                               end
            Check_0          : begin
                                if (ALU_Config0[0])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_0;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_0;
                                    end
                               end
            Check_1          : begin
                                if (ALU_Config0[1])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b0001; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_1;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_1;
                                    end
                               end
            Check_2          : begin
                                if (ALU_Config0[2])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b0010; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_2;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_2;
                                    end
                               end
            Check_3          : begin
                                if (ALU_Config0[3])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b0011; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_3;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_3;
                                    end
                               end
            Check_4          : begin
                                if (ALU_Config0[4])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b0100; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_4;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_4;
                                    end
                               end
            Check_5          : begin
                                if (ALU_Config0[5])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b0101; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_5;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_5;
                                    end
                               end
            Check_6          : begin
                                if (ALU_Config0[6])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b0110; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_6;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_6;
                                    end
                               end
            Check_7          : begin
                                if (ALU_Config0[7])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b0111; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_7;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_7;
                                    end
                               end
            Check_8          : begin
                                if (ALU_Config1[0])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b1000; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_8;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b1000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_8;
                                    end
                               end
            Check_9          : begin
                                if (ALU_Config1[1])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b1001; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_9;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_9;
                                    end
                               end
            Check_10         : begin
                                if (ALU_Config1[2])
                                     begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b1010; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_10;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_10;
                                    end
                               end
            Check_11         : begin
                                if (ALU_Config1[3])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b1011; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_11;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_11;
                                    end
                               end
            Check_12         : begin
                                if (ALU_Config1[4])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b1100; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_12;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_12;
                                    end
                               end
            Check_13         : begin
                                if (ALU_Config1[5])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b1101; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_13;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_13;
                                    end
                               end
            Check_14         : begin
                                if (ALU_Config1[6])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b1110; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_14;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_14;
                                    end
                               end
            Check_15         : begin
                                if (ALU_Config1[7])
                                    begin
                                        ALU_Enable                  = 1'b1;
                                        ALU_FUN                     = 4'b1111; 
                                        CLKG_EN                     = 1'b1;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b1;
                                        Prev_Check_State            = Check_15;
                                    end
                                else 
                                    begin
                                        ALU_Enable                  = 1'b0;
                                        ALU_FUN                     = 4'b0000; 
                                        CLKG_EN                     = 1'b0;
                                        Done_Flag				    = 1'b0;
                                        Save_Enable                 = 1'b0;
                                        Prev_Check_State            = Check_15;
                                    end
                               end
            default          : begin
                                ALU_Enable                  = 1'b0;
                                ALU_FUN                     = 4'b0000; 
                                CLKG_EN                     = 1'b0;
                                Done_Flag				    = 1'b1;
                                Save_Enable                 = 1'b0;
                                Prev_Check_State            = IDLE_STATE;
                               end
        endcase
    end
endmodule 