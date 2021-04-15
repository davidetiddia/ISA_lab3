library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IF_ID_reg is
    port(
        CLK                 : in std_logic;
        RST_n          : in std_logic;
        PC_in               : in std_logic_vector (31 downto 0);
        PC_next_in          : in std_logic_vector (31 downto 0); -- contains PC + 4 (used for jumps)
        fetched_instruction : in std_logic_vector (31 downto 0);

        if_flush            : in std_logic;
        if_id_Write         : in std_logic;

        PC_out              : out std_logic_vector (31 downto 0);
        PC_next_out         : out std_logic_vector (31 downto 0);
        instruction         : out std_logic_vector (31 downto 0)
    );
end IF_ID_reg;



architecture behavioral of IF_ID_reg is

begin

    process (CLK, RST_n)
    begin
        if (RST_n = '0') then
            PC_out <= (others => '0');
            PC_next_out <= (others => '0');
            instruction <= (others => '0');
        else
            if (rising_edge(clk)) then
                if (if_flush = '1')  then
                    PC_out <= (others => '0');
                    PC_next_out <= (others => '0');
                    instruction <= (others => '0');

                elsif (if_id_Write = '1') then
                    PC_out <= PC_in;
                    PC_next_out <= PC_next_in;
                    instruction <= fetched_instruction;  
                end if;
        end if;
    end if;
    end process;


end behavioral;
