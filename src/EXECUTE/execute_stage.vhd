library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity execute_stage is
    port(

        -- INPUTS
        --  CLK, RST : in std_logic;
        RegSource1      :   in std_logic_vector (4 downto 0);
        RegSource2      :   in std_logic_vector (4 downto 0);
        RegDest         :   in std_logic_vector (4 downto 0);

        Rs1_DATA        :   in std_logic_vector (31 downto 0);
        Rs2_DATA        :   in std_logic_vector (31 downto 0);
        Immediate       :   in std_logic_vector (31 downto 0);

        func3           :   in std_logic_vector (2 downto 0);
        func7           :   in std_logic;

        --forwarding signals coming from following stages of the pipe
        ex_mem_reg_Rd        :   in std_logic_vector (4 downto 0);
        mem_wb_reg_Rd        :   in std_logic_vector (4 downto 0);

        ex_mem_RegWrite      :   in std_logic;
        mem_wb_RegWrite      :   in std_logic;

        ex_mem_data_IN       :   in std_logic_vector (31 downto 0);
        mem_wb_data_IN       :   in std_logic_vector (31 downto 0);

        -- control signals
        RegWrite        :   in std_logic;
        ALUSrcA         :   in std_logic;
		ALUSrcB         :   in std_logic;
		PCZ				:	in std_logic;        
		ALUOp           :   in std_logic_vector (2 downto 0);
        MemWrite        :   in std_logic;
        MemRead         :   in std_logic;
        MemtoReg        :   in std_logic;  --  page 257
        Jump            :   in std_logic;

        PC              :   in std_logic_vector (31 downto 0);
        PC_next         :   in std_logic_vector(31 downto 0);


        -- OUTPUTS
        RegSource2_out  :   out std_logic_vector(4 downto 0);
        RegDest_out     :   out std_logic_vector(4 downto 0);
        ALU_result      :   out std_logic_vector(31 downto 0);
        WriteData       :   out std_logic_vector(31 downto 0);

        RegWrite_out    :   out std_logic;
        MemWrite_out    :   out std_logic;
        MemRead_out     :   out std_logic;
        MemtoReg_out    :   out std_logic;
        Jump_out        :   out std_logic;

        --PC_out          :   out std_logic_vector(31 downto 0);
        PC_next_out     :   out std_logic_vector(31 downto 0)

    );
end execute_stage;

architecture structural of execute_stage is

component immediate_mux 
    port(
        immediate_value  : in  std_logic_vector (31 downto 0);
        reg_value        : in  std_logic_vector (31 downto 0);
        sel              : in  std_logic;

        output_value     : out std_logic_vector (31 downto 0)
    );
end component;

component forward_mux 
    port(
        regfile_in  : in  std_logic_vector (31 downto 0);
        ex_mem_in   : in  std_logic_vector (31 downto 0);
        mem_wb_in   : in  std_logic_vector (31 downto 0);

        forward_sel : in  std_logic_vector (1 downto 0);

        output      : out std_logic_vector (31 downto 0)
    );
end component;

component branch_mux 
    port(
        regsource1_in : in  std_logic_vector (31 downto 0);
        PC_in   : in  std_logic_vector (31 downto 0);

        PCZ     : in std_logic;
        ALUSrcA : in std_logic;

        ALU_operator_1      : out std_logic_vector (31 downto 0)
    );
end component;

component forwarding_unit 
    port (
        id_ex_reg_rs1        :   in std_logic_vector (4 downto 0);
        id_ex_reg_rs2        :   in std_logic_vector (4 downto 0);
        ex_mem_reg_Rd        :   in std_logic_vector (4 downto 0);
        mem_wb_reg_Rd        :   in std_logic_vector (4 downto 0);

        ex_mem_RegWrite      :   in std_logic;
        mem_wb_RegWrite      :   in std_logic;

        forwardA             :   out std_logic_vector (1 downto 0);
        forwardB             :   out std_logic_vector (1 downto 0)
    );
end component;

component alu_control 
    port (
        ALUOp : in std_logic_vector (2 downto 0);
        func3 : in std_logic_vector (2 downto 0);
        func7: in std_logic;

        operation: out std_logic_vector (3 downto 0)
    );

end component;

component ALU 
    port (
        operand_1 : in std_logic_vector (31 downto 0);
        operand_2 : in std_logic_vector (31 downto 0);
        operation : in std_logic_vector (3 downto 0);
       -- zero      : out std_logic;
        ALU_result: out std_logic_vector(31 downto 0)
    );
end component;

--signal operation : std_logic_vector(3 downto 0);
-- forwarding signals and data
signal forwardA  : std_logic_vector(1 downto 0);
signal forwardB  : std_logic_vector(1 downto 0);

signal src1_fwd_mux_out : std_logic_vector (31 downto 0);
signal src2_fwd_mux_out : std_logic_vector (31 downto 0);
signal alu_src1         : std_logic_vector(31 downto 0);
signal alu_src2         : std_logic_vector(31 downto 0);

signal alu_operation    : std_logic_vector(3 downto 0);


begin

--data forwarding
forward_control : forwarding_unit port map (RegSource1, RegSource2, ex_mem_reg_Rd, mem_wb_reg_Rd, ex_mem_RegWrite, mem_wb_RegWrite, forwardA, forwardB);

fwd_rs1    : forward_mux port map (Rs1_DATA, ex_mem_data_IN, mem_wb_data_IN, forwardA, src1_fwd_mux_out);
fwd_rs2    : forward_mux port map (Rs2_DATA, ex_mem_data_IN, mem_wb_data_IN, forwardB, src2_fwd_mux_out);

-- branch and immediate mux
mux_branch_AUIPC:   branch_mux port map (src1_fwd_mux_out, PC, PCZ, ALUSrcA, alu_src1);
mux_immediate   :   immediate_mux port map (Immediate, src2_fwd_mux_out, ALUSrcB, alu_src2);

-- ALU and alu control
alu_controller  : alu_control port map (ALUOp, func3, func7, alu_operation);
the_ALU         : ALU   port map (alu_src1, alu_src2, alu_operation,ALU_result);

RegSource2_out <= RegSource2;
Jump_out <= Jump;
RegDest_out <= RegDest;
RegWrite_out <= RegWrite;
MemWrite_out <= MemWrite;
MemRead_out <= MemRead;
MemtoReg_out <= MemtoReg;
WriteData <= src2_fwd_mux_out;

--PC_out <= PC;
PC_next_out <= PC_next;

end structural;