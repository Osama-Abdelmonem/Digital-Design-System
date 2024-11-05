
module System_Top #(parameter WIDTH = 8, ADDR = 4 , ALU_FUN_WD = 4) (

input    wire                CONTROL_EN,
input    wire                CLKDIV_EN,
input    wire                CLK,
input    wire                RST,
input    wire                WrEn,
input    wire                RdEn,
input    wire   [ADDR-1:0]   Address,
input    wire   [WIDTH-1:0]  WrData,
output   wire   [WIDTH-1:0]  RdData,
output   wire                SYS_OUT,
output   wire                SYS_VLD,
output   wire                DONE_FLAG
);

wire    [WIDTH-1:0]      ALU_A,
                         ALU_B,
						 ALU_Config0,
						 ALU_Config1,
						 UART_Config,
						 CLKDIV_Config;
						 
						 
						 
wire 	                 ALU_Enable,
					     CLKG_EN,
						 ALU_CLK,
						 ALU_VLD,
						 UART_CLK,
						 UART_CLK_div;

wire   [WIDTH-1:0]       ALU_OUT ;

wire   [ALU_FUN_WD-1:0]  ALU_FUN ;


						 
FSM_Controller U0_FSM_Controller (
.CLK(CLK),
.RST(RST),
.Enable(CONTROL_EN),
.ALU_Config0(ALU_Config0),
.ALU_Config1(ALU_Config1),
.UART_Busy(SYS_VLD),
.ALU_Enable(ALU_Enable),
.ALU_FUN(ALU_FUN),
.CLKG_EN(CLKG_EN),
.Done_Flag(DONE_FLAG)
);

RegFile U0_RegFile (
.CLK(CLK),
.RST(RST),
.WrEn(WrEn),
.RdEn(RdEn),
.Address(Address),
.WrData(WrData),
.RdData(RdData),
.REG0(ALU_A),
.REG1(ALU_B),
.REG2(ALU_Config0),
.REG3(ALU_Config1),
.REG4(UART_Config),
.REG5(CLKDIV_Config)
);


ALU U0_ALU (
.CLK(ALU_CLK),
.RST(RST),
.A(ALU_A), 
.B(ALU_B),
.Enable(ALU_Enable),
.ALU_FUN(ALU_FUN),
.ALU_OUT(ALU_OUT),
.OUT_VALID(ALU_VLD)
);


UART  U0_UART_TX (
.CLK(UART_CLK_div),
.RST(RST),
.P_DATA(ALU_OUT),
.DATA_VALID(ALU_VLD),
.Configuration(UART_Config[1:0]),
.S_DATA(SYS_OUT),
.Busy(SYS_VLD)
);

CLK_GATE U0_CLK_GATE(
.CLK_EN(CLKG_EN),
.CLK(CLK),
.GATED_CLK(ALU_CLK)
);

Clock_Divider U0_ClkDiv (
.i_ref_clk(CLK),             
.i_rst_en(RST),               
.i_clk_en(CLKDIV_EN),               
.i_div_ratio(CLKDIV_Config),            
.o_div_clk(UART_CLK_div)           
);


endmodule