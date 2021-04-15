library  IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.instruction_types.all;

entity decode_stage is 
    port (
        -- inputs
        clk: in std_logic;
        rst_n        : in std_logic;
        current_PC_in      : in std_logic_vector (31 downto 0);
        next_PC_in         : in std_logic_vector (31 downto 0);
        instruction     : in std_logic_vector (31 downto 0);

       -- RegWrite_in     : in std_logic;
       -- RegDest_in      : in std_logic_vector (4 downto 0);
      --  RegDest_Data_in : in std_logic_vector (31 downto 0);

        ex_mem_reg_Rd    : in std_logic_vector (4 downto 0);
        mem_wb_reg_Rd    : in std_logic_vector (4 downto 0);
        id_ex_reg_Rd     : in std_logic_vector (4 downto 0);

        ex_mem_data_IN   : in std_logic_vector (31 downto 0);
        mem_wb_data_IN   : in std_logic_vector (31 downto 0);
        
        -- hazard signals
        id_ex_MemRead      :  in std_logic;
        ex_mem_MemRead     :  in std_logic;
        id_ex_RegWrite     :  in std_logic;

        -- forward signals
        ex_mem_RegWrite  : in std_logic;
        mem_wb_RegWrite  : in std_logic;

        -- OUTPUTS
        --Address lines
        RegSource1      :   out std_logic_vector (4 downto 0);
        RegSource2      :   out std_logic_vector (4 downto 0);
        RegDest         :   out std_logic_vector (4 downto 0);
        -- data lines
        Rs1_DATA        :   out std_logic_vector (31 downto 0);
        Rs2_DATA        :   out std_logic_vector (31 downto 0);
        Immediate       :   out std_logic_vector (31 downto 0);

        -- control signals
        if_flush        :   out std_logic;
        RegWrite        :   out std_logic;
        ALUSrcA         :   out std_logic;
		ALUSrcB         :   out std_logic;
		PCZ				:	out std_logic;        
		ALUOp           :   out std_logic_vector (2 downto 0);
        MemWrite        :   out std_logic;
        MemRead         :   out std_logic;
        MemtoReg        :   out std_logic;  --  page 257
        Jump            :   out std_logic;

        if_id_Write     :   out std_logic;
        PCWrite         :   out std_logic;

        branch_PC_out      : out std_logic_vector (31 downto 0);
        current_PC_out     : out std_logic_vector (31 downto 0);
        next_PC_out        : out std_logic_vector (31 downto 0)     
    );
end decode_stage;

architecture structural of decode_stage is

-- components declaration
component adder
    port(
        current_PC       : in  std_logic_vector (31 downto 0);    
        jump_offset      : in  std_logic_vector (31 downto 0);
        branch_target_PC : out std_logic_vector (31 downto 0)
    );
end component;

component imm_gen 
    port(
        instruction         :  in std_logic_vector (31 downto 0);
        immediate           : out std_logic_vector (31 downto 0)
    );
end component;

component registerfile 
    port (
      RS1 	: in std_logic_vector(4 downto 0);
      RS2		: in std_logic_vector(4 downto 0);
      RD		: in std_logic_vector(4 downto 0);
      RegWrite	: in std_logic;
      DATAIN	: in std_logic_vector(31 downto 0);
      CLK     : in std_logic;
      RST_n   : in std_logic;
      OUT1	: out std_logic_vector(31 downto 0);
      OUT2	: out std_logic_vector(31 downto 0)
      );
end component;

component  decode_hazard_mux 
    port(
        RegWrite_in     : in std_logic;
        MemWrite_in     : in std_logic;

        stall           : in std_logic;

        RegWrite_out    : out std_logic;
        MemWrite_out    : out std_logic
    );
end component;

component hazard_unit 
    port (
        id_ex_MemRead      :  in std_logic;
        ex_mem_MemRead     :  in std_logic;
        id_ex_RegWrite     :  in std_logic;
        
        id_ex_Rd           :  in std_logic_vector (4 downto 0);
        ex_mem_Rd          :  in std_logic_vector (4 downto 0);

        if_id_register_Rs1 :  in std_logic_vector (4 downto 0);
        if_id_register_Rs2 :  in std_logic_vector (4 downto 0);
        
        branch_instruction :  in std_logic;

        stall              : out std_logic; -- controls muxing with ControlUnit
        PCWrite            : out std_logic;
        if_id_Write        : out std_logic
    );
end component;

component control_unit 
    port(
        -- pag 294 shows control connection
        -- pag 309 clarifications on different placement for BEQ check
        -- pag 314 shows the final datapath
        opcode     		: in std_logic_vector(6 downto 0); --instruction bits (6:0)
		Jump			: out std_logic;		
		PCZ				: out std_logic;		
		ALUSrcA         : out std_logic;		
		ALUSrcB         : out std_logic;
		MemtoReg        : out std_logic;
		RegWrite        : out std_logic;
		MemRead         : out std_logic;
		MemWrite        : out std_logic;
		Branch			: out std_logic;
        ALUOp           : out std_logic_vector(2 downto 0)
    );

end component;

