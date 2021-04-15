LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity riscv is
    port ( 
        CLK: in std_logic;
        RST_n: in std_logic;
        
        --fetch stage
        Instruction : in std_logic_vector(31 downto 0);
        PC          : out std_logic_vector(31 downto 0);
        
        -- memory stage
        READ_DATA   : in std_logic_vector(31 downto 0); 
        MemRead     : out std_logic;
        MemWrite    : out std_logic;      
        R_W_address : out std_logic_vector(31 downto 0);
        WRITE_DATA  : out std_logic_vector(31 downto 0)
    );
end riscv;

architecture pipeline of riscv is

-- component declaration
component fetch_stage 
    port (
        CLK, RST_n        : in std_logic;
        branch_jump_PC  : in std_logic_vector (31 downto 0);

        PCSrc           : in std_logic;
        PCWrite         : in std_logic;

        --instruction     : out std_logic_vector (31 downto 0);

        PC              : out std_logic_vector (31 downto 0);
        PC_next         : out std_logic_vector (31 downto 0)
    );
end component;

component IF_ID_reg 
    port(
        CLK, RST_n            : in std_logic;
        PC_in               : in std_logic_vector (31 downto 0);
        PC_next_in          : in std_logic_vector (31 downto 0); -- contains PC + 4 (used for jumps)
        fetched_instruction : in std_logic_vector (31 downto 0);

        if_flush            : in std_logic;
        if_id_Write         : in std_logic;

        PC_out              : out std_logic_vector (31 downto 0);
        PC_next_out         : out std_logic_vector (31 downto 0);
        instruction         : out std_logic_vector (31 downto 0)
    );
end component;

