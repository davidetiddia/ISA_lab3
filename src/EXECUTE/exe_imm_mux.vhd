library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity immediate_mux is
    port(
        immediate_value  : in  std_logic_vector (31 downto 0);
        reg_value        : in  std_logic_vector (31 downto 0);
        sel              : in  std_logic;

        output_value     : out std_logic_vector (31 downto 0)
    );
end immediate_mux;


architecture behavioral of immediate_mux is

begin
    output_value <= immediate_value when (sel = '1') else reg_value;

end behavioral;