module Save_State_Unit (
    //-------------------------------Input Ports------------------------------------//
    input     wire                  Save_Enable,
    input     wire    [4:0]         Prev_Check_State,
    input     wire                  RST,
    input     wire                  CLK,
    //-------------------------------Output Ports------------------------------------//
    output    reg     [4:0]         Saved_State
);

always @(posedge CLK or negedge RST)
    begin
        if(!RST)
            begin
                Saved_State <= 5'b0_0000;
            end 
        else if (Save_Enable)
            begin
                Saved_State <= Prev_Check_State;
            end
    end

endmodule 