component decode_stage  
    port (
        -- inputs
        clk, RST_n        : in std_logic;
        current_PC_in      : in std_logic_vector (31 downto 0);
        next_PC_in         : in std_logic_vector (31 downto 0);
        instruction     : in std_logic_vector (31 downto 0);

      --  RegWrite_in     : in std_logic;
      --  RegDest_in      : in std_logic_vector (4 downto 0);
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
        RegWrite    :   out std_logic;
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
end component;

component ID_EXE_reg
    port (
        -- inputs
        CLK, RST_n        :   in std_logic;

        RegSource1      :   in std_logic_vector (4 downto 0);
        RegSource2      :   in std_logic_vector (4 downto 0);
        RegDest         :   in std_logic_vector (4 downto 0);

        Rs1_DATA        :   in std_logic_vector (31 downto 0);
        Rs2_DATA        :   in std_logic_vector (31 downto 0);
        Immediate       :   in std_logic_vector (31 downto 0);

        func3           :   in std_logic_vector (2 downto 0);
        func7           :   in std_logic;

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
        PC_NEXT         :   in std_logic_vector(31 downto 0);
        -- outputs
        
        RegSource1_out  :   out std_logic_vector (4 downto 0);
        RegSource2_out  :   out std_logic_vector (4 downto 0);
        RegDest_out  :   out std_logic_vector (4 downto 0);


        Rs1_DATA_out        :   out std_logic_vector (31 downto 0);
        Rs2_DATA_out        :   out std_logic_vector (31 downto 0);
        Immediate_out    :   out std_logic_vector (31 downto 0);

        func3_out           :   out std_logic_vector (2 downto 0);
        func7_out           :   out std_logic;

        RegWrite_out        :   out std_logic;
        ALUSrcA_out        :   out std_logic;
        ALUSrcB_out         :  out std_logic;
        PCZ_out             :  out std_logic;
        ALUOp_out           :   out std_logic_vector (2 downto 0);
        MemWrite_out        :   out std_logic;
        MemRead_out         :   out std_logic;
        MemtoReg_out        :   out std_logic;  --  page 257
        jump_out            :   out std_logic;

        PC_out              :   out std_logic_vector (31 downto 0);
        PC_next_out         :   out std_logic_vector(31 downto 0)
    );

end component;

component execute_stage 
    port(

        -- INPUTS
        --CLK, RST_n : in std_logic;
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
end component;

component EX_MEM_reg 
    port (
        -- inputs
        CLK, RST_n        :   in std_logic;
        RegSource2      :   in std_logic_vector(4 downto 0);
        RegDest         :   in std_logic_vector (4 downto 0);
        ALU_output      :   in std_logic_vector(31 downto 0);
        WriteData       :   in std_logic_vector(31 downto 0);

        RegWrite        :   in std_logic;
        MemWrite        :   in std_logic;
        MemRead         :   in std_logic;
        MemtoReg        :   in std_logic;  
        Jump            :   in std_logic;
        
        next_PC              :   in std_logic_vector (31 downto 0);
        -- outputs
        RegSource2_out : out std_logic_vector(4 downto 0);
        RegDest_out  :   out std_logic_vector (4 downto 0);
        ALU_output_out:  out std_logic_vector(31 downto 0);
        WriteData_out :  out std_logic_vector (31 downto 0);

        RegWrite_out        :   out std_logic;
        MemWrite_out        :   out std_logic;
        MemRead_out         :   out std_logic;
        MemtoReg_out        :   out std_logic;  
        jump_out            :   out std_logic;

        next_PC_out              :   out std_logic_vector (31 downto 0)

    );

end component;

component memory_stage 
    port(
       -- clk, RST_n : in std_logic;

        RegDest         :   in std_logic_vector (4 downto 0);
        ALU_output      :   in std_logic_vector (31 downto 0);

        ex_mem_write_DATA : in std_logic_vector (31 downto 0);
        ex_mem_reg_Rs2  :   in std_logic_vector(4 downto 0);

        mem_wb_reg_Rd   :   in std_logic_vector (4 downto 0);
        mem_wb_data_IN  :   in std_logic_vector (31 downto 0);

        
        RegWrite        :   in std_logic;
        MemWrite        :   in std_logic;
        MemRead         :   in std_logic;
        MemtoReg        :   in std_logic;  
        Jump            :   in std_logic;
        
        next_PC              :   in std_logic_vector (31 downto 0);

        --outputs
        RegDest_out  :   out std_logic_vector (4 downto 0);
        --Read_DATA    :   out std_logic_vector(31 downto 0);
        ALU_output_out:  out std_logic_vector(31 downto 0);
        WriteData  :   out std_logic_vector(31 downto 0);

        memread_out     : out std_logic;
        memwrite_out    : out std_logic;
        RegWrite_out        :   out std_logic;
        MemtoReg_out        :   out std_logic;
        Jump_out            :   out std_logic;  

        --PC_out              :   out std_logic_vector (31 downto 0);
        PC_next_out         :   out std_logic_vector (31 downto 0)

    );
end component;

component  MEM_WB_reg 
    port (
        -- inputs
        CLK, RST_n        :   in std_logic;

        RegDest         :   in std_logic_vector (4 downto 0);
        Read_DATA       :   in std_logic_vector (31 downto 0);
        ALU_output      :   in std_logic_vector (31 downto 0);

        RegWrite        :   in std_logic;
        MemtoReg        :   in std_logic;  
        Jump            :   in std_logic;
        
       -- PC              :   in std_logic_vector (31 downto 0);
        PC_next         :   in std_logic_vector(31 downto 0);
        -- outputs
        
        RegDest_out  :   out std_logic_vector (4 downto 0);
        Read_DATA_out    : out std_logic_vector (31 downto 0);
        ALU_output_out   : out std_logic_vector (31 downto 0);

        RegWrite_out        :   out std_logic;
        MemtoReg_out        :   out std_logic;  
        Jump_out            :   out std_logic;

        --PC_out              :   out std_logic_vector (31 downto 0);
        PC_next_out         :   out std_logic_vector (31 downto 0)

    );

end component;

component  writeback_stage is
    port (
      --  clk, RST_n  : in std_logic;
       -- RegDest   : in std_logic_vector (4 downto 0);
        Read_DATA : in std_logic_vector (31 downto 0);
        ALU_output: in std_logic_vector (31 downto 0);
        PC_next   : in std_logic_vector (31 downto 0);

        MemtoReg  : in std_logic;
        Jump      : in std_logic;

        Out_to_Regfile : out std_logic_vector (31 downto 0)
    );

end component;

-- internal signals declaration
--############################################
-- fetch stage
--signal branch_jump_PC : std_logic_vector (31 downto 0);
--signal PCSrc : std_logic;
--signal PCWrite  : std_logic;
--signal PC_internal, PC_next : std_logic_vector (31 downto 0);


signal if_PC, if_PC_next: std_logic_vector (31 downto 0);
signal fetched_instruction: std_logic_vector(31 downto 0);
--##############################################
--decode stage
signal id_RegSource1 : std_logic_vector (4 downto 0);
signal id_RegSource2 : std_logic_vector (4 downto 0);
signal id_RegDest : std_logic_vector(4 downto 0);
signal id_Rs1Data : std_logic_vector (31 downto 0);
signal id_Rs2Data : std_logic_vector (31 downto 0);
signal id_Immediate : std_logic_vector (31 downto 0);

signal if_flush, if_id_Write : std_logic;
signal id_RegWrite, id_ALUSrcA, id_ALUSrcB, id_PCZ, id_MemWrite, id_MemRead, id_MemtoReg, id_Jump, id_PCWrite : std_logic;
signal id_ALUOp : std_logic_vector(2 downto 0);
signal id_branch_PC : std_logic_vector(31 downto 0);
signal id_PC, id_PC_next, id_PC_out, id_PC_next_out : std_logic_vector(31 downto 0);  

--#############################################

-- exectue stage
signal ex_reg_Rd, ex_reg_Rd_out     :  std_logic_vector (4 downto 0);
signal ex_MemRead , ex_MemRead_out   : std_logic;
signal ex_RegWrite, ex_RegWrite_out   : std_logic;

signal ex_RegSource1, ex_RegSource2, ex_RegSource2_out : std_logic_vector(4 downto 0);
signal ex_Rs1Data, ex_Rs2Data, ex_Rs2Data_out, ex_Immediate : std_logic_vector(31 downto 0);
signal ex_func3, ex_ALUOp : std_logic_vector(2 downto 0);
signal ex_func7, ex_ALUSrcA, ex_ALUSrcB,ex_PCZ, ex_MemWrite, ex_MemWrite_out, ex_MemtoReg, ex_MemtoReg_out, ex_jump, ex_jump_out : std_logic;
signal ex_PC, ex_PC_next, ex_PC_next_out : std_logic_vector(31 downto 0);

-- ex_stage_outputs

signal ex_ALU_result    : std_logic_vector(31 downto 0);
signal ex_WriteData     : std_logic_vector(31 downto 0);

-- don't know if needed
--signal ex_RegWrite_out , ex_MemWrite_out, ex_MemRead_out, ex_MemtoReg_out, ex_jump_out : std_logic;
--signal ex_reg_Rd_out : std_logic_vector(4 downto 0);

--##############################################
-- memory stage
signal mem_reg_Rd,mem_reg_Rd_out, mem_Regsource2 : std_logic_vector(4 downto 0);
signal mem_Read_DATA, mem_ALU_result, mem_ALU_result_out, mem_WriteData, mem_WriteData_out : std_logic_vector(31 downto 0);
signal mem_MemRead: std_logic;
signal mem_RegWrite, mem_RegWrite_out: std_logic;
signal mem_MemWrite, mem_MemtoReg, mem_MemtoReg_out, mem_jump, mem_jump_out: std_logic;
signal mem_PC_next, mem_PC_next_out : std_logic_vector(31 downto 0);

-- writeback stage
signal wb_reg_Rd : std_logic_vector(4 downto 0);
signal wb_Out_to_Regfile, wb_Read_DATA, wb_ALU_result, wb_PC_next: std_logic_vector(31 downto 0);
signal wb_RegWrite, wb_MemtoReg, wb_Jump : std_logic;


-- signal wb_Regwrite : std_logic;
-- signal wb_RegDest  : std_logic_vector (4 downto 0);
-- signal wb_Out_to_Regfile : std_logic_vector (31 downto 0);

BEGIN

-- components instantiation
-- if_flush controls also the PC_mux, when a branch/jump has to be taken, then the PC is the one coming from ID
fetch  : fetch_stage port map (clk,RST_n, id_branch_PC, if_flush, id_PCWrite, if_PC, if_PC_next);

PC <= if_PC;

if_id_pipeline_register : IF_ID_reg port map (clk, RST_n, if_PC, if_PC_next, Instruction, if_flush, if_id_Write, id_PC, id_PC_next, fetched_instruction);

decode : decode_stage port map (clk, RST_n, id_PC, id_PC_next, fetched_instruction, mem_reg_Rd, wb_reg_Rd, ex_reg_Rd, mem_ALU_result, wb_Out_to_Regfile, ex_MemRead, mem_MemRead, ex_RegWrite, mem_RegWrite, wb_RegWrite, id_RegSource1, id_RegSource2, id_RegDest, id_Rs1Data, id_Rs2Data, id_Immediate, if_flush, id_RegWrite, id_ALUSrcA, id_ALUSrcB, id_PCZ, id_ALUOp, id_MemWrite, id_MemRead, id_MemtoReg, id_Jump, if_id_Write, id_PCWrite, id_branch_PC, id_PC_out, id_PC_next_out);

id_ex_pipeline_register: ID_EXE_reg port map (clk, RST_n, id_RegSource1, id_RegSource2, id_RegDest, id_Rs1Data, id_Rs2Data, id_Immediate, fetched_instruction(14 downto 12), fetched_instruction(30), id_RegWrite, id_ALUSrcA, id_ALUSrcB, id_PCZ, id_ALUOp, id_MemWrite, id_MemRead, id_MemtoReg, id_jump, id_PC_out, id_PC_next_out, ex_RegSource1, ex_RegSource2, ex_reg_Rd, ex_Rs1Data, ex_Rs2Data, ex_Immediate, ex_func3, ex_func7, ex_RegWrite, ex_ALUSrcA, ex_ALUSrcB, ex_PCZ, ex_ALUOp, ex_MemWrite, ex_MemRead, ex_MemtoReg, ex_jump, ex_PC, ex_PC_next);

--execute stage missing clk and RST_n as not used
execute: execute_stage port map(ex_RegSource1, ex_RegSource2, ex_reg_Rd, ex_Rs1Data, ex_Rs2Data, ex_Immediate, ex_func3, ex_func7, mem_reg_Rd, wb_reg_Rd, mem_RegWrite, wb_RegWrite, mem_ALU_result, wb_Out_to_Regfile, ex_RegWrite, ex_ALUSrcA, ex_ALUSrcB, ex_PCZ, ex_ALUOp, ex_MemWrite, ex_MemRead, ex_MemtoReg, ex_jump, ex_PC, ex_PC_next, ex_RegSource2_out, ex_reg_Rd_out, ex_ALU_result, ex_WriteData, ex_RegWrite_out, ex_MemWrite_out, ex_MemRead_out, ex_MemtoReg_out, ex_jump_out, ex_PC_next_out );

--Write_Data line added in register and memory stage
ex_mem_pipeline_register: EX_MEM_reg port map (clk, RST_n,ex_RegSource2_out, ex_reg_Rd_out, ex_ALU_result, ex_WriteData, ex_RegWrite_out, ex_MemWrite_out, ex_MemRead_out, ex_MemtoReg_out, ex_jump_out, ex_PC_next_out, mem_Regsource2, mem_reg_Rd, mem_ALU_result, mem_WriteData, mem_RegWrite, mem_MemWrite, mem_MemRead, mem_MemtoReg, mem_jump, mem_PC_next);

memory : memory_stage port map (mem_reg_Rd, mem_ALU_result, mem_WriteData, mem_Regsource2, wb_reg_Rd, wb_Out_to_Regfile, mem_RegWrite, mem_MemWrite, mem_MemRead, mem_MemtoReg, mem_jump, mem_PC_next, mem_reg_Rd_out, mem_ALU_result_out, write_DATA, MemRead, MemWrite, mem_RegWrite_out, mem_MemtoReg_out, mem_jump_out, mem_PC_next_out);

R_W_address <= mem_ALU_result;

mem_wb_pipeline_register: MEM_WB_reg port map (clk, RST_n, mem_reg_Rd_out, Read_DATA, mem_ALU_result_out, mem_RegWrite_out, mem_MemtoReg_out, mem_jump_out, mem_PC_next_out, wb_reg_Rd, wb_Read_DATA, wb_ALU_result, wb_RegWrite, wb_MemtoReg, wb_Jump, wb_PC_next );

writeback : writeback_stage port map (wb_Read_DATA, wb_ALU_result, wb_PC_next, wb_MemtoReg, wb_Jump, wb_Out_to_Regfile);

end pipeline;

--fix input names of pipe regs!
