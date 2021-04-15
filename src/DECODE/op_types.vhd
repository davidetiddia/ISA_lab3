library ieee;
use IEEE.std_logic_1164.all;

package instruction_types is


-- opcodes of each type of instruction (U, UJ, SB, Load(imm), S, I, R)
constant LUI_U_type    : std_logic_vector (6 downto 0) := "0110111";
constant AUIPC_U_type  : std_logic_vector (6 downto 0) := "0010111";
constant UJ_type       : std_logic_vector (6 downto 0) := "1101111";
constant SB_type       : std_logic_vector (6 downto 0) := "1100011";
constant load_type     : std_logic_vector (6 downto 0) := "0000011"; -- load ops are I-type ops
constant S_type        : std_logic_vector (6 downto 0) := "0100011";
constant I_type        : std_logic_vector (6 downto 0) := "0010011";
constant R_type        : std_logic_vector (6 downto 0) := "0110011";

-- func3 of each instruction
constant BEQ   : std_logic_vector (2 downto 0) := "000";
constant ADDI  : std_logic_vector (2 downto 0) := "000";
constant ANDI  : std_logic_vector (2 downto 0) := "111";
constant SRI   : std_logic_vector (2 downto 0) := "101"; -- same for srai and srli
constant ADD_R : std_logic_vector (2 downto 0) := "000";
constant SLT   : std_logic_vector (2 downto 0) := "010";
constant XOR_R : std_logic_vector (2 downto 0) := "100";
constant SW     : std_logic_vector(2 downto 0) := "010";
constant LW     : std_logic_vector(2 downto 0) := "010";

-- func7 of each instruction 
-- in our implementation it is only used by the SRAI instruction
constant logic  : std_logic_vector (6 downto 0) :="0000000";
constant arith  : std_logic_vector (6 downto 0) := "0100000";

-- ALU operations
constant alu_add : std_logic_vector (3 downto 0) := "0000";
constant alu_sub : std_logic_vector (3 downto 0) := "0001";
constant alu_xor : std_logic_vector (3 downto 0) := "0010";
constant alu_and : std_logic_vector (3 downto 0) := "0011";
constant alu_shift_r_a: std_logic_vector (3 downto 0) := "0100";
constant alu_slt : std_logic_vector (3 downto 0) := "0101";

end instruction_types;

-- opcodes of each instruction
-- constant ADD_R is: std_logic_vector(6 downto 0) :="0110011"; --same as SLT, XOR, but differernt func
-- constant I_ADDI is: std_logic_vector(6 downto 0) :="0010011";
-- constant AUIPC is: std_logic_vector(6 downto 0) :="0010111";
-- constant LUI is: std_logic_vector(6 downto 0) :="0110111";
-- constant BEQ is: std_logic_vector(6 downto 0) :="1100011"; --mind the different func code
-- constant LW is: std_logic_vector(6 downto 0) :="0000011";
-- constant SRAI  is: std_logic_vector(6 downto 0) :="0010011";
-- constant ANDI is: std_logic_vector(6 downto 0) :="0010011"; -- same as SRAI
-- constant XOR_logical is: std_logic_vector(6 downto 0) :="0110011";--same as SLT, ADD
-- constant SLT is: std_logic_vector(6 downto 0) :="0110011";
-- constant JAL is: std_logic_vector(6 downto 0) :="1101111";
-- constant SW is: std_logic_vector(6 downto 0) :="0100011";

