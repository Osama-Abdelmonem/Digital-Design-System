module Serializer 
(
   //-------------------------------Input Ports------------------------------------//
    input      wire      [7:0]                         P_DATA,
    input      wire                                    CLK,
    input      wire                                    RST,
    input      wire                                    Load_Data_en,
  //-------------------------------Output Ports-----------------------------------//
    output     reg                                     DATA
);

reg    [7:0]  Parallel_Data;

// Store the Parallel Data (Sequential Logic)
always @(posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                Parallel_Data   <=   8'b0;
            end
        else if (Load_Data_en)
            begin
                Parallel_Data   <=   P_DATA;
            end
        else 
            begin
                Parallel_Data   <=   {1'b0,Parallel_Data[7:1]};
                DATA            <= Parallel_Data[0];
            end
    end


endmodule

