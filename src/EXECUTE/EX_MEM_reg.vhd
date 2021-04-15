library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity EX_MEM_reg is
    port (
        -- inputs
        CLK, RST_n        :   in std_logic;
        RegSource2      :   in std_logic_vector(4 downto 0);
        RegDest         :   in std_logic_vector (4 downto 0);
        ALU_output      :   in std_logic_vector(31 downto 0);
        WriteData      :   in std_logic_vector(31 downto 0);

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
        WriteData_out : out std_logic_vector(31 downto 0);

        RegWrite_out        :   out std_logic;
        MemWrite_out        :   out std_logic;
        MemRead_out         :   out std_logic;
        MemtoReg_out        :   out std_logic;  
        jump_out            :   out std_logic;

        next_PC_out              :   out std_logic_vector (31 downto 0)

    );

end EX_MEM_reg;

architecture behavioral of EX_MEM_reg is

begin
    process (CLK, RST_n)
    begin
        if (RST_n = '0') then
            RegSource2_out <= (others => '0');
            RegDest_out <= (others => '0');
            ALU_output_out <= (others => '0');
            WriteData_out <= (others => '0');
            RegWrite_out <= '0';
            MemWrite_out<= '0';
            MemRead_out<= '0';
            MemtoReg_out<= '0';
            Jump_out <= '0';
            next_PC_out <= (others => '0');
        elsif (rising_edge (CLK)) then
            RegSource2_out <= RegSource2;
            RegDest_out <= RegDest;
            ALU_output_out <= ALU_output;
            WriteData_out <= WriteData;
            RegWrite_out <= RegWrite;
            MemWrite_out<= MemWrite;
            MemRead_out<= MemRead;
            MemtoReg_out<= MemtoReg;
            Jump_out <= Jump;
            next_PC_out <= next_PC;
        end if;

    end process;

end behavioral;
                