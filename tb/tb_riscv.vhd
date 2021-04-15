library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_riscv is
end tb_riscv;


architecture TEST of tb_riscv is
  
  component riscv is
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
end component;

component instruction_mem IS
PORT(
    RST_n: in std_logic;
    PC: in std_logic_vector (31 downto 0);   
    instruction  : out std_logic_vector (31 downto 0)
    
    );
end component;

component data_mem IS
PORT(
    rst_n: in std_logic;
    address : in std_logic_vector(31 downto 0);
    WriteData : in std_logic_vector(31 downto 0);

    MemWrite : in std_logic;
    MemRead  : in std_logic;

    ReadData    : out std_logic_vector(31 downto 0)
    
    );
end component;

signal CLK : std_logic := '0';
signal RST_n : std_logic;
signal Memwrite, MemRead : std_logic;
signal Instruction, PC, Read_DATA, R_W_address, WRITE_DATA : std_logic_vector(31 downto 0);


BEGIN

IRAM: instruction_mem port map (RST_n, PC, Instruction);

DRAM: data_mem port map (RST_n, R_W_address, WRITE_DATA, MemWrite, MemRead, Read_DATA);

-- risc_v entity requires two additional output ports
UUT: riscv port map (CLK, RST_n, Instruction, PC, Read_DATA, MemRead, Memwrite, R_W_address, WRITE_DATA);

--################################
PCLOCK : process(clk)
begin
    CLK <= not(CLK) after 1 ns;
end process;
--################################

RST_n <= '0', '1' after 2 ns;

end TEST;
