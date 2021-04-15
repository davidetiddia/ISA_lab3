library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity MEM_WB_reg is
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

end MEM_WB_reg;

architecture behavioral of MEM_WB_reg is

begin
    process (CLK, RST_n)
    begin
        if (RST_n = '0') then
            RegDest_out <= (others => '0');
            Read_DATA_out <= (others => '0');
            ALU_output_out <= (others => '0');
            RegWrite_out <= '0';
            Jump_out <= '0';
            MemtoReg_out<= '0';
            
        --    PC_out <= (others => '0');
            PC_next_out <= (others => '0');
        elsif (rising_edge (CLK)) then
            RegDest_out <= RegDest;
            Read_DATA_out <= Read_DATA;
            ALU_output_out <= ALU_output;
            RegWrite_out <= RegWrite;
            Jump_out <= Jump;
            MemtoReg_out<= MemtoReg;
         --   PC_out <= PC;
            PC_next_out <= PC_next;
        end if;

    end process;

end behavioral;
                