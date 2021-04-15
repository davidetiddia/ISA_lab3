library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PC_adder is
    port (
        PC : in std_logic_vector (31 downto 0);

        PC_next: out std_logic_vector(31 downto 0)
    );
end PC_adder;


architecture behavioral of PC_adder is
begin
    PC_next <= std_logic_vector (unsigned (PC) +4);
    
end behavioral;
