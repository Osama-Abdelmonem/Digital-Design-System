`timescale 1ms/1ps

module System_tb ();

//---------------------------------- Constant Parameters -------------------------------//
localparam CLk_PERIOD                      = 50;
localparam Num_Test_Cases                  = 5;
localparam DATA_BUS_WIDTH                  = 8;
localparam ADDR_BUS_WIDTH                  = 4;
localparam ALU_FUN_WORD                    = 4;
localparam NUM_LOAD_REG_FILE               = 7;
localparam MAX_NUM_OPERATIONS              = DATA_BUS_WIDTH * 2;
localparam MEM_TEST_VECTOR_WIDTH           = 9 + ADDR_BUS_WIDTH + DATA_BUS_WIDTH;
localparam MEM_TEST_VECTOR_DEPTH           = NUM_LOAD_REG_FILE * Num_Test_Cases;
localparam MEM_EXPECTED_OUTPUTS_WIDTH      = 3 + DATA_BUS_WIDTH;
localparam MEM_EXPECTED_OUTPUTS_DEPTH      = MAX_NUM_OPERATIONS * Num_Test_Cases;


//------------------------------------- Loop Variables ---------------------------------//
integer i; 
integer bit_index;
integer reg_index;
integer oper_output_index;

//----------------------------------------- Flags --------------------------------------//
reg              TEST_CASE_FAILED;
reg              PARITY_ENABLE;
reg    [3:0]     NUM_OPERATIONS;

//---------------------------------------- Memories ------------------------------------//
reg    [MEM_TEST_VECTOR_WIDTH - 1:0]         TEST_VECTOR         [0:MEM_TEST_VECTOR_DEPTH - 1];
reg    [MEM_EXPECTED_OUTPUTS_WIDTH - 1:0]    EXPECTED_OUTPUTS    [0:MEM_EXPECTED_OUTPUTS_DEPTH - 1];

//------------------------------------- Testbench Ports --------------------------------//
reg                           CONTROL_EN_TB;
reg                           CLKDIV_EN_TB;
reg                           CLK_TB;
reg                           RST_TB;
reg                           WrEn_TB;
reg                           RdEn_TB;
reg   [ADDR_BUS_WIDTH-1:0]    Address_TB;
reg   [DATA_BUS_WIDTH-1:0]    WrData_TB;
wire  [DATA_BUS_WIDTH-1:0]    RdData_TB;
wire                          SYS_OUT_TB;
wire                          SYS_VLD_TB;
wire                          DONE_FLAG_TB;

//------------------------------------ Clock Generation -------------------------------//
always #CLk_PERIOD CLK_TB = ~CLK_TB;

//--------------------------------- Module Instantiation ------------------------------// 
System_Top DUT (
.CLK(CLK_TB),
.RST(RST_TB),
.RdEn(RdEn_TB),
.WrEn(WrEn_TB),
.Address(Address_TB),
.WrData(WrData_TB),
.RdData(RdData_TB),
.CONTROL_EN(CONTROL_EN_TB),
.CLKDIV_EN(CLKDIV_EN_TB),
.SYS_OUT(SYS_OUT_TB),
.SYS_VLD(SYS_VLD_TB),
.DONE_FLAG(DONE_FLAG_TB)
);

//----------------------------------- Main Initial Block ----------------------------//
initial 
    begin
        $dumpfile("System.vcd");
        $dumpvars;

        // ----> Initialization 
        Initialize();

        // ----> Reset
        Reset();

        // ----> Read Test Vectors and Expected Outputs
        $readmemb("Test Vector.txt", TEST_VECTOR);
        $readmemb("Expected Outputs.txt", EXPECTED_OUTPUTS);

        // ----> Write the Test Cases , then verify the results with the Eexpected Output
        for (i = 0; i < Num_Test_Cases; i = i + 1)
            begin
                $display ("------------------- Test Case %d ---------------", i + 1);
                wait(DONE_FLAG_TB)
                        for (reg_index = 0; reg_index < NUM_LOAD_REG_FILE; reg_index = reg_index + 1)
                            begin
                                    do_write_test_case(TEST_VECTOR[reg_index + (i * NUM_LOAD_REG_FILE)]);
                            end
                    for (oper_output_index = 0; oper_output_index < NUM_OPERATIONS; oper_output_index = oper_output_index + 1)
                        begin
                            @(posedge SYS_VLD_TB);
                                    do_check_output(EXPECTED_OUTPUTS[oper_output_index + (i * MAX_NUM_OPERATIONS)], i + 1, oper_output_index + 1);
                        end
            end
        repeat (5) @(posedge CLK_TB);
        $stop;
    end

//////////////////////////////////////////////////////////////////////////////////////
//                                     Tasks                                        // 
//////////////////////////////////////////////////////////////////////////////////////

// ----------------> Task Name : Initialize
task Initialize();
    begin
      CONTROL_EN_TB  = 1'b0;
      CLKDIV_EN_TB   = 1'b1;
      CLK_TB         = 1'b0;
      RST_TB         = 1'b1;
      WrEn_TB        = 1'b0;
      RdEn_TB        = 1'b0;
      Address_TB     =  'b0;
      WrData_TB      =  'b0;
    end
endtask

// ----------------> Task Name : Reset
task Reset();
    begin
        RST_TB = 1'b1;  
        #(0.2 * CLk_PERIOD)
        RST_TB = 1'b0;  
        #(0.5 * CLk_PERIOD)
        RST_TB = 1'b1; 
    end
endtask

// ----------------> Task Name : do_write_test_case
task do_write_test_case(
    input    reg        [MEM_TEST_VECTOR_WIDTH - 1:0]       TEST_CASE
);
    begin
        @(negedge CLK_TB);
         {NUM_OPERATIONS, PARITY_ENABLE, CONTROL_EN_TB, CLKDIV_EN_TB, WrEn_TB, RdEn_TB, Address_TB, WrData_TB} = TEST_CASE;
    end
endtask

// ----------------> Task Name : do_check_output
task do_check_output(
    input    reg        [MEM_EXPECTED_OUTPUTS_WIDTH - 1:0]    EXPECTED_OUTPUT,
    input    integer                                          OPER_NUM, Num_Frame
);
    begin
        TEST_CASE_FAILED = 1'b0;
        if (PARITY_ENABLE)
            begin
                for (bit_index = 0; bit_index < MEM_EXPECTED_OUTPUTS_WIDTH; bit_index = bit_index + 1)
                    begin
                        @(negedge CLK_TB);
                        if ((EXPECTED_OUTPUT[bit_index] != SYS_OUT_TB) | !SYS_VLD_TB)
                            begin
                                TEST_CASE_FAILED = 1'b1;
                                $display("exp = %d, out = %d in bit num = %d", EXPECTED_OUTPUT[bit_index], SYS_OUT_TB, bit_index);
                            end
                    end
            end
        else
            begin
                for (bit_index = 0; bit_index < (MEM_EXPECTED_OUTPUTS_WIDTH - 1); bit_index = bit_index + 1)
                    begin
                        @(negedge CLK_TB)
                        if ((EXPECTED_OUTPUT[bit_index] != SYS_OUT_TB) | !SYS_VLD_TB)
                            begin
                                TEST_CASE_FAILED = 1'b1;
                                $display("exp = %d, out = %d in bit num = %d", EXPECTED_OUTPUT[bit_index], SYS_OUT_TB, bit_index);
                            end
                    end
            end
        if (TEST_CASE_FAILED)
            begin
                $display(" Test Case : %d ; Transmitted Frame : %d is Failed", OPER_NUM, Num_Frame);
            end
        else
            begin
                $display(" Test Case : %d ; Transmitted Frame : %d is Passed", OPER_NUM, Num_Frame);
            end
    end
endtask

endmodule