component branch_forward_unit 
    port (
      --  branch           : in std_logic;
        --RegSource1 and RegSource2 come from the instruction fields
        RegSource1       : in std_logic_vector (4 downto 0);
        RegSource2       : in std_logic_vector (4 downto 0);
        
        ex_mem_reg_Rd    : in std_logic_vector (4 downto 0);
        mem_wb_reg_Rd    : in std_logic_vector (4 downto 0);

        ex_mem_RegWrite  : in std_logic;
        mem_wb_RegWrite  : in std_logic;

        forward_1        : out std_logic_vector (1 downto 0);
        forward_2        : out std_logic_vector (1 downto 0)
        
    );
end component;

component branch_forward_mux 
    port(
        regfile_data_IN  : in  std_logic_vector (31 downto 0);
        ex_mem_data_IN  : in  std_logic_vector (31 downto 0);
        mem_wb_data_IN   : in  std_logic_vector (31 downto 0);

        forward_sel : in  std_logic_vector (1 downto 0);

        output      : out std_logic_vector (31 downto 0)
    );
end component;

component branch_evaluator 
    port (
        RegSource1    : in std_logic_vector (31 downto 0);
        RegSource2    : in std_logic_vector (31 downto 0);

        test_branch   : in std_logic;
        func3         : in std_logic_vector (2 downto 0);

        branch_res    : out std_logic
    );
end component;

-- register file lines
signal Rs1_reg_DATA_internal : std_logic_vector (31 downto 0);
signal Rs2_reg_DATA_internal : std_logic_vector (31 downto 0);

-- branch forward signals
signal forward_1 : std_logic_vector (1 downto 0);
signal forward_2 : std_logic_vector (1 downto 0);
signal muxed_RS1 : std_logic_vector (31 downto 0);
signal muxed_RS2 : std_logic_vector (31 downto 0);

-- hazard signals
signal stall : std_logic;

-- control unit signals 
signal jump_int : std_logic;
signal branch : std_logic;
signal RegWrite_internal : std_logic;
signal Memwrite_internal : std_logic;

-- various signals
signal branch_result : std_logic;
signal sign_ext_imm  : std_logic_vector (31 downto 0);

signal internal_pc   : std_logic_vector(31 downto 0);


begin

internal_pc <= current_PC_in;

-- jump target address calculation
immediate_gen : imm_gen port map (instruction, sign_ext_imm);
--address_adder : adder port map (current_PC_in, sign_ext_imm, branch_PC_out);
address_adder : adder port map (internal_pc, sign_ext_imm, branch_PC_out);

-- register file and branch check
reg_file      : registerfile port map (instruction (19 downto 15), instruction (24 downto 20), mem_wb_reg_Rd, mem_wb_RegWrite, mem_wb_data_IN, CLK, RST_n, Rs1_reg_DATA_internal, Rs2_reg_DATA_internal);

branch_fwd_unit:  branch_forward_unit port map (instruction(19 downto 15), instruction (24 downto 20), ex_mem_reg_Rd, mem_wb_reg_Rd, ex_mem_RegWrite, mem_wb_RegWrite, forward_1,  forward_2);

--branch_fwd_unit:  branch_forward_unit port map (branch, instruction(19 downto 15), instruction (24 downto 20), ex_mem_reg_Rd, mem_wb_reg_Rd, ex_mem_RegWrite, mem_wb_RegWrite, forward_1,  forward_2);

branch_mux_rs1: branch_forward_mux port map(Rs1_reg_DATA_internal, ex_mem_data_IN, mem_wb_data_IN, forward_1, muxed_RS1);
branch_mux_rs2: branch_forward_mux port map(Rs2_reg_DATA_internal, ex_mem_data_IN, mem_wb_data_IN, forward_2, muxed_RS2);

branch_check  : branch_evaluator port map (muxed_RS1, muxed_RS2, branch, instruction(14 downto 12), branch_result);

-- hazard unit
hazard  : hazard_unit port map (id_ex_MemRead, ex_mem_MemRead, id_ex_RegWrite, id_ex_reg_Rd, ex_mem_reg_Rd, instruction(19 downto 15), instruction (24 downto 20), branch, stall, PCWrite, if_id_Write);


-- control unit

control : control_unit port map (instruction (6 downto 0), jump_int, PCZ, ALUSrcA, ALUSrcB, MemtoReg, RegWrite_internal, MemRead, Memwrite_internal, Branch, ALUOp);

-- hazard mux: insert nops in case of detected data hazard.
hzd_mux : decode_hazard_mux port map (RegWrite_internal, Memwrite_internal, stall, RegWrite, MemWrite);

if_flush <= jump_int OR (branch_result and not(stall));

RegSource1 <= instruction (19 downto 15);
RegSource2 <= instruction (24 downto 20);
RegDest <=  instruction (11 downto 7);

Rs1_DATA <= muxed_RS1;
Rs2_DATA <= muxed_RS2;
Immediate <= sign_ext_imm;

Jump      <= jump_int;
current_PC_out <= current_PC_in;
next_PC_out <= next_PC_in;





end structural;