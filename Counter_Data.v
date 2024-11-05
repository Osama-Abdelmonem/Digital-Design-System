module Counter_Data 
(
    //-------------------------------Input Ports------------------------------------//
    input          wire                           En,
    input          wire                           CLK,
    input          wire                           RST,
    //-------------------------------Output Ports------------------------------------//
    output         wire                           Finish_Data_Transmission
);
// Counter Variable 
reg   [3:0]    Counter;

always @(posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                Counter <= 4'b0000;
            end
        else if (En)
            begin
                Counter <= Counter + 4'b0001;
            end
        else
            begin
                Counter <= 4'b0000;
            end
    end
assign Finish_Data_Transmission = (Counter == 4'd7);
endmodule