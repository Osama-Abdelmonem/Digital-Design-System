module Parity
(
   //-------------------------------Input Ports------------------------------------//
    input      wire      [7:0]                         P_DATA,
    input      wire      [1:0]                         Configuration,    // Configuration[0] = parity bit enable 
                                                                         // Configuration[1] = parity type
    input      wire                                    CLK,
    input      wire                                    RST,
    input      wire                                    Load_Data_En,
    //-------------------------------Output Ports-----------------------------------//
    output     reg                                     Parity_bit
);

always @(posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                Parity_bit <= 1'b0;
            end
        else if (Configuration[0] & Load_Data_En)
            begin
                Parity_bit <= Configuration[1] ? ~^P_DATA : ^P_DATA;
            end
    end
endmodule