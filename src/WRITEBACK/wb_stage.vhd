library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity writeback_stage is
    port (
        --clk, rst  : in std_logic;
       -- RegDest   : in std_logic_vector (4 downto 0);
        Read_DATA : in std_logic_vector (31 downto 0);
        ALU_output: in std_logic_vector (31 downto 0);
        PC_next   : in std_logic_vector (31 downto 0);

        MemtoReg  : in std_logic;
        Jump      : in std_logic;

        Out_to_Regfile : out std_logic_vector (31 downto 0)
    );

end writeback_stage;

architecture structural of writeback_stage is

component mem_wb_mux 
        port (
            memory_out : in  std_logic_vector (31 downto 0);
            alu_or_PC  : in  std_logic_vector (31 downto 0);
    
            MemtoReg   : in  std_logic;
    
            out_to_reg : out std_logic_vector (31 downto 0)
    
        );
end component;

component jump_mux  --2 to 1 , 32 bit
        port (
            return_address : in  std_logic_vector (31 downto 0);
            alu_out        : in  std_logic_vector (31 downto 0);
    
            jump  : in  std_logic;
    
            output : out std_logic_vector (31 downto 0)
    
        );
end component;

signal jump_mux_out : std_logic_vector(31 downto 0);

begin

    mux1: jump_mux port map(PC_next, ALU_output, Jump, jump_mux_out);
    mux2: mem_wb_mux port map (Read_DATA, jump_mux_out, MemtoReg, Out_to_Regfile);


end structural;