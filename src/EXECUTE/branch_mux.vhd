library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity branch_mux is
    port(
        regsource1_in : in  std_logic_vector (31 downto 0);
        PC_in   : in  std_logic_vector (31 downto 0);

        PCZ     : in std_logic;
        ALUSrcA : in std_logic;

        ALU_operator_1      : out std_logic_vector (31 downto 0)
    );
end branch_mux;


architecture behavioral of branch_mux is

signal sel : std_logic_vector (1 downto 0);

begin
    sel <= PCZ & ALUSrcA;
    alu_source_1: process (regsource1_in, PC_in, sel)
        begin   
            case sel is
                when "00" => ALU_operator_1 <= regsource1_in;
                when "10" => ALU_operator_1 <= PC_in;
                when "01" => ALU_operator_1 <= (others => '0');
                when others => ALU_operator_1 <= (others => '0');
            end case;

        end process;
        

end behavioral;