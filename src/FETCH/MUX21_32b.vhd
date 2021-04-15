library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity mux21_32b is
    port(
        A    : in std_logic_vector (31 downto 0);
        B    : in std_logic_vector (31 downto 0);
        SEL  : in std_logic;
        OUTPUT  : out std_logic_vector (31 downto 0)
    );
end mux21_32b;

architecture behavioral of mux21_32b is
begin

    OUTPUT <= A when (SEL = '0') else B;

end behavioral;